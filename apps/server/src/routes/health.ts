import { sql } from "drizzle-orm";
import { Hono } from "hono";
import { db } from "../db/client";

export const healthRoute = new Hono();

healthRoute.get("/", async (c) => {
  try {
    await db.execute(sql`select 1`);
    return c.json({ status: "ok", db: "ok" });
  } catch (err) {
    return c.json(
      { status: "degraded", db: "down", error: String(err) },
      503,
    );
  }
});
