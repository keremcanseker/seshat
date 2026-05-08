import { createMiddleware } from "hono/factory";
import { HTTPException } from "hono/http-exception";
import { env } from "../env";

export const requireWriteToken = createMiddleware(async (c, next) => {
  if (!env.WRITE_TOKEN) {
    await next();
    return;
  }
  const header = c.req.header("authorization") ?? "";
  const token = header.startsWith("Bearer ") ? header.slice(7) : "";
  if (token !== env.WRITE_TOKEN) {
    throw new HTTPException(401, { message: "invalid or missing write token" });
  }
  await next();
});
