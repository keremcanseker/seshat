import { and, desc, eq, sql } from "drizzle-orm";
import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";
import { z } from "zod";
import { db } from "../db/client";
import { documentVersions, documents } from "../db/schema";
import { archiveVersion } from "../lib/versions";
import { loadUserRow, requireFeature, requireUser, type AuthVariables } from "../middleware/auth";
import { ownDocument } from "./docs";

// Earlier versions of a shared document (KER-807, Premium `version_history`).
// Mounted under /docs; every route is owner-only.
export const versionsRoute = new Hono<{ Variables: AuthVariables }>();

versionsRoute.use("/:slug/versions/*", requireUser, requireFeature("version_history"));
versionsRoute.use("/:slug/versions", requireUser, requireFeature("version_history"));

const versionId = z.string().uuid();

async function ownVersion(c: { req: { param: (k: "id") => string } }, documentId: string) {
  const id = versionId.safeParse(c.req.param("id"));
  if (!id.success) throw new HTTPException(400, { message: "invalid version id" });
  const [v] = await db
    .select()
    .from(documentVersions)
    .where(and(eq(documentVersions.id, id.data), eq(documentVersions.documentId, documentId)))
    .limit(1);
  if (!v) throw new HTTPException(404, { message: "version not found" });
  return v;
}

versionsRoute.get("/:slug/versions", async (c) => {
  const user = await loadUserRow(c);
  const doc = await ownDocument(c, user.id);
  const rows = await db
    .select({
      id: documentVersions.id,
      title: documentVersions.title,
      createdAt: documentVersions.createdAt,
      bytes: sql<number>`octet_length(${documentVersions.content})`.mapWith(Number),
    })
    .from(documentVersions)
    .where(eq(documentVersions.documentId, doc.id))
    .orderBy(desc(documentVersions.createdAt));
  return c.json({ versions: rows });
});

// Raw markdown of one version, as a download.
versionsRoute.get("/:slug/versions/:id", async (c) => {
  const user = await loadUserRow(c);
  const doc = await ownDocument(c, user.id);
  const v = await ownVersion(c, doc.id);
  const stamp = v.createdAt.toISOString().slice(0, 19).replace(/[T:]/g, "-");
  return c.body(v.content, 200, {
    "content-type": "text/markdown; charset=utf-8",
    "content-disposition": `attachment; filename="${doc.slug}-${stamp}.md"`,
  });
});

// Makes an earlier version current again. What was current is archived first,
// so a restore is undoable by restoring once more.
versionsRoute.post("/:slug/versions/:id/restore", async (c) => {
  const user = await loadUserRow(c);
  const doc = await ownDocument(c, user.id);
  const v = await ownVersion(c, doc.id);
  await db.transaction(async (tx) => {
    await archiveVersion(tx, user, doc, v);
    await tx
      .update(documents)
      .set({ title: v.title, content: v.content, updatedAt: sql`now()` })
      .where(eq(documents.id, doc.id));
  });
  return c.json({ slug: doc.slug, title: v.title });
});
