"use client";

import { useState, useTransition } from "react";
import Link from "next/link";
import { Check, Copy, ExternalLink, History, Pencil, Trash2 } from "lucide-react";
import { SeshatMark } from "@/components/seshat-mark";
import { deleteItemAction, renameDocAction } from "@/app/dashboard/actions";
import type { SharedItem } from "@/lib/session";

type Props = {
  docs: SharedItem[];
  /** Premium `custom_slug`: docs get an editable address (KER-808). */
  canRename: boolean;
  /** Premium `version_history`: docs link to their earlier versions (KER-807). */
  canSeeHistory: boolean;
};

const dateFmt = new Intl.DateTimeFormat("en-US", {
  month: "short",
  day: "numeric",
  year: "numeric",
});

function formatDate(value: string): string {
  const d = new Date(value);
  return Number.isNaN(d.getTime()) ? "" : dateFmt.format(d);
}

export function DocList({ docs, canRename, canSeeHistory }: Props) {
  if (docs.length === 0) {
    return (
      <div className="border-rule grid place-items-center rounded-lg border-[0.5px] px-8 py-20 text-center">
        <SeshatMark size={32} className="text-ink-faint mb-5" />
        <h2 className="font-heading text-ink m-0 mb-2 text-[20px] font-semibold">
          Nothing shared yet
        </h2>
        <p className="text-ink-muted m-0 max-w-[360px] text-[14px] leading-[1.6]">
          Share a markdown file from the macOS app or CLI with{" "}
          <code className="font-mono text-[13px]">seshat share file.md</code>. It
          will appear here.
        </p>
      </div>
    );
  }

  return (
    <ul className="border-rule divide-rule m-0 list-none divide-y rounded-lg border-[0.5px] p-0">
      {docs.map((doc) => (
        <DocRow key={`${doc.kind}:${doc.slug}`} doc={doc} canRename={canRename} canSeeHistory={canSeeHistory} />
      ))}
    </ul>
  );
}

function DocRow({ doc, canRename, canSeeHistory }: { doc: SharedItem; canRename: boolean; canSeeHistory: boolean }) {
  const [copied, setCopied] = useState(false);
  const [confirming, setConfirming] = useState(false);
  const [isDeleting, startDelete] = useTransition();

  const path = `/${doc.kind === "site" ? "s" : "d"}/${doc.slug}`;

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
      // clipboard unavailable, no-op
    }
  }

  function handleDelete() {
    if (!confirming) {
      setConfirming(true);
      setTimeout(() => setConfirming(false), 3000);
      return;
    }
    startDelete(async () => {
      await deleteItemAction(doc.kind, doc.slug);
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
          {doc.kind === "site" ? "Site · shared " : "Shared "}
          {formatDate(doc.createdAt)}
          {doc.updatedAt && doc.updatedAt !== doc.createdAt
            ? ` · updated ${formatDate(doc.updatedAt)}`
            : ""}
          {doc.views !== undefined
            ? ` · ${doc.views} ${doc.views === 1 ? "view" : "views"}`
            : ""}
        </p>
        {doc.kind === "doc" ? <SlugLine slug={doc.slug} canRename={canRename} /> : null}
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

        {doc.kind === "doc" ? (
          <Link
            href={canSeeHistory ? `/dashboard/${doc.slug}/history` : "/pricing"}
            aria-label={canSeeHistory ? "Version history" : "Version history needs Premium"}
            title={canSeeHistory ? "Version history" : "Version history needs Premium"}
            className="text-ink-muted hover:bg-paper-subtle hover:text-ink inline-flex h-8 w-8 items-center justify-center rounded-md transition-colors"
          >
            <History className="size-4" />
          </Link>
        ) : null}

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

/**
 * The address under the title. Premium users edit it in place; the previous
 * address keeps redirecting. A custom address is guessable, unlike the random
 * one, which is the user's call.
 */
function SlugLine({ slug, canRename }: { slug: string; canRename: boolean }) {
  const [editing, setEditing] = useState(false);
  const [value, setValue] = useState(slug);
  const [error, setError] = useState<string | null>(null);
  const [isSaving, startSave] = useTransition();

  function save() {
    const wanted = value.trim();
    if (wanted === slug) {
      setEditing(false);
      return;
    }
    startSave(async () => {
      const result = await renameDocAction(slug, wanted);
      if (result.error) {
        setError(result.error);
        return;
      }
      setEditing(false);
      setError(null);
    });
  }

  if (editing) {
    return (
      <form
        className="mt-1.5 flex items-center gap-2"
        onSubmit={(e) => {
          e.preventDefault();
          save();
        }}
      >
        <span className="text-ink-faint font-mono text-[12px]">seshat.page/d/</span>
        <input
          autoFocus
          value={value}
          onChange={(e) => setValue(e.target.value.toLowerCase())}
          onKeyDown={(e) => {
            if (e.key === "Escape") {
              setEditing(false);
              setValue(slug);
              setError(null);
            }
          }}
          disabled={isSaving}
          aria-label="Link address"
          pattern="[a-z0-9]+(-[a-z0-9]+)*"
          minLength={3}
          maxLength={64}
          className="border-rule-strong text-ink h-7 w-[220px] rounded-md border-[0.5px] bg-transparent px-2 font-mono text-[12px] outline-none"
        />
        <button
          type="submit"
          disabled={isSaving}
          className="text-ink-muted hover:text-ink text-[12px] font-medium transition-colors disabled:opacity-50"
        >
          Save
        </button>
        {error ? <span className="text-destructive text-[12px]">{error}</span> : null}
      </form>
    );
  }

  return (
    <p className="text-ink-faint m-0 mt-1 flex items-center gap-1.5 font-mono text-[12px]">
      <span className="truncate">seshat.page/d/{slug}</span>
      {canRename ? (
        <button
          type="button"
          onClick={() => setEditing(true)}
          aria-label="Change link address"
          title="Change address"
          className="hover:text-ink inline-flex size-5 items-center justify-center rounded transition-colors"
        >
          <Pencil className="size-3" />
        </button>
      ) : (
        <Link
          href="/pricing"
          aria-label="Custom addresses need Premium"
          title="Custom addresses need Premium"
          className="hover:text-ink inline-flex size-5 items-center justify-center rounded transition-colors"
        >
          <Pencil className="size-3" />
        </Link>
      )}
    </p>
  );
}
