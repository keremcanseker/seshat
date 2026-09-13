// Runs against the dev database in DATABASE_URL, like docs.test.ts.
import { afterAll, beforeAll, expect, test } from "bun:test";
import { inArray } from "drizzle-orm";
import { db } from "../db/client";
import { sites, users } from "../db/schema";
import { app } from "../index";
import { issueSessionToken } from "../lib/auth";

const stamp = Date.now();
const ids: string[] = [];
const tokens: Record<"free" | "premium", string> = { free: "", premium: "" };

beforeAll(async () => {
  for (const plan of ["free", "premium"] as const) {
    const [u] = await db
      .insert(users)
      .values({
        googleSub: `site-test-${plan}-${stamp}`,
        email: `site-test-${plan}-${stamp}@example.invalid`,
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
  await db.delete(sites).where(inArray(sites.ownerId, ids));
  await db.delete(users).where(inArray(users.id, ids));
});

function call(method: string, path: string, token: string, body?: unknown) {
  return app.request(path, {
    method,
    headers: { authorization: `Bearer ${token}`, "content-type": "application/json" },
    body: body ? JSON.stringify(body) : undefined,
  });
}

const page = (path: string) => ({ path, title: path, content: `# ${path}` });
const site = (paths: string[]) => ({ title: "Docs", pages: paths.map(page) });

test("folder site is premium only", async () => {
  const res = await call("POST", "/sites", tokens.free, site(["README"]));
  expect(res.status).toBe(402);
  expect(await res.json()).toMatchObject({ code: "feature_required", feature: "folder_site" });
});

test("publish, re-publish replaces pages, public read, delete", async () => {
  const made = await call("POST", "/sites", tokens.premium, site(["README", "guides/setup"]));
  expect(made.status).toBe(201);
  const { slug, url } = (await made.json()) as { slug: string; url: string };
  expect(url).toContain(`/s/${slug}`);

  const read = await call("GET", `/sites/${slug}`, "");
  expect(read.status).toBe(200);
  const body = (await read.json()) as { pages: { path: string }[]; id?: string };
  expect(body.id).toBeUndefined();
  expect(body.pages.map((p) => p.path)).toEqual(["README", "guides/setup"]);

  // A dropped file disappears, a new one appears.
  const updated = await call("PUT", `/sites/${slug}`, tokens.premium, site(["README", "faq"]));
  expect(updated.status).toBe(200);
  const after = (await (await call("GET", `/sites/${slug}`, "")).json()) as { pages: { path: string }[] };
  expect(after.pages.map((p) => p.path)).toEqual(["README", "faq"]);

  // Someone else's site is 404 on write.
  expect((await call("PUT", `/sites/${slug}`, tokens.free, site(["x"]))).status).toBe(402);
  expect((await call("DELETE", `/sites/${slug}`, tokens.free)).status).toBe(404);

  const mine = (await (await call("GET", "/sites/me", tokens.premium)).json()) as { sites: { slug: string }[] };
  expect(mine.sites.map((s) => s.slug)).toContain(slug);

  expect((await call("DELETE", `/sites/${slug}`, tokens.premium)).status).toBe(200);
  expect((await call("GET", `/sites/${slug}`, "")).status).toBe(404);
});

test("rejects escaping paths and duplicates", async () => {
  expect((await call("POST", "/sites", tokens.premium, site(["../etc"]))).status).toBe(400);
  expect((await call("POST", "/sites", tokens.premium, site(["a", "a"]))).status).toBe(400);
  expect((await call("POST", "/sites", tokens.premium, site(["/abs"]))).status).toBe(400);
});
