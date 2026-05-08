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
});

export const env = schema.parse(Bun.env);
export type Env = typeof env;
