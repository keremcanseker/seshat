import { cookies } from "next/headers";
import { NextResponse } from "next/server";
import { SESSION_COOKIE, SESSION_MAX_AGE } from "@/lib/session";

/**
 * First-party session cookie endpoint for the web app.
 *
 * POST { token }: set after the OAuth callback hands back a session JWT.
 * DELETE: clear on logout.
 *
 * The token is stored httpOnly so client JS can never read it; authenticated
 * API calls are made server-side (see src/lib/auth.ts).
 */

function looksLikeJwt(token: unknown): token is string {
  return typeof token === "string" && /^[\w-]+\.[\w-]+\.[\w-]+$/.test(token);
}

export async function POST(request: Request) {
  const body = (await request.json().catch(() => null)) as {
    token?: unknown;
  } | null;

  if (!looksLikeJwt(body?.token)) {
    return NextResponse.json({ error: "invalid token" }, { status: 400 });
  }

  const store = await cookies();
  store.set(SESSION_COOKIE, body.token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    path: "/",
    maxAge: SESSION_MAX_AGE,
  });

  return NextResponse.json({ ok: true });
}

export async function DELETE() {
  const store = await cookies();
  store.delete(SESSION_COOKIE);
  return NextResponse.json({ ok: true });
}
