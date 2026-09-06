import { and, count, eq, lt, or, sql } from "drizzle-orm";
import { HTTPException } from "hono/http-exception";
import { db } from "../db/client";
import { documents, type User } from "../db/schema";
import { env } from "../env";
import { PLANS, type FeatureKey, type PlanId, type Quotas } from "./plans";

export type Entitlements = {
  plan: PlanId;
  features: Set<FeatureKey>;
  quotas: Quotas;
};

type BillingRow = Pick<User, "plan" | "planStatus" | "planPeriodEnd">;

/**
 * The one place that decides what a user may do. Canceled (or past_due)
 * subscriptions stay premium until plan_period_end; the webhook never has to
 * schedule a downgrade.
 */
export function entitlementsFor(user: BillingRow, now: Date = new Date()): Entitlements {
  const stillPaid =
    user.planStatus === "active" ||
    (user.planPeriodEnd !== null && user.planPeriodEnd > now);
  const plan: PlanId = user.plan === "premium" && stillPaid ? "premium" : "free";
  return {
    plan,
    features: new Set(PLANS[plan].features),
    quotas: PLANS[plan].quotas,
  };
}

export const upgradeUrl = `${env.WEB_BASE_URL}/pricing`;

/** 402 with a JSON body. Bodies carry codes and counts only, never internal ids. */
export function paymentRequired(body: Record<string, unknown>, message: string): HTTPException {
  return new HTTPException(402, {
    message,
    res: Response.json({ error: message, ...body, upgradeUrl }, { status: 402 }),
  });
}

export async function countDocuments(ownerId: string): Promise<number> {
  const [row] = await db
    .select({ n: count() })
    .from(documents)
    .where(eq(documents.ownerId, ownerId));
  return row?.n ?? 0;
}

/** Quota applies to creating new documents only. Shared by POST /docs and any future CLI/MCP route. */
export async function assertCanCreateDocument(user: User): Promise<void> {
  const limit = entitlementsFor(user).quotas.activeLinks;
  if (limit === null) return;
  const used = await countDocuments(user.id);
  if (used >= limit) {
    throw paymentRequired(
      { code: "quota_exceeded", used, limit },
      "free plan link limit reached",
    );
  }
}

/**
 * A free user may update only their oldest N documents (N = free quota);
 * anything newer is read-only until they upgrade. Missing docs fall through so
 * the caller's own 404 fires.
 */
export async function assertCanUpdateDocument(user: User, slug: string): Promise<void> {
  const limit = entitlementsFor(user).quotas.activeLinks;
  if (limit === null) return;
  const [doc] = await db
    .select({ id: documents.id, createdAt: documents.createdAt })
    .from(documents)
    .where(and(eq(documents.slug, slug), eq(documents.ownerId, user.id)))
    .limit(1);
  if (!doc) return;
  const [older] = await db
    .select({ n: count() })
    .from(documents)
    .where(
      and(
        eq(documents.ownerId, user.id),
        or(
          lt(documents.createdAt, doc.createdAt),
          and(eq(documents.createdAt, doc.createdAt), sql`${documents.id} < ${doc.id}`),
        ),
      ),
    );
  if ((older?.n ?? 0) >= limit) {
    throw paymentRequired(
      { code: "read_only_over_quota", limit },
      "this document is above the free allowance and is read-only",
    );
  }
}
