import { Fragment } from "react";
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
import type { LibraryFile, LibraryGroup } from "./hero-desktop";

type Props = {
  library: LibraryGroup[];
  activeId: string;
  read: string[];
  onSelect: (id: string) => void;
  dark: boolean;
  sidebar: boolean;
  outline: boolean;
  onToggleOutline: () => void;
  onToggleDark: () => void;
  onShare: () => void;
};

// The reader window as it looks on a Mac. Colors are theme tokens; the `dark`
// class flips them for the window alone, the page around it stays paper.
// The sidebar is a real library: pick a file and the document, path and
// outline follow.
export function HeroWindow({
  library,
  activeId,
  read,
  onSelect,
  dark,
  sidebar,
  outline,
  onToggleOutline,
  onToggleDark,
  onShare,
}: Props) {
  const activeGroup =
    library.find((g) => g.files.some((f) => f.id === activeId)) ?? library[0];
  const active = activeGroup.files.find((f) => f.id === activeId) ?? activeGroup.files[0];

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
            <span className="shrink-0 text-[10px] font-semibold tracking-[0.14em]">LIBRARY</span>
            <span className="text-ink-muted flex min-w-0 items-center gap-1 text-[12px] font-medium">
              <Folder size={12} className="shrink-0" />
              <span className="truncate">{activeGroup.name}</span>
              <span className="shrink-0">⌄</span>
            </span>
            <span className="text-ink-faint ml-auto flex shrink-0 items-center gap-2">
              <Plus size={13} />
              <Folder size={13} />
              <RefreshCw size={12} />
            </span>
          </div>
          <div className="min-h-0 flex-1 overflow-hidden">
            {library.map((g, gi) => (
              <Fragment key={g.name}>
                {gi === 0 ? (
                  <div className="text-gold bg-gold/10 mb-2 flex w-fit items-center gap-1.5 rounded-md px-2 py-1 font-mono text-[10px] font-semibold tracking-[0.12em]">
                    <span className="bg-gold inline-block h-[7px] w-[7px] rounded-full" />
                    {g.name.toUpperCase()}
                  </div>
                ) : (
                  <Group label={g.name.toUpperCase()} />
                )}
                {g.files.map((f) => (
                  <Row
                    key={f.id}
                    file={f}
                    unread={Boolean(f.unread) && !read.includes(f.id)}
                    selected={f.id === active.id}
                    onClick={() => onSelect(f.id)}
                  />
                ))}
              </Fragment>
            ))}
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
          <span className="text-ink-faint bg-ink/6 flex min-w-0 items-center gap-2 rounded-lg px-3 py-1.5 font-mono text-[11px]">
            <Folder size={11} className="shrink-0" />
            <span className="truncate">
              ~/Seshat/{activeGroup.name}/{active.name}.md
            </span>
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
              {dark ? <Sun size={13} /> : <Moon size={13} />}
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
        {/* Keyed by file so switching documents resets the scroll position. */}
        <div key={active.id} className={`landing-window min-h-0 flex-1 ${outline ? "has-outline" : ""}`}>
          {active.doc}
        </div>
        {outline && active.outline.length > 0 ? (
          <nav className="hero-outline">
            <p className="seshat-doc-chrome-outline-label">OUTLINE</p>
            <ul className="seshat-doc-chrome-outline-list">
              {active.outline.slice(0, 7).map((entry, i) => (
                <li key={entry.id}>
                  <span
                    className={`seshat-doc-chrome-outline-link block truncate ${
                      entry.level <= 1 ? "is-d0" : "is-d1"
                    } ${i === 0 ? "is-active" : ""}`}
                  >
                    {entry.text}
                  </span>
                </li>
              ))}
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
  file,
  unread,
  selected,
  onClick,
}: {
  file: LibraryFile;
  unread: boolean;
  selected: boolean;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`flex w-full cursor-default items-center gap-1.5 rounded-md border-0 px-2 py-[4.5px] text-left text-[12.5px] ${
        selected ? "bg-ink/8" : "hover:bg-ink/5 bg-transparent"
      }`}
    >
      <span
        className={`h-[5px] w-[5px] shrink-0 rounded-full ${
          unread ? "bg-gold" : "bg-transparent"
        }`}
      />
      <FileText size={11} className={`shrink-0 ${unread ? "text-ink-muted" : "text-ink-faint"}`} />
      <span className={`truncate ${unread ? "text-ink font-semibold" : "text-ink-muted"}`}>
        {file.name}
      </span>
      <span className="text-ink-faint ml-auto shrink-0 font-mono text-[10px]">{file.age}</span>
    </button>
  );
}
