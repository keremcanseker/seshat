import { eq } from "drizzle-orm";
import { HTTPException } from "hono/http-exception";
import { customAlphabet } from "nanoid";
import { z } from "zod";
import { db } from "../db/client";
import { documents, slugRedirects, type Document, type User } from "../db/schema";
import { entitlementsFor, paymentRequired } from "./entitlements";

const alphabet = "0123456789abcdefghijklmnopqrstuvwxyz";
const make = customAlphabet(alphabet, 10);

export const generateSlug = () => make();

/** A slug the user picks (KER-808, Premium `custom_slug`). Random slugs are 10 base36 chars. */
export const customSlug = z
  .string()
  .min(3)
  .max(64)
  .regex(/^[a-z0-9]+(-[a-z0-9]+)*$/, "slug must be lowercase letters, digits and single hyphens");

/** Looks a document up by its current slug, then by any slug it used to have. */
export async function resolveDocument(slug: string): Promise<Document | null> {
  const [direct] = await db.select().from(documents).where(eq(documents.slug, slug)).limit(1);
  if (direct) return direct;
  const [old] = await db
    .select({ doc: documents })
    .from(slugRedirects)
    .innerJoin(documents, eq(documents.id, slugRedirects.documentId))
    .where(eq(slugRedirects.slug, slug))
    .limit(1);
  return old?.doc ?? null;
}

export const slugTaken = () =>
  new HTTPException(409, {
    message: "slug already taken",
    res: Response.json({ error: "slug already taken", code: "slug_taken" }, { status: 409 }),
  });

/**
 * 402 when the plan lacks custom slugs, 409 when another document holds or
 * held `wanted`. A document may take back one of its own old slugs.
 */
export async function assertSlugAvailable(user: User, wanted: string, ownDocId?: string): Promise<void> {
  if (!entitlementsFor(user).features.has("custom_slug")) {
    throw paymentRequired(
      { code: "feature_required", feature: "custom_slug" },
      "custom slugs need Seshat Premium",
    );
  }
  const [current] = await db
    .select({ id: documents.id })
    .from(documents)
    .where(eq(documents.slug, wanted))
    .limit(1);
  if (current && current.id !== ownDocId) throw slugTaken();
  const [old] = await db
    .select({ documentId: slugRedirects.documentId })
    .from(slugRedirects)
    .where(eq(slugRedirects.slug, wanted))
    .limit(1);
  if (old && old.documentId !== ownDocId) throw slugTaken();
}

type Tx = Parameters<Parameters<typeof db.transaction>[0]>[0];

/** Moves a document to `wanted`; its previous slug keeps redirecting. Call after assertSlugAvailable. */
export async function renameSlug(tx: Tx, doc: Pick<Document, "id" | "slug">, wanted: string): Promise<void> {
  if (doc.slug === wanted) return;
  await tx.delete(slugRedirects).where(eq(slugRedirects.slug, wanted));
  await tx.insert(slugRedirects).values({ slug: doc.slug, documentId: doc.id }).onConflictDoNothing();
  await tx.update(documents).set({ slug: wanted }).where(eq(documents.id, doc.id));
}

/** Postgres unique_violation: two requests raced past assertSlugAvailable. */
export function isUniqueViolation(err: unknown): boolean {
  return typeof err === "object" && err !== null && (err as { code?: string }).code === "23505";
}
