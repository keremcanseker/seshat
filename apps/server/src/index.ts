import { Hono } from "hono";
import { cors } from "hono/cors";
import { HTTPException } from "hono/http-exception";
import { logger } from "hono/logger";
import { env } from "./env";
import { authRoute } from "./routes/auth";
import { docsRoute } from "./routes/docs";
import { downloadsRoute } from "./routes/downloads";
import { healthRoute } from "./routes/health";
import { meRoute } from "./routes/me";
import { plansRoute } from "./routes/plans";
import { releaseRoute } from "./routes/release";

const app = new Hono();

app.use("*", logger());

if (env.CORS_ORIGINS.length > 0) {
  app.use(
    "*",
    cors({
      origin: env.CORS_ORIGINS,
      allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
      allowHeaders: ["content-type", "authorization"],
      credentials: true,
    }),
  );
}

app.get("/", (c) => c.json({ name: "seshat-server", version: "0.1.0" }));
app.route("/health", healthRoute);
app.route("/auth", authRoute);
app.route("/docs", docsRoute);
app.route("/plans", plansRoute);
app.route("/me", meRoute);
app.route("/downloads", downloadsRoute);
app.route("/", releaseRoute);

app.onError((err, c) => {
  if (err instanceof HTTPException) {
    // 402s carry a structured body (lib/entitlements.ts); everything else is { error }.
    return err.res ?? c.json({ error: err.message }, err.status);
  }
  console.error(err);
  return c.json({ error: "internal server error" }, 500);
});

export { app };

export default {
  port: env.PORT,
  fetch: app.fetch,
};
