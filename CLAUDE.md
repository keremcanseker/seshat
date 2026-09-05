# Seshat

Native macOS markdown reader with a CLI. Renders `.md` files with calm, Notion-grade typography and provides a Finder-style sidebar over a managed library at `~/Seshat/`. Future direction is a self-hostable backend + web frontend so docs can be shared with the same look.

> **Name origin:** Seshat is the Egyptian goddess of writing, scribes, and libraries — "Mistress of the House of Books." Pick names that fit this vibe; avoid generic "MD" / "Markdown" branding. Placeholder name was `MDPump`; do not let that leak back in.

> **Vision and philosophy live in [README.md](README.md).** Read it before doing any design, copy, or product-shaped work — it explains *why* this project exists (long markdown is unpleasant to read in dev tools; sharing it is fiddly), the two product surfaces (local reader today, `seshat share` link layer next), the scholarly-library philosophy, and what Seshat explicitly is *not* (not a PKM, not an editor yet, not a wiki, not configurable). When briefing a design agent, hand them README.md as the brief; this file is the engineering companion.

---

## Repository layout

This is a **monorepo from day one**, even though only the macOS app exists today.

```
md-share/                      # repo root (folder name is a leftover placeholder; do not rename casually — it leaks into many configs)
├── apps/
│   ├── macos/                 # Xcode project lives here
│   │   ├── project.yml        # xcodegen source-of-truth — edit this, never the .pbxproj
│   │   ├── Seshat.xcodeproj   # generated, gitignored
│   │   └── Seshat/            # all Swift sources, assets, Info.plist, entitlements
│   ├── server/                # Bun + Hono share API, deployed via Coolify (Supabase Postgres)
│   └── web/                   # FUTURE — separate React/Next app, no code reuse with macOS
├── cli/
│   └── seshat                 # POSIX shell shim, bundled into Seshat.app/Contents/Resources/seshat
├── samples/                   # markdown fixtures used during dev (e.g. stress.md)
└── README.md
```

The macOS app source tree under `apps/macos/Seshat/`:

```
Seshat/
├── SeshatApp.swift            # @main, scene composition, NSApplicationDelegateAdaptor
├── Scenes/
│   ├── ReaderScene.swift      # WindowGroup(for: URL.self) — per-file reader windows
│   └── WorkspaceScene.swift   # singleton Window(id: "workspace")
├── Views/
│   ├── MarkdownReader.swift   # ScrollView + Markdown(...) + outline overlay
│   ├── MarkdownOutline.swift  # right-side floating TOC (no background, hover-only feedback)
│   ├── OutlineEntryRow.swift
│   ├── Sidebar.swift          # NavigationSplitView sidebar — folders & files
│   ├── WorkspaceRoot.swift    # NavigationSplitView wrapper for the workspace
│   └── WindowAccessor.swift   # NSViewRepresentable bridge to NSWindow
├── Models/
│   ├── Library.swift          # @Observable @MainActor — scans ~/Seshat/, watches via FSEvents
│   ├── LibraryFolder.swift
│   ├── LibraryFile.swift
│   ├── MarkdownParser.swift   # ATX heading parser, splits doc into anchored sections
│   ├── ParsedMarkdown.swift
│   ├── MarkdownSection.swift
│   └── OutlineEntry.swift
├── Services/
│   ├── AppRouter.swift        # @Observable @MainActor — URL → action dispatch, window registry
│   ├── SeshatAppDelegate.swift # @MainActor NSApplicationDelegate — bridges open URLs to AppRouter
│   ├── SeshatURL.swift        # parses seshat:// and file:// URLs into actions
│   └── LibraryWatcher.swift   # FSEventStream wrapper, callbacks back to MainActor
└── Theme/
    ├── SeshatTheme.swift      # MarkdownUI Theme — serif headings + sans body + warm code blocks
    └── SeshatColors.swift     # paper/heading/body/code/rule palette w/ light+dark dynamic colors
```

**Naming convention:** one type per file (struct/class/enum). The `swiftui-pro` skill enforces this; a file with two top-level types is a smell. Nested private types inside a single conceptual unit (e.g. `WindowAccessor.Reporter`) are fine.

---

## Tech stack — locked decisions

| | |
|---|---|
| Stack | **Native SwiftUI** macOS app. User explicitly chose 100% native feel over cross-platform reuse. |
| Min target | **macOS 14 (Sonoma)** |
| Swift | 6.0 with `SWIFT_STRICT_CONCURRENCY: complete` |
| Markdown lib | [`swift-markdown-ui`](https://github.com/gonzalezreal/swift-markdown-ui) (MarkdownUI) — the **only** third-party dep |
| Project gen | xcodegen (`brew install xcodegen`) — `project.yml` is canonical |
| Library model | Managed folder at `~/Seshat/` — top-level subfolders are workspaces |
| URL scheme | `seshat://` (`open` and `global` hosts) |
| Bundle ID | `com.keremcan.seshat` |
| Code style | Modern SwiftUI per `.claude/skills/swiftui-pro/references/api.md` (e.g. `foregroundStyle()` not `foregroundColor()`, `clipShape(.rect(cornerRadius:))` not `cornerRadius()`, `.task(id:)` over `.onAppear` for async) |
| Sandbox | **Disabled** for MVP. Means we can `String(contentsOf:)` arbitrary file paths from URL handlers. Re-enable + add security-scoped bookmarks before App Store. |

### Skills that auto-load

A user-mandated rule says **always load relevant SwiftUI skill references before writing or editing Swift code** in this repo. Located at:

- `.claude/skills/swiftui-pro/references/` — `api.md`, `views.md`, `data.md`, `navigation.md`, `swift.md`, `hygiene.md`, `accessibility.md`, `design.md`, `performance.md`
- `.claude/skills/swiftui-expert-skill/references/` — `macos-scenes.md`, `macos-views.md`, `macos-window-styling.md`, `text-patterns.md`, `state-management.md`, `liquid-glass.md`, etc.

Pick the ones relevant to the work — don't load everything blind.

---

## Build, run, install

```sh
# regenerate Xcode project after editing project.yml or adding/removing files
cd apps/macos && xcodegen generate

# build (Debug)
xcodebuild -project Seshat.xcodeproj -scheme Seshat -configuration Debug \
  -destination 'platform=macOS' build 2>&1 | \
  grep -E "warning:|error:|BUILD SUCCEEDED|BUILD FAILED"

# launch the built app directly
open "$(find ~/Library/Developer/Xcode/DerivedData -name 'Seshat.app' -path '*/Debug/*' -type d | head -1)"

# install the CLI symlink from a built app (no sudo if target is ~/.local/bin)
"$(...)/Seshat.app/Contents/Resources/seshat" install ~/.local/bin/seshat
```

After install, the CLI works from any terminal: `seshat open file.md`, `seshat global file.md`, `seshat help`.

### Clean-state debug helper

```sh
pkill -x Seshat
rm -rf ~/Library/Saved\ Application\ State/com.keremcan.seshat.savedState
```

macOS window restoration aggressively re-opens windows on relaunch, masking bugs. Always clear saved state before testing window-lifecycle changes.

---

## Architecture mental model

**App entry → URL routing → window scenes**

1. `SeshatApp` declares two scenes. `@NSApplicationDelegateAdaptor` brings in `SeshatAppDelegate`, which holds the singleton `AppRouter`.
2. AppKit calls `application(_:open:)` for any URL the OS hands us (`seshat://` or `file://` from "Open With"). The delegate forwards to `AppRouter.handle(urls:)`.
3. `SeshatURL.action(for:)` parses the URL into `.openReader(URL)` or `.openWorkspace(URL?)`.
4. `AppRouter` calls `openWindow(value:)` (for reader) or `openWindow(id: "workspace")`. The `OpenWindowAction` is captured from a SwiftUI environment via `bind(openWindow:)` on first appearance — URLs received before that are queued in `pending`.
5. ReaderScene uses `WindowGroup(for: URL.self)` so each file gets its own window. Same-URL invocations are deduped explicitly by `AppRouter.liveReaderWindow(for:)` calling `makeKeyAndOrderFront` — we do **not** rely on SwiftUI's implicit dedup which has been unreliable in our setup.

**Library + sidebar**

- `Library` (Observable @MainActor) owns the `~/Seshat/` directory. On init it ensures the dir exists, scans top-level subfolders, and starts an `FSEventStream` watch.
- `LibraryWatcher` is a non-Sendable `@unchecked Sendable` wrapper around `FSEventStreamCreate`. The C callback uses `FSEventStreamSetDispatchQueue(.main)` so it runs on main thread; the Swift closure uses `MainActor.assumeIsolated` to call `Library.refresh()`.
- `WorkspaceRoot` composes `Sidebar` + `MarkdownReader` via `NavigationSplitView(.balanced)`.

**Markdown rendering**

- `MarkdownParser` walks the source line-by-line, tracks fenced code blocks, extracts ATX headings, and **splits the doc into sections each anchored at a heading**. Sections get slug IDs.
- `MarkdownReader` renders each section as a separate `Markdown(...)` view in a `VStack(spacing: 28)`. Each section view has `.id(section.id)` so `ScrollViewProxy.scrollTo(_:anchor:)` lands precisely on a heading.
- `SeshatTheme` extends `MarkdownUI.Theme`. Must be `@MainActor` because `Theme` isn't Sendable.
- Layout strategy: outer content area at 920pt, prose blocks (paragraph/heading/blockquote/listItem) clamped to 720pt left-aligned, code blocks unclamped so they extend wider — that's the "code blocks breathe" effect.

**Empty-window cleanup (currently buggy — see Known issues)**

- `WindowAccessor` is an `NSViewRepresentable` whose `Reporter: NSView` overrides `viewDidMoveToWindow()` to fire a callback with the resolved `NSWindow`.
- ReaderRoot uses it to call `AppRouter.registerReader(window:fileURL:)` whenever a window's value changes.
- `AppRouter.reconcileEmptyWindows` is event-driven: when a content window registers, close all empty siblings; when an empty window registers and content already exists, self-close.
- Gated by `hasHandledLaunchURL` so a Dock-launch (no URL) keeps the empty placeholder as a deliberate intro.

---

## Visual identity (locked)

> **"Notion-inspired structure but Seshat's own scholarly identity"** — confirmed direction.

| Element | Decision |
|---|---|
| Headings | System serif (New York) — H1 36pt bold, H2 26pt bold, H3 20pt semibold |
| Body | SF Pro Text 16pt, line-height ~1.65 |
| Code | SF Mono 14pt on warm gray background (`seshatCodeBg`) |
| Background | Warm off-white `seshatPaper` (`#FCFAF7`) — not stark white |
| Body color | Warm dark `seshatBodyText` (`#2A2522`) — not pure black |
| Accent | Warm gold for blockquote rule, list bullets, task-list checks |
| Tables | Horizontal-only borders at 0.5pt, alternating row backgrounds — no hard grid |
| Outline panel | No background card. Just floating muted text in top-right gutter, hover darkens to heading color |
| Bullets | `diamond.fill` (level 1, gold) → `diamond` (level 2) → `circle.fill` (level 3+, muted) — these are placeholders for eventual custom Egyptian-themed glyphs (Seshat's seven-pointed star is the canonical icon) |

Avoid: emoji callouts, colorful highlights, anything that screams "Notion clone."

---

## Future roadmap

The MVP is the macOS app + CLI. Three larger phases follow, in this order.

### Near-term polish (before declaring v0.1)

- [ ] Fix the empty-default-window cleanup race (see Known issues)
- [ ] Custom Egyptian-themed bullet/check glyphs to replace SF Symbol diamonds — research seven-pointed star, ankh, papyrus icons
- [ ] First-launch onboarding view that explains `~/Seshat/` and the `seshat install` one-liner (currently skipped — Phase 8 in the original plan)
- [ ] Disable macOS window restoration via `applicationSupportsSecureRestorableState` to prevent stale-state confusion, OR embrace it cleanly
- [x] App icon: `AppIcon.appiconset/icon_1024.png` is the master (letterpress emblem on cream paper); smaller sizes and `apps/web/src/app/apple-icon.png` are downscaled from it
- [ ] Code-sign + notarize for distribution outside the Xcode build tree

### Editing mode (v0.2) — shipped

**Decision (KER-269): minimal in-place block toggle.** Not split-view, not full WYSIWYG. The reader stays the editor — no separate panes, no layout reflow when you enter edit mode.

- **Toggle** via the toolbar Edit button or `⌘E`. The document keeps rendering exactly as it reads; only the block you click swaps to its raw markdown source for editing.
- **Per-section editing** reuses the existing `MarkdownParser` section split. Clicking a rendered section (`EditTapTarget` overlay, faint hover wash) turns *that* section into an auto-growing `TextField(axis: .vertical)` holding its source. Other sections stay rendered.
- **Source-preserving** — no AST round-trip. Edited section source is stored per-id in `sectionDrafts`; on save the document is reassembled by joining `parsed.sections` content (edited or original) with `\n`. (Caveat: a whitespace-only leading preamble the parser drops is not reconstructed — only matters for plain re-shares, which use `rawContent` instead.)
- **Save** via toolbar or `⌘S`. Writes through `DocumentWriter.write(_:to:expecting:)` (atomic, in `Services/`) so reader windows holding files *outside* `~/Seshat/` can save too. `Library.write(file:content:expectedModification:)` delegates to it after a library-root check.
- **Conflict detection (KER-270):** `DocumentWriter` compares the on-disk modification date against the one captured at load; a newer file returns `WriteOutcome.externalChange(remoteContent:)`, surfaced as an alert (Keep My Version / Reload from Disk / Cancel). Full three-way merge + diff view deferred.

### Server + web (v0.3)

User has a Hetzner box and a bucket. The plan:

- **Server** (likely Node/Bun + Hono, or NestJS — TBD): auth, doc CRUD, share-link generation
- Storage: bucket for blob (markdown source) + Postgres for metadata/permissions
- macOS app gains a "Share" button → POST doc to server → returns `https://seshat.<domain>/<slug>` link
- **Web app** at `apps/web/`: renders shared docs with a port of `SeshatTheme.swift` to CSS. Code is **not** shared with the macOS app — keep them as siblings, port the design tokens manually.
- Color palette and typography in `Theme/SeshatColors.swift` and `Theme/SeshatTheme.swift` are the canonical reference for the web port.

### Possible later features

- Search across the library (Spotlight integration via `CSSearchableItem`, or local SQLite FTS, or just BFS through files)
- Tags / frontmatter parsing → sidebar filters
- Math via KaTeX (deferred for MVP — would need `WKWebView` fallback for math blocks since MarkdownUI doesn't render LaTeX)
- Mermaid diagrams (same approach)
- Folder-management UI in the sidebar: New Folder, Import, Rename, Move between folders, Delete (trash).
- Multi-library support (more than one `~/Seshat/`)
- Settings UI (font size, theme variants — Notion-light / Notion-dark / paper-warm)
- iCloud / Dropbox sync of `~/Seshat/`
- Drag-drop import from Finder
- Recently-opened menu

---

## Known issues

### 1. Empty default reader window not always cleaned up

When launching cold via `seshat open file.md`, an extra "No file open" placeholder window can persist alongside the rendered file. Dedup of same-file invocations works correctly; only the empty placeholder cleanup is racy.

Investigated: time-based delay (replaced with event-driven), `viewDidMoveToWindow` ordering, `hasHandledLaunchURL` gate. See `apps/macos/Seshat/Services/AppRouter.swift`'s `reconcileEmptyWindows`. Adding `os_log` in both `registerReader` and the empty-default window's `WindowAccessor` callback should pinpoint the order — the bug is almost certainly that the empty default window's `viewDidMoveToWindow` fires *after* the content window's `reconcileEmptyWindows` runs, but its self-close branch isn't triggering for some reason.

### 2. macOS Window Restoration confuses tests

Quitting Seshat preserves window state. Re-launching restores everything — including potentially-stale empty windows that bypass our registration ordering. Always `rm -rf ~/Library/Saved\ Application\ State/com.keremcan.seshat.savedState` between debug runs. Long-term fix is probably implementing `applicationSupportsSecureRestorableState` returning `false` (or properly opting into restoration with explicit state encoders).

### 3. CLI install path

`seshat install` defaults to `/usr/local/bin/seshat`, which often requires sudo on modern Macs. Tell users to install to `~/.local/bin/seshat` instead, which works without elevation if `~/.local/bin` is in `PATH`.

---

## Conventions & gotchas (read these before editing)

- **One type per file** — see `.claude/skills/swiftui-pro/references/views.md`. Nested private types are fine.
- **`@Observable @MainActor`** for any class holding shared UI state. Mark `static let theme = Theme()...` as `@MainActor` (`MarkdownUI.Theme` isn't Sendable).
- **`foregroundStyle()` not `foregroundColor()`**, **`clipShape(.rect(cornerRadius:))` not `cornerRadius()`**, **`.onChange(of: x) { _, _ in }`** (two-param), **`@Entry` macro** for custom EnvironmentValues, **`.overlay(alignment:content:)`** form. Full list in `.claude/skills/swiftui-pro/references/api.md`.
- **No `ObservableObject` / `@Published` / `@StateObject` / `@EnvironmentObject`** — use `@Observable` + `@State` / `@Bindable` / `@Environment(SomeType.self)`.
- **No third-party deps without asking the user first.** MarkdownUI is the only one; Splash for code highlighting comes through MarkdownUI transitively.
- **Don't downgrade Swift strict concurrency** to silence errors. Solve them properly with `@MainActor` annotations or `@Sendable` boundaries.
- **Don't add `// removed: ...` comments or backwards-compat shims.** If something is unused, delete it.
- **Don't write design docs to disk** during planning. Discuss in chat, get approval, implement. (Global user rule.)
- **Never include `Co-Authored-By` lines in commit messages.** (Global user rule.)
- **`#Preview` macro**, not `PreviewProvider`.
- **Build the project after non-trivial Swift changes** to catch strict-concurrency regressions early.

---

## Useful commands

```sh
# verbose build output for debugging
xcodebuild -project apps/macos/Seshat.xcodeproj -scheme Seshat -configuration Debug build

# launch with a sample file
seshat open samples/stress.md

# trigger workspace selection of a file
seshat global ~/some-note.md

# count Seshat windows (rough)
osascript -e 'tell application "System Events" to count (every window of process "Seshat")'

# reveal the bundled CLI inside the .app
open "$(find ~/Library/Developer/Xcode/DerivedData -name 'Seshat.app' -path '*/Debug/*')/Contents/Resources/"

# tail Seshat's stderr for crashes / log() output
log stream --predicate 'process == "Seshat"' --info --debug
```
