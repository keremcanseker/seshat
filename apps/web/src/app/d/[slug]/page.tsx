import type { Metadata } from "next";
import Link from "next/link";
import { headers } from "next/headers";
import { notFound, permanentRedirect } from "next/navigation";
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
  // First hop of x-forwarded-for is the reader; Traefik sets it on the way in.
  const viewer = (await headers()).get("x-forwarded-for")?.split(",")[0]?.trim() || "local";
  const doc = await fetchSharedDoc(slug, viewer);
  if (!doc) notFound();
  // A renamed document answers under its current slug (KER-808): 301 there.
  if (doc.slug !== slug) permanentRedirect(`/d/${doc.slug}`);

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
