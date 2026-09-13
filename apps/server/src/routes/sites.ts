import { and, desc, eq, sql } from "drizzle-orm";
import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";
import { z } from "zod";
import { db } from "../db/client";
import { sitePages, sites } from "../db/schema";
import { env } from "../env";
import { generateSlug } from "../lib/slug";
import { loadUserRow, requireFeature, requireUser, type AuthVariables } from "../middleware/auth";

// A folder published as a mini site (KER-811, Premium `folder_site`). Every
// publish sends the whole folder and replaces every page: no diffing, no
// per-page endpoints. A removed file is a removed page.
const MAX_PAGES = 200;
const MAX_PAGE_BYTES = 1_000_000;
const MAX_SITE_BYTES = 5_000_000;

const bytes = (s: string) => new TextEncoder().encode(s).byteLength;

const pathSchema = z
  .string()
  .min(1)
  .max(300)
  .refine(
    (p) =>
      !/[\\\u0000-\u001f]/.test(p) &&
      p.split("/").every((seg) => seg !== "" && seg !== "." && seg !== ".."),
    { message: "invalid page path" },
  );

const publishBody = z
  .object({
    title: z.string().trim().min(1).max(200),
    pages: z
      .array(
        z.object({
          path: pathSchema,
          title: z.string().trim().min(1).max(200),
          content: z.string().refine((s) => bytes(s) <= MAX_PAGE_BYTES, {
            message: `a page exceeds ${MAX_PAGE_BYTES} bytes`,
          }),
        }),
      )
      .min(1)
      .max(MAX_PAGES),
  })
  .refine((b) => new Set(b.pages.map((p) => p.path)).size === b.pages.length, {
    message: "duplicate page paths",
  })
  .refine((b) => b.pages.reduce((n, p) => n + bytes(p.content), 0) <= MAX_SITE_BYTES, {
    message: `site exceeds ${MAX_SITE_BYTES} bytes`,
  });

const slugParam = z.object({
  slug: z.string().min(1).max(64).regex(/^[a-z0-9-]+$/),
});

function parseSlug(c: { req: { param: () => Record<string, string> } }): string {
  const parsed = slugParam.safeParse(c.req.param());
  if (!parsed.success) throw new HTTPException(400, { message: "invalid slug" });
  return parsed.data.slug;
}

async function parseBody(raw: unknown) {
  const parsed = publishBody.safeParse(raw);
  if (!parsed.success) {
    throw new HTTPException(400, {
      message: parsed.error.issues.map((i) => i.message).join("; "),
    });
  }
  return parsed.data;
}

const siteURL = (slug: string) => `${env.WEB_BASE_URL}/s/${slug}`;

export const sitesRoute = new Hono<{ Variables: AuthVariables }>();

sitesRoute.post("/", requireUser, requireFeature("folder_site"), async (c) => {
  const { title, pages } = await parseBody(await c.req.json().catch(() => null));
  const user = await loadUserRow(c);
  const slug = generateSlug();
  const row = await db.transaction(async (tx) => {
    const [site] = await tx
      .insert(sites)
      .values({ slug, title, ownerId: user.id })
      .returning({ id: sites.id, slug: sites.slug, title: sites.title, createdAt: sites.createdAt });
    if (!site) throw new HTTPException(500, { message: "failed to create site" });
    await tx.insert(sitePages).values(pages.map((p) => ({ ...p, siteId: site.id })));
    return site;
  });
  return c.json(
    { slug: row.slug, title: row.title, createdAt: row.createdAt, url: siteURL(row.slug) },
    201,
  );
});

sitesRoute.put("/:slug", requireUser, requireFeature("folder_site"), async (c) => {
  const slug = parseSlug(c);
  const { title, pages } = await parseBody(await c.req.json().catch(() => null));
  const user = await loadUserRow(c);
  const row = await db.transaction(async (tx) => {
    const [site] = await tx
      .update(sites)
      .set({ title, updatedAt: sql`now()` })
      .where(and(eq(sites.slug, slug), eq(sites.ownerId, user.id)))
      .returning({
        id: sites.id,
        slug: sites.slug,
        title: sites.title,
        createdAt: sites.createdAt,
        updatedAt: sites.updatedAt,
      });
    if (!site) return null;
    await tx.delete(sitePages).where(eq(sitePages.siteId, site.id));
    await tx.insert(sitePages).values(pages.map((p) => ({ ...p, siteId: site.id })));
    return site;
  });
  if (!row) throw new HTTPException(404, { message: "site not found" });
  return c.json({
    slug: row.slug,
    title: row.title,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    url: siteURL(row.slug),
  });
});

sitesRoute.get("/me", requireUser, async (c) => {
  const user = c.get("user");
  const rows = await db
    .select({
      slug: sites.slug,
      title: sites.title,
      createdAt: sites.createdAt,
      updatedAt: sites.updatedAt,
    })
    .from(sites)
    .where(eq(sites.ownerId, user.id))
    .orderBy(desc(sites.createdAt));
  return c.json({ sites: rows });
});

// Deleting your own site is never paywalled, so no feature gate here.
sitesRoute.delete("/:slug", requireUser, async (c) => {
  const slug = parseSlug(c);
  const user = c.get("user");
  const result = await db
    .delete(sites)
    .where(and(eq(sites.slug, slug), eq(sites.ownerId, user.id)))
    .returning({ slug: sites.slug });
  if (result.length === 0) throw new HTTPException(404, { message: "site not found" });
  return c.json({ ok: true });
});

// Public. Ships every page's content so the web app can render any page and
// search the whole site client-side without a second round trip.
// ponytail: whole site per request, bounded by MAX_SITE_BYTES; add a search
// index endpoint if the cap ever moves.
sitesRoute.get("/:slug", async (c) => {
  const slug = parseSlug(c);
  const [site] = await db
    .select({
      id: sites.id,
      slug: sites.slug,
      title: sites.title,
      createdAt: sites.createdAt,
      updatedAt: sites.updatedAt,
    })
    .from(sites)
    .where(eq(sites.slug, slug))
    .limit(1);
  if (!site) throw new HTTPException(404, { message: "site not found" });
  const pages = await db
    .select({ path: sitePages.path, title: sitePages.title, content: sitePages.content })
    .from(sitePages)
    .where(eq(sitePages.siteId, site.id))
    .orderBy(sql`${sitePages.path} COLLATE "C"`);
  const { id: _id, ...publicSite } = site;
  return c.json({ ...publicSite, pages });
});
