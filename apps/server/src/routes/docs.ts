import { desc, eq, sql } from "drizzle-orm";
import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";
import { z } from "zod";
import { db } from "../db/client";
import { documents, type Document } from "../db/schema";
import { env } from "../env";
import { assertCanCreateDocument, assertCanUpdateDocument, entitlementsFor } from "../lib/entitlements";
import {
  assertSlugAvailable,
  customSlug,
  generateSlug,
  isUniqueViolation,
  renameSlug,
  resolveDocument,
  slugTaken,
} from "../lib/slug";
import { recordView } from "../lib/views";
import { archiveVersion } from "../lib/versions";
import { loadUserRow, requireUser, type AuthVariables } from "../middleware/auth";

const MAX_CONTENT_BYTES = 1_000_000;

const createBody = z.object({
  title: z.string().trim().min(1).max(200),
  content: z
    .string()
    .min(1)
    .refine(
      (s) => new TextEncoder().encode(s).byteLength <= MAX_CONTENT_BYTES,
      { message: `content exceeds ${MAX_CONTENT_BYTES} bytes` },
    ),
  // Premium only (KER-808). Omitted = keep the current slug, or a random one on create.
  slug: customSlug.optional(),
});

const renameBody = z.object({ slug: customSlug });

const slugParam = z.object({
  slug: z
    .string()
    .min(1)
    .max(64)
    .regex(/^[a-z0-9-]+$/, "slug must be lowercase alphanumeric"),
});

export const docsRoute = new Hono<{ Variables: AuthVariables }>();

const docURL = (slug: string) => `${env.WEB_BASE_URL}/d/${slug}`;

function parseBody<T>(schema: z.ZodSchema<T>, raw: unknown): T {
  const parsed = schema.safeParse(raw);
  if (!parsed.success) {
    throw new HTTPException(400, {
      message: parsed.error.issues.map((i) => i.message).join("; "),
    });
  }
  return parsed.data;
}

/** The caller's own document at `slug` (current or former), else 404. */
export async function ownDocument(c: { req: { param: () => Record<string, string> } }, ownerId: string): Promise<Document> {
  const parsed = slugParam.safeParse(c.req.param());
  if (!parsed.success) throw new HTTPException(400, { message: "invalid slug" });
  const doc = await resolveDocument(parsed.data.slug);
  if (!doc || doc.ownerId !== ownerId) throw new HTTPException(404, { message: "document not found" });
  return doc;
}

docsRoute.post("/", requireUser, async (c) => {
  const { title, content, slug: wanted } = parseBody(createBody, await c.req.json().catch(() => null));
  const user = await loadUserRow(c);
  await assertCanCreateDocument(user);
  if (wanted) await assertSlugAvailable(user, wanted);
  const slug = wanted ?? generateSlug();
  let row: Pick<Document, "slug" | "title" | "createdAt"> | undefined;
  try {
    [row] = await db
      .insert(documents)
      .values({ slug, title, content, ownerId: user.id })
      .returning({ slug: documents.slug, title: documents.title, createdAt: documents.createdAt });
  } catch (err) {
    if (isUniqueViolation(err)) throw slugTaken();
    throw err;
  }
  if (!row) {
    throw new HTTPException(500, { message: "failed to create document" });
  }
  return c.json({ slug: row.slug, title: row.title, createdAt: row.createdAt, url: docURL(row.slug) }, 201);
});

docsRoute.put("/:slug", requireUser, async (c) => {
  const { title, content, slug: wanted } = parseBody(createBody, await c.req.json().catch(() => null));
  const user = await loadUserRow(c);
  const doc = await ownDocument(c, user.id);
  await assertCanUpdateDocument(user, doc);
  if (wanted && wanted !== doc.slug) await assertSlugAvailable(user, wanted, doc.id);
  let row: Pick<Document, "slug" | "title" | "createdAt" | "updatedAt"> | undefined;
  try {
    row = await db.transaction(async (tx) => {
      if (wanted) await renameSlug(tx, doc, wanted);
      await archiveVersion(tx, user, doc, { title, content });
      const [updated] = await tx
        .update(documents)
        .set({ title, content, updatedAt: sql`now()` })
        .where(eq(documents.id, doc.id))
        .returning({
          slug: documents.slug,
          title: documents.title,
          createdAt: documents.createdAt,
          updatedAt: documents.updatedAt,
        });
      return updated;
    });
  } catch (err) {
    if (isUniqueViolation(err)) throw slugTaken();
    throw err;
  }
  if (!row) throw new HTTPException(404, { message: "document not found" });
  return c.json({ ...row, url: docURL(row.slug) });
});

// Rename only, for the dashboard: no content round trip. The old slug redirects.
docsRoute.patch("/:slug", requireUser, async (c) => {
  const { slug: wanted } = parseBody(renameBody, await c.req.json().catch(() => null));
  const user = await loadUserRow(c);
  const doc = await ownDocument(c, user.id);
  if (wanted !== doc.slug) {
    await assertSlugAvailable(user, wanted, doc.id);
    try {
      await db.transaction((tx) => renameSlug(tx, doc, wanted));
    } catch (err) {
      if (isUniqueViolation(err)) throw slugTaken();
      throw err;
    }
  }
  return c.json({ slug: wanted, title: doc.title, url: docURL(wanted) });
});

docsRoute.get("/me", requireUser, async (c) => {
  const user = await loadUserRow(c);
  const rows = await db
    .select({
      slug: documents.slug,
      title: documents.title,
      createdAt: documents.createdAt,
      updatedAt: documents.updatedAt,
      views: documents.views,
    })
    .from(documents)
    .where(eq(documents.ownerId, user.id))
    .orderBy(desc(documents.createdAt));
  // Views are counted for everyone but shown only with Premium (KER-809).
  const showViews = entitlementsFor(user).features.has("view_count");
  return c.json({ documents: rows.map(({ views, ...row }) => (showViews ? { ...row, views } : row)) });
});

docsRoute.delete("/:slug", requireUser, async (c) => {
  const doc = await ownDocument(c, c.get("user").id);
  await db.delete(documents).where(eq(documents.id, doc.id));
  return c.json({ ok: true });
});

// Public. A former slug answers with the document under its current slug; the
// web app turns that into a 301.
docsRoute.get("/:slug", async (c) => {
  const parsed = slugParam.safeParse(c.req.param());
  if (!parsed.success) {
    throw new HTTPException(400, { message: "invalid slug" });
  }
  const doc = await resolveDocument(parsed.data.slug);
  if (!doc) {
    throw new HTTPException(404, { message: "document not found" });
  }
  // Only the web page render sends the viewer's IP; unfurlers and raw API
  // calls fetch without it and stay uncounted. A former slug counts once the
  // browser lands on the current one.
  const viewer = c.req.header("x-seshat-viewer");
  if (viewer && doc.slug === parsed.data.slug) await recordView(doc.id, viewer);
  const { slug, title, content, createdAt, updatedAt } = doc;
  return c.json({ slug, title, content, createdAt, updatedAt });
});
