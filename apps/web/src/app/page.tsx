import { DownloadButton } from "@/components/download-button";
import { SeshatMark } from "@/components/seshat-mark";

const DOWNLOAD_URL = "/Seshat.dmg";

export default function Home() {
  return (
    <main className="bg-paper text-ink min-h-screen">
      <Hero />
      <Why />
      <TwoSurfaces />
      <How />
      <InPractice />
      <TOC />
      <Philosophy />
      <Footer />
    </main>
  );
}

function Lockup() {
  return (
    <div className="flex items-center gap-2.5">
      <SeshatMark size={20} className="text-ink" strokeWidth={1.4} />
      <span className="font-heading text-ink text-[17px] font-semibold tracking-[-0.005em]">
        Seshat
      </span>
    </div>
  );
}

/* ── Hero ──────────────────────────────────────────────────────────── */

function Hero() {
  return (
    <section className="border-rule relative border-b-[0.5px] px-20 pt-[120px] pb-[100px]">
      <nav className="absolute top-8 right-20 left-20 flex items-center justify-between font-sans">
        <Lockup />
        <div className="text-ink-muted flex gap-7 text-[14px]">
          <a href="#what" className="hover:text-ink transition-colors">
            Reader
          </a>
          <a href="#how" className="hover:text-ink transition-colors">
            CLI
          </a>
          <a href="#how" className="hover:text-ink transition-colors">
            Share
          </a>
          <a href="#philosophy" className="hover:text-ink transition-colors">
            Notes
          </a>
        </div>
      </nav>

      <div className="font-sans mx-auto max-w-[760px] text-center">
        <p className="text-ink-muted font-heading mb-7 text-[18px] italic">
          A reading room for markdown.
        </p>
        <h1 className="font-heading text-ink m-0 text-balance text-[76px] leading-[1.05] font-bold tracking-[-0.018em]">
          Long markdown,
          <br />
          finally readable.
        </h1>
        <p className="text-ink-muted mx-auto mt-7 mb-9 max-w-[560px] text-[19px] leading-[1.55]">
          A native macOS reader and CLI for the markdown you write, generate,
          and share — set in book-quality typography, on a 720pt measure, in
          its own window.
        </p>
        <div className="flex items-center justify-center gap-3.5">
          <DownloadButton
            href={DOWNLOAD_URL}
            className="bg-ink text-paper inline-flex items-center gap-2.5 rounded-md px-[22px] py-3.5 text-[15px] font-medium no-underline"
          >
            <AppleGlyph />
            Download for macOS
          </DownloadButton>
          <a
            href="#how"
            className="text-ink inline-flex items-center gap-2 px-[18px] py-3.5 text-[15px] no-underline"
          >
            See how it reads
            <ArrowRight />
          </a>
        </div>
        <p className="text-ink-faint mt-9 font-mono text-[12px]">
          macOS 14+ · Universal · 18 MB · also:{" "}
          <span className="text-ink-muted">brew install seshat</span>
        </p>
      </div>
    </section>
  );
}

function AppleGlyph() {
  return (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" aria-hidden>
      <path d="M17.5 12.5c0-2.4 2-3.6 2.1-3.6-1.2-1.7-3-1.9-3.6-2-1.5-.2-3 .9-3.7.9-.8 0-2-.9-3.3-.9-1.7 0-3.3 1-4.2 2.6-1.8 3.1-.5 7.7 1.3 10.2.9 1.2 1.9 2.6 3.2 2.5 1.3-.1 1.8-.8 3.3-.8 1.6 0 2 .8 3.4.8 1.4 0 2.3-1.2 3.1-2.5.6-.8 1.1-1.7 1.4-2.6-2.5-.9-2.9-4-3-4.6zM14.7 5.4c.7-.8 1.2-2 1-3.2-1.1.1-2.4.8-3 1.5-.6.7-1.2 1.8-1 3 1.2.1 2.4-.6 3-1.3z" />
    </svg>
  );
}

function ArrowRight() {
  return (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" aria-hidden>
      <path d="M5 12h14M13 6l6 6-6 6" />
    </svg>
  );
}

/* ── Why ───────────────────────────────────────────────────────────── */

function Why() {
  return (
    <section className="border-rule border-b-[0.5px] px-20 py-[100px] font-sans">
      <div className="mx-auto grid max-w-[920px] grid-cols-[180px_1fr] gap-20">
        <div className="text-ink-faint pt-1.5 font-mono text-[11px] tracking-[0.1em] uppercase">
          02 · Why Seshat
        </div>
        <div>
          <h2 className="font-heading text-ink m-0 mb-8 text-balance text-[40px] leading-[1.18] font-bold tracking-[-0.01em]">
            Two things were broken about long markdown.
          </h2>
          <div className="text-ink-muted grid gap-7 text-[17px] leading-[1.65]">
            <p className="m-0">
              <span className="text-ink font-semibold">One.</span> Reading it
              inside a developer tool is exhausting. 13-pixel sans-serif inside
              a tree view, between a sidebar of files and a panel of metadata,
              was never a reading layout.
            </p>
            <p className="m-0">
              <span className="text-ink font-semibold">Two.</span> Sharing it
              is fiddly. You don&rsquo;t want to deploy a service, paste it
              into Notion, or convert to PDF for someone to read three
              paragraphs of an RFC.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}

/* ── Two surfaces ──────────────────────────────────────────────────── */

function TwoSurfaces() {
  return (
    <section
      id="surfaces"
      className="border-rule border-b-[0.5px] px-20 py-[100px] font-sans"
    >
      <div className="mx-auto grid max-w-[1100px] grid-cols-[180px_1fr] gap-20">
        <div className="text-ink-faint pt-1.5 font-mono text-[11px] tracking-[0.1em] uppercase">
          03 · Two surfaces
        </div>
        <div>
          <h2 className="font-heading text-ink m-0 mb-4 text-balance text-[40px] leading-[1.18] font-bold tracking-[-0.01em]">
            A reader for you, a link for everyone else.
          </h2>
          <p className="text-ink-muted m-0 mb-10 max-w-[560px] text-[17px] leading-[1.65]">
            One product, two surfaces. The desktop reader and the share link
            are the same document, rendered with the same care.
          </p>
          <div className="grid grid-cols-1 gap-8 sm:grid-cols-2">
            <SurfaceCard
              numeral="i."
              when="today"
              title="The reader"
              body="A native macOS app pointed at a managed library at ~/Seshat/. Open any file in its own window, browse a Finder-style sidebar, glance at the outline. Minimal chrome, generous typography, scholarly calm."
              command="seshat open notes.md"
              output="→ window opens, typeset like a chapter"
            />
            <SurfaceCard
              numeral="ii."
              when="next"
              title="The share layer"
              body={
                <>
                  <code className="font-mono">seshat share</code> takes a local
                  <code className="font-mono">.md</code> and gives back a
                  public URL. The recipient opens the link in any browser and
                  sees the same document, rendered with the same theme. No
                  login wall. No app install.
                </>
              }
              command="seshat share investigation.md"
              output="https://seshat.app/d/atrium-7c1a"
            />
          </div>
        </div>
      </div>
    </section>
  );
}

function SurfaceCard({
  numeral,
  when,
  title,
  body,
  command,
  output,
}: {
  numeral: string;
  when: string;
  title: string;
  body: React.ReactNode;
  command: string;
  output: string;
}) {
  return (
    <div className="border-rule grid gap-5 border-[0.5px] p-7">
      <div className="flex items-baseline justify-between">
        <span className="font-heading text-gold text-[14px] italic">
          {numeral}
        </span>
        <span className="text-ink-faint font-mono text-[10px] tracking-[0.12em] uppercase">
          {when}
        </span>
      </div>
      <h3 className="font-heading text-ink m-0 text-[22px] font-semibold leading-[1.2]">
        {title}
      </h3>
      <p className="text-ink-muted m-0 text-[15px] leading-[1.65]">{body}</p>
      <pre className="border-rule bg-paper-subtle text-ink mt-auto m-0 rounded-md border-[0.5px] px-[14px] py-3 font-mono text-[13px] leading-[1.55]">
        <div>
          <span className="text-gold">$</span> {command}
        </div>
        <div className="text-ink-muted">{output}</div>
      </pre>
    </div>
  );
}

/* ── How ───────────────────────────────────────────────────────────── */

const commands: Array<{ cmd: string; desc: React.ReactNode }> = [
  {
    cmd: "seshat open report.md",
    desc: "Opens any markdown file in its own reader window — 720pt measure, book-grade type, no editor chrome.",
  },
  {
    cmd: "cd ~/Seshat",
    desc: "A managed library folder. Drop files in, browse them in a Finder-style sidebar, every file gets its own window.",
  },
  {
    cmd: "seshat share file.md",
    desc: (
      <>
        Coming soon. Publishes a local file to a one-link web reader.{" "}
        <em>No Notion. No service. Just a link.</em>
      </>
    ),
  },
  {
    cmd: "seshat list",
    desc: "See your library at a glance — recent reads, last-modified, words, time-to-read.",
  },
];

function How() {
  return (
    <section
      id="how"
      className="border-rule border-b-[0.5px] px-20 py-[100px] font-sans"
    >
      <div className="mx-auto grid max-w-[1100px] grid-cols-[180px_1fr] gap-20">
        <div className="text-ink-faint pt-1.5 font-mono text-[11px] tracking-[0.1em] uppercase">
          04 · How it works
        </div>
        <div>
          <h2 className="font-heading text-ink m-0 mb-10 text-balance text-[40px] leading-[1.18] font-bold">
            Three commands. The rest is reading.
          </h2>
          <div className="grid grid-cols-1 gap-8 sm:grid-cols-2">
            {commands.map((c) => (
              <div key={c.cmd} className="grid gap-3.5">
                <pre className="border-rule bg-paper-subtle text-ink m-0 rounded-md border-[0.5px] px-[18px] py-3.5 font-mono text-[14px]">
                  <span className="text-gold">$</span> {c.cmd}
                </pre>
                <p className="text-ink-muted m-0 text-[15px] leading-[1.6]">
                  {c.desc}
                </p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

/* ── In Practice ───────────────────────────────────────────────────── */

const scenarios: Array<{ headline: string; body: string }> = [
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

function InPractice() {
  return (
    <section
      id="practice"
      className="border-rule border-b-[0.5px] px-20 py-[100px] font-sans"
    >
      <div className="mx-auto grid max-w-[1100px] grid-cols-[180px_1fr] gap-20">
        <div className="text-ink-faint pt-1.5 font-mono text-[11px] tracking-[0.1em] uppercase">
          05 · In practice
        </div>
        <div>
          <h2 className="font-heading text-ink m-0 mb-10 text-balance text-[40px] leading-[1.18] font-bold tracking-[-0.01em]">
            Scenarios this is built around.
          </h2>
          <div className="grid gap-10">
            {scenarios.map((s, i) => (
              <article
                key={s.headline}
                className="border-rule grid gap-4 border-t-[0.5px] pt-7 sm:grid-cols-[64px_1fr] sm:gap-8"
              >
                <div className="font-heading text-gold text-[28px] leading-none italic tabular-nums">
                  {String(i + 1).padStart(2, "0")}
                </div>
                <div>
                  <h3 className="font-heading text-ink m-0 max-w-[34rem] text-balance text-[22px] font-semibold leading-[1.25]">
                    {s.headline}
                  </h3>
                  <p className="text-ink-muted mt-3 mb-0 max-w-[40rem] text-[15px] leading-[1.65]">
                    {s.body}
                  </p>
                </div>
              </article>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

/* ── TOC ───────────────────────────────────────────────────────────── */

const rows: Array<{ num: string; left: string; right: string }> = [
  { num: "I", left: "A reader, not an editor.", right: "No cursor, no toolbar, no margin notes." },
  { num: "II", left: "Opinionated typography.", right: "New York for headings, SF for body, SF Mono for code. Locked." },
  { num: "III", left: "One file, one window.", right: "Like documents in TextEdit. State per file." },
  { num: "IV", left: "A managed library.", right: "~/Seshat — your folder, your files, our sidebar." },
  { num: "V", left: "Floating outline.", right: "Background-less panel. Headings only." },
  { num: "VI", left: "Light, by default.", right: "Because Seshat is paper. Dark mode is there." },
  { num: "VII", left: "Built for AI output.", right: "Long agent transcripts, RFCs, postmortems, drafts." },
  { num: "VIII", left: "Soon — share by link.", right: "One terminal command. One URL. They just open it." },
];

function TOC() {
  return (
    <section
      id="what"
      className="border-rule bg-paper-subtle border-b-[0.5px] px-20 py-[100px] font-sans"
    >
      <div className="mx-auto max-w-[920px]">
        <div className="mb-10 flex items-baseline gap-7">
          <div className="text-ink-faint font-mono text-[11px] tracking-[0.1em] uppercase">
            06 · Reading, not editing
          </div>
          <h2 className="font-heading text-ink m-0 text-[40px] font-bold tracking-[-0.01em]">
            What Seshat is, what it isn&rsquo;t.
          </h2>
        </div>
        <div>
          {rows.map((r) => (
            <div
              key={r.num}
              className="border-rule-strong grid grid-cols-[64px_1fr_1fr] items-baseline gap-6 border-t-[0.5px] py-5"
            >
              <span className="font-heading text-gold text-[18px] italic">
                {r.num}.
              </span>
              <span className="font-heading text-ink text-[22px] font-semibold">
                {r.left}
              </span>
              <span className="text-ink-muted text-[15px]">{r.right}</span>
            </div>
          ))}
          <div className="border-rule-strong border-t-[0.5px]" />
        </div>
      </div>
    </section>
  );
}

/* ── Philosophy ────────────────────────────────────────────────────── */

function Philosophy() {
  return (
    <section
      id="philosophy"
      className="border-rule border-b-[0.5px] px-20 py-[120px] font-sans"
    >
      <div className="mx-auto max-w-[720px] text-left">
        <div className="text-ink-faint mb-7 font-mono text-[11px] tracking-[0.1em] uppercase">
          07 · Philosophy
        </div>
        <p className="font-heading text-ink m-0 text-[32px] leading-[1.4] font-normal tracking-[-0.005em]">
          Seshat is for developers, but it isn&rsquo;t a dev tool. It does one
          thing — render long markdown legibly — and it has opinions about how.
          You don&rsquo;t pick the font. You don&rsquo;t pick the measure. You
          don&rsquo;t pick the theme. You drop a file in and read it.
        </p>
        <p className="font-heading text-ink-muted mt-8 mb-0 text-[18px] italic">
          Hand someone a pamphlet, not deploy a service.
        </p>
      </div>
    </section>
  );
}

/* ── Footer ────────────────────────────────────────────────────────── */

function Footer() {
  return (
    <footer className="text-ink-faint flex items-center justify-between px-20 py-10 font-sans text-[12px]">
      <div className="flex items-center gap-3.5">
        <SeshatMark size={18} strokeWidth={1.6} className="text-ink-faint" />
        <span>Seshat — Mistress of the House of Books</span>
      </div>
      <div className="flex gap-6">
        <a href="#" className="hover:text-ink-muted transition-colors">
          changelog
        </a>
        <a href="#" className="hover:text-ink-muted transition-colors">
          privacy
        </a>
        <span>© 2026</span>
      </div>
    </footer>
  );
}
