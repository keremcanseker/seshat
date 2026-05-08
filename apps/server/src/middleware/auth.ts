import { createMiddleware } from "hono/factory";
import { getCookie } from "hono/cookie";
import { HTTPException } from "hono/http-exception";
import { verifySessionToken } from "../lib/auth";

export const SESSION_COOKIE = "seshat_session";

export type AuthVariables = {
  user: {
    id: string;
    email: string;
  };
};

function readBearer(headerValue: string | undefined): string | null {
  if (!headerValue) return null;
  return headerValue.startsWith("Bearer ") ? headerValue.slice(7) : null;
}

export const requireUser = createMiddleware<{ Variables: AuthVariables }>(
  async (c, next) => {
    const token = readBearer(c.req.header("authorization")) ?? getCookie(c, SESSION_COOKIE);
    if (!token) {
      throw new HTTPException(401, { message: "authentication required" });
    }
    try {
      const payload = await verifySessionToken(token);
      c.set("user", { id: payload.sub, email: payload.email });
    } catch {
      throw new HTTPException(401, { message: "invalid or expired session" });
    }
    await next();
  },
);
