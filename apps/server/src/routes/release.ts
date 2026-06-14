import { Hono } from "hono";
import { db } from "../db/client";
import { downloadEvents } from "../db/schema";
import { env } from "../env";
import { sendDownloadNotification } from "../lib/notify";

const MAX_FIELD_LEN = 512;

export const releaseRoute = new Hono();

// Drives the macOS in-app update banner. Returns the latest published version
// and where to get it. 404 until a release is configured via env.
releaseRoute.get("/version", (c) => {
  if (!env.SESHAT_LATEST_VERSION || !env.SESHAT_DMG_URL) {
    return c.json({ error: "no release configured" }, 404);
  }
  return c.json({
    version: env.SESHAT_LATEST_VERSION,
    url: `${env.PUBLIC_BASE_URL}/download`,
    notes: env.SESHAT_RELEASE_NOTES ?? null,
  });
});

// The public "Download for macOS" target: logs the event, then redirects to the
// current DMG. Always serves the latest because SESHAT_DMG_URL is the only source.
releaseRoute.get("/download", async (c) => {
  if (!env.SESHAT_DMG_URL) {
    return c.json({ error: "download not available" }, 503);
  }
  const userAgent = c.req.header("user-agent")?.slice(0, MAX_FIELD_LEN) ?? null;
  const referrer = c.req.header("referer")?.slice(0, MAX_FIELD_LEN) ?? null;
  try {
    await db
      .insert(downloadEvents)
      .values({ userAgent, referrer, platform: "macos" });
    sendDownloadNotification({ userAgent, referrer, platform: "macos" }).catch(
      (err) => console.error("download notify failed:", err),
    );
  } catch (err) {
    console.error("download log failed:", err);
  }
  return c.redirect(env.SESHAT_DMG_URL, 302);
});
