// Runs against the dev database in DATABASE_URL, like docs.test.ts.
import { afterAll, beforeAll, expect, test } from "bun:test";
import { inArray } from "drizzle-orm";
import { db } from "../db/client";
import { documents, users } from "../db/schema";
import { app } from "../index";
import { issueSessionToken } from "../lib/auth";
import { PLANS } from "../lib/plans";

const stamp = Date.now();
const ids: string[] = [];
const tokens: Record<"free" | "premium", string> = { free: "", premium: "" };

beforeAll(async () => {
  for (const plan of ["free", "premium"] as const) {
    const [u] = await db
      .insert(users)
      .values({
        googleSub: `test-versions-${plan}-${stamp}`,
        email: `test-versions-${plan}-${stamp}@example.invalid`,
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

const doc = (n: number) => ({ title: `Doc v${n}`, content: `# Doc v${n}` });

type Version = { id: string; title: string; createdAt: string; bytes: number };
async function versions(slug: string, token: string): Promise<Version[]> {
  const res = await call("GET", `/docs/${slug}/versions`, token);
  expect(res.status).toBe(200);
  return ((await res.json()) as { versions: Version[] }).versions;
}

let freeSlug = "";

test("free plan keeps no history and the endpoints are behind the wall", async () => {
  const { slug } = (await (await call("POST", "/docs", tokens.free, doc(1))).json()) as { slug: string };
  freeSlug = slug;
  expect((await call("PUT", `/docs/${slug}`, tokens.free, doc(2))).status).toBe(200);
  const res = await call("GET", `/docs/${slug}/versions`, tokens.free);
  expect(res.status).toBe(402);
  expect(await res.json()).toMatchObject({ code: "feature_required", feature: "version_history" });
});

test("premium: every changed re-share is kept, capped, downloadable and restorable", async () => {
  const keep = PLANS.premium.quotas.versions;
  const { slug } = (await (await call("POST", "/docs", tokens.premium, doc(0))).json()) as { slug: string };
  expect(await versions(slug, tokens.premium)).toEqual([]);

  // Same content again: nothing to keep.
  expect((await call("PUT", `/docs/${slug}`, tokens.premium, doc(0))).status).toBe(200);
  expect(await versions(slug, tokens.premium)).toEqual([]);

  for (let n = 1; n <= keep + 2; n++) {
    expect((await call("PUT", `/docs/${slug}`, tokens.premium, doc(n))).status).toBe(200);
  }
  const list = await versions(slug, tokens.premium);
  expect(list).toHaveLength(keep);
  // Newest first; the oldest ones fell off.
  expect(list[0]!.title).toBe(`Doc v${keep + 1}`);
  expect(list[keep - 1]!.title).toBe("Doc v2");
  expect(list[0]!.bytes).toBe(new TextEncoder().encode(`# Doc v${keep + 1}`).byteLength);

  const raw = await call("GET", `/docs/${slug}/versions/${list[0]!.id}`, tokens.premium);
  expect(raw.status).toBe(200);
  expect(raw.headers.get("content-type")).toContain("text/markdown");
  expect(await raw.text()).toBe(`# Doc v${keep + 1}`);

  // Restore: the old text is live, what was live is now the newest version.
  const target = list[keep - 1]!;
  expect((await call("POST", `/docs/${slug}/versions/${target.id}/restore`, tokens.premium)).status).toBe(200);
  expect(await (await call("GET", `/docs/${slug}`, "")).json()).toMatchObject({ title: "Doc v2", content: "# Doc v2" });
  const after = await versions(slug, tokens.premium);
  expect(after).toHaveLength(keep);
  expect(after[0]!.title).toBe(`Doc v${keep + 2}`);

  // Another owner's document is a 404, not a leak.
  expect((await call("GET", `/docs/${freeSlug}/versions`, tokens.premium)).status).toBe(404);
  expect((await call("GET", `/docs/${slug}/versions/not-a-uuid`, tokens.premium)).status).toBe(400);

  // Deleting the document takes its history with it.
  expect((await call("DELETE", `/docs/${slug}`, tokens.premium)).status).toBe(200);
  expect((await call("GET", `/docs/${slug}/versions`, tokens.premium)).status).toBe(404);
});
