// Runs against the dev database in DATABASE_URL. Creates two throwaway users and
// removes them (and their documents, via cascade on owner) at the end.
import { afterAll, beforeAll, expect, test } from "bun:test";
import { eq, inArray } from "drizzle-orm";
import { db } from "../db/client";
import { documents, users } from "../db/schema";
import { app } from "../index";
import { issueSessionToken } from "../lib/auth";
import { entitlementsFor } from "../lib/entitlements";

const stamp = Date.now();
const ids: string[] = [];
const tokens: Record<"free" | "premium", string> = { free: "", premium: "" };

beforeAll(async () => {
  for (const plan of ["free", "premium"] as const) {
    const [u] = await db
      .insert(users)
      .values({
        googleSub: `test-${plan}-${stamp}`,
        email: `test-${plan}-${stamp}@example.invalid`,
        plan,
        planStatus: plan === "premium" ? "active" : null,
      })
      .returning({ id: users.id, email: users.email });
    if (!u) throw new Error("insert failed");
    ids.push(u.id);
    tokens[plan] = await issueSessionToken(u);
  }
});

afterAll(async () => {
  await db.delete(documents).where(inArray(documents.ownerId, ids));
  await db.delete(users).where(inArray(users.id, ids));
});

function call(method: string, path: string, token: string, body?: unknown) {
  return app.request(path, {
    method,
    headers: { authorization: `Bearer ${token}`, "content-type": "application/json" },
    body: body ? JSON.stringify(body) : undefined,
  });
}

const doc = (n: number) => ({ title: `Doc ${n}`, content: `# Doc ${n}` });

test("free user: 1 link, then 402, delete frees the quota, newer doc is read-only", async () => {
  const first = await call("POST", "/docs", tokens.free, doc(1));
  expect(first.status).toBe(201);
  const { slug } = (await first.json()) as { slug: string };

  const second = await call("POST", "/docs", tokens.free, doc(2));
  expect(second.status).toBe(402);
  expect(await second.json()).toMatchObject({ code: "quota_exceeded", used: 1, limit: 1 });

  const me = await (await call("GET", "/me", tokens.free)).json();
  expect(me).toMatchObject({ plan: "free", usage: { activeLinks: 1, limit: 1 } });

  // Oldest doc stays editable on the free plan.
  expect((await call("PUT", `/docs/${slug}`, tokens.free, doc(1))).status).toBe(200);

  // Simulate a churned user who owns a second, newer document.
  const [extra] = await db
    .insert(documents)
    .values({ slug: `t-${stamp}`, title: "x", content: "x", ownerId: ids[0] })
    .returning({ slug: documents.slug });
  const readOnly = await call("PUT", `/docs/${extra!.slug}`, tokens.free, doc(3));
  expect(readOnly.status).toBe(402);
  expect(await readOnly.json()).toMatchObject({ code: "read_only_over_quota" });
  expect((await call("GET", `/docs/${extra!.slug}`, "")).status).toBe(200);
  await db.delete(documents).where(eq(documents.slug, extra!.slug));

  expect((await call("DELETE", `/docs/${slug}`, tokens.free)).status).toBe(200);
  expect((await call("POST", "/docs", tokens.free, doc(4))).status).toBe(201);
});

test("premium user creates freely", async () => {
  expect((await call("POST", "/docs", tokens.premium, doc(1))).status).toBe(201);
  expect((await call("POST", "/docs", tokens.premium, doc(2))).status).toBe(201);
  const me = await (await call("GET", "/me", tokens.premium)).json();
  expect(me).toMatchObject({ plan: "premium", usage: { activeLinks: 2, limit: null } });
});

test("canceled subscription stays premium until period end", () => {
  const future = new Date(Date.now() + 86_400_000);
  const past = new Date(Date.now() - 86_400_000);
  expect(entitlementsFor({ plan: "premium", planStatus: "canceled", planPeriodEnd: future }).plan).toBe("premium");
  expect(entitlementsFor({ plan: "premium", planStatus: "canceled", planPeriodEnd: past }).plan).toBe("free");
  expect(entitlementsFor({ plan: "premium", planStatus: "active", planPeriodEnd: past }).plan).toBe("premium");
  expect(entitlementsFor({ plan: "free", planStatus: null, planPeriodEnd: null }).plan).toBe("free");
});
