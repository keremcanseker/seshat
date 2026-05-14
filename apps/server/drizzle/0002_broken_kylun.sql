CREATE TABLE "download_events" (
	"id" text PRIMARY KEY NOT NULL,
	"user_agent" text,
	"referrer" text,
	"platform" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE INDEX "download_events_created_at_idx" ON "download_events" USING btree ("created_at");