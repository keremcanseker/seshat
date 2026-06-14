"use client";

import { useEffect, useState } from "react";
import { Moon, PanelRight, Sun, X } from "lucide-react";
import { useTheme } from "next-themes";
import { useMediaQuery } from "@base-ui/react/unstable-use-media-query";
import type { OutlineEntry } from "@/lib/extract-outline";

type Props = {
  entries: OutlineEntry[];
};

export function SeshatDocChrome({ entries }: Props) {
  const { resolvedTheme, setTheme } = useTheme();
  const [showOutline, setShowOutline] = useState(true);
  const [mobileOutlineOpen, setMobileOutlineOpen] = useState(false);
  const [activeId, setActiveId] = useState<string | null>(
    entries[0]?.id ?? null,
  );
  const [mounted, setMounted] = useState(false);

  // Mirror the CSS breakpoint that switches the inline panel for the overlay.
  const isCompact = useMediaQuery("(max-width: 1180px)", {
    defaultMatches: false,
  });

  // Canonical next-themes hydration-safe pattern; see
  // https://github.com/pacocoursey/next-themes#avoid-hydration-mismatch
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => setMounted(true), []);

  // The overlay only renders while compact; if the viewport grows back to
  // desktop it simply stops rendering, so no reset effect is needed.
  const mobileOverlayOpen = isCompact && mobileOutlineOpen;

  // Lock body scroll + close on Escape while the mobile overlay is open.
  useEffect(() => {
    if (!mobileOverlayOpen) return;
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    function onKeyDown(event: KeyboardEvent) {
      if (event.key === "Escape") setMobileOutlineOpen(false);
    }
    window.addEventListener("keydown", onKeyDown);
    return () => {
      document.body.style.overflow = previousOverflow;
      window.removeEventListener("keydown", onKeyDown);
    };
  }, [mobileOverlayOpen]);

  useEffect(() => {
    if (entries.length === 0) return;
    const ids = entries.map((entry) => entry.id);
    const targets = ids
      .map((id) => document.getElementById(id))
      .filter((el): el is HTMLElement => el != null);
    if (targets.length === 0) return;

    const observer = new IntersectionObserver(
      (changes) => {
        const visible = changes
          .filter((change) => change.isIntersecting)
          .sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top);
        if (visible.length > 0) {
          setActiveId(visible[0].target.id);
          return;
        }
        const above = changes
          .filter((change) => change.boundingClientRect.top < 0)
          .sort((a, b) => b.boundingClientRect.top - a.boundingClientRect.top);
        if (above.length > 0) {
          setActiveId(above[0].target.id);
        }
      },
      { rootMargin: "-80px 0px -70% 0px", threshold: [0, 1] },
    );
    for (const target of targets) observer.observe(target);
    return () => observer.disconnect();
  }, [entries]);

  const isDark = mounted && resolvedTheme === "dark";

  function toggleTheme() {
    setTheme(isDark ? "light" : "dark");
  }

  const minLevel =
    entries.length > 0 ? Math.min(...entries.map((entry) => entry.level)) : 1;
  const hasOutline = entries.length > 0;

  function navigateTo(id: string, closeOverlay: boolean) {
    const target = document.getElementById(id);
    if (!target) return;
    target.scrollIntoView({ behavior: "smooth", block: "start" });
    history.replaceState(null, "", `#${id}`);
    setActiveId(id);
    if (closeOverlay) setMobileOutlineOpen(false);
  }

  function renderOutlineList(closeOnSelect: boolean) {
    return (
      <ul className="seshat-doc-chrome-outline-list">
        {entries.map((entry) => {
          const depth = Math.min(2, Math.max(0, entry.level - minLevel));
          const isActive = entry.id === activeId;
          return (
            <li key={entry.id}>
              <a
                href={`#${entry.id}`}
                className={`seshat-doc-chrome-outline-link is-d${depth}${
                  isActive ? " is-active" : ""
                }`}
                onClick={(event) => {
                  event.preventDefault();
                  navigateTo(entry.id, closeOnSelect);
                }}
              >
                {entry.text}
              </a>
            </li>
          );
        })}
      </ul>
    );
  }

  // The outline toggle drives the inline panel on desktop and the overlay on
  // mobile. On mobile the outline is available but hidden by default.
  const outlineToggleOn = isCompact ? mobileOutlineOpen : showOutline;

  function toggleOutline() {
    if (isCompact) {
      setMobileOutlineOpen((prev) => !prev);
    } else {
      setShowOutline((prev) => !prev);
    }
  }

  return (
    <>
      <div className="seshat-doc-chrome">
        <div className="seshat-doc-chrome-toolbar">
          {hasOutline ? (
            <button
              type="button"
              onClick={toggleOutline}
              className={`seshat-doc-chrome-button ${outlineToggleOn ? "is-active" : ""}`}
              title={outlineToggleOn ? "Hide outline" : "Show outline"}
              aria-pressed={outlineToggleOn}
            >
              <PanelRight size={14} strokeWidth={1.5} />
            </button>
          ) : null}
          <button
            type="button"
            onClick={toggleTheme}
            className="seshat-doc-chrome-button"
            title={isDark ? "Switch to light theme" : "Switch to dark theme"}
            aria-label="Toggle theme"
          >
            {isDark ? (
              <Sun size={14} strokeWidth={1.5} />
            ) : (
              <Moon size={14} strokeWidth={1.5} />
            )}
          </button>
        </div>

        {/* Desktop inline panel — hidden under the breakpoint by CSS. */}
        {hasOutline && showOutline ? (
          <nav
            aria-label="Document outline"
            className="seshat-doc-chrome-outline"
          >
            <p className="seshat-doc-chrome-outline-label">OUTLINE</p>
            {renderOutlineList(false)}
          </nav>
        ) : null}
      </div>

      {/* Mobile overlay — only rendered on compact viewports, hidden by default. */}
      {hasOutline && mobileOverlayOpen ? (
        <div className="seshat-doc-chrome-overlay" role="presentation">
          <button
            type="button"
            className="seshat-doc-chrome-overlay-backdrop"
            aria-label="Close outline"
            onClick={() => setMobileOutlineOpen(false)}
          />
          <nav
            aria-label="Document outline"
            className="seshat-doc-chrome-overlay-panel"
          >
            <div className="seshat-doc-chrome-overlay-header">
              <p className="seshat-doc-chrome-outline-label">OUTLINE</p>
              <button
                type="button"
                className="seshat-doc-chrome-button"
                onClick={() => setMobileOutlineOpen(false)}
                aria-label="Close outline"
                title="Close outline"
              >
                <X size={14} strokeWidth={1.5} />
              </button>
            </div>
            {renderOutlineList(true)}
          </nav>
        </div>
      ) : null}
    </>
  );
}
