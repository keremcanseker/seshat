import Link from "next/link";
import { SeshatMark } from "@/components/seshat-mark";

const DOWNLOAD_URL =
  "https://github.com/keremcanseker/seshat/releases/latest/download/Seshat.dmg";
const REPO_URL = "https://github.com/keremcanseker/seshat";
const BYPASS_COMMAND = "xattr -dr com.apple.quarantine /Applications/Seshat.app";

export default function Home() {
  return (
    <main className="text-ink relative">
      <BackgroundOrnament />
      <Nav />
      <Hero />
      <SectionDivider />
      <Motivation />
      <SectionDivider />
      <TwoSurfaces />
      <SectionDivider />
      <ReaderShowcase />
      <SectionDivider />
      <Philosophy />
      <SectionDivider />
      <UseCases />
      <SectionDivider />
      <NotList />
      <SectionDivider />
      <Audience />
      <SectionDivider />
      <Closing />
      <Footer />
    </main>
  );
}

/* ───────────────────────── Layout primitives ───────────────────────── */

function BackgroundOrnament() {
  return (
    <div
      aria-hidden="true"
      className="pointer-events-none fixed inset-0 -z-10 select-none"
    >
      <div
        className="absolute inset-0"
        style={{
          backgroundImage:
            "radial-gradient(circle at 50% -10%, color-mix(in oklab, var(--gold) 8%, transparent) 0%, transparent 60%)",
        }}
      />
      <div
        className="absolute inset-x-0 top-0 h-px"
        style={{
          background:
            "linear-gradient(to right, transparent, var(--rule-strong), transparent)",
        }}
      />
    </div>
  );
}

function SectionDivider() {
  return (
    <div className="mx-auto flex w-full max-w-[var(--measure-wide)] items-center justify-center px-6 py-2">
      <div className="flex w-full max-w-[var(--measure-content)] items-center gap-4">
        <span className="seshat-rule flex-1 opacity-60" />
        <span className="text-gold/60 text-xs" aria-hidden="true">
          ❦
        </span>
        <span className="seshat-rule flex-1 opacity-60" />
      </div>
    </div>
  );
}

function SectionLabel({ numeral, title }: { numeral: string; title: string }) {
  return (
    <div className="seshat-section-label flex items-baseline gap-3">
      <span className="text-gold">§ {numeral}</span>
      <span>{title}</span>
    </div>
  );
}

/* ──────────────────────────────── Nav ─────────────────────────────── */

function Nav() {
  return (
    <header className="border-rule bg-paper/80 sticky top-0 z-30 border-b backdrop-blur supports-[backdrop-filter]:bg-paper/70">
      <div className="mx-auto flex max-w-[var(--measure-wide)] items-center justify-between px-6 py-3.5">
        <Link href="/" className="text-ink flex items-center gap-2.5 group">
          <SeshatMark
            size={22}
            className="text-gold transition-transform duration-500 group-hover:rotate-[51.4deg]"
          />
          <span className="font-heading text-[1.05rem] font-semibold tracking-tight">
            Seshat
          </span>
        </Link>
        <nav className="flex items-center gap-7 text-sm">
          <a
            className="text-ink-muted hover:text-ink seshat-link-underline hidden sm:inline"
            href="#reader"
          >
            Reader
          </a>
          <a
            className="text-ink-muted hover:text-ink seshat-link-underline hidden sm:inline"
            href="#share"
          >
            Share
          </a>
          <a
            className="text-ink-muted hover:text-ink seshat-link-underline hidden sm:inline"
            href="#philosophy"
          >
            Philosophy
          </a>
          <a
            className="text-ink hover:text-gold inline-flex items-center gap-1.5 font-medium"
            href="https://github.com/keremcanseker"
            target="_blank"
            rel="noreferrer"
          >
            <GitHubGlyph />
            <span>GitHub</span>
          </a>
        </nav>
      </div>
    </header>
  );
}

/* ──────────────────────────────── Hero ─────────────────────────────── */

function Hero() {
  return (
    <section className="relative mx-auto w-full max-w-[var(--measure-wide)] px-6 pt-20 pb-16 sm:pt-28 sm:pb-24">
      <div className="mx-auto max-w-[var(--measure-content)] text-center">
        <p className="seshat-section-label flex items-center justify-center gap-2">
          <SeshatMark size={14} starOnly className="text-gold" />
          <span>Mistress of the House of Books</span>
          <SeshatMark size={14} starOnly className="text-gold" />
        </p>

        <h1 className="font-heading text-ink mt-7 text-balance text-[2.85rem] font-semibold leading-[1.04] tracking-[-0.018em] sm:text-[4.25rem]">
          A reading room for
          <br />
          <span className="italic">long-form </span>
          <span className="relative inline-block">
            markdown
            <svg
              aria-hidden="true"
              viewBox="0 0 220 12"
              className="text-gold pointer-events-none absolute -bottom-2 left-0 h-[10px] w-full"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.6"
              strokeLinecap="round"
            >
              <path d="M3 7 C 50 1, 110 11, 217 5" />
            </svg>
          </span>
          .
        </h1>

        <p className="text-ink-muted mx-auto mt-7 max-w-[34rem] text-balance text-[1.075rem] leading-[1.65]">
          A native macOS app and CLI that renders <code className="font-mono text-[0.94em] text-ink">.md</code>{" "}
          files the way a thoughtful book does — and lets you share any local
          file as a beautifully-typeset link with a single command.
        </p>

        <div className="mt-9 flex flex-wrap items-center justify-center gap-3">
          <PrimaryCTA heroVariant />
          <SecondaryCTA />
        </div>

        <p className="text-ink-faint mt-5 font-mono text-xs tracking-tight">
          macOS 14+ · Apple Silicon &amp; Intel · MIT
        </p>
      </div>

      <div className="mx-auto mt-16 w-full max-w-[var(--measure-content)]">
        <CliFrame
          lines={[
            { kind: "cmd", text: "seshat open report.md" },
            { kind: "out", text: "Opening report.md in reader window…" },
            { kind: "blank" },
            { kind: "cmd", text: "seshat share investigation.md" },
            { kind: "out", text: "https://seshat.app/d/atrium-7c1a" },
          ]}
        />
      </div>
    </section>
  );
}

function PrimaryCTA({ heroVariant = false }: { heroVariant?: boolean }) {
  return (
    <a
      href={heroVariant ? "#download" : DOWNLOAD_URL}
      className="bg-ink text-paper hover:bg-ink/90 inline-flex h-11 items-center gap-2 rounded-md px-5 text-[0.92rem] font-medium tracking-tight shadow-[0_1px_0_color-mix(in_oklab,var(--ink)_30%,transparent)] transition-colors"
    >
      Download for macOS
      <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
        <path
          d="M7 1.5v9m0 0L3 6.5m4 4 4-4m-9 7h10"
          stroke="currentColor"
          strokeWidth="1.4"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      </svg>
    </a>
  );
}

function SecondaryCTA() {
  return (
    <a
      href={REPO_URL}
      target="_blank"
      rel="noreferrer"
      className="border-rule-strong bg-paper text-ink hover:border-ink/40 hover:bg-paper-subtle inline-flex h-11 items-center gap-2 rounded-md border px-5 text-[0.92rem] font-medium tracking-tight transition-colors"
    >
      <GitHubGlyph />
      View source
    </a>
  );
}

function GitHubGlyph() {
  return (
    <svg
      width="14"
      height="14"
      viewBox="0 0 16 16"
      fill="currentColor"
      aria-hidden="true"
    >
      <path d="M8 0C3.58 0 0 3.58 0 8a8 8 0 0 0 5.47 7.59c.4.07.55-.17.55-.38v-1.49c-2.23.49-2.7-.94-2.7-.94-.36-.92-.89-1.17-.89-1.17-.73-.5.05-.49.05-.49.81.06 1.23.83 1.23.83.72 1.23 1.88.88 2.34.67.07-.52.28-.88.5-1.08-1.78-.2-3.65-.89-3.65-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.13 0 0 .67-.21 2.2.82A7.66 7.66 0 0 1 8 4.21c.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.11.16 1.93.08 2.13.51.56.82 1.27.82 2.15 0 3.07-1.87 3.74-3.65 3.94.29.25.54.73.54 1.48v2.19c0 .21.15.46.55.38A8 8 0 0 0 16 8c0-4.42-3.58-8-8-8Z" />
    </svg>
  );
}

/* ───────────────────────────── CLI frame ──────────────────────────── */

type CliLine =
  | { kind: "cmd"; text: string }
  | { kind: "out"; text: string }
  | { kind: "blank" };

function CliFrame({ lines }: { lines: CliLine[] }) {
  return (
    <div className="border-rule bg-paper-subtle/70 overflow-hidden rounded-lg border shadow-[0_1px_0_var(--paper)] backdrop-blur-sm">
      <div className="border-rule flex items-center gap-1.5 border-b px-4 py-2.5">
        <span className="bg-ink/10 size-2.5 rounded-full" />
        <span className="bg-ink/10 size-2.5 rounded-full" />
        <span className="bg-ink/10 size-2.5 rounded-full" />
        <span className="text-ink-faint mx-auto select-none font-mono text-[10px] tracking-[0.18em] uppercase">
          ~/notes — zsh
        </span>
      </div>
      <pre className="text-ink overflow-x-auto px-5 py-5 font-mono text-[0.9rem] leading-[1.7]">
        {lines.map((line, i) => {
          if (line.kind === "blank") {
            return <div key={i}>&nbsp;</div>;
          }
          if (line.kind === "cmd") {
            return (
              <div key={i}>
                <span className="text-gold select-none">$ </span>
                <span className="text-ink">{line.text}</span>
              </div>
            );
          }
          return (
            <div key={i} className="text-ink-muted">
              {line.text}
            </div>
          );
        })}
      </pre>
    </div>
  );
}

/* ─────────────────────────── Motivation ──────────────────────────── */

function Motivation() {
  return (
    <section className="relative mx-auto w-full max-w-[var(--measure-wide)] px-6 py-20 sm:py-28">
      <div className="mx-auto grid max-w-[var(--measure-wide)] gap-12 lg:grid-cols-[1fr_2fr]">
        <div className="lg:sticky lg:top-24 lg:self-start">
          <SectionLabel numeral="I" title="Why this exists" />
          <h2 className="font-heading text-ink mt-5 text-balance text-[2rem] font-semibold leading-[1.1] sm:text-[2.4rem]">
            Reading prose in dev tools feels like reading a config file.
          </h2>
        </div>
        <div className="max-w-[var(--measure-prose)] space-y-6 text-[1.0625rem] leading-[1.75] text-ink">
          <p className="seshat-dropcap">
            The VS Code preview, the GitHub render, every dotfile-tier viewer —
            they’re functional, but reading a 4,000-word agent output, a
            postmortem, a design doc, or a long README inside one of them feels
            like work. The container is austere and tiring. The content is
            often genuinely worth reading; the surface around it makes it feel
            like it isn’t.
          </p>
          <p>
            Sharing markdown is fiddly too. You generate something
            interesting on your own machine — a long Claude session, an
            architecture proposal, a runbook — and now you’re choosing between
            pasting into Slack (loses formatting), uploading to Notion
            (heavy, captures it into someone else’s workspace), making a gist
            (fine, but it looks like a gist), or sending the raw file (now
            the recipient needs their own renderer).
          </p>
          <blockquote className="seshat-pull">
            Seshat is the answer to both: a calm, well-typeset reader that
            lives on your machine — and a one-command path to put any local
            file on the web with the same look.
          </blockquote>
        </div>
      </div>
    </section>
  );
}

/* ───────────────────────── Two product surfaces ───────────────────── */

function TwoSurfaces() {
  return (
    <section className="relative mx-auto w-full max-w-[var(--measure-wide)] px-6 py-20 sm:py-24">
      <div className="mx-auto max-w-[var(--measure-content)] text-center">
        <SectionLabel numeral="II" title="Two surfaces" />
        <h2 className="font-heading text-ink mx-auto mt-5 max-w-[28rem] text-balance text-[2rem] font-semibold leading-[1.1] sm:text-[2.4rem]">
          A reader for you, a link for everyone else.
        </h2>
        <p className="text-ink-muted mx-auto mt-5 max-w-[36rem] text-[1.0625rem] leading-[1.7]">
          One product, two surfaces. The desktop reader and the share link are
          the same document, rendered with the same care.
        </p>
      </div>

      <div className="mx-auto mt-14 grid max-w-[var(--measure-content)] gap-px overflow-hidden rounded-xl bg-rule sm:grid-cols-2">
        <SurfaceCard
          id="reader"
          numeral="i"
          title="The reader"
          when="today"
          body="A native macOS app pointed at a managed library at ~/Seshat/. Open any file in its own window, browse a Finder-style sidebar, glance at the outline. Minimal chrome, generous typography, scholarly calm."
          example={
            <CliFrame
              lines={[
                { kind: "cmd", text: "seshat open notes.md" },
                { kind: "out", text: "→ window opens, typeset like a chapter" },
              ]}
            />
          }
        />
        <SurfaceCard
          id="share"
          numeral="ii"
          title="The share layer"
          when="next"
          body="seshat share takes a local .md and gives back a public URL. The recipient opens the link in any browser and sees the same document, rendered with the same theme. No login wall. No app install."
          example={
            <CliFrame
              lines={[
                { kind: "cmd", text: "seshat share investigation.md" },
                { kind: "out", text: "https://seshat.app/d/atrium-7c1a" },
              ]}
            />
          }
        />
      </div>
    </section>
  );
}

function SurfaceCard({
  id,
  numeral,
  title,
  when,
  body,
  example,
}: {
  id: string;
  numeral: string;
  title: string;
  when: string;
  body: string;
  example: React.ReactNode;
}) {
  return (
    <article
      id={id}
      className="bg-paper relative flex flex-col gap-6 p-8 sm:p-10"
    >
      <div className="flex items-baseline justify-between">
        <span className="seshat-section-label text-gold">{numeral}.</span>
        <span className="seshat-section-label">{when}</span>
      </div>
      <h3 className="font-heading text-ink text-[1.5rem] font-semibold leading-[1.15]">
        {title}
      </h3>
      <p className="text-ink-muted text-[0.98rem] leading-[1.7]">{body}</p>
      <div className="mt-auto">{example}</div>
    </article>
  );
}

/* ───────────────────── Reader showcase (markdown render) ─────────── */

function ReaderShowcase() {
  return (
    <section className="relative mx-auto w-full max-w-[var(--measure-wide)] px-6 py-20 sm:py-28">
      <div className="mx-auto max-w-[var(--measure-content)] text-center">
        <SectionLabel numeral="III" title="Inside the reader" />
        <h2 className="font-heading text-ink mx-auto mt-5 max-w-[30rem] text-balance text-[2rem] font-semibold leading-[1.1] sm:text-[2.4rem]">
          What it looks like to read here.
        </h2>
        <p className="text-ink-muted mx-auto mt-5 max-w-[34rem] text-[1.0625rem] leading-[1.7]">
          The same theme renders on macOS and on a shared link. Below: a sample
          document, typeset by Seshat, the way you’d see it.
        </p>
      </div>

      <div className="mx-auto mt-14 max-w-[var(--measure-content)]">
        <WindowFrame title="On Long-Form Markdown.md">
          <article className="seshat-prose">
            <h1>On long-form markdown</h1>
            <p className="text-ink-muted text-[0.9rem]">
              <span className="font-mono">draft · 2026-05-08</span>
            </p>
            <p>
              The thing about long markdown is that it deserves to be{" "}
              <em>read</em>, not scrolled past. In a developer tool, prose
              competes with line numbers, monospace UI, and minimaps —{" "}
              everything around it says <em>this is code</em>.
            </p>
            <p>
              In a reader built for prose, the same words behave differently:
              line length is constrained, headings breathe, and the eye
              actually finds the next paragraph instead of skipping it.
            </p>
            <h2>What changes</h2>
            <ul>
              <li>Body type set in a humanist sans, sized for the eye.</li>
              <li>Headings in a heritage serif, optical-sized for screen.</li>
              <li>Code blocks unfurl wider than prose; the prose column stays calm.</li>
              <li>Tables use horizontal rules only — no spreadsheet grid.</li>
            </ul>
            <blockquote>
              Seshat is the Egyptian goddess of writing and libraries —{" "}
              <em>Mistress of the House of Books</em>. The name is the brief.
            </blockquote>
            <h2>Try it</h2>
            <pre>
              <code>{`$ seshat open notes.md
→ window opens, typeset like a chapter`}</code>
            </pre>
            <p>
              Or <code>seshat share notes.md</code> to hand someone a link.
            </p>
          </article>
        </WindowFrame>
      </div>
    </section>
  );
}

function WindowFrame({
  title,
  children,
}: {
  title: string;
  children: React.ReactNode;
}) {
  return (
    <div className="border-rule bg-paper overflow-hidden rounded-xl border shadow-[0_1px_0_var(--paper),0_24px_60px_-30px_color-mix(in_oklab,var(--ink)_30%,transparent)]">
      <div className="border-rule from-paper-subtle to-paper relative flex items-center gap-1.5 border-b bg-gradient-to-b px-4 py-2.5">
        <span className="bg-ink/10 size-2.5 rounded-full" />
        <span className="bg-ink/10 size-2.5 rounded-full" />
        <span className="bg-ink/10 size-2.5 rounded-full" />
        <span className="text-ink-muted absolute left-1/2 -translate-x-1/2 select-none font-sans text-[0.78rem]">
          {title}
        </span>
      </div>
      <div className="px-8 py-12 sm:px-16 sm:py-16">
        <div className="mx-auto max-w-[var(--measure-prose)]">{children}</div>
      </div>
    </div>
  );
}

/* ─────────────────────────── Philosophy ──────────────────────────── */

const principles = [
  {
    title: "A library, not a dashboard.",
    body: "Scholarly reading room, not productivity tool. Calm, considered, quiet. Negative space is encouraged. Chrome is suspect.",
  },
  {
    title: "The content is the product.",
    body: "Anything that competes with the words on the page — heavy borders, colored callouts, sidebar trees that demand attention, badges, status pills — is wrong by default.",
  },
  {
    title: "Made for developers, but doesn’t look like a dev tool.",
    body: "The audience writes code. The output is for reading. Aesthetic borrows from books, journals, and long-form essays — not IDEs, terminals, or admin panels.",
  },
  {
    title: "Opinionated, not configurable.",
    body: "No theme pickers, no font sliders, no density toggles. The reading experience is one specific thing, chosen carefully, applied consistently.",
  },
  {
    title: "Inspired by Notion, but not a Notion clone.",
    body: "Block-based clarity, yes. SaaS-doc-tool feel, no. Older, warmer, more rooted in writing tradition — a scribe’s library.",
  },
  {
    title: "The CLI is a first-class surface.",
    body: "Type a sentence in your terminal, get a beautifully-rendered document or shareable link in return. The CLI is not a convenience — it is the gesture.",
  },
];

function Philosophy() {
  return (
    <section
      id="philosophy"
      className="relative mx-auto w-full max-w-[var(--measure-wide)] px-6 py-20 sm:py-28"
    >
      <div className="mx-auto max-w-[var(--measure-content)] text-center">
        <SectionLabel numeral="IV" title="Philosophy" />
        <h2 className="font-heading text-ink mx-auto mt-5 max-w-[28rem] text-balance text-[2rem] font-semibold leading-[1.1] sm:text-[2.4rem]">
          Six principles, applied without negotiation.
        </h2>
      </div>

      <ol className="mx-auto mt-14 grid max-w-[var(--measure-wide)] gap-x-12 gap-y-12 sm:grid-cols-2">
        {principles.map((p, i) => (
          <li
            key={p.title}
            className="border-rule relative border-t pt-6 first:border-t sm:border-t"
          >
            <div className="flex items-baseline justify-between gap-6">
              <h3 className="font-heading text-ink max-w-[26rem] text-balance text-[1.2rem] font-semibold leading-[1.25]">
                {p.title}
              </h3>
              <span className="text-gold font-mono text-xs tracking-tight tabular-nums">
                {String(i + 1).padStart(2, "0")}
              </span>
            </div>
            <p className="text-ink-muted mt-3 max-w-[28rem] text-[0.98rem] leading-[1.7]">
              {p.body}
            </p>
          </li>
        ))}
      </ol>
    </section>
  );
}

/* ──────────────────────────── Use cases ──────────────────────────── */

const useCases = [
  {
    headline: "AI output that finally feels like reading.",
    body: "A long Claude Code session produces a 3,000-line markdown report. seshat open report.md and the report is typeset like a chapter — for the first time, it feels worth reading instead of scrolling past.",
  },
  {
    headline: "Send a teammate something they’ll actually open.",
    body: "seshat share report.md returns a link. Paste it into Slack. They click, read it on their phone on the bus, and it still looks good. No login wall, no app install.",
  },
  {
    headline: "A personal study, not a file picker.",
    body: "Your ~/Seshat/ folder of notes, drafts, investigations, half-finished essays. The sidebar feels like walking into a library — not opening a directory in VS Code.",
  },
  {
    headline: "RFCs that read like the real thing.",
    body: "Your team writes RFCs as markdown. The Seshat link is the canonical place to read them. Discussion lives elsewhere; the link is just for the document.",
  },
];

function UseCases() {
  return (
    <section className="relative mx-auto w-full max-w-[var(--measure-wide)] px-6 py-20 sm:py-28">
      <div className="mx-auto max-w-[var(--measure-content)] text-center">
        <SectionLabel numeral="V" title="In practice" />
        <h2 className="font-heading text-ink mx-auto mt-5 max-w-[30rem] text-balance text-[2rem] font-semibold leading-[1.1] sm:text-[2.4rem]">
          Scenarios this is built around.
        </h2>
      </div>

      <div className="mx-auto mt-14 max-w-[var(--measure-content)] space-y-12">
        {useCases.map((u, i) => (
          <article
            key={u.headline}
            className="border-rule grid gap-6 border-t pt-8 sm:grid-cols-[6rem_1fr]"
          >
            <div className="font-heading text-gold text-[1.85rem] leading-none italic">
              {String(i + 1).padStart(2, "0")}
            </div>
            <div>
              <h3 className="font-heading text-ink max-w-[34rem] text-balance text-[1.4rem] font-semibold leading-[1.25]">
                {u.headline}
              </h3>
              <p className="text-ink-muted mt-3 max-w-[40rem] text-[1.0125rem] leading-[1.7]">
                {u.body}
              </p>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}

/* ───────────────────────────── Not list ──────────────────────────── */

const notItems = [
  ["Not a note-taking PKM.", "No backlinks, no graph view, no daily notes. Obsidian and Logseq exist."],
  ["Not an editor (yet).", "v0.1 is read-only. Editing comes later, and will be careful about preserving source."],
  ["Not a wiki.", "Files are files; folders are folders. No namespaces, no mandatory linking structure."],
  ["Not a collaboration tool.", "Sharing is one-way: you publish, they read. No comments, no co-editing, no presence."],
  ["Not multi-platform first.", "Native macOS app and a web reader. No iOS, Windows, or Linux app planned."],
  ["Not configurable.", "No themes, no fonts, no layout options. One reading experience, executed well."],
];

function NotList() {
  return (
    <section className="relative mx-auto w-full max-w-[var(--measure-wide)] px-6 py-20 sm:py-28">
      <div className="mx-auto grid max-w-[var(--measure-wide)] gap-12 lg:grid-cols-[1fr_2fr]">
        <div className="lg:sticky lg:top-24 lg:self-start">
          <SectionLabel numeral="VI" title="Out of scope" />
          <h2 className="font-heading text-ink mt-5 text-balance text-[2rem] font-semibold leading-[1.1] sm:text-[2.4rem]">
            What Seshat is&nbsp;
            <em className="text-ink-muted">not</em>.
          </h2>
          <p className="text-ink-muted mt-5 max-w-[26rem] text-[0.98rem] leading-[1.7]">
            Naming what we are not is how we keep the design honest.
          </p>
        </div>
        <ul className="grid max-w-[var(--measure-prose)] gap-px overflow-hidden rounded-xl bg-rule">
          {notItems.map(([title, body]) => (
            <li
              key={title}
              className="bg-paper flex flex-col gap-1.5 p-5 sm:p-6"
            >
              <div className="flex items-baseline gap-3">
                <span className="text-gold font-heading text-[0.95rem] italic">
                  ✕
                </span>
                <h3 className="font-heading text-ink text-[1.075rem] font-semibold">
                  {title}
                </h3>
              </div>
              <p className="text-ink-muted ml-7 text-[0.95rem] leading-[1.65]">
                {body}
              </p>
            </li>
          ))}
        </ul>
      </div>
    </section>
  );
}

/* ───────────────────────────── Audience ──────────────────────────── */

const audience = [
  "Writes or generates long-form markdown often, including AI output.",
  "Cares enough about how text looks that current tools quietly annoy them.",
  "Wants sharing to be a cmd+space → seshat share → paste-link reflex, not a workflow.",
  "Trusts taste over toggles — would rather use something opinionated than configure something flexible.",
];

function Audience() {
  return (
    <section className="relative mx-auto w-full max-w-[var(--measure-wide)] px-6 py-20 sm:py-28">
      <div className="mx-auto max-w-[var(--measure-content)] text-center">
        <SectionLabel numeral="VII" title="For whom" />
        <h2 className="font-heading text-ink mx-auto mt-5 max-w-[28rem] text-balance text-[2rem] font-semibold leading-[1.1] sm:text-[2.4rem]">
          Built for one specific reader.
        </h2>
        <p className="text-ink-muted mx-auto mt-5 max-w-[34rem] text-[1.0625rem] leading-[1.7]">
          A developer (or developer-adjacent — designer, technical writer,
          researcher) who:
        </p>
      </div>

      <ul className="mx-auto mt-12 max-w-[var(--measure-prose)] space-y-6">
        {audience.map((line) => (
          <li key={line} className="flex gap-4">
            <SeshatMark
              size={16}
              starOnly
              className="text-gold mt-[5px] shrink-0"
            />
            <span className="text-ink text-[1.05rem] leading-[1.7]">
              {line}
            </span>
          </li>
        ))}
      </ul>
    </section>
  );
}

/* ───────────────────────────── Closing ───────────────────────────── */

function Closing() {
  return (
    <section
      id="download"
      className="relative mx-auto w-full max-w-[var(--measure-wide)] px-6 py-24 sm:py-32"
    >
      <div className="mx-auto max-w-[var(--measure-content)] text-center">
        <SectionLabel numeral="❦" title="Begin reading" />
        <h2 className="font-heading text-ink mx-auto mt-6 max-w-[30rem] text-balance text-[2.4rem] font-semibold leading-[1.05] sm:text-[3rem]">
          Open a markdown file.
          <br />
          <span className="italic">See the difference.</span>
        </h2>
        <p className="text-ink-muted mx-auto mt-6 max-w-[32rem] text-[1.0625rem] leading-[1.7]">
          Download the macOS app, drop your <code className="font-mono">.md</code>{" "}
          files into <code className="font-mono">~/Seshat</code>, and read them
          the way you wish you’d been reading them all along.
        </p>

        <div className="mt-10 flex flex-wrap items-center justify-center gap-3">
          <PrimaryCTA />
          <SecondaryCTA />
        </div>

        <p className="text-ink-faint mt-6 font-mono text-xs tracking-tight">
          Or, after install:{" "}
          <code className="text-ink-muted">seshat open path/to/file.md</code>
        </p>
      </div>

      <FirstRunNote />
    </section>
  );
}

function FirstRunNote() {
  return (
    <aside
      id="setup"
      className="border-rule bg-paper-subtle/60 mx-auto mt-16 max-w-[var(--measure-content)] rounded-xl border p-6 sm:p-8"
    >
      <div className="flex items-baseline justify-between gap-3">
        <h3 className="font-heading text-ink text-[1.05rem] font-semibold">
          First-time setup
        </h3>
        <span className="seshat-section-label text-gold">pre-release</span>
      </div>
      <p className="text-ink-muted mt-3 max-w-2xl text-[0.95rem] leading-[1.65]">
        Seshat is unsigned during early access (Apple Developer ID is pending).
        On first launch, macOS Gatekeeper may say the app is{" "}
        <em>“damaged” or from an unidentified developer</em>. It’s neither —
        macOS just hasn’t seen our signature yet. Run this once in Terminal,
        then double-click <code className="font-mono">Seshat.app</code> normally:
      </p>
      <CopyableCommand command={BYPASS_COMMAND} />
      <p className="text-ink-faint mt-4 text-[0.85rem] leading-[1.6]">
        Once Seshat opens, it will offer to install the{" "}
        <code className="font-mono">seshat</code> command into your{" "}
        <code className="font-mono">PATH</code>. You can use{" "}
        <code className="font-mono">seshat open file.md</code> from any
        terminal afterwards — no manual symlinks, no shell config edits.
      </p>
    </aside>
  );
}

function CopyableCommand({ command }: { command: string }) {
  return (
    <div className="border-rule bg-paper mt-4 flex items-stretch overflow-hidden rounded-md border">
      <pre className="text-ink flex-1 overflow-x-auto px-4 py-3 font-mono text-[0.85rem] leading-[1.6]">
        <span className="text-gold/70 select-none">$ </span>
        {command}
      </pre>
    </div>
  );
}

/* ───────────────────────────── Footer ────────────────────────────── */

function Footer() {
  return (
    <footer className="border-rule mt-8 border-t">
      <div className="mx-auto grid max-w-[var(--measure-wide)] gap-10 px-6 py-14 sm:grid-cols-[2fr_1fr_1fr_1fr]">
        <div className="max-w-sm">
          <Link href="/" className="text-ink inline-flex items-center gap-2.5">
            <SeshatMark size={20} className="text-gold" />
            <span className="font-heading text-[1rem] font-semibold tracking-tight">
              Seshat
            </span>
          </Link>
          <p className="text-ink-muted mt-4 text-[0.9rem] leading-[1.65]">
            <em>Seshat</em> — Egyptian goddess of writing, scribes, and
            libraries. <em>Mistress of the House of Books.</em> The name is
            the brief: this is a place where written things are kept and shown
            well.
          </p>
        </div>
        <FooterCol
          title="Product"
          links={[
            ["Reader", "#reader"],
            ["Share", "#share"],
            ["Download", "#download"],
          ]}
        />
        <FooterCol
          title="The thinking"
          links={[
            ["Philosophy", "#philosophy"],
            ["Use cases", "#"],
            ["Out of scope", "#"],
          ]}
        />
        <FooterCol
          title="Source"
          links={[
            ["GitHub", "https://github.com/keremcanseker", true],
            ["Issues", "https://github.com/keremcanseker", true],
            ["License (MIT)", "#"],
          ]}
        />
      </div>
      <div className="border-rule border-t">
        <div className="mx-auto flex max-w-[var(--measure-wide)] flex-col items-center justify-between gap-2 px-6 py-5 sm:flex-row">
          <p className="text-ink-faint font-mono text-[0.7rem] tracking-[0.18em] uppercase">
            © {new Date().getFullYear()} · Seshat · Built in macOS, for macOS
          </p>
          <p className="text-ink-faint flex items-center gap-2 text-[0.78rem]">
            <span>Reading room</span>
            <SeshatMark size={10} starOnly className="text-gold" />
            <span>not a dashboard</span>
          </p>
        </div>
      </div>
    </footer>
  );
}

function FooterCol({
  title,
  links,
}: {
  title: string;
  links: Array<[string, string] | [string, string, boolean]>;
}) {
  return (
    <div>
      <h4 className="seshat-section-label">{title}</h4>
      <ul className="mt-4 space-y-2.5">
        {links.map(([label, href, external]) => (
          <li key={label}>
            <a
              href={href}
              target={external ? "_blank" : undefined}
              rel={external ? "noreferrer" : undefined}
              className="text-ink-muted hover:text-ink seshat-link-underline text-[0.92rem]"
            >
              {label}
            </a>
          </li>
        ))}
      </ul>
    </div>
  );
}
