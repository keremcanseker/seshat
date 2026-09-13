import { SESHAT_API_BASE } from "@/lib/session";

/** Mirrors apps/server/src/lib/plans.ts `publicPlans()`. The server is the source of truth. */
export type PlanId = "free" | "premium";
export type Interval = "monthly" | "yearly";

export type DisplayFeature = { key: string; label: string; available: boolean };

export type Plans = {
  plans: Record<PlanId, { features: string[]; quotas: { activeLinks: number | null; versions: number } }>;
  pricing: Record<Interval, { amount: number; currency: string }>;
  display: Record<PlanId, DisplayFeature[]>;
};

export type Me = {
  user: { id: string; email: string; name: string | null; avatarUrl: string | null };
  plan: PlanId;
  planStatus: string | null;
  planPeriodEnd: string | null;
  features: string[];
  usage: { activeLinks: number; limit: number | null };
};

export async function fetchPlans(): Promise<Plans> {
  const res = await fetch(`${SESHAT_API_BASE}/plans`, { headers: { accept: "application/json" } });
  if (!res.ok) throw new Error(`Failed to load plans (${res.status})`);
  return (await res.json()) as Plans;
}

/** Minor units to "39.99 USD". */
export function formatMoney(amount: number, currency: string): string {
  return `${(amount / 100).toFixed(2)} ${currency}`;
}
