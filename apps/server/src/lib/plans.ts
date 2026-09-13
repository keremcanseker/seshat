import { env } from "../env";

// Single source of truth for plans, quotas, features and prices.
// UI (web pricing cards, dashboard, macOS app) reads this through GET /plans.

export const FEATURES = [
  "unlimited_links",
  "expiring_links",
  "image_hosting",
  "custom_slug",
  "pdf_export",
  "view_count",
  "version_history",
  "folder_site",
  "copy_formats",
] as const;

export type FeatureKey = (typeof FEATURES)[number];
export type PlanId = "free" | "premium";

export type Quotas = {
  /** Max documents a user may create. null = unlimited. */
  activeLinks: number | null;
};

export const PLANS: Record<PlanId, { features: readonly FeatureKey[]; quotas: Quotas }> = {
  free: { features: [], quotas: { activeLinks: 1 } },
  premium: { features: FEATURES, quotas: { activeLinks: null } },
};

export type Interval = "monthly" | "yearly";

/** Amounts in minor units (cents). Polar product ids come from env; never sent to clients. */
export const PRICING: Record<Interval, { amount: number; currency: string; polarProductId?: string }> = {
  monthly: { amount: 699, currency: "USD", polarProductId: env.POLAR_PRODUCT_ID_MONTHLY },
  yearly: { amount: 3999, currency: "USD", polarProductId: env.POLAR_PRODUCT_ID_YEARLY },
};

export type DisplayFeature = { key: FeatureKey | string; label: string; available: boolean };

/** Ordered rows for the pricing cards. `available: false` renders as "soon". */
export const DISPLAY: Record<PlanId, DisplayFeature[]> = {
  free: [
    { key: "reader", label: "The macOS reader, library and CLI", available: true },
    { key: "vscode", label: "VS Code extension", available: true },
    { key: "one_link", label: "1 permanent share link, updatable and deletable", available: true },
  ],
  premium: [
    { key: "unlimited_links", label: "Unlimited share links", available: true },
    { key: "expiring_links", label: "Expiring links", available: false },
    { key: "image_hosting", label: "Image hosting", available: false },
    { key: "custom_slug", label: "Custom slugs", available: false },
    { key: "pdf_export", label: "PDF export with smart pagination", available: true },
    { key: "view_count", label: "View counts", available: false },
    { key: "version_history", label: "Version history", available: false },
    { key: "folder_site", label: "Publish a folder as a site", available: true },
    { key: "copy_formats", label: "Copy as rich text for Slack and email", available: false },
  ],
};

/** What GET /plans returns: everything above minus Polar ids. */
export function publicPlans() {
  return {
    plans: PLANS,
    pricing: {
      monthly: { amount: PRICING.monthly.amount, currency: PRICING.monthly.currency },
      yearly: { amount: PRICING.yearly.amount, currency: PRICING.yearly.currency },
    },
    display: DISPLAY,
  };
}
