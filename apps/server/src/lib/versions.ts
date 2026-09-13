import { and, desc, eq, notInArray } from "drizzle-orm";
import { db } from "../db/client";
import { documentVersions, type Document, type User } from "../db/schema";
import { entitlementsFor } from "./entitlements";

type Tx = Parameters<Parameters<typeof db.transaction>[0]>[0];

/**
 * Files the document's current text away before a re-share or restore
 * overwrites it (KER-807). No-op on the free plan and when nothing changed,
 * so `seshat share` of an unchanged file does not pile up copies. Keeps the
 * newest `quotas.versions` rows.
 */
export async function archiveVersion(
  tx: Tx,
  user: User,
  doc: Pick<Document, "id" | "title" | "content" | "updatedAt">,
  next: { title: string; content: string },
): Promise<void> {
  const ent = entitlementsFor(user);
  if (!ent.features.has("version_history") || ent.quotas.versions === 0) return;
  if (doc.title === next.title && doc.content === next.content) return;
  await tx.insert(documentVersions).values({
    documentId: doc.id,
    title: doc.title,
    content: doc.content,
    createdAt: doc.updatedAt,
  });
  const keep = tx
    .select({ id: documentVersions.id })
    .from(documentVersions)
    .where(eq(documentVersions.documentId, doc.id))
    .orderBy(desc(documentVersions.createdAt))
    .limit(ent.quotas.versions);
  await tx
    .delete(documentVersions)
    .where(and(eq(documentVersions.documentId, doc.id), notInArray(documentVersions.id, keep)));
}
