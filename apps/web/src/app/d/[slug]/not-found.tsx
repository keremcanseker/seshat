import Link from "next/link";
import { SeshatMark } from "@/components/seshat-mark";

export default function DocNotFound() {
  return (
    <main className="seshat-doc-missing">
      <div className="seshat-doc-missing-card">
        <SeshatMark size={36} className="seshat-doc-missing-mark" />
        <h1 className="seshat-doc-missing-title">Document not found</h1>
        <p className="seshat-doc-missing-body">
          This share link does not exist, or its author removed it.
        </p>
        <Link href="/" className="seshat-doc-missing-cta btn-ink">
          Back to Seshat
        </Link>
      </div>
    </main>
  );
}
