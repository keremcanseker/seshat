"use client";

import { useEffect, useRef, useState, type ReactNode } from "react";
import { AlignLeft, Link2, Moon, PanelLeft, Search, Sun, Wifi } from "lucide-react";
import { SeshatMark } from "@/components/seshat-mark";
import { DownloadButton } from "@/components/download-button";
import { HeroWindow } from "./hero-window";

type Props = {
  downloadHref: string;
  doc: ReactNode;
};

const WALL = "/hero-temple.jpg";

// A macOS desktop that fills the viewport on load and, over the first screen
// of scrolling, settles into a rounded card inside the page. Everything on the
// desktop is live: the window re-skins, the wallpaper turns to night, the
// outline and sidebar toggle, Share drops a toast.
export function HeroDesktop({ downloadHref, doc }: Props) {
  const [dark, setDark] = useState(false);
  const [sidebar, setSidebar] = useState(true);
  const [outline, setOutline] = useState(true);
  const [copied, setCopied] = useState(false);
  const toastTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const pinRef = useRef<HTMLDivElement>(null);
  const topRef = useRef<HTMLDivElement>(null);
  const stageRef = useRef<HTMLDivElement>(null);
  useHeroShrink(pinRef, topRef, stageRef);

  const share = () => {
    setCopied(true);
    if (toastTimer.current) clearTimeout(toastTimer.current);
    toastTimer.current = setTimeout(() => setCopied(false), 2600);
  };

  return (
    <div ref={pinRef} className="relative">
      <div>
        <div ref={topRef} className="hero-top">
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
            className="bg-ink text-paper inline-flex h-8 shrink-0 items-center gap-2 rounded-full px-4 text-[13px] font-medium no-underline"
          >
            <AppleGlyph />
            Download for macOS
          </DownloadButton>
        </div>

        <div ref={stageRef} className={`hero-stage ${dark ? "is-dark" : ""}`}>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img className="hero-wall" src={WALL} alt="" fetchPriority="high" />
          {/* ponytail: night is the same painting under a CSS filter and an
              indigo multiply. Swap this img's src for a real night painting
              when one exists and drop the filter. */}
          <div className="hero-night" aria-hidden>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img className="hero-wall" src={WALL} alt="" />
          </div>

          <MenuBar />

          <div className={`hero-toast ${copied ? "is-open" : ""}`} role="status">
            <div className="hero-toast-title">
              <Link2 size={12} className="text-gold" /> Link copied
            </div>
            <div className="hero-toast-url">seshat.page/d/atrium-7c1a</div>
          </div>

          <div className="hero-app">
            <HeroWindow
              dark={dark}
              sidebar={sidebar}
              outline={outline}
              onToggleOutline={() => setOutline((v) => !v)}
              onToggleDark={() => setDark((v) => !v)}
              onShare={share}
              doc={doc}
            />
            <div className="hero-dock">
              <DockButton on={dark} onClick={() => setDark((v) => !v)} label="Night">
                {dark ? <Moon size={14} /> : <Sun size={14} />}
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

function MenuBar() {
  const [clock, setClock] = useState({ date: "", time: "" });
  useEffect(() => {
    const tick = () => {
      const now = new Date();
      setClock({
        date: new Intl.DateTimeFormat("en-US", { weekday: "short", month: "short", day: "numeric" }).format(now),
        time: new Intl.DateTimeFormat("en-US", { hour: "numeric", minute: "2-digit", hour12: true }).format(now),
      });
    };
    tick();
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);
  }, []);
  return (
    <div className="hero-menubar">
      <div className="flex items-center gap-[15px]">
        <AppleGlyph />
        <span className="font-bold">Seshat</span>
        <span className="opacity-85">File</span>
        <span className="opacity-85">Edit</span>
        <span className="opacity-85 max-sm:hidden">View</span>
        <span className="opacity-85 max-sm:hidden">Window</span>
        <span className="opacity-85 max-sm:hidden">Help</span>
      </div>
      <div className="flex items-center gap-[13px] whitespace-nowrap">
        <Wifi size={13} className="max-sm:hidden" />
        <Search size={12} className="max-sm:hidden" />
        <span className="tabular-nums">
          <span className="max-sm:hidden">{clock.date}&nbsp;&nbsp;</span>
          {clock.time}
        </span>
      </div>
    </div>
  );
}

function AppleGlyph() {
  return (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" aria-hidden>
      <path d="M17.5 12.5c0-2.4 2-3.6 2.1-3.6-1.2-1.7-3-1.9-3.6-2-1.5-.2-3 .9-3.7.9-.8 0-2-.9-3.3-.9-1.7 0-3.3 1-4.2 2.6-1.8 3.1-.5 7.7 1.3 10.2.9 1.2 1.9 2.6 3.2 2.5 1.3-.1 1.8-.8 3.3-.8 1.6 0 2 .8 3.4.8 1.4 0 2.3-1.2 3.1-2.5.6-.8 1.1-1.7 1.4-2.6-2.5-.9-2.9-4-3-4.6zM14.7 5.4c.7-.8 1.2-2 1-3.2-1.1.1-2.4.8-3 1.5-.6.7-1.2 1.8-1 3 1.2.1 2.4-.6 3-1.3z" />
    </svg>
  );
}

// Scroll-driven shrink. The pin reserves one viewport of "dwell"; while the
// user scrolls through it the stage is position:fixed and interpolated from
// full-bleed to its resting card geometry, and the brand row fades in. Past
// the dwell everything returns to normal flow. Off on phones and when the
// user prefers reduced motion.
function useHeroShrink(
  pinRef: React.RefObject<HTMLDivElement | null>,
  topRef: React.RefObject<HTMLDivElement | null>,
  stageRef: React.RefObject<HTMLDivElement | null>,
) {
  useEffect(() => {
    const pin = pinRef.current;
    const top = topRef.current;
    const stage = stageRef.current;
    if (!pin || !top || !stage) return;
    if (matchMedia("(prefers-reduced-motion: reduce)").matches) return;

    let dwell = 0;
    let rest = { sl: 0, sw: 0, sh: 0, st: 0, tl: 0, tw: 0, tt: 0 };
    let pinned = false;
    let ticking = false;
    const lerp = (a: number, b: number, t: number) => a + (b - a) * t;

    const clear = () => {
      stage.classList.remove("is-pinned");
      for (const el of [stage, top]) {
        el.style.position = "";
        el.style.top = "";
        el.style.left = "";
        el.style.width = "";
        el.style.height = "";
        el.style.borderRadius = "";
      }
      top.style.opacity = "";
    };

    const update = () => {
      const p = Math.min(Math.max(dwell > 0 ? window.scrollY / dwell : 1, 0), 1);
      if (p >= 1) {
        if (pinned) {
          clear();
          pinned = false;
        }
        return;
      }
      pinned = true;
      stage.classList.add("is-pinned");
      stage.style.position = "fixed";
      stage.style.top = `${lerp(0, rest.st - dwell, p).toFixed(2)}px`;
      stage.style.left = `${lerp(0, rest.sl, p).toFixed(2)}px`;
      stage.style.width = `${lerp(window.innerWidth, rest.sw, p).toFixed(2)}px`;
      stage.style.height = `${lerp(window.innerHeight, rest.sh, p).toFixed(2)}px`;
      stage.style.borderRadius = `${lerp(0, 16, p).toFixed(2)}px`;
      top.style.position = "fixed";
      top.style.top = `${lerp(-60, rest.tt - dwell, p).toFixed(2)}px`;
      top.style.left = `${rest.tl}px`;
      top.style.width = `${rest.tw}px`;
      top.style.opacity = p.toFixed(3);
    };

    const measure = () => {
      clear();
      pin.style.height = "";
      pin.style.paddingTop = "";
      pinned = false;
      if (matchMedia("(max-width: 768px)").matches) {
        dwell = 0;
        return;
      }
      dwell = window.innerHeight;
      const pinTop = pin.getBoundingClientRect().top + window.scrollY;
      pin.style.paddingTop = `${dwell}px`;
      const s = stage.getBoundingClientRect();
      const t = top.getBoundingClientRect();
      rest = {
        sl: s.left,
        sw: s.width,
        sh: s.height,
        st: s.top + window.scrollY,
        tl: t.left,
        tw: t.width,
        tt: t.top + window.scrollY,
      };
      const settled = s.top + window.scrollY + s.height - (pinTop + dwell);
      pin.style.height = `${dwell + Math.max(settled, 0)}px`;
      update();
    };

    const onScroll = () => {
      if (ticking) return;
      ticking = true;
      requestAnimationFrame(() => {
        update();
        ticking = false;
      });
    };

    measure();
    window.addEventListener("scroll", onScroll, { passive: true });
    window.addEventListener("resize", measure);
    return () => {
      window.removeEventListener("scroll", onScroll);
      window.removeEventListener("resize", measure);
      clear();
      pin.style.height = "";
      pin.style.paddingTop = "";
    };
  }, [pinRef, topRef, stageRef]);
}
