"use client";

import { useEffect, useRef, useState, type ReactNode } from "react";
import { AlignLeft, Link2, Moon, PanelLeft, Sun } from "lucide-react";
import { SeshatMark } from "@/components/seshat-mark";
import { DownloadButton } from "@/components/download-button";
import type { OutlineEntry } from "@/lib/extract-outline";
import { HeroWindow } from "./hero-window";

// A file in the mock library. `doc` is the server-rendered SeshatDoc for the
// file, so switching documents never touches the markdown pipeline on the
// client.
export type LibraryFile = {
  id: string;
  name: string;
  age: string;
  unread?: boolean;
  outline: OutlineEntry[];
  doc: ReactNode;
};

export type LibraryGroup = {
  name: string;
  files: LibraryFile[];
};

type Props = {
  downloadHref: string;
  library: LibraryGroup[];
  initialId: string;
};

const WALL = "/hero-temple.jpg";
const WALL_M = "/hero-temple-m.jpg";

// The wallpaper: the landscape temple on desktop, its portrait cut on phones.
// <picture> so a phone never downloads the landscape file.
function Wall({ priority = false }: { priority?: boolean }) {
  return (
    <picture>
      <source media="(max-width: 768px)" srcSet={WALL_M} />
      <img className="hero-wall" src={WALL} draggable={false} alt="" fetchPriority={priority ? "high" : undefined} />
    </picture>
  );
}

// A macOS desktop in a rounded card under the brand row. Everything on the
// desktop is live: the window re-skins, the wallpaper turns to night, the
// outline and sidebar toggle, files switch, Share drops a toast.
//
// Night is local to the desktop: the wallpaper sweeps, the window re-skins,
// the page around it stays paper. The landing pins the document to light
// tokens (globals.css, `html:has(.landing)`), so a dark theme saved on a
// shared doc can never make the window dark while this toggle says day.
export function HeroDesktop({ downloadHref, library, initialId }: Props) {
  const [dark, setDark] = useState(false);
  const toggleDark = () => setDark((v) => !v);

  const [activeId, setActiveId] = useState(initialId);
  const [read, setRead] = useState<string[]>([initialId]);
  const [sidebar, setSidebar] = useState(true);
  const [outline, setOutline] = useState(true);
  const [copied, setCopied] = useState(false);
  const toastTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const select = (id: string) => {
    setActiveId(id);
    setRead((r) => (r.includes(id) ? r : [...r, id]));
  };

  const share = () => {
    setCopied(true);
    if (toastTimer.current) clearTimeout(toastTimer.current);
    toastTimer.current = setTimeout(() => setCopied(false), 2600);
  };

  return (
    <div>
      <div className="hero">
        <div className="hero-top">
          <div className="flex items-center gap-2.5">
            <SeshatMark size={20} className="text-ink" strokeWidth={1.4} />
            <span className="font-heading text-ink text-[16px] font-semibold tracking-[-0.005em]">
              Seshat
            </span>
            <span className="text-ink-muted hidden text-[14px] sm:inline">
              a reading room for markdown
            </span>
          </div>
          <DownloadButton
            href={downloadHref}
            className="hero-cta inline-flex h-8 shrink-0 items-center gap-2 rounded-full px-4 text-[13px] font-medium no-underline"
          >
            <AppleGlyph />
            Download for macOS
          </DownloadButton>
        </div>

        <div className={`hero-stage ${dark ? "is-dark" : ""}`}>
          <Wall priority />
          {/* ponytail: night is the same painting under a CSS filter and an
              indigo multiply. Swap this img's src for a real night painting
              when one exists and drop the filter. */}
          <div className="hero-night" aria-hidden>
            <Wall />
          </div>

          {/* Phones only: no window, no menu bar. The icon, one line of copy
              and the download button sit over the sky, under the goddess. */}
          <div className="hero-copy">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img className="hero-copy-icon" src="/apple-icon.png" alt="" width={72} height={72} draggable={false} />
            <h1 className="font-heading text-ink m-0 text-balance text-[38px] leading-[1.08] font-semibold tracking-[-0.015em]">
              A reading room for markdown.
            </h1>
            <p className="text-ink/80 mx-auto mt-4 mb-0 max-w-[32ch] text-[17px] leading-normal">
              A native macOS reader with calm, book-like type. Your library is a folder. Any page becomes a link.
            </p>
            <DownloadButton
              href={downloadHref}
              className="hero-cta mt-7 inline-flex h-11 items-center gap-2 rounded-full px-6 text-[15px] font-medium no-underline"
            >
              <AppleGlyph />
              Download for macOS
            </DownloadButton>
            <p className="text-ink/70 mt-3 mb-0 text-[13px]">Free. macOS 14 or later.</p>
          </div>

          <MenuBar />

          {/* macOS notification banner: app icon, bold title, body, "now". */}
          <div className={`hero-toast ${copied ? "is-open" : ""}`} role="status">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img className="hero-toast-icon" src="/apple-icon.png" alt="" width={52} height={52} />
            <div className="hero-toast-text">
              <div className="hero-toast-title">
                Link copied
                <span className="hero-toast-time">now</span>
              </div>
              <div className="hero-toast-body">seshat.page/d/atrium-7c1a is on your clipboard.</div>
            </div>
          </div>

          <div className="hero-app">
            <HeroWindow
              library={library}
              activeId={activeId}
              read={read}
              onSelect={select}
              dark={dark}
              sidebar={sidebar}
              outline={outline}
              onToggleOutline={() => setOutline((v) => !v)}
              onToggleDark={toggleDark}
              onShare={share}
            />
            <div className="hero-dock">
              {/* Icon and label show the action, matching the window toolbar
                  and the shared-doc chrome: moon to enter night, sun to leave. */}
              <DockButton on={dark} onClick={toggleDark} label={dark ? "Day" : "Night"}>
                {dark ? <Sun size={14} /> : <Moon size={14} />}
              </DockButton>
              <DockButton on={!sidebar} onClick={() => setSidebar((v) => !v)} label="Sidebar">
                <PanelLeft size={14} />
              </DockButton>
              <DockButton on={!outline} onClick={() => setOutline((v) => !v)} label="Outline">
                <AlignLeft size={14} />
              </DockButton>
              <DockButton on={copied} onClick={share} label="Share">
                <Link2 size={14} />
              </DockButton>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function DockButton({
  on,
  onClick,
  label,
  children,
}: {
  on: boolean;
  onClick: () => void;
  label: string;
  children: ReactNode;
}) {
  return (
    <button type="button" className={`hero-dock-btn ${on ? "is-on" : ""}`} onClick={onClick}>
      {children}
      <span>{label}</span>
    </button>
  );
}

// Icons are the real SF Symbols (apple.logo, battery.100, wifi, switch.2,
// magnifyingglass) rendered to white PNGs by apps/web/scripts/sf-symbols.swift.
function MenuBar() {
  const [clock, setClock] = useState({ day: "", time: "" });
  useEffect(() => {
    const tick = () => {
      const now = new Date();
      setClock({
        day: new Intl.DateTimeFormat("en-US", { weekday: "short" }).format(now),
        time: new Intl.DateTimeFormat("en-US", { hour: "numeric", minute: "2-digit", hour12: true }).format(now),
      });
    };
    tick();
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);
  }, []);
  return (
    <div className="hero-menubar">
      <div className="hero-menubar-side">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img className="hero-mbi-apple" draggable={false} src="/mb/mb-apple.png" alt="" />
        <b className="hero-menubar-app">Seshat</b>
        <span>File</span>
        <span>Edit</span>
        <span className="max-sm:hidden">View</span>
        <span className="max-sm:hidden">Window</span>
        <span className="max-sm:hidden">Help</span>
      </div>
      <div className="hero-menubar-side">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img className="hero-mbi-batt" draggable={false} src="/mb/mb-battery.png" alt="" />
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img className="hero-mbi-wifi max-sm:hidden" draggable={false} src="/mb/mb-wifi.png" alt="" />
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img className="hero-mbi-cc max-sm:hidden" draggable={false} src="/mb/mb-control-centre.png" alt="" />
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img className="hero-mbi-spot max-sm:hidden" draggable={false} src="/mb/mb-spotlight.png" alt="" />
        <span className="hero-menubar-clock">
          <span className="max-sm:hidden">{clock.day} </span>
          {clock.time}
        </span>
      </div>
    </div>
  );
}

export function AppleGlyph() {
  return (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" aria-hidden>
      <path d="M17.5 12.5c0-2.4 2-3.6 2.1-3.6-1.2-1.7-3-1.9-3.6-2-1.5-.2-3 .9-3.7.9-.8 0-2-.9-3.3-.9-1.7 0-3.3 1-4.2 2.6-1.8 3.1-.5 7.7 1.3 10.2.9 1.2 1.9 2.6 3.2 2.5 1.3-.1 1.8-.8 3.3-.8 1.6 0 2 .8 3.4.8 1.4 0 2.3-1.2 3.1-2.5.6-.8 1.1-1.7 1.4-2.6-2.5-.9-2.9-4-3-4.6zM14.7 5.4c.7-.8 1.2-2 1-3.2-1.1.1-2.4.8-3 1.5-.6.7-1.2 1.8-1 3 1.2.1 2.4-.6 3-1.3z" />
    </svg>
  );
}
