import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { SeshatDoc } from "@/components/seshat-doc";
import { SeshatDocChrome } from "@/components/seshat-doc-chrome";
import { SeshatMark } from "@/components/seshat-mark";
import { SiteSidebar } from "@/components/site-sidebar";
import { extractOutline } from "@/lib/extract-outline";
import { fetchSharedSite, type SharedSite, type SitePage } from "@/lib/seshat-api";

// A folder published as a mini site (KER-811): same reader, a page tree on the
// left, search over every page. Same secrecy rules as /d/[slug].

type Props = {
  params: Promise<{ slug: string; path?: string[] }>;
};

function landingPage(site: SharedSite): SitePage {
  return (
    site.pages.find((p) => /^(readme|index)$/i.test(p.path)) ?? site.pages[0]
  );
}

function findPage(site: SharedSite, path: string[] | undefined): SitePage | null {
  if (!path || path.length === 0) return landingPage(site);
  const wanted = path.join("/");
  return site.pages.find((p) => p.path === wanted) ?? null;
}

/** Turns `../guides/setup.md#install` inside `intro/start` into `/s/<slug>/guides/setup#install`. */
function makeResolveHref(site: SharedSite, current: SitePage) {
  const known = new Set(site.pages.map((p) => p.path));
  const dir = current.path.split("/").slice(0, -1);
  return (href: string): string => {
    if (/^[a-z][a-z0-9+.-]*:/i.test(href) || href.startsWith("/") || href.startsWith("#")) {
      return href;
    }
    const [target, hash] = href.split("#", 2);
    const segments = [...dir];
    for (const seg of decodeURIComponent(target).split("/")) {
      if (seg === "" || seg === ".") continue;
      if (seg === "..") segments.pop();
      else segments.push(seg);
    }
    const path = segments.join("/").replace(/\.(md|markdown)$/i, "");
    if (!known.has(path)) return href;
    const encoded = path.split("/").map(encodeURIComponent).join("/");
    return `/s/${site.slug}/${encoded}${hash ? `#${hash}` : ""}`;
  };
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug, path } = await params;
  const site = await fetchSharedSite(slug).catch(() => null);
  const robots = "noindex, nofollow";
  const page = site ? findPage(site, path) : null;
  if (!site || !page) {
    return { title: "Site not found · Seshat", robots };
  }
  const title = page.title === site.title ? site.title : `${page.title} · ${site.title}`;
  return {
    title: `${title} · Seshat`,
    description: "A folder of markdown documents shared with Seshat.",
    robots,
    openGraph: { title, type: "article", siteName: "Seshat" },
    twitter: { card: "summary", title },
  };
}

export default async function SharedSitePage({ params }: Props) {
  const { slug, path } = await params;
  const site = await fetchSharedSite(slug);
  if (!site) notFound();
  const page = findPage(site, path);
  if (!page) notFound();

  return (
    <main className="seshat-doc-page seshat-site">
      <SiteSidebar
        slug={site.slug}
        title={site.title}
        pages={site.pages}
        currentPath={page.path}
      />

      <div className="seshat-site-main">
        <SeshatDocChrome entries={extractOutline(page.content)} />
        <SeshatDoc content={page.content} resolveHref={makeResolveHref(site, page)} />
        <footer className="seshat-doc-page-footer">
          <Link href="/" className="seshat-doc-page-footer-link">
            <SeshatMark size={12} />
            <span>Read with Seshat</span>
          </Link>
        </footer>
      </div>
    </main>
  );
}
