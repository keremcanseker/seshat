CREATE TABLE "slug_redirects" (
	"slug" text PRIMARY KEY NOT NULL,
	"document_id" text NOT NULL
);
--> statement-breakpoint
ALTER TABLE "slug_redirects" ADD CONSTRAINT "slug_redirects_document_id_documents_id_fk" FOREIGN KEY ("document_id") REFERENCES "public"."documents"("id") ON DELETE cascade ON UPDATE no action;