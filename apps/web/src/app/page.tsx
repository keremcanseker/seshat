import { BookOpen, Library, Link2, ListTree, SunMoon, Terminal } from "lucide-react";
import { DownloadButton } from "@/components/download-button";
import { Faq, type FaqItem } from "@/components/landing/faq";
import { AppleGlyph, HeroDesktop, type LibraryGroup } from "@/components/landing/hero-desktop";
import { SeshatDoc } from "@/components/seshat-doc";
import { SeshatMark } from "@/components/seshat-mark";
import { extractOutline } from "@/lib/extract-outline";

// Our own server is the single source of truth for the latest build (repo is
// private): /download logs the click and 302s to the current DMG.
const API_BASE =
  process.env.NEXT_PUBLIC_SESHAT_API ?? "https://api.seshat.page";
const DOWNLOAD_URL = `${API_BASE}/download`;

export default function Home() {
  return (
    <main className="landing text-ink">
      <HeroDesktop downloadHref={DOWNLOAD_URL} library={LIBRARY} initialId="Inbox/start-here" />
      <div className="mx-auto max-w-[1200px] px-6">
        <About />
        <LibraryCard />
        <SharePromo />
        <Questions />
      </div>
      <Closure />
    </main>
  );
}

/* ── The mock library ──────────────────────────────────────────────── */

// Every file in the hero sidebar is a real document. They are rendered here,
// on the server, and handed to the desktop already typeset.
type Shelf = {
  name: string;
  files: { name: string; age: string; unread?: boolean; md: string }[];
};

const SHELVES: Shelf[] = [
  {
    name: "Inbox",
    files: [
      {
        // The document the desktop opens on. It is the hero copy: what
        // Seshat is, read inside Seshat.
        name: "start-here",
        age: "now",
        unread: true,
        md: `# A reading room for markdown

Seshat is a native macOS reader for the markdown you write, generate, and share. Open a file and it reads like a page, not like source: serif headings, a calm measure, room in the margins.

> Reading is the work. The renderer should disappear.

## What it does

- **Reads.** One file per window. An outline drifts in the margin; click a heading to jump.
- **Keeps a library.** \`~/Seshat/\` is plain files in a folder. Subfolders are shelves. Nothing to import, nothing to sync.
- **Opens from the terminal.** One word, from any folder.
- **Shares by link.** Click Share and the page is public, set in the same type, on any device.
- **Paper by day, ink by night.** Light by default, because Seshat is paper.

\`\`\`sh
$ seshat open report.md
$ seshat share notes.md
https://seshat.page/d/atrium-7c1a · copied
\`\`\`

## What it is not

| Not a | Because |
| --- | --- |
| Editor | The reader stays the reader. ⌘E edits a block in place when you must. |
| Wiki | No links between notes, no graph. Files in folders. |
| Sync service | Your folder, your files. Put it in iCloud if you like. |

## Free, macOS 14 or later

Download the app, run \`seshat install\`, and open any file. Everything in this window is real: the sidebar, the outline, Night, Share. Try them.
`,
      },
      {
        name: "claude-session-report",
        age: "2h ago",
        unread: true,
        md: `# Session report: share links

*Claude Code · 41 tool calls · 2h ago*

## What changed

- \`DocumentWriter\` re-reads the file before publishing, so an external edit is never shared stale.
- The share toast shows the copied URL for 2.6 seconds, then fades.
- Removed the 60 second cache on shared docs. Readers always get the latest.

## Open questions

- [x] Should \`seshat share\` print the URL to stdout as well? Yes, done.
- [ ] Rate-limit publishes per device?
- [ ] Expire links after 30 days by default?

## Verification

\`\`\`sh
$ seshat share samples/stress.md
https://seshat.page/d/atrium-7c1a · copied
\`\`\`

> Nothing in this session touched the renderer. Typography is unchanged.
`,
      },
      {
        name: "typography",
        age: "1w ago",
        unread: true,
        md: `# Typography for Long Documents

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
`,
      },
      {
        name: "reading-list",
        age: "2w ago",
        unread: true,
        md: `# Reading list

Things worth an hour, kept where I will actually see them.

## Typography

- *The Elements of Typographic Style*, Bringhurst. The chapter on measure alone justifies the price.
- Butterick, *Practical Typography*. Free, opinionated, right.
- Matthew Carter on Georgia and the screen.

## Reading tools

| Tool | What it gets right | What it gets wrong |
| --- | --- | --- |
| iA Writer | Focus mode | Everything is an editor |
| Bear | Tags | Lock-in |
| Marked 2 | Preview | Looks like 2012 |

## Egypt

- Seshat, "she who scrivens": the seven-pointed star, the leopard skin, the notched palm rib.
- The House of Life at Abydos.
`,
      },
    ],
  },
  {
    name: "Product",
    files: [
      {
        name: "RFC-014-share-links",
        age: "20h ago",
        unread: true,
        md: `# RFC 014: Share links

| Status | Owner | Target |
| --- | --- | --- |
| Accepted | Kerem | 0.4 |

## Summary

A document in the reader gets a **Share** button. One click publishes the markdown to the server and copies a public URL. The page renders with the same theme as the app.

## Non-goals

1. Editing on the web.
2. Comments, reactions, presence.
3. Accounts for readers. The link is the permission.

## Design

- \`POST /docs\` with the raw markdown and a title. Returns a slug.
- Slugs are two words and four hex chars: \`atrium-7c1a\`.
- Re-sharing the same file updates the same slug.

> A link should feel like handing someone a printed page, not inviting them into a workspace.

## Risks

- Abuse: rate limit per device, 20 publishes an hour.
- Secrets in notes: warn on the first share, never scan content.
`,
      },
      {
        name: "api-design-review",
        age: "2d ago",
        md: `# API design review

Notes from Tuesday. Two endpoints, one opinion.

## Publish

\`\`\`http
POST /docs
Content-Type: application/json

{ "title": "typography", "content": "# Typography..." }
\`\`\`

Returns \`201\` with the slug and the full URL.

## Read

\`\`\`http
GET /docs/atrium-7c1a
\`\`\`

## Decisions

| Question | Answer |
| --- | --- |
| Auth on publish | Device token, minted on first run |
| Auth on read | None |
| Max size | 2 MB of markdown |
| Storage | Bucket for source, Postgres for metadata |

- Keep the JSON flat. No envelopes.
- Errors are \`{ "error": "message" }\` and nothing else.
`,
      },
      {
        name: "Q3-PLANNING-DRAFT",
        age: "1w ago",
        unread: true,
        md: `# Q3 planning, draft

Three things. If a fourth appears, one of these goes.

## Ship

- [x] Editing mode, minimal in-place block toggle
- [x] Share links with conflict detection
- [ ] A landing page that shows the app instead of describing it
- [ ] Notarized releases from the pre-push hook

## Decide

- [ ] Pricing: free reader, paid share?
- [ ] Custom bullet glyphs: seven-pointed star, or keep the diamonds

## Ignore, on purpose

- Search across the library
- Tags and frontmatter
- Windows

> The reader stays the editor. No split view, no second pane.
`,
      },
      {
        name: "release-notes-0.4",
        age: "3w ago",
        unread: true,
        md: `# Seshat 0.4

*Universal · 18 MB · macOS 14+*

## New

- **Share.** Click the share icon or run \`seshat share file.md\` to get a public link.
- **Edit in place.** ⌘E turns the section you click into its source. ⌘S saves.
- **Conflict detection.** If the file changed on disk while you edited, Seshat asks before overwriting.

## Improved

- Outline entries now track the heading in view.
- Code blocks extend past the prose measure.
- Tables lost their vertical rules.

## Fixed

- The empty placeholder window no longer survives a cold \`seshat open\`.
- Dark mode no longer flashes paper on launch.

## Known

- \`seshat install\` still defaults to \`/usr/local/bin\`. Use \`~/.local/bin\`.
`,
      },
    ],
  },
  {
    name: "Engineering",
    files: [
      {
        name: "ARCHITECTURE_OVERVIEW",
        age: "3w ago",
        md: `# Architecture overview

One repo, three surfaces, no shared code between them.

\`\`\`
seshat/
├── apps/macos/     SwiftUI reader + CLI shim
├── apps/server/    Bun + Hono, Postgres, a bucket
├── apps/web/       Next.js, renders shared docs
└── cli/seshat      POSIX shell, bundled into the .app
\`\`\`

## The reader

- \`MarkdownParser\` splits a file into sections anchored at headings.
- Each section renders as its own view, so the outline can scroll to a heading precisely.
- \`Library\` watches \`~/Seshat/\` with FSEvents and refreshes the sidebar.

## The share layer

1. The app posts markdown to the server.
2. The server stores source in the bucket and metadata in Postgres.
3. The web app fetches by slug and renders with the same theme tokens, ported by hand.

> Ports, not packages. The Swift theme and the CSS theme are siblings that happen to agree.
`,
      },
      {
        name: "incident-postmortem-08-24",
        age: "4d ago",
        unread: true,
        md: `# Postmortem: shared docs served stale

*Severity 3 · 24 Aug · 40 minutes*

## What happened

Shared documents kept showing the previous version for up to a minute after a re-share. Nobody lost data. Two people thought Share was broken.

## Timeline

| Time | Event |
| --- | --- |
| 14:02 | Re-share of an edited doc, link opens old content |
| 14:09 | Reproduced locally |
| 14:31 | Cause found: 60 second revalidate on the fetch |
| 14:42 | Fix deployed, \`cache: "no-store"\` |

## Cause

The web app fetched documents with a 60 second revalidation window. Correct for a blog, wrong for a link you just copied.

## Actions

- [x] Fetch shared docs with no cache.
- [ ] Show the published timestamp on the page.
- [ ] Add a smoke test that shares, edits, re-shares, and reads.
`,
      },
      {
        name: "migration-runbook",
        age: "1w ago",
        md: `# Migration runbook

For moving the server to a new box. Twenty minutes if nothing surprises you.

## Before

1. Announce a ten minute window. Shares fail closed, reads keep working.
2. Snapshot Postgres.

\`\`\`sh
pg_dump "$DATABASE_URL" > seshat-$(date +%F).sql
\`\`\`

## During

1. Point the bucket credentials at the new host.
2. Restore the snapshot.
3. Deploy with the same env, then flip DNS.

\`\`\`sh
psql "$NEW_DATABASE_URL" < seshat-$(date +%F).sql
\`\`\`

## After

- [ ] Share a doc from the app, open the link.
- [ ] Check the Sparkle feed still resolves.
- [ ] Delete the old box after a week, not a day.
`,
      },
    ],
  },
  {
    name: "Personal",
    files: [
      {
        name: "conference-talk-outline",
        age: "2mo ago",
        md: `# Talk: reading is the work

Twenty minutes, no slides with bullet points, which is funny given this file.

## Opening

- Show a 4,000 line markdown file in a code editor. Let it sit.
- Show the same file in a reader. Say nothing for ten seconds.

## The argument

1. Markdown won because it is plain text.
2. Plain text tools were built for code, not prose.
3. Nobody reads a long document in a 13 pixel monospace tree view. They skim it and pretend.

## What a reader owes you

- A measure. Sixty to seventy characters.
- A serif for headings, because structure should look different from body.
- Margins that do the work of separators.

## Close

> The renderer should disappear.

Then the link. One command, one page.
`,
      },
      {
        name: "half-finished-essay",
        age: "3mo ago",
        md: `# On margins

*Unfinished, and likely to stay that way.*

A margin is the part of the page that says nothing. It is also the part that decides whether you can read the rest. Wide margins are not luxury. They are the reader's share of the paper.

Software mostly forgot this. Screens were expensive, so interfaces filled them. Then screens got cheap and the habit stayed. Every panel earned its place by being useful, and none of them earned it by being quiet.

## What a scribe knew

The scribes at the House of Life left space. Not because papyrus was cheap, it was not, but because a column of glyphs with no room around it cannot be read aloud.

> Seshat measured the temple before the first stone. The margin came before the wall.

## Where this is going

I do not know yet. Somewhere about the difference between a tool that helps you write and a room that lets you read.
`,
      },
    ],
  },
];

const LIBRARY: LibraryGroup[] = SHELVES.map((shelf) => ({
  name: shelf.name,
  files: shelf.files.map((f) => ({
    id: `${shelf.name}/${f.name}`,
    name: f.name,
    age: f.age,
    unread: f.unread,
    outline: extractOutline(f.md),
    doc: <SeshatDoc content={f.md} />,
  })),
}));

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
    <section id="about" className="mt-[100px]">
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

/* ── Questions ─────────────────────────────────────────────────────── */

const FAQ: FaqItem[] = [
  {
    q: "Where do my files live?",
    a: "In ~/Seshat/, as plain markdown on disk. Top-level folders are shelves in the sidebar. Put the folder in Git, sync it, open it in any editor. Nothing is imported or converted.",
  },
  {
    q: "Do I have to move files into the library?",
    a: "No. seshat open report.md reads a file from anywhere and opens it in its own window. The library is for the documents you want in the sidebar.",
  },
  {
    q: "Is it an editor?",
    a: "A reader first. Press ⌘E and the section you click turns into its source; ⌘S writes it back to the file. No split view, no second pane, the page keeps its layout.",
  },
  {
    q: "What happens when I click Share?",
    a: "Seshat publishes the markdown and copies a link. The page renders with the same type on any device, and the reader needs no account. Sharing the same file again updates the same link.",
  },
  {
    q: "What does the CLI do?",
    a: "seshat open file.md opens a reader window, seshat global file.md selects it in the workspace, and seshat share file.md publishes it. Install the shim once with seshat install ~/.local/bin/seshat.",
  },
  {
    q: "What if the file changes on disk while I am editing?",
    a: "Seshat compares the file before saving. If something else wrote to it, you choose: keep your version, reload from disk, or cancel. It never overwrites silently.",
  },
  {
    q: "Does it render math or Mermaid diagrams?",
    a: "Not yet. Both are on the list. The native renderer has no web view today, and adding one only for those blocks is a decision still being made.",
  },
  {
    q: "Is there a Windows or Linux version?",
    a: "No. Seshat is a native macOS app built around macOS type. Shared links open in any browser, on any system.",
  },
  {
    q: "Why the name?",
    a: "Seshat is the Egyptian goddess of writing, scribes, and libraries, the Mistress of the House of Books. A reading room for text felt like her kind of room.",
  },
];

function Questions() {
  return (
    <section id="faq" className="faq-band">
      <h2 className="faq-title">Questions, before you begin.</h2>
      <Faq items={FAQ} />
    </section>
  );
}

/* ── Closing call + footer ─────────────────────────────────────────── */

function Closure() {
  return (
    <div className="closure">
      <section className="close" aria-labelledby="close-h">
        <h2 id="close-h" className="close-line">
          Give your markdown a reading room.
        </h2>
        <p className="close-lede">
          Free on macOS. Open any file, keep a library in a folder, and hand a
          page on with one link.
        </p>
        <DownloadButton
          href={DOWNLOAD_URL}
          className="close-cta btn-ink inline-flex h-10 items-center gap-2 rounded-full px-5 text-[14px] font-medium no-underline"
        >
          <AppleGlyph />
          Download for macOS
        </DownloadButton>
        <p className="close-fine">No account. Nothing to import. macOS 14 or later.</p>
      </section>

      <footer className="foot">
        <div className="foot-in">
          <div className="foot-id">
            <a className="foot-brand" href="/" aria-label="Seshat home">
              <SeshatMark size={22} strokeWidth={1.4} />
            </a>
            <p className="foot-name">Seshat</p>
            <p className="foot-by">
              Made by <a href="https://github.com/keremcanseker">Kerem</a> · © 2026
            </p>
          </div>
          <div className="foot-cols">
            <div className="foot-col">
              <p className="foot-h">Seshat</p>
              <a href="#about">What it is</a>
              <a href="#faq">Questions</a>
              <a href={DOWNLOAD_URL}>Download for macOS</a>
            </div>
            <div className="foot-col">
              <p className="foot-h">Share</p>
              <a href="/login">Sign in</a>
              <a href="/dashboard">Your pages</a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
