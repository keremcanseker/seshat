# Seshat

A native macOS app and CLI for reading and sharing markdown — built so long-form `.md` files actually feel good to read, and so any developer can publish one with a single terminal command.

> Seshat is the Egyptian goddess of writing, scribes, and libraries — *Mistress of the House of Books*. The name is the brief: this is a place where written things are kept and shown well.

---

## Why this project exists

Two frustrations triggered it:

**1. Reading long markdown on developer tools is unpleasant.** The VS Code markdown preview, GitHub's render, every dotfile-tier viewer — they're functional, but reading a 4,000-word agent output, a postmortem, a design doc, or a long README inside one of them feels like reading a config file. The container is austere and tiring. The content is often genuinely worth reading; the surface around it makes it feel like work.

**2. Sharing markdown is fiddly.** You generate something interesting on your own machine — Claude Code dumps a 3,000-line investigation, you write up an architecture proposal, you want a teammate to read your runbook — and now you're choosing between pasting into Slack (loses formatting), uploading to Notion (slow, heavyweight, captures it into someone's workspace), making a gist (fine, but it looks like a gist), or sending the raw file (now the recipient needs their own renderer). None of these feel right for "I just want to send you this thing to read."

Seshat is the answer to both: a calm, well-typeset reader that lives on your machine, plus a one-command path to put any local file on the web with the same look.

## The two product surfaces

### The reader (today)

A native macOS app that points at a managed library folder (`~/Seshat/`) and renders any `.md` inside it the way a thoughtful book does — generous, readable, scholarly. Open a single file in its own window from the CLI:

```
$ seshat open notes.md
```

…or open the workspace and browse a Finder-style sidebar of everything in your library. The window is for *reading*: minimal chrome, an outline you can glance at, typography that invites you to actually finish the page.

### The share layer (next, not yet built)

The eventual `seshat share` command. The intended flow is intentionally one step:

```
$ seshat share investigation.md
https://seshat.<domain>/<slug>
```

Anyone — developer or not — opens the link in a browser and sees the same document rendered with the same care. No login wall, no "create an account to view," no app install. The web renderer is a deliberate visual port of the desktop reader, so a document looks the same wherever it's read.

That's the loop the project is organized around: **write or generate markdown → read it well locally → share it as a link that reads just as well.**

## The philosophy

A few principles govern every decision, including visual and interaction design.

- **It's a library, not a dashboard.** The mental model is "scholarly reading room," not "productivity tool." Things should feel calm, considered, and quiet. Negative space is encouraged. Chrome is suspect.

- **The content is the product.** Anything that competes with the words on the page — heavy borders, colored callouts, sidebar trees that demand attention, badges, status pills — is wrong by default. The reader's eye should land on the prose first, every time.

- **Made for developers, but doesn't look like a dev tool.** The audience writes code and lives in a terminal. But the *output* is for reading, not editing or debugging. So the aesthetic borrows from books, journals, and long-form web essays — not from IDEs, terminals, or admin panels. No monospace-everywhere. No data-grid energy.

- **Opinionated, not configurable.** There are no theme pickers, no font sliders, no density toggles. The reading experience is one specific thing, chosen carefully, and applied consistently. A user who wants to fiddle with margins is not the user we are building for.

- **Inspired by Notion's structural clarity, but with its own identity.** Notion got a lot right about block-based reading layouts; we don't pretend otherwise. But Seshat is not a Notion clone. It should feel older, warmer, more rooted in writing tradition — a scribe's library, not a SaaS doc tool.

- **Sharing should feel like handing someone a pamphlet, not deploying a service.** One command, one link, one render. The web side should never feel like "an app you signed up for" — it should feel like a document someone handed you.

- **The CLI is a first-class surface.** The product's defining gesture is *typing a sentence in your terminal and getting a beautifully rendered document or shareable link in return*. The CLI is not a dev convenience layered on top of a GUI app — it's the primary entry point for the people the product is built for.

## Use cases that drive the design

These are the scenarios we explicitly want to feel great:

- A developer runs a long Claude Code session that produces a 3,000-line markdown report. They type `seshat open report.md` and a reader window opens with the report typeset like a chapter of a book. It's the first time their own AI output has felt like something worth reading rather than scrolling past.
- They like it enough to send a colleague: `seshat share report.md`. A link comes back. They paste it in Slack. The colleague clicks, reads it on their phone on the bus, and it still looks good.
- Someone is browsing their `~/Seshat/` library — a folder of personal notes, drafts, investigations, half-finished essays — and the sidebar feels like walking into a personal study, not opening a file picker.
- A team writes RFCs as markdown and the Seshat share link is the canonical place to *read* them. Discussions live elsewhere; the link is just for the document.

## What Seshat is *not*

To keep design and product decisions oriented, here's what's explicitly out of scope:

- **Not a note-taking PKM.** No backlinks, no graph view, no daily notes, no tags-as-databases. Obsidian and Logseq exist; this isn't trying to compete with them.
- **Not an editor (yet).** v0.1 is read-only. Editing comes later and will be careful about preserving source. There is no "Notion-style block editor" ambition.
- **Not a wiki.** Files are files; folders are folders. No namespaces, no graph, no mandatory linking structure. If you want a wiki, the filesystem is your wiki.
- **Not a collaboration tool.** Sharing is one-way: you publish, they read. No comments, no co-editing, no presence indicators. If a document needs discussion, that happens in Slack, GitHub, Linear — wherever the team already lives.
- **Not multi-platform first.** Native macOS app and a web reader. No iOS, Windows, or Linux app planned. Native feel on macOS was an explicit choice over cross-platform reach.
- **Not configurable.** No themes, no fonts, no layout options. One reading experience, executed well.

## Who this is for

A developer (or developer-adjacent — designer, technical writer, researcher) who:

- Writes or generates long-form markdown often, including AI-generated output.
- Cares enough about how text looks that current tools quietly annoy them.
- Wants sharing to be a `cmd+space → seshat share → paste link` reflex, not a workflow.
- Trusts taste over toggles — i.e., would rather use something opinionated than configure something flexible.

---

## Repository layout

This is a monorepo. Today only the macOS app and CLI shim exist; the server and web reader come later.

```
.
├── apps/
│   ├── macos/             # SwiftUI app — open in Xcode after running xcodegen
│   │   ├── project.yml    # source of truth; regenerates Seshat.xcodeproj
│   │   └── Seshat/        # Swift sources, assets, Info.plist
│   └── web/               # FUTURE — web reader for shared docs
├── server/                # FUTURE — share-link backend
├── cli/
│   └── seshat             # POSIX shell shim, bundled into Seshat.app
└── samples/               # markdown fixtures
```

## Development

Requires: macOS 14+, Xcode 16+, [xcodegen](https://github.com/yonaskolb/XcodeGen).

```sh
brew install xcodegen
cd apps/macos && xcodegen generate
open Seshat.xcodeproj
```

The `.xcodeproj` is gitignored — regenerate from `project.yml` whenever sources or build config change.

For deeper architectural and convention notes, see [CLAUDE.md](CLAUDE.md).
