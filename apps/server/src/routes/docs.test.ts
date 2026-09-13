// Runs against the dev database in DATABASE_URL. Creates two throwaway users and
// removes them (and their documents, via cascade on owner) at the end.
import { afterAll, beforeAll, expect, test } from "bun:test";
import { eq, inArray, sql } from "drizzle-orm";
import { db } from "../db/client";
import { documents, documentViewers, users } from "../db/schema";
import { app } from "../index";
import { issueSessionToken } from "../lib/auth";
import { entitlementsFor } from "../lib/entitlements";
import { resetRateLimits } from "../lib/rate-limit";

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

/** Every 4xx body we hand a client must be free of database ids. */
function expectNoInternalIds(body: unknown): void {
  const text = JSON.stringify(body);
  expect(text).not.toMatch(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i);
  for (const id of ids) expect(text).not.toContain(id);
}

test("free user: 1 link, then 402, delete frees the quota, newer doc is read-only", async () => {
  const first = await call("POST", "/docs", tokens.free, doc(1));
  expect(first.status).toBe(201);
  const { slug } = (await first.json()) as { slug: string };

  const second = await call("POST", "/docs", tokens.free, doc(2));
  expect(second.status).toBe(402);
  const quotaBody = await second.json();
  expect(quotaBody).toMatchObject({ code: "quota_exceeded", used: 1, limit: 1 });
  expectNoInternalIds(quotaBody);

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
  const readOnlyBody = await readOnly.json();
  expect(readOnlyBody).toMatchObject({ code: "read_only_over_quota" });
  expectNoInternalIds(readOnlyBody);
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

test("free account cannot cycle create and delete forever", async () => {
  resetRateLimits();
  // Start from an empty library so the quota never masks the rate limit.
  await db.delete(documents).where(eq(documents.ownerId, ids[0]!));
  // Ten creates are allowed per hour; each one is deleted so the quota never bites.
  for (let i = 0; i < 10; i++) {
    const made = await call("POST", "/docs", tokens.free, doc(i));
    expect(made.status).toBe(201);
    const { slug } = (await made.json()) as { slug: string };
    expect((await call("DELETE", `/docs/${slug}`, tokens.free)).status).toBe(200);
  }
  const blocked = await call("POST", "/docs", tokens.free, doc(11));
  expect(blocked.status).toBe(429);
  const body = await blocked.json();
  expect(body).toMatchObject({ code: "rate_limited" });
  expectNoInternalIds(body);

  // Premium is not rate limited here.
  resetRateLimits();
  expect((await call("POST", "/docs", tokens.premium, doc(12))).status).toBe(201);
});

test("custom slug: premium only, old slug keeps resolving, nobody can take it", async () => {
  const free = await call("POST", "/docs", tokens.free, { ...doc(1), slug: `free-pick-${stamp}` });
  expect(free.status).toBe(402);
  const freeBody = await free.json();
  expect(freeBody).toMatchObject({ code: "feature_required", feature: "custom_slug" });
  expectNoInternalIds(freeBody);

  const first = `q3-plan-${stamp}`;
  const made = await call("POST", "/docs", tokens.premium, { ...doc(1), slug: first });
  expect(made.status).toBe(201);
  expect(await made.json()).toMatchObject({ slug: first, url: expect.stringContaining(`/d/${first}`) });

  // Dashboard rename; the first slug becomes a redirect.
  const second = `q3-plan-final-${stamp}`;
  const renamed = await call("PATCH", `/docs/${first}`, tokens.premium, { slug: second });
  expect(renamed.status).toBe(200);
  const viaOld = await call("GET", `/docs/${first}`, "");
  expect(viaOld.status).toBe(200);
  expect(await viaOld.json()).toMatchObject({ slug: second });

  // Old slug stays reserved for this document; re-share through it self-heals.
  const other = await call("POST", "/docs", tokens.premium, { ...doc(2), slug: first });
  expect(other.status).toBe(409);
  expect(await other.json()).toMatchObject({ code: "slug_taken" });
  const reshared = await call("PUT", `/docs/${first}`, tokens.premium, doc(1));
  expect(reshared.status).toBe(200);
  expect(await reshared.json()).toMatchObject({ slug: second });

  // Taking your own old slug back works; the newer one redirects instead.
  const back = await call("PUT", `/docs/${second}`, tokens.premium, { ...doc(1), slug: first });
  expect(back.status).toBe(200);
  expect(await (await call("GET", `/docs/${second}`, "")).json()).toMatchObject({ slug: first });

  expect((await call("POST", "/docs", tokens.premium, { ...doc(3), slug: "ab" })).status).toBe(400);
  expect((await call("POST", "/docs", tokens.premium, { ...doc(3), slug: "-bad-" })).status).toBe(400);

  expect((await call("DELETE", `/docs/${second}`, tokens.premium)).status).toBe(200);
  expect((await call("GET", `/docs/${first}`, "")).status).toBe(404);
  expect((await call("GET", `/docs/${second}`, "")).status).toBe(404);
});

test("view count: one per viewer per 24 h, premium sees it, free does not", async () => {
  const made = await call("POST", "/docs", tokens.premium, doc(1));
  const { slug } = (await made.json()) as { slug: string };
  const view = (ip?: string) =>
    app.request(`/docs/${slug}`, { headers: ip ? { "x-seshat-viewer": ip } : {} });

  await view(); // no viewer header: unfurlers and raw API calls do not count
  await view("10.0.0.1");
  await view("10.0.0.1"); // same viewer within 24 h
  await view("10.0.0.2");
  const mine = (await (await call("GET", "/docs/me", tokens.premium)).json()) as {
    documents: { slug: string; views?: number }[];
  };
  expect(mine.documents.find((d) => d.slug === slug)?.views).toBe(2);

  // Viewer seen more than a day ago counts again.
  await db
    .update(documentViewers)
    .set({ seenAt: sql`now() - interval '25 hours'` })
    .where(inArray(documentViewers.documentId, db.select({ id: documents.id }).from(documents).where(eq(documents.slug, slug))));
  await view("10.0.0.1");
  const again = (await (await call("GET", "/docs/me", tokens.premium)).json()) as typeof mine;
  expect(again.documents.find((d) => d.slug === slug)?.views).toBe(3);

  // Free accounts never see the number.
  const free = (await (await call("GET", "/docs/me", tokens.free)).json()) as typeof mine;
  for (const d of free.documents) expect(d).not.toHaveProperty("views");
});

test("canceled subscription stays premium until period end", () => {
  const future = new Date(Date.now() + 86_400_000);
  const past = new Date(Date.now() - 86_400_000);
  expect(entitlementsFor({ plan: "premium", planStatus: "canceled", planPeriodEnd: future }).plan).toBe("premium");
  expect(entitlementsFor({ plan: "premium", planStatus: "canceled", planPeriodEnd: past }).plan).toBe("free");
  expect(entitlementsFor({ plan: "premium", planStatus: "active", planPeriodEnd: past }).plan).toBe("premium");
  expect(entitlementsFor({ plan: "free", planStatus: null, planPeriodEnd: null }).plan).toBe("free");
});
