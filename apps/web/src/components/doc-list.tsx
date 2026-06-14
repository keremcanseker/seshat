"use client";

import { useState, useTransition } from "react";
import Link from "next/link";
import { Check, Copy, ExternalLink, Trash2 } from "lucide-react";
import { SeshatMark } from "@/components/seshat-mark";
import { deleteDocAction } from "@/app/dashboard/actions";
import type { SharedDocSummary } from "@/lib/session";

type Props = {
  docs: SharedDocSummary[];
};

const dateFmt = new Intl.DateTimeFormat("en-US", {
  month: "short",
  day: "numeric",
  year: "numeric",
});

function formatDate(value: string): string {
  const d = new Date(value);
  return Number.isNaN(d.getTime()) ? "—" : dateFmt.format(d);
}

export function DocList({ docs }: Props) {
  if (docs.length === 0) {
    return (
      <div className="border-rule grid place-items-center rounded-lg border-[0.5px] px-8 py-20 text-center">
        <SeshatMark size={32} className="text-ink-faint mb-5" />
        <h2 className="font-heading text-ink m-0 mb-2 text-[20px] font-semibold">
          Nothing shared yet
        </h2>
        <p className="text-ink-muted m-0 max-w-[360px] text-[14px] leading-[1.6]">
          Share a markdown file from the macOS app or the CLI with{" "}
          <code className="font-mono text-[13px]">seshat share file.md</code> and
          it&rsquo;ll show up here.
        </p>
      </div>
    );
  }

  return (
    <ul className="border-rule divide-rule m-0 list-none divide-y rounded-lg border-[0.5px] p-0">
      {docs.map((doc) => (
        <DocRow key={doc.slug} doc={doc} />
      ))}
    </ul>
  );
}

function DocRow({ doc }: { doc: SharedDocSummary }) {
  const [copied, setCopied] = useState(false);
  const [confirming, setConfirming] = useState(false);
  const [isDeleting, startDelete] = useTransition();

  const path = `/d/${doc.slug}`;

  async function copyLink() {
    const url =
      typeof window !== "undefined"
        ? `${window.location.origin}${path}`
        : path;
    try {
      await navigator.clipboard.writeText(url);
      setCopied(true);
      setTimeout(() => setCopied(false), 1600);
    } catch {
      // clipboard unavailable — no-op
    }
  }

  function handleDelete() {
    if (!confirming) {
      setConfirming(true);
      setTimeout(() => setConfirming(false), 3000);
      return;
    }
    startDelete(async () => {
      await deleteDocAction(doc.slug);
    });
  }

  return (
    <li className="flex items-center gap-4 px-5 py-4">
      <div className="min-w-0 flex-1">
        <Link
          href={path}
          className="font-heading text-ink hover:text-link block truncate text-[17px] font-semibold transition-colors"
        >
          {doc.title}
        </Link>
        <p className="text-ink-faint m-0 mt-1 text-[12px] tabular-nums">
          Shared {formatDate(doc.createdAt)}
          {doc.updatedAt && doc.updatedAt !== doc.createdAt
            ? ` · updated ${formatDate(doc.updatedAt)}`
            : ""}
        </p>
      </div>

      <div className="flex shrink-0 items-center gap-1">
        <button
          type="button"
          onClick={copyLink}
          aria-label="Copy link"
          title="Copy link"
          className="text-ink-muted hover:bg-paper-subtle hover:text-ink inline-flex h-8 w-8 items-center justify-center rounded-md transition-colors"
        >
          {copied ? (
            <Check className="text-gold size-4" />
          ) : (
            <Copy className="size-4" />
          )}
        </button>

        <Link
          href={path}
          aria-label="Open document"
          title="Open"
          className="text-ink-muted hover:bg-paper-subtle hover:text-ink inline-flex h-8 w-8 items-center justify-center rounded-md transition-colors"
        >
          <ExternalLink className="size-4" />
        </Link>

        <button
          type="button"
          onClick={handleDelete}
          disabled={isDeleting}
          aria-label={confirming ? "Confirm delete" : "Delete document"}
          title={confirming ? "Click again to confirm" : "Delete"}
          className={`inline-flex h-8 items-center justify-center gap-1.5 rounded-md px-2 text-[12px] font-medium transition-colors disabled:opacity-50 ${
            confirming
              ? "bg-destructive/10 text-destructive"
              : "text-ink-muted hover:bg-paper-subtle hover:text-ink w-8"
          }`}
        >
          <Trash2 className="size-4" />
          {confirming ? <span>Confirm</span> : null}
        </button>
      </div>
    </li>
  );
}
