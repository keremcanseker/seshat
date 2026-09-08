import { Fragment } from "react";
import {
  AlignLeft,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
  Moon,
  PanelLeft,
  Plus,
  Printer,
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
// Mirrors the shipped chrome: sidebar toggle and ‹ › next to the traffic
// lights, workspace tabs in the toolbar, Linear-density sidebar rows.
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

  // Tabs are the files opened so far, in the order they were opened — the app's
  // workspace tabs, minus the 10-tab cap the mock never reaches.
  const files = library.flatMap((g) => g.files);
  const tabs = read
    .map((id) => files.find((f) => f.id === id))
    .filter((f): f is LibraryFile => Boolean(f))
    .slice(-5);

  return (
    <div className={`hero-window ${dark ? "dark" : ""}`}>
      {sidebar ? (
        <aside className="hero-sidebar">
          <div className="flex items-center gap-3 px-1 pb-3">
            <div className="flex gap-2">
              <span className="h-3 w-3 rounded-full bg-[#ff5f57]" />
              <span className="h-3 w-3 rounded-full bg-[#febc2e]" />
              <span className="h-3 w-3 rounded-full bg-[#28c840]" />
            </div>
            <span className="text-ink-faint ml-auto flex items-center gap-1.5">
              <PanelLeft size={14} />
              <ChevronLeft size={13} />
              <ChevronRight size={13} />
            </span>
          </div>
          <div className="flex items-center px-1 pb-2">
            <span className="text-ink flex items-center gap-1 text-[12px] font-medium">
              {activeGroup.name}
              <ChevronDown size={9} className="text-ink-faint" strokeWidth={3} />
            </span>
            <Plus size={12} className="text-ink-faint ml-auto" strokeWidth={2.5} />
          </div>
          <div className="min-h-0 flex-1 overflow-hidden">
            {library.map((g) => (
              <Fragment key={g.name}>
                <Group label={g.name.toUpperCase()} />
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
        <div className="flex items-center gap-3 px-3 pt-2.5 pb-1">
          {!sidebar ? (
            <div className="mr-1 flex gap-2">
              <span className="h-3 w-3 rounded-full bg-[#ff5f57]" />
              <span className="h-3 w-3 rounded-full bg-[#febc2e]" />
              <span className="h-3 w-3 rounded-full bg-[#28c840]" />
            </div>
          ) : null}
          <div className="flex min-w-0 items-center gap-[2px] overflow-hidden">
            {tabs.map((f) => (
              <Tab key={f.id} file={f} active={f.id === active.id} onClick={() => onSelect(f.id)} />
            ))}
          </div>
          <div className="ml-auto flex shrink-0 items-center gap-[2px]">
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
            <span className="seshat-doc-chrome-button" aria-hidden>
              <Printer size={13} />
            </span>
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

// Equal-width pill, filled when active; the title fades out at the trailing edge.
function Tab({ file, active, onClick }: { file: LibraryFile; active: boolean; onClick: () => void }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`hero-tab ${active ? "is-active" : ""}`}
      aria-current={active ? "page" : undefined}
    >
      <span className="hero-tab-title">{file.name}.md</span>
    </button>
  );
}

// Folder header: mono caps with the collapse chevron right after the name.
function Group({ label }: { label: string }) {
  return (
    <div className="text-ink-faint flex items-center gap-1 px-1.5 pt-3 pb-0.5 font-mono text-[10px] font-medium tracking-[0.12em]">
      {label}
      <ChevronDown size={7} strokeWidth={4} className="opacity-60" />
    </div>
  );
}

// 26px row, no document icon, unread dot in the gutter, date on hover only.
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
      className={`group flex h-[26px] w-full cursor-default items-center gap-2 rounded-md border-0 px-1.5 text-left text-[13px] ${
        selected ? "bg-ink/8" : "hover:bg-ink/5 bg-transparent"
      }`}
    >
      <span
        className={`h-[5px] w-[5px] shrink-0 rounded-full ${unread ? "bg-gold" : "bg-transparent"}`}
      />
      <span className={`text-ink truncate ${unread ? "font-semibold" : ""}`}>{file.name}</span>
      <span className="text-ink-faint ml-auto shrink-0 font-mono text-[10.5px] opacity-0 transition-opacity group-hover:opacity-100">
        {file.age}
      </span>
    </button>
  );
}
