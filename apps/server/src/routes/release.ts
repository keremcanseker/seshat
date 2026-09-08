import { Hono } from "hono";
import { env } from "../env";

const MANIFEST_TTL_MS = 60_000;

type VersionBody = { version: string; url: string; notes: string | null };

export const releaseRoute = new Hono();

let manifestCache: { at: number; body: VersionBody } | null = null;

async function fetchManifest(url: string): Promise<VersionBody | null> {
  const now = Date.now();
  if (manifestCache && now - manifestCache.at < MANIFEST_TTL_MS) {
    return manifestCache.body;
  }
  try {
    const res = await fetch(url, { signal: AbortSignal.timeout(5000) });
    if (!res.ok) return null;
    const raw = (await res.json()) as { version?: unknown; notes?: unknown };
    if (typeof raw.version !== "string" || raw.version.length === 0) return null;
    const body: VersionBody = {
      version: raw.version,
      url: `${env.PUBLIC_BASE_URL}/download`,
      notes: typeof raw.notes === "string" ? raw.notes : null,
    };
    manifestCache = { at: now, body };
    return body;
  } catch {
    return null;
  }
}

// Drives the macOS in-app update banner. Prefers the CI-published manifest (no
// redeploy per release); falls back to env. 404 until a release is configured.
releaseRoute.get("/version", async (c) => {
  if (env.SESHAT_RELEASE_MANIFEST_URL) {
    const body = await fetchManifest(env.SESHAT_RELEASE_MANIFEST_URL);
    if (body) return c.json(body);
  }
  if (env.SESHAT_LATEST_VERSION && env.SESHAT_DMG_URL) {
    return c.json({
      version: env.SESHAT_LATEST_VERSION,
      url: `${env.PUBLIC_BASE_URL}/download`,
      notes: env.SESHAT_RELEASE_NOTES ?? null,
    });
  }
  return c.json({ error: "no release configured" }, 404);
});

// The public "Download for macOS" target: redirects to the current DMG. Always
// serves the latest because SESHAT_DMG_URL is the only source.
releaseRoute.get("/download", (c) => {
  if (!env.SESHAT_DMG_URL) {
    return c.json({ error: "download not available" }, 503);
  }
  return c.redirect(env.SESHAT_DMG_URL, 302);
});
