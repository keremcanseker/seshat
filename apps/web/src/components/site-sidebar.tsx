"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { PanelLeft, Search, X } from "lucide-react";
import { SeshatMark } from "@/components/seshat-mark";
import type { SitePage } from "@/lib/seshat-api";

type Props = {
  slug: string;
  title: string;
  pages: SitePage[];
  currentPath: string;
};

type TreeNode = {
  name: string;
  page?: SitePage;
  children: TreeNode[];
};

function href(slug: string, path: string): string {
  return `/s/${slug}/${path.split("/").map(encodeURIComponent).join("/")}`;
}

/** Folder tree from flat paths. Files before folders, README/index first. */
function buildTree(pages: SitePage[]): TreeNode[] {
  const root: TreeNode = { name: "", children: [] };
  for (const page of pages) {
    const parts = page.path.split("/");
    let node = root;
    for (const part of parts.slice(0, -1)) {
      let next = node.children.find((c) => c.name === part && !c.page);
      if (!next) {
        next = { name: part, children: [] };
        node.children.push(next);
      }
      node = next;
    }
    node.children.push({ name: parts[parts.length - 1], page, children: [] });
  }
  const rank = (n: TreeNode) =>
    n.page ? (/^(readme|index)$/i.test(n.name) ? 0 : 1) : 2;
  const sort = (n: TreeNode) => {
    n.children.sort(
      (a, b) => rank(a) - rank(b) || a.name.localeCompare(b.name, undefined, { numeric: true }),
    );
    n.children.forEach(sort);
  };
  sort(root);
  return root.children;
}

function snippet(content: string, query: string): string {
  const at = content.toLowerCase().indexOf(query);
  if (at < 0) return "";
  const start = Math.max(0, at - 40);
  const text = content.slice(start, at + query.length + 60).replace(/\s+/g, " ");
  return `${start > 0 ? "…" : ""}${text}…`;
}

export function SiteSidebar({ slug, title, pages, currentPath }: Props) {
  const [query, setQuery] = useState("");
  const [open, setOpen] = useState(false);
  const tree = useMemo(() => buildTree(pages), [pages]);

  // Close the mobile panel when the page changes and on Escape.
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => setOpen(false), [currentPath]);
  useEffect(() => {
    if (!open) return;
    function onKeyDown(event: KeyboardEvent) {
      if (event.key === "Escape") setOpen(false);
    }
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [open]);

  // ponytail: substring search over every page in memory; a server index when
  // sites outgrow the 5 MB cap.
  const q = query.trim().toLowerCase();
  const results = q
    ? pages
        .filter((p) => p.title.toLowerCase().includes(q) || p.content.toLowerCase().includes(q))
        .slice(0, 20)
    : null;

  function renderTree(nodes: TreeNode[], depth: number) {
    return (
      <ul className="seshat-site-tree">
        {nodes.map((node) =>
          node.page ? (
            <li key={node.page.path}>
              <Link
                href={href(slug, node.page.path)}
                className={`seshat-site-link${node.page.path === currentPath ? " is-active" : ""}`}
                style={{ paddingLeft: 10 + depth * 14 }}
                aria-current={node.page.path === currentPath ? "page" : undefined}
              >
                {node.page.title}
              </Link>
            </li>
          ) : (
            <li key={`dir:${node.name}:${depth}`}>
              <p className="seshat-site-folder" style={{ paddingLeft: 10 + depth * 14 }}>
                {node.name}
              </p>
              {renderTree(node.children, depth + 1)}
            </li>
          ),
        )}
      </ul>
    );
  }

  return (
    <>
      <button
        type="button"
        className="seshat-doc-chrome-button seshat-site-menu"
        onClick={() => setOpen((v) => !v)}
        aria-label={open ? "Close pages" : "Show pages"}
        aria-expanded={open}
      >
        {open ? <X size={14} strokeWidth={1.5} /> : <PanelLeft size={14} strokeWidth={1.5} />}
      </button>
      {open ? (
        <button
          type="button"
          className="seshat-site-backdrop"
          aria-label="Close pages"
          onClick={() => setOpen(false)}
        />
      ) : null}

      <nav className={`seshat-site-sidebar${open ? " is-open" : ""}`} aria-label="Pages">
        <Link href={`/s/${slug}`} className="seshat-site-brand">
          <SeshatMark size={18} />
          <span>{title}</span>
        </Link>

        <label className="seshat-site-search">
          <Search size={13} strokeWidth={1.5} aria-hidden="true" />
          <input
            type="search"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Search pages"
            aria-label="Search pages"
          />
        </label>

        {results ? (
          results.length === 0 ? (
            <p className="seshat-site-empty">No matches.</p>
          ) : (
            <ul className="seshat-site-tree">
              {results.map((p) => (
                <li key={p.path}>
                  <Link href={href(slug, p.path)} className="seshat-site-link seshat-site-result">
                    <span>{p.title}</span>
                    <small>{snippet(p.content, q) || p.path}</small>
                  </Link>
                </li>
              ))}
            </ul>
          )
        ) : (
          renderTree(tree, 0)
        )}
      </nav>
    </>
  );
}
