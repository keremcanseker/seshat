"use client";

import { useEffect, useState } from "react";
import { Moon, PanelRight, Sun } from "lucide-react";
import { useTheme } from "next-themes";
import type { OutlineEntry } from "@/lib/extract-outline";

type Props = {
  entries: OutlineEntry[];
};

export function SeshatDocChrome({ entries }: Props) {
  const { resolvedTheme, setTheme } = useTheme();
  const [showOutline, setShowOutline] = useState(true);
  const [activeId, setActiveId] = useState<string | null>(
    entries[0]?.id ?? null,
  );
  const [mounted, setMounted] = useState(false);

  // Canonical next-themes hydration-safe pattern; see
  // https://github.com/pacocoursey/next-themes#avoid-hydration-mismatch
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => setMounted(true), []);

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

  return (
    <div className="seshat-doc-chrome">
      <div className="seshat-doc-chrome-toolbar">
        {hasOutline ? (
          <button
            type="button"
            onClick={() => setShowOutline((prev) => !prev)}
            className={`seshat-doc-chrome-button ${showOutline ? "is-active" : ""}`}
            title={showOutline ? "Hide outline" : "Show outline"}
            aria-pressed={showOutline}
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

      {hasOutline && showOutline ? (
        <nav aria-label="Document outline" className="seshat-doc-chrome-outline">
          <p className="seshat-doc-chrome-outline-label">OUTLINE</p>
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
                      const target = document.getElementById(entry.id);
                      if (!target) return;
                      event.preventDefault();
                      target.scrollIntoView({ behavior: "smooth", block: "start" });
                      history.replaceState(null, "", `#${entry.id}`);
                      setActiveId(entry.id);
                    }}
                  >
                    {entry.text}
                  </a>
                </li>
              );
            })}
          </ul>
        </nav>
      ) : null}
    </div>
  );
}
