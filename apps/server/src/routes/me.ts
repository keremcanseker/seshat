import { Hono } from "hono";
import { countDocuments, entitlementsFor } from "../lib/entitlements";
import { loadUserRow, requireUser, type AuthVariables } from "../middleware/auth";

export const meRoute = new Hono<{ Variables: AuthVariables }>();

meRoute.get("/", requireUser, async (c) => {
  const row = await loadUserRow(c);
  const ent = entitlementsFor(row);
  return c.json({
    user: { id: row.id, email: row.email, name: row.name, avatarUrl: row.avatarUrl },
    plan: ent.plan,
    planStatus: row.planStatus,
    planPeriodEnd: row.planPeriodEnd,
    features: [...ent.features],
    usage: { activeLinks: await countDocuments(row.id), limit: ent.quotas.activeLinks },
  });
});
