import { eq } from "drizzle-orm";
import { Hono } from "hono";
import { setCookie, deleteCookie } from "hono/cookie";
import { HTTPException } from "hono/http-exception";
import { db } from "../db/client";
import { users } from "../db/schema";
import { env } from "../env";
import {
  type AuthSource,
  issueOAuthState,
  issueSessionToken,
  verifyOAuthState,
} from "../lib/auth";
import {
  buildAuthorizeUrl,
  exchangeCodeForToken,
  fetchUserInfo,
} from "../lib/google";
import { requireUser, SESSION_COOKIE, type AuthVariables } from "../middleware/auth";

const SESSION_MAX_AGE = 60 * 60 * 24 * 30;

export const authRoute = new Hono<{ Variables: AuthVariables }>();

authRoute.get("/google", async (c) => {
  const sourceParam = c.req.query("source");
  const source: AuthSource =
    sourceParam === "macos"
      ? "macos"
      : sourceParam === "web-token"
        ? "web-token"
        : "web";
  const state = await issueOAuthState(source);
  return c.redirect(buildAuthorizeUrl(state));
});

authRoute.get("/google/callback", async (c) => {
  const code = c.req.query("code");
  const state = c.req.query("state");
  const error = c.req.query("error");

  if (error) {
    throw new HTTPException(400, { message: `google oauth error: ${error}` });
  }
  if (!code || !state) {
    throw new HTTPException(400, { message: "missing code or state" });
  }

  let source: AuthSource;
  try {
    ({ source } = await verifyOAuthState(state));
  } catch {
    throw new HTTPException(400, { message: "invalid or expired state" });
  }

  const accessToken = await exchangeCodeForToken(code);
  const profile = await fetchUserInfo(accessToken);

  const [existing] = await db
    .select()
    .from(users)
    .where(eq(users.googleSub, profile.sub))
    .limit(1);

  let userId: string;
  if (existing) {
    userId = existing.id;
    await db
      .update(users)
      .set({
        email: profile.email,
        name: profile.name ?? null,
        avatarUrl: profile.picture ?? null,
        updatedAt: new Date(),
      })
      .where(eq(users.id, existing.id));
  } else {
    const [created] = await db
      .insert(users)
      .values({
        googleSub: profile.sub,
        email: profile.email,
        name: profile.name ?? null,
        avatarUrl: profile.picture ?? null,
      })
      .returning({ id: users.id });
    if (!created) {
      throw new HTTPException(500, { message: "failed to create user" });
    }
    userId = created.id;
  }

  const sessionToken = await issueSessionToken({ id: userId, email: profile.email });

  if (source === "macos") {
    const target = `${env.AUTH_MACOS_REDIRECT}#token=${encodeURIComponent(sessionToken)}`;
    return c.redirect(target);
  }

  if (source === "web-token") {
    // Hand the token to the web app via URL fragment (kept out of server logs,
    // mirroring the macOS flow). The web app stores it in a first-party
    // httpOnly cookie on its own origin, then proxies API calls with a Bearer
    // token — avoiding cross-site SameSite=Lax cookie restrictions.
    const target = `${env.WEB_BASE_URL}/auth/callback#token=${encodeURIComponent(sessionToken)}`;
    return c.redirect(target);
  }

  setCookie(c, SESSION_COOKIE, sessionToken, {
    httpOnly: true,
    secure: true,
    sameSite: "Lax",
    path: "/",
    maxAge: SESSION_MAX_AGE,
  });
  return c.redirect(env.WEB_BASE_URL);
});

authRoute.get("/me", requireUser, async (c) => {
  const u = c.get("user");
  const [row] = await db
    .select({
      id: users.id,
      email: users.email,
      name: users.name,
      avatarUrl: users.avatarUrl,
      createdAt: users.createdAt,
    })
    .from(users)
    .where(eq(users.id, u.id))
    .limit(1);
  if (!row) {
    throw new HTTPException(404, { message: "user not found" });
  }
  return c.json(row);
});

authRoute.post("/logout", async (c) => {
  deleteCookie(c, SESSION_COOKIE, { path: "/" });
  return c.json({ ok: true });
});
