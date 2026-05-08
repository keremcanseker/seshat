import { eq } from "drizzle-orm";
import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";
import { z } from "zod";
import { db } from "../db/client";
import { documents } from "../db/schema";
import { env } from "../env";
import { generateSlug } from "../lib/slug";
import { requireWriteToken } from "../middleware/auth";

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
});

const slugParam = z.object({
  slug: z
    .string()
    .min(1)
    .max(64)
    .regex(/^[a-z0-9-]+$/, "slug must be lowercase alphanumeric"),
});

export const docsRoute = new Hono();

docsRoute.post("/", requireWriteToken, async (c) => {
  const parsed = createBody.safeParse(await c.req.json().catch(() => null));
  if (!parsed.success) {
    throw new HTTPException(400, {
      message: parsed.error.issues.map((i) => i.message).join("; "),
    });
  }
  const { title, content } = parsed.data;
  const slug = generateSlug();
  const [row] = await db
    .insert(documents)
    .values({ slug, title, content })
    .returning({
      slug: documents.slug,
      title: documents.title,
      createdAt: documents.createdAt,
    });
  if (!row) {
    throw new HTTPException(500, { message: "failed to create document" });
  }
  return c.json(
    {
      slug: row.slug,
      title: row.title,
      createdAt: row.createdAt,
      url: `${env.PUBLIC_BASE_URL}/d/${row.slug}`,
    },
    201,
  );
});

docsRoute.get("/:slug", async (c) => {
  const parsed = slugParam.safeParse(c.req.param());
  if (!parsed.success) {
    throw new HTTPException(400, { message: "invalid slug" });
  }
  const [doc] = await db
    .select({
      slug: documents.slug,
      title: documents.title,
      content: documents.content,
      createdAt: documents.createdAt,
      updatedAt: documents.updatedAt,
    })
    .from(documents)
    .where(eq(documents.slug, parsed.data.slug))
    .limit(1);
  if (!doc) {
    throw new HTTPException(404, { message: "document not found" });
  }
  return c.json(doc);
});
