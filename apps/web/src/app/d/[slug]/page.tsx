import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { SeshatDoc } from "@/components/seshat-doc";
import { SeshatDocChrome } from "@/components/seshat-doc-chrome";
import { SeshatMark } from "@/components/seshat-mark";
import { extractOutline } from "@/lib/extract-outline";
import { fetchSharedDoc } from "@/lib/seshat-api";

type Props = {
  params: Promise<{ slug: string }>;
};

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const doc = await fetchSharedDoc(slug).catch(() => null);
  // Every share link is a secret: never indexed, never followed, and the
  // unfurl carries only the title. See KER-803.
  const robots = "noindex, nofollow";
  if (!doc) {
    return { title: "Document not found · Seshat", robots };
  }
  return {
    title: `${doc.title} · Seshat`,
    description: "A markdown document shared with Seshat.",
    robots,
    openGraph: { title: doc.title, type: "article", siteName: "Seshat" },
    twitter: { card: "summary", title: doc.title },
  };
}

export default async function SharedDocPage({ params }: Props) {
  const { slug } = await params;
  const doc = await fetchSharedDoc(slug);
  if (!doc) notFound();

  const outline = extractOutline(doc.content);

  return (
    <main className="seshat-doc-page">
      <Link href="/" className="seshat-doc-brand-fixed" aria-label="Seshat home">
        <SeshatMark size={20} />
        <span>Seshat</span>
      </Link>

      <SeshatDocChrome entries={outline} />

      <SeshatDoc content={doc.content} />

      <footer className="seshat-doc-page-footer">
        <Link href="/" className="seshat-doc-page-footer-link">
          <SeshatMark size={12} />
          <span>Read with Seshat</span>
        </Link>
      </footer>
    </main>
  );
}
