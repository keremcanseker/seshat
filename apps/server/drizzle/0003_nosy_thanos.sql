ALTER TABLE "users" ADD COLUMN "plan" text DEFAULT 'free' NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "plan_status" text;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "plan_period_end" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "polar_customer_id" text;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "polar_subscription_id" text;--> statement-breakpoint
CREATE INDEX "users_polar_customer_idx" ON "users" USING btree ("polar_customer_id");