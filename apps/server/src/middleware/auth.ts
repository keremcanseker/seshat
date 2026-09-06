import { eq } from "drizzle-orm";
import { createMiddleware } from "hono/factory";
import type { Context } from "hono";
import { getCookie } from "hono/cookie";
import { HTTPException } from "hono/http-exception";
import { db } from "../db/client";
import { users, type User } from "../db/schema";
import { verifySessionToken } from "../lib/auth";
import { entitlementsFor, paymentRequired } from "../lib/entitlements";
import type { FeatureKey } from "../lib/plans";

export const SESSION_COOKIE = "seshat_session";

export type AuthVariables = {
  user: {
    id: string;
    email: string;
  };
  userRow?: User;
};

function readBearer(headerValue: string | undefined): string | null {
  if (!headerValue) return null;
  return headerValue.startsWith("Bearer ") ? headerValue.slice(7) : null;
}

export const requireUser = createMiddleware<{ Variables: AuthVariables }>(
  async (c, next) => {
    const token = readBearer(c.req.header("authorization")) ?? getCookie(c, SESSION_COOKIE);
    if (!token) {
      throw new HTTPException(401, { message: "authentication required" });
    }
    try {
      const payload = await verifySessionToken(token);
      c.set("user", { id: payload.sub, email: payload.email });
    } catch {
      throw new HTTPException(401, { message: "invalid or expired session" });
    }
    await next();
  },
);

/** Full users row for the session, read once per request and memoized on the context. */
export async function loadUserRow(c: Context<{ Variables: AuthVariables }>): Promise<User> {
  const cached = c.get("userRow");
  if (cached) return cached;
  const [row] = await db.select().from(users).where(eq(users.id, c.get("user").id)).limit(1);
  if (!row) throw new HTTPException(401, { message: "user not found" });
  c.set("userRow", row);
  return row;
}

/** Use after requireUser. 402 { code: "feature_required" } when the plan lacks the feature. */
export function requireFeature(key: FeatureKey) {
  return createMiddleware<{ Variables: AuthVariables }>(async (c, next) => {
    const row = await loadUserRow(c);
    if (!entitlementsFor(row).features.has(key)) {
      throw paymentRequired({ code: "feature_required", feature: key }, `${key} needs Seshat Premium`);
    }
    await next();
  });
}
