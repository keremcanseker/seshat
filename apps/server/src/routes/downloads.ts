import { Hono } from "hono";
import { z } from "zod";
import { db } from "../db/client";
import { downloadEvents } from "../db/schema";
import { sendDownloadNotification } from "../lib/notify";

const MAX_FIELD_LEN = 512;

const optionalString = z
  .string()
  .trim()
  .max(MAX_FIELD_LEN)
  .transform((s) => (s.length === 0 ? null : s))
  .nullable()
  .optional();

const body = z
  .object({
    platform: optionalString,
    referrer: optionalString,
  })
  .partial();

export const downloadsRoute = new Hono();

downloadsRoute.post("/", async (c) => {
  const raw = await c.req.json().catch(() => ({}));
  const parsed = body.safeParse(raw);
  const data = parsed.success ? parsed.data : {};

  const userAgent = c.req.header("user-agent")?.slice(0, MAX_FIELD_LEN) ?? null;
  const referrer =
    data.referrer ?? c.req.header("referer")?.slice(0, MAX_FIELD_LEN) ?? null;
  const platform = data.platform ?? null;

  await db.insert(downloadEvents).values({ userAgent, referrer, platform });

  sendDownloadNotification({ userAgent, referrer, platform }).catch((err) => {
    console.error("download notify failed:", err);
  });

  return c.body(null, 204);
});
