import type { ReactNode } from "react";
import {
  AlignLeft,
  FileText,
  Folder,
  Moon,
  PanelLeft,
  Plus,
  RefreshCw,
  Share,
  Sun,
} from "lucide-react";

type Props = {
  dark: boolean;
  sidebar: boolean;
  outline: boolean;
  onToggleOutline: () => void;
  onToggleDark: () => void;
  onShare: () => void;
  doc: ReactNode;
};

// The reader window as it looks on a Mac. Token colors flip with the `dark`
// class so the whole window re-skins when the room goes dark.
export function HeroWindow({
  dark,
  sidebar,
  outline,
  onToggleOutline,
  onToggleDark,
  onShare,
  doc,
}: Props) {
  return (
    <div className={`hero-window ${dark ? "dark" : ""}`}>
      {sidebar ? (
        <aside className="hero-sidebar">
          <div className="flex items-center px-1 pb-4">
            <div className="flex gap-2">
              <span className="h-3 w-3 rounded-full bg-[#ff5f57]" />
              <span className="h-3 w-3 rounded-full bg-[#febc2e]" />
              <span className="h-3 w-3 rounded-full bg-[#28c840]" />
            </div>
            <PanelLeft size={14} className="text-ink-muted ml-auto" />
          </div>
          <div className="text-ink-faint flex items-center gap-1.5 px-1 pb-3">
            <span className="text-[10px] font-semibold tracking-[0.14em]">LIBRARY</span>
            <span className="text-ink-muted flex items-center gap-1 text-[12px] font-medium">
              <Folder size={12} /> Inbox ⌄
            </span>
            <span className="text-ink-faint ml-auto flex items-center gap-2">
              <Plus size={13} />
              <Folder size={13} />
              <RefreshCw size={12} />
            </span>
          </div>
          <div className="text-gold bg-gold/10 mb-2 flex w-fit items-center gap-1.5 rounded-md px-2 py-1 font-mono text-[10px] font-semibold tracking-[0.12em]">
            <span className="bg-gold inline-block h-[7px] w-[7px] rounded-full" /> INBOX
          </div>
          <div className="min-h-0 flex-1 overflow-hidden">
            <Row name="claude-session-report" age="2h ago" unread />
            <Row name="typography" age="1w ago" selected unread />
            <Row name="reading-list" age="2w ago" unread />
            <Group label="PRODUCT" />
            <Row name="RFC-014-share-links" age="20h ago" unread />
            <Row name="api-design-review" age="2d ago" />
            <Row name="Q3-PLANNING-DRAFT" age="1w ago" unread />
            <Row name="release-notes-0.4" age="3w ago" unread />
            <Row name="pricing-research" age="2w ago" />
            <Group label="ENGINEERING" />
            <Row name="ARCHITECTURE_OVERVIEW" age="3w ago" />
            <Row name="incident-postmortem-08-24" age="4d ago" unread />
            <Row name="migration-runbook" age="1w ago" />
            <Row name="agent-eval-results" age="2w ago" unread />
            <Group label="PERSONAL" />
            <Row name="conference-talk-outline" age="2mo ago" />
            <Row name="half-finished-essay" age="3mo ago" />
          </div>
        </aside>
      ) : null}

      <div className="relative flex min-w-0 flex-1 flex-col">
        <div className="flex items-center px-4 pt-3">
          {!sidebar ? (
            <div className="mr-3 flex gap-2">
              <span className="h-3 w-3 rounded-full bg-[#ff5f57]" />
              <span className="h-3 w-3 rounded-full bg-[#febc2e]" />
              <span className="h-3 w-3 rounded-full bg-[#28c840]" />
            </div>
          ) : null}
          <span className="text-ink-faint bg-ink/6 flex items-center gap-2 rounded-lg px-3 py-1.5 font-mono text-[11px]">
            <Folder size={11} /> ~/Seshat/Inbox/typography.md
          </span>
          <div className="seshat-doc-chrome-toolbar ml-auto">
            <button
              type="button"
              className={`seshat-doc-chrome-button ${outline ? "is-active" : ""}`}
              onClick={onToggleOutline}
              aria-label="Toggle outline"
            >
              <AlignLeft size={13} />
            </button>
            <button
              type="button"
              className="seshat-doc-chrome-button"
              onClick={onToggleDark}
              aria-label="Toggle theme"
            >
              {dark ? <Moon size={13} /> : <Sun size={13} />}
            </button>
            <button
              type="button"
              className="seshat-doc-chrome-button"
              onClick={onShare}
              aria-label="Share"
            >
              <Share size={13} />
            </button>
          </div>
        </div>
        <div className={`landing-window min-h-0 flex-1 ${outline ? "has-outline" : ""}`}>
          {doc}
        </div>
        {outline ? (
          <nav className="hero-outline">
            <p className="seshat-doc-chrome-outline-label">OUTLINE</p>
            <ul className="seshat-doc-chrome-outline-list">
              <li><span className="seshat-doc-chrome-outline-link is-d0 is-active">Typography for Long Do...</span></li>
              <li><span className="seshat-doc-chrome-outline-link is-d1">What changes on paper</span></li>
              <li><span className="seshat-doc-chrome-outline-link is-d1">Tables without the grid</span></li>
              <li><span className="seshat-doc-chrome-outline-link is-d1">Lists</span></li>
              <li><span className="seshat-doc-chrome-outline-link is-d1">Blockquotes</span></li>
            </ul>
          </nav>
        ) : null}
      </div>
    </div>
  );
}

function Group({ label }: { label: string }) {
  return (
    <div className="text-ink-faint px-2 pt-4 pb-1.5 font-mono text-[9.5px] font-medium tracking-[0.18em]">
      {label}
    </div>
  );
}

function Row({
  name,
  age,
  unread,
  selected,
}: {
  name: string;
  age: string;
  unread?: boolean;
  selected?: boolean;
}) {
  return (
    <div
      className={`flex items-center gap-1.5 rounded-md px-2 py-[4.5px] text-[12.5px] ${
        selected ? "bg-ink/8" : ""
      }`}
    >
      <span
        className={`h-[5px] w-[5px] shrink-0 rounded-full ${
          unread ? "bg-gold" : "bg-transparent"
        }`}
      />
      <FileText size={11} className={unread ? "text-ink-muted" : "text-ink-faint"} />
      <span className={`truncate ${unread ? "text-ink font-semibold" : "text-ink-muted"}`}>
        {name}
      </span>
      <span className="text-ink-faint ml-auto shrink-0 font-mono text-[10px]">{age}</span>
    </div>
  );
}
