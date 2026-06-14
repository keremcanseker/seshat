import { sign, verify } from "hono/jwt";
import { env } from "../env";

const ALG = "HS256";
const JWT_EXPIRES_IN_SECONDS = 60 * 60 * 24 * 30;
const STATE_TTL_SECONDS = 600;

export type AuthSource = "macos" | "web" | "web-token";

export type SessionPayload = {
  sub: string;
  email: string;
  exp: number;
  iat: number;
};

export async function issueSessionToken(user: {
  id: string;
  email: string;
}): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  return sign(
    {
      sub: user.id,
      email: user.email,
      iat: now,
      exp: now + JWT_EXPIRES_IN_SECONDS,
    },
    env.AUTH_JWT_SECRET,
    ALG,
  );
}

export async function verifySessionToken(token: string): Promise<SessionPayload> {
  const payload = (await verify(token, env.AUTH_JWT_SECRET, ALG)) as unknown as SessionPayload;
  return payload;
}

export async function issueOAuthState(source: AuthSource): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  return sign(
    {
      source,
      iat: now,
      exp: now + STATE_TTL_SECONDS,
    },
    env.AUTH_JWT_SECRET,
    ALG,
  );
}

export async function verifyOAuthState(state: string): Promise<{ source: AuthSource }> {
  const payload = (await verify(state, env.AUTH_JWT_SECRET, ALG)) as unknown as {
    source: AuthSource;
  };
  if (
    payload.source !== "macos" &&
    payload.source !== "web" &&
    payload.source !== "web-token"
  ) {
    throw new Error("invalid state source");
  }
  return { source: payload.source };
}
