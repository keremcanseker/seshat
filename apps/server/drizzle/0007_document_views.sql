CREATE TABLE "document_viewers" (
	"document_id" text NOT NULL,
	"viewer" text NOT NULL,
	"seen_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "document_viewers_document_id_viewer_pk" PRIMARY KEY("document_id","viewer")
);
--> statement-breakpoint
ALTER TABLE "documents" ADD COLUMN "views" integer DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE "document_viewers" ADD CONSTRAINT "document_viewers_document_id_documents_id_fk" FOREIGN KEY ("document_id") REFERENCES "public"."documents"("id") ON DELETE cascade ON UPDATE no action;