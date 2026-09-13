import { sql } from "drizzle-orm";
import { index, integer, pgTable, primaryKey, text, timestamp, uniqueIndex } from "drizzle-orm/pg-core";

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
    /** Views deduplicated per viewer per 24 h (KER-809). Counted for every plan, shown to Premium. */
    views: integer("views").notNull().default(0),
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

// Every slug a document used to live at (KER-808). Rows are never freed while
// the document exists, so an old link keeps redirecting and nobody can claim it.
export const slugRedirects = pgTable("slug_redirects", {
  slug: text("slug").primaryKey(),
  documentId: text("document_id")
    .notNull()
    .references(() => documents.id, { onDelete: "cascade" }),
});

// Last time a hashed viewer opened a document (KER-809). One row per viewer per
// document, so the table stays bounded; `documents.views` is the counter.
export const documentViewers = pgTable(
  "document_viewers",
  {
    documentId: text("document_id")
      .notNull()
      .references(() => documents.id, { onDelete: "cascade" }),
    viewer: text("viewer").notNull(),
    seenAt: timestamp("seen_at", { withTimezone: true })
      .notNull()
      .default(sql`now()`),
  },
  (t) => [primaryKey({ columns: [t.documentId, t.viewer] })],
);

// What a document said before each re-share (KER-807, Premium `version_history`).
// Only the newest `quotas.versions` rows survive; free plans store none.
export const documentVersions = pgTable(
  "document_versions",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    documentId: text("document_id")
      .notNull()
      .references(() => documents.id, { onDelete: "cascade" }),
    title: text("title").notNull(),
    content: text("content").notNull(),
    /** When this content went live, i.e. the document's updatedAt at the time. */
    createdAt: timestamp("created_at", { withTimezone: true }).notNull(),
  },
  (t) => [index("document_versions_document_idx").on(t.documentId, t.createdAt)],
);

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
export type Document = typeof documents.$inferSelect;
export type NewDocument = typeof documents.$inferInsert;
