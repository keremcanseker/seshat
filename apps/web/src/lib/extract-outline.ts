import GithubSlugger from "github-slugger";

export type OutlineEntry = {
  id: string;
  level: number;
  text: string;
};

const HEADING_RE = /^(#{1,6})\s+(.+?)\s*#*\s*$/;
const FENCE_RE = /^\s*(```|~~~)/;

export function extractOutline(markdown: string): OutlineEntry[] {
  const slugger = new GithubSlugger();
  const out: OutlineEntry[] = [];
  let inFence = false;
  for (const line of markdown.split("\n")) {
    if (FENCE_RE.test(line)) {
      inFence = !inFence;
      continue;
    }
    if (inFence) continue;
    const match = line.match(HEADING_RE);
    if (!match) continue;
    const level = match[1].length;
    const rawText = match[2].trim();
    const text = stripInlineMarkdown(rawText);
    if (!text) continue;
    out.push({ id: slugger.slug(text), level, text });
  }
  return out;
}

function stripInlineMarkdown(input: string): string {
  return input
    .replace(/`([^`]+)`/g, "$1")
    .replace(/\*\*([^*]+)\*\*/g, "$1")
    .replace(/__([^_]+)__/g, "$1")
    .replace(/\*([^*]+)\*/g, "$1")
    .replace(/_([^_]+)_/g, "$1")
    .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
    .replace(/!\[([^\]]*)\]\([^)]+\)/g, "$1");
}
