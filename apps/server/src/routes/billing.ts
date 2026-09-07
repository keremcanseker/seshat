import { eq, or } from "drizzle-orm";
import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";
import { z } from "zod";
import { validateEvent, WebhookVerificationError } from "@polar-sh/sdk/webhooks.js";
import { db } from "../db/client";
import { users } from "../db/schema";
import { env } from "../env";
import { polar } from "../lib/polar";
import { PRICING, type Interval } from "../lib/plans";
import { loadUserRow, requireUser, type AuthVariables } from "../middleware/auth";

export const billingRoute = new Hono<{ Variables: AuthVariables }>();

const checkoutBody = z.object({ interval: z.enum(["monthly", "yearly"]) });

function client() {
  if (!polar) {
    throw new HTTPException(503, { message: "billing is not configured" });
  }
  return polar;
}

/** Polar rejected the call. Log the detail, tell the client something useful. */
function upstream(error: unknown, message: string): HTTPException {
  console.error(`polar: ${message}`, error);
  return new HTTPException(502, { message });
}

billingRoute.post("/checkout", requireUser, async (c) => {
  const parsed = checkoutBody.safeParse(await c.req.json().catch(() => null));
  if (!parsed.success) {
    throw new HTTPException(400, { message: "interval must be monthly or yearly" });
  }
  const interval: Interval = parsed.data.interval;
  const productId = PRICING[interval].polarProductId;
  if (!productId) {
    throw new HTTPException(503, { message: `no Polar product for ${interval}` });
  }
  const user = await loadUserRow(c);
  try {
    const checkout = await client().checkouts.create({
      products: [productId],
      // Ties the Polar customer to our user row; the webhook maps back by this id.
      externalCustomerId: user.id,
      customerEmail: user.email,
      successUrl: `${env.WEB_BASE_URL}/dashboard?checkout=success`,
    });
    return c.json({ url: checkout.url });
  } catch (error) {
    throw upstream(error, "could not start checkout");
  }
});

billingRoute.get("/portal", requireUser, async (c) => {
  const user = await loadUserRow(c);
  if (!user.polarCustomerId) {
    throw new HTTPException(404, { message: "no subscription to manage" });
  }
  try {
    const session = await client().customerSessions.create({
      customerId: user.polarCustomerId,
    });
    return c.json({ url: session.customerPortalUrl });
  } catch (error) {
    throw upstream(error, "could not open the customer portal");
  }
});

/**
 * Polar webhook. Unauthenticated by design: the Standard Webhooks signature over
 * the raw body is the authentication. The plan only ever changes here, never
 * from the checkout success redirect.
 */
billingRoute.post("/webhook", async (c) => {
  if (!env.POLAR_WEBHOOK_SECRET) {
    throw new HTTPException(503, { message: "billing is not configured" });
  }
  const raw = await c.req.text();
  const headers: Record<string, string> = {};
  c.req.raw.headers.forEach((value, key) => {
    headers[key] = value;
  });

  let event: ReturnType<typeof validateEvent>;
  try {
    event = validateEvent(raw, headers, env.POLAR_WEBHOOK_SECRET);
  } catch (error) {
    if (error instanceof WebhookVerificationError) {
      throw new HTTPException(403, { message: "invalid signature" });
    }
    // The signature was good but the payload did not match the SDK's schema.
    // 400 rather than 500 so Polar stops retrying and shows it as failed.
    console.error("polar webhook: unparseable payload", error);
    throw new HTTPException(400, { message: "unparseable payload" });
  }

  // One line per delivery, so KER-793's audit has something to read.
  console.log(`polar webhook ${headers["webhook-id"] ?? "?"} ${event.type}`);

  switch (event.type) {
    case "subscription.created":
    case "subscription.updated":
    case "subscription.active":
    case "subscription.canceled":
    case "subscription.past_due":
    case "subscription.uncanceled":
    case "subscription.revoked":
      await applySubscription(event.data);
      break;
    default:
      break;
  }

  return c.json({ ok: true });
});

type SubscriptionEvent = {
  id: string;
  status: string;
  cancelAtPeriodEnd: boolean;
  currentPeriodEnd: Date | null;
  customerId: string;
  customer: { id: string; externalId?: string | null };
};

/**
 * Writes plan state onto the user row. Deliberately dumb: it records what Polar
 * says and lets `entitlementsFor` decide access, so a canceled subscription
 * keeps premium until its period end with no scheduled job.
 */
async function applySubscription(sub: SubscriptionEvent): Promise<void> {
  const externalId = sub.customer.externalId ?? null;
  const match = externalId
    ? or(eq(users.id, externalId), eq(users.polarCustomerId, sub.customerId))
    : eq(users.polarCustomerId, sub.customerId);

  const [user] = await db.select().from(users).where(match).limit(1);
  if (!user) {
    console.warn(`polar webhook: no user for customer ${sub.customerId}`);
    return;
  }

  // "dead" statuses end access immediately; everything else stays premium and
  // lets the period end decide.
  const dead = ["revoked", "unpaid", "incomplete_expired"].includes(sub.status);
  const periodEnd = sub.currentPeriodEnd ?? null;
  // Polar keeps a cancelled subscription at status "active" with
  // cancel_at_period_end until the period actually runs out. Record it as
  // "canceled" so the dashboard can say when it ends; entitlements still read
  // premium because the period end is in the future.
  const status = sub.cancelAtPeriodEnd && sub.status === "active" ? "canceled" : sub.status;

  // ponytail: out-of-order deliveries are guarded by the period end alone.
  // Polar retries can arrive late; an older event never rolls a newer one back.
  if (
    !dead &&
    user.polarSubscriptionId === sub.id &&
    user.planPeriodEnd &&
    periodEnd &&
    periodEnd < user.planPeriodEnd
  ) {
    console.log(`polar webhook: ignoring stale event for subscription ${sub.id}`);
    return;
  }

  await db
    .update(users)
    .set({
      plan: dead ? "free" : "premium",
      planStatus: dead ? null : status,
      planPeriodEnd: dead ? null : periodEnd,
      polarCustomerId: sub.customerId,
      polarSubscriptionId: sub.id,
      updatedAt: new Date(),
    })
    .where(eq(users.id, user.id));

  console.log(`polar webhook: ${user.id} -> ${dead ? "free" : "premium"} (${status})`);
}
