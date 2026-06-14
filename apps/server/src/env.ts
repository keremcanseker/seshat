import { z } from "zod";

const schema = z.object({
  DATABASE_URL: z.string().url(),
  PORT: z.coerce.number().int().positive().default(3000),
  PUBLIC_BASE_URL: z.string().url(),
  WEB_BASE_URL: z.string().url(),
  CORS_ORIGINS: z
    .string()
    .default("")
    .transform((s) =>
      s
        .split(",")
        .map((o) => o.trim())
        .filter(Boolean),
    ),
  GOOGLE_CLIENT_ID: z.string().min(1),
  GOOGLE_CLIENT_SECRET: z.string().min(1),
  AUTH_JWT_SECRET: z.string().min(32),
  AUTH_MACOS_REDIRECT: z.string().default("seshat://auth/callback"),
  RESEND_API_KEY: z.string().optional(),
  DOWNLOAD_NOTIFY_TO: z.string().email().optional(),
  DOWNLOAD_NOTIFY_FROM: z
    .string()
    .default("Seshat <notifications@seshat.page>"),
  // Latest macOS build, served from our own infra (repo is private). Point
  // SESHAT_DMG_URL at the DMG on the bucket and bump SESHAT_LATEST_VERSION on
  // each release; /download redirects to it and /version drives the in-app banner.
  SESHAT_DMG_URL: z.string().url().optional(),
  SESHAT_LATEST_VERSION: z.string().optional(),
  SESHAT_RELEASE_NOTES: z.string().optional(),
});

export const env = schema.parse(Bun.env);
export type Env = typeof env;
