import { Hono } from "hono";
import { publicPlans } from "../lib/plans";

export const plansRoute = new Hono();

plansRoute.get("/", (c) => c.json(publicPlans()));
