import type { Metadata } from "next";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { ArrowLeft, Download } from "lucide-react";
import { getCurrentUser } from "@/lib/auth";
import { fetchSharedDoc } from "@/lib/seshat-api";
import { getMyVersions, type DocVersion } from "@/lib/versions";
import { restoreVersionAction } from "./actions";

export const metadata: Metadata = {
  title: "Version history · Seshat",
};

const dateFmt = new Intl.DateTimeFormat("en-US", {
  month: "short",
  day: "numeric",
  year: "numeric",
  hour: "numeric",
  minute: "2-digit",
});

function formatBytes(n: number): string {
  return n < 1024 ? `${n} B` : `${(n / 1024).toFixed(n < 10240 ? 1 : 0)} KB`;
}

/**
 * Earlier versions of one shared doc (KER-807, Premium). Each `seshat share`
 * that changed the text left the previous one here; restore or download it.
 */
export default async function HistoryPage({ params }: { params: Promise<{ slug: string }> }) {
  const user = await getCurrentUser();
  if (!user) redirect("/login");
  const { slug } = await params;

  const [doc, versions] = await Promise.all([fetchSharedDoc(slug), getMyVersions(slug)]);
  if (!doc) notFound();
  // Not the owner, or history is not on this plan.
  if (versions === null) redirect("/dashboard");

  return (
    <main className="paper-page bg-paper text-ink min-h-screen font-sans">
      <section className="mx-auto max-w-[920px] px-8 py-12 sm:px-12">
        <Link
          href="/dashboard"
          className="text-ink-muted hover:text-ink mb-8 inline-flex items-center gap-1.5 text-[13px] no-underline transition-colors"
        >
          <ArrowLeft className="size-3.5" />
          Your pages
        </Link>

        <div className="mb-9">
          <p className="text-ink-faint mb-3 font-mono text-[11px] tracking-[0.1em] uppercase">
            Version history
          </p>
          <h1 className="font-heading text-ink m-0 text-[36px] font-bold tracking-[-0.012em]">
            {doc.title}
          </h1>
          <p className="text-ink-muted mt-3 max-w-[520px] text-[15px] leading-[1.6]">
            Every <code className="font-mono text-[13px]">seshat share</code> that changed this
            page keeps the previous text here. Restoring puts an older version back at{" "}
            <Link href={`/d/${slug}`} className="font-mono text-[13px]">
              /d/{slug}
            </Link>{" "}
            and files the current one away, so nothing is lost.
          </p>
        </div>

        <ul className="border-rule divide-rule m-0 list-none divide-y rounded-lg border-[0.5px] p-0">
          <li className="flex items-center gap-4 px-5 py-4">
            <div className="min-w-0 flex-1">
              <p className="text-ink m-0 text-[15px] font-medium">Current</p>
              <p className="text-ink-faint m-0 mt-1 text-[12px] tabular-nums">
                {dateFmt.format(new Date(doc.updatedAt))}
              </p>
            </div>
            <Link
              href={`/d/${slug}`}
              className="text-ink-muted hover:text-ink text-[12px] font-medium no-underline transition-colors"
            >
              Open
            </Link>
          </li>
          {versions.map((v) => (
            <VersionRow key={v.id} slug={slug} version={v} />
          ))}
        </ul>

        {versions.length === 0 ? (
          <p className="text-ink-faint mt-4 text-[13px]">
            No earlier versions yet. Share this file again after editing it and the
            previous text will appear here.
          </p>
        ) : null}
      </section>
    </main>
  );
}

function VersionRow({ slug, version }: { slug: string; version: DocVersion }) {
  const restore = restoreVersionAction.bind(null, slug, version.id);
  return (
    <li className="flex items-center gap-4 px-5 py-4">
      <div className="min-w-0 flex-1">
        <p className="text-ink m-0 truncate text-[15px]">{version.title}</p>
        <p className="text-ink-faint m-0 mt-1 text-[12px] tabular-nums">
          {dateFmt.format(new Date(version.createdAt))} · {formatBytes(version.bytes)}
        </p>
      </div>
      <div className="flex shrink-0 items-center gap-1">
        <a
          href={`/api/versions/${encodeURIComponent(slug)}/${encodeURIComponent(version.id)}`}
          aria-label="Download markdown"
          title="Download .md"
          className="text-ink-muted hover:bg-paper-subtle hover:text-ink inline-flex h-8 w-8 items-center justify-center rounded-md transition-colors"
        >
          <Download className="size-4" />
        </a>
        <form action={restore}>
          <button
            type="submit"
            className="border-rule-strong text-ink-muted hover:text-ink h-8 rounded-md border-[0.5px] px-3 text-[12px] font-medium transition-colors"
          >
            Restore
          </button>
        </form>
      </div>
    </li>
  );
}
