import { BookOpen, Library, Link2, ListTree, SunMoon, Terminal } from "lucide-react";
import { HeroDesktop } from "@/components/landing/hero-desktop";
import { SeshatDoc } from "@/components/seshat-doc";
import { SeshatMark } from "@/components/seshat-mark";

// Our own server is the single source of truth for the latest build (repo is
// private): /download logs the click and 302s to the current DMG.
const API_BASE =
  process.env.NEXT_PUBLIC_SESHAT_API ?? "https://api.seshat.page";
const DOWNLOAD_URL = `${API_BASE}/download`;

export default function Home() {
  return (
    <main className="bg-paper text-ink mx-auto max-w-[1200px] px-6 pt-7 pb-16">
      <HeroDesktop downloadHref={DOWNLOAD_URL} doc={<SeshatDoc content={SAMPLE_MD} />} />
      <About />
      <LibraryCard />
      <SharePromo />
      <Footer />
    </main>
  );
}

const SAMPLE_MD = `# Typography for Long Documents

Most tools treat markdown as source code. Seshat treats it as *writing*: serif headings, generous line height, and a measure narrow enough to actually read.

> Reading is the work. The renderer should disappear.

## What changes on paper

- Headings set in New York, the system serif
- Body text at a calm 1.65 line height
- Code blocks breathe wider than prose

\`\`\`swift
let parsed = MarkdownParser.parse(source)
for section in parsed.sections {
    render(section, theme: .seshat)
}
\`\`\`

## Tables without the grid

| Element | Typeface | Size |
| --- | --- | --- |
| Headings | New York Serif | 36 / 26 / 20 |
| Body | SF Pro Text | 16 pt |
| Code | SF Mono | 14 pt |

## Lists

- Plain unordered list item with reasonable line height
- Second item

## Blockquotes

> Margins, not separators, do the work of structuring prose.
`;

/* ── About ─────────────────────────────────────────────────────────── */

const features = [
  {
    icon: BookOpen,
    title: "A reader, not an editor",
    body: "Serif headings, a 720pt measure, one file per window.",
  },
  {
    icon: Terminal,
    title: "A one-word CLI",
    body: "seshat open report.md from any terminal, any folder.",
  },
  {
    icon: Library,
    title: "A library at ~/Seshat",
    body: "Plain files in a folder. Subfolders are shelves.",
  },
  {
    icon: ListTree,
    title: "A floating outline",
    body: "Headings drift in the margin. Click one to jump.",
  },
  {
    icon: Link2,
    title: "Share by link",
    body: "One click publishes the page. Same type, any device.",
  },
  {
    icon: SunMoon,
    title: "Paper by day, ink by night",
    body: "Light by default, because Seshat is paper.",
  },
];

function About() {
  return (
    <section className="mt-[100px]">
      <h2 className="font-heading text-ink mx-auto mb-8 max-w-[46ch] text-balance text-center text-[24px] leading-[1.3] font-semibold tracking-[-0.01em]">
        A native macOS reader for the markdown you write, generate, and share.
      </h2>
      <div className="mx-auto grid max-w-[820px] grid-cols-1 gap-5 sm:grid-cols-2 md:grid-cols-3">
        {features.map((f) => (
          <div key={f.title} className="bg-paper-subtle flex flex-col rounded-2xl p-5">
            <f.icon size={20} className="text-gold mb-2.5" strokeWidth={1.6} />
            <h3 className="text-ink m-0 mb-1 text-[15px] font-medium tracking-[-0.005em]">
              {f.title}
            </h3>
            <p className="text-ink-muted m-0 text-[14px] leading-[1.5]">{f.body}</p>
          </div>
        ))}
      </div>
    </section>
  );
}

/* ── Library ───────────────────────────────────────────────────────── */

function LibraryCard() {
  return (
    <section className="bg-paper-subtle mx-auto mt-[100px] max-w-[820px] rounded-2xl px-6 py-14 text-center">
      <div className="hero-sheets" aria-hidden>
        <span>RFC</span>
        <span>typography</span>
        <span>notes</span>
      </div>
      <h2 className="font-heading text-ink m-0 mb-2 text-[24px] font-semibold tracking-[-0.01em]">
        Your library is a folder.
      </h2>
      <p className="text-ink-muted mx-auto mb-5 max-w-[42ch] text-[14px] leading-[1.55]">
        ~/Seshat/ is plain markdown on disk. Drop a file in and it appears in
        the sidebar. Nothing to import, nothing to sync, nothing to export.
      </p>
      <code className="text-ink-faint font-mono text-[12px]">
        ~/Seshat/Inbox/typography.md
      </code>
    </section>
  );
}

/* ── Share ─────────────────────────────────────────────────────────── */

function SharePromo() {
  return (
    <section className="mx-auto mt-[100px] grid max-w-[820px] items-center gap-7 sm:grid-cols-[411px_1fr] sm:gap-14">
      <div className="relative aspect-[411/311] overflow-hidden rounded-[20px]">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src="/hero-temple.jpg"
          alt=""
          className="absolute inset-0 h-full w-full object-cover object-[88%_50%]"
        />
        <div className="bg-paper/92 text-ink absolute top-1/2 left-1/2 flex -translate-x-1/2 -translate-y-1/2 items-center gap-2.5 rounded-xl px-4 py-2.5 font-mono text-[12px] whitespace-nowrap shadow-[0_18px_40px_rgba(30,20,10,.28),0_2px_8px_rgba(0,0,0,.12)] backdrop-blur">
          <Link2 size={13} className="text-gold" />
          seshat.page/d/atrium-7c1a
          <span className="text-ink-faint">· copied</span>
        </div>
      </div>
      <div>
        <h3 className="font-heading text-ink m-0 mb-3.5 text-balance text-[24px] leading-[1.25] font-semibold tracking-[-0.01em]">
          Hand someone a pamphlet.
        </h3>
        <p className="text-ink-muted m-0 mb-6 max-w-[38ch] text-[15px] leading-[1.6]">
          Open a document, click Share. Seshat publishes it and copies a link.
          The page renders with the same type on any device. No login wall,
          no app to install.
        </p>
        <span className="bg-paper-subtle text-ink-muted inline-flex h-7 items-center rounded-full px-3.5 font-mono text-[12px]">
          <span className="text-gold mr-2">$</span> seshat share notes.md
        </span>
      </div>
    </section>
  );
}

/* ── Footer ────────────────────────────────────────────────────────── */

function Footer() {
  return (
    <footer className="mx-auto mt-[100px] max-w-[820px]">
      <hr className="bg-rule m-0 h-px border-0" />
      <div className="text-ink-faint flex items-center justify-between pt-14 text-[13px]">
        <span className="flex items-center gap-2.5">
          <SeshatMark size={16} strokeWidth={1.6} />
          Seshat · Mistress of the House of Books
        </span>
        <span>© 2026 · macOS 14+</span>
      </div>
    </footer>
  );
}
