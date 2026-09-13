import { sql } from "drizzle-orm";
import { index, pgTable, text, timestamp, uniqueIndex } from "drizzle-orm/pg-core";

export const users = pgTable(
  "users",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    googleSub: text("google_sub").notNull().unique(),
    email: text("email").notNull().unique(),
    name: text("name"),
    avatarUrl: text("avatar_url"),
    // Billing state, written only by the Polar webhook (lib/plans.ts, lib/entitlements.ts).
    plan: text("plan").notNull().default("free"),
    planStatus: text("plan_status"), // active | canceled | past_due | null
    planPeriodEnd: timestamp("plan_period_end", { withTimezone: true }),
    polarCustomerId: text("polar_customer_id"),
    polarSubscriptionId: text("polar_subscription_id"),
    createdAt: timestamp("created_at", { withTimezone: true })
      .notNull()
      .default(sql`now()`),
    updatedAt: timestamp("updated_at", { withTimezone: true })
      .notNull()
      .default(sql`now()`),
  },
  (t) => [
    index("users_google_sub_idx").on(t.googleSub),
    index("users_email_idx").on(t.email),
    index("users_polar_customer_idx").on(t.polarCustomerId),
  ],
);

export const documents = pgTable(
  "documents",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    slug: text("slug").notNull().unique(),
    title: text("title").notNull(),
    content: text("content").notNull(),
    ownerId: text("owner_id").references(() => users.id, {
      onDelete: "set null",
    }),
    createdAt: timestamp("created_at", { withTimezone: true })
      .notNull()
      .default(sql`now()`),
    updatedAt: timestamp("updated_at", { withTimezone: true })
      .notNull()
      .default(sql`now()`),
  },
  (t) => [
    index("documents_slug_idx").on(t.slug),
    index("documents_owner_idx").on(t.ownerId),
  ],
);

/** A folder published as one site (KER-811). Pages are replaced wholesale on every publish. */
export const sites = pgTable(
  "sites",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    slug: text("slug").notNull().unique(),
    title: text("title").notNull(),
    ownerId: text("owner_id").references(() => users.id, {
      onDelete: "set null",
    }),
    createdAt: timestamp("created_at", { withTimezone: true })
      .notNull()
      .default(sql`now()`),
    updatedAt: timestamp("updated_at", { withTimezone: true })
      .notNull()
      .default(sql`now()`),
  },
  (t) => [index("sites_owner_idx").on(t.ownerId)],
);

export const sitePages = pgTable(
  "site_pages",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    siteId: text("site_id")
      .notNull()
      .references(() => sites.id, { onDelete: "cascade" }),
    /** Folder-relative path without the .md extension, e.g. "guides/setup". */
    path: text("path").notNull(),
    title: text("title").notNull(),
    content: text("content").notNull(),
  },
  (t) => [uniqueIndex("site_pages_site_path_idx").on(t.siteId, t.path)],
);

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
export type Document = typeof documents.$inferSelect;
export type NewDocument = typeof documents.$inferInsert;
