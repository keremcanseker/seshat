import { z } from "zod";
import { env } from "../env";

const AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
const TOKEN_URL = "https://oauth2.googleapis.com/token";
const USERINFO_URL = "https://openidconnect.googleapis.com/v1/userinfo";

function callbackUrl(): string {
  return `${env.PUBLIC_BASE_URL}/auth/google/callback`;
}

export function buildAuthorizeUrl(state: string): string {
  const params = new URLSearchParams({
    client_id: env.GOOGLE_CLIENT_ID,
    redirect_uri: callbackUrl(),
    response_type: "code",
    scope: "openid email profile",
    state,
    access_type: "online",
    prompt: "select_account",
  });
  return `${AUTH_URL}?${params.toString()}`;
}

const tokenResponseSchema = z.object({
  access_token: z.string(),
  expires_in: z.number().optional(),
  id_token: z.string().optional(),
  scope: z.string().optional(),
  token_type: z.string().optional(),
});

export async function exchangeCodeForToken(code: string): Promise<string> {
  const body = new URLSearchParams({
    code,
    client_id: env.GOOGLE_CLIENT_ID,
    client_secret: env.GOOGLE_CLIENT_SECRET,
    redirect_uri: callbackUrl(),
    grant_type: "authorization_code",
  });
  const res = await fetch(TOKEN_URL, {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body,
  });
  if (!res.ok) {
    throw new Error(`google token exchange failed: ${res.status} ${await res.text()}`);
  }
  const json = tokenResponseSchema.parse(await res.json());
  return json.access_token;
}

const userInfoSchema = z.object({
  sub: z.string(),
  email: z.string().email(),
  email_verified: z.boolean().optional(),
  name: z.string().optional(),
  picture: z.string().url().optional(),
});

export type GoogleUserInfo = z.infer<typeof userInfoSchema>;

export async function fetchUserInfo(accessToken: string): Promise<GoogleUserInfo> {
  const res = await fetch(USERINFO_URL, {
    headers: { authorization: `Bearer ${accessToken}` },
  });
  if (!res.ok) {
    throw new Error(`google userinfo failed: ${res.status} ${await res.text()}`);
  }
  return userInfoSchema.parse(await res.json());
}
