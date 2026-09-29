# Seshat Share: market research report

Date: 2026-09-06. Scope: what people who read, write, and share markdown complain about, wish for, and pay for, and which of those fit a server-side, subscription-priced "Seshat Share".

Method: seven parallel research lanes (Reddit, X, Hacker News + Product Hunt, competitor matrix, app-store and forum reviews, AI-workflow demand, pricing benchmarks), then two verification passes that re-fetched every URL behind the top-10 features plus a seeded random 20% sample of all other URLs. Lane files with every finding are in the same folder as this report (`lane1-reddit.md` through `lane7-pricing.md`, plus `verify-top10.md` and `verify-sample.md`).

Conventions: OBSERVED = quoted verbatim from a source. INFERRED = our synthesis. Every quote has a URL. Counts are of independent people, not posts. "Old" means older than 24 months (before 2024-09). Vendor posts (someone launching a tool) are counted but flagged; they show a builder felt the pain, not that a buyer did.

Access caveat: Reddit blocked every free route, so Reddit evidence comes from 20 paid API calls covering r/Markdown, r/ObsidianMD, r/macapps, r/ClaudeAI, r/Notion, r/selfhosted, r/Slack; r/technicalwriting, r/ProductManagement, r/writing, r/webdev, r/programming were not reached. G2 and Capterra were CAPTCHA-walled. See section 9.

---

## 1. Executive summary

1. **Strongest signal: one readable link for one .md file, that updates in place, that the reader can open without an account.** About 35 independent people across Reddit, X, HN, PH, and app reviews describe exactly this, five of them plain users asking for help rather than vendors. The incumbent answer is "export to PDF" (30-upvote top comment) and it hurts: 21 low-star reviews across 7 apps complain about PDF export.
2. **Second: private, unlisted, password-protected, or expiring links.** About 30 independent people, a 152-like Obsidian thread, two 2025-2026 incidents of shared AI chats being indexed by Google, and a 220-like post about Notion public pages leaking editor emails. This is the strongest paid-feature signal and the one users say they would pay for.
3. **Third: AI-generated markdown is now the framing everyone uses.** Anthropic's own Claude Code team wrote "I find it difficult to read a markdown file of more than a hundred lines" (528-point HN thread, 12k-like X post). Twelve or more Mac markdown viewers launched in 2026 citing CLAUDE.md and plan.md. Sharing pain is stated as "good luck getting your manager to open it".
4. **Biggest surprise: the loudest voices propose switching to HTML, not fixing markdown.** "HTML is the new markdown" got 12,079 likes and Anthropic shipped shareable HTML artifacts from Claude Code. Seshat's counter-position must be explicit: keep the .md source, give it a reader and a link that look as good as HTML.
5. **Second surprise: view stats have almost no organic demand** (zero mentions on Reddit, X, HN, PH; two old forum requests). Custom domain has real but small demand. Library sync across Macs has no requests and 21 one-star reviews warning against charging for it.
6. **The one thing not to build: library sync across Macs.** Zero requests in any lane; Git and iCloud already cover the audience; charging for it is the single most resented pattern in the review corpus (Bear: "Why is a sub required to sync my devices using iCloud?").
7. **Pricing: 8.99 USD/year is defensible and has one exact precedent (Mataroa, 9 USD/year, yearly only).** It sits 3x under the nearest product-shape competitor (JotBird Pro 29/yr) and 10x under Obsidian Publish (96/yr per site). Treat it as a launch price with a grandfather promise; the evidence supports a standard price of 19 to 29 USD/year once images and private links ship. No lifetime tier.
8. **Free tier: quota, not trial.** Three permanent public links with no image uploads keeps the viral loop alive; every quota must be visible before it hits (Craft's mid-task walls earned 26 one-star reviews).

---

## 2. Ranked feature list

Legend. Demand = independent people across lanes (vendor posts flagged). WTP = willingness to pay, observed or none. Side = server (fits subscription rule) or local (must stay free). Effort = S/M/L. Candidates from the brief are marked [candidate].

### Tier 1: build or keep, these are the product

**F1. One document, one permanent link, update in place, no account for the reader** [exists today]
- Need: hand someone a rendered page, not a file, a repo, or a PDF, and push changes without resending.
- Demand: about 35 people. Reddit 10 (5 plain users), X 12, HN/PH 13, reviews: 34 Craft reviews praising it, Obsidian forum users describing it as the one thing Publish lacks.
- WTP: observed. maebert (Obsidian forum): "I'd be more than happy to pay for Obsidian publish, but to my best knowledge it doesn't cover the one use case I care about: publishing a single file (and, recursively, linked files) to a hidden, non-indexed URL." Craft charges for it (Plus, about 96/yr); JotBird 29/yr; MDtoLink 36/yr.
- Side: server. Effort: done. Competitor gap: Bear has no public link at all (three forum requests in 2025-2026), iA Writer and Ulysses only push to CMSs, chat share links are frozen snapshots that die when the chat is deleted, and every free paste service either expires or renders GitHub-style.
- Quotes:
  - "Sending the raw .md file assumes they already have a viewer, while converting to PDF removes easy revisions and can break links or diagrams. Is there a simple workflow that gives the recipient a readable link, preserves formatting, and lets the author update the source without resending a new export?" (r/Markdown, 22 upvotes, 35 comments, 2026-08-21) https://www.reddit.com/r/Markdown/comments/1vu538c/what_is_the_least_confusing_way_to_share_a/
  - "The ability to update a single document on craft which is then automatically shared across the web shared link is fantastic." (Craft, 5 stars, gb, 2024-05-24) https://itunes.apple.com/gb/rss/customerreviews/id=1487937127/sortBy=mostRecent/json
  - "If you delete the conversation the link will cause an error. Conversations are currently not duplicated before sharing." (OpenAI community, on ChatGPT share links, 2024-10) https://community.openai.com/t/get-a-public-link-of-chatgpt-reply/985795

**F2. Private, unlisted, password-protected links, noindex by default, author identity not leaked** [candidate: private/password]
- Need: share early-stage or client-sensitive work with "some eyes only"; avoid public indexing.
- Demand: about 30 people. Reddit 8, X 8 (incl. 220-like Notion leak thread), HN/PH 7, reviews: 152-like Obsidian thread plus a business user asking for "user expiration, and link sharing", AI-workflow lane: agent files "contain some of the most sensitive information we have".
- WTP: observed. Craft gates password and expiry behind Plus; JotBird Pro (29/yr) and MDtoLink Pro (36/yr) sell exactly this; Obsidian forum: "I'd be more than happy to pay".
- Side: server. Effort: S for unlisted + noindex, M for password. Competitor gap: Obsidian Publish passwords are site-wide only; Notion has none on any plan; Vercel charges 150/mo; Gist "secret" is unlisted, not private.
- Quotes:
  - "can someone build a privacy focused hackmd that actually works i BEG" (X, 20 likes, 2026-03-26) https://x.com/networkspirits/status/2037098897831580142
  - "every public Notion page silently exposes the full name, email, and profile photo of everyone who ever touched it" (X, 220 likes, 2026-04-19) https://x.com/k1rallik/status/2045925731885035877
  - "I want to share some of the notes with my students and coworkers Current publish option doesn't suggest to have passwords page-based, you can only password the entire website" (Obsidian forum, 152 likes, old thread active to 2024) https://forum.obsidian.md/t/obsidian-publish-password-protect-only-parts-of-the-website-individual-notes/13947

**F3. Image hosting inside shared docs** [candidate]
- Need: a research report or spec with screenshots must arrive whole; local image paths break the moment the doc leaves the machine.
- Demand: about 15 people. Reviews 7 (incl. 32-like "option to pay for additional storage" and "Why only 50MB?"), HN/PH 4 (first question on mdto.page's thread), AI lane 2 (Deep Research exports lose images), Reddit 3 indirect, Typora issues +54 and +67 (old).
- WTP: observed. Obsidian forum thread titled "Option to pay for additional storage in Obsidian Publish"; images are the second most common paid gate in the category (Write.as Pro, Pika Pro, HackMD 1 MB vs 20 MB).
- Side: server. Effort: M (upload on share, rewrite paths, quota, dedupe). Competitor gap: rentry, telegra.ph, Bear Blog, mdto.page, write.as free have no or flaky image hosting; JotBird free hosts images but they expire.
- Quotes:
  - "I'm guessing it doesn't handle images because you'd have to upload the image" (HN, mdto.page thread, 2026-01) https://news.ycombinator.com/item?id=46645942
  - "The limitations on publish are incredibly frustrating. Why only 50MB?" (Obsidian forum, 2025-12-31) https://forum.obsidian.md/t/support-all-file-types-for-the-publish-service/24908
  - "Copy and paste doesn't retain images and links" (OpenAI community, Deep Research export, 2025-05) https://community.openai.com/t/exporting-deep-research-reports/1149810

**F4. `seshat share` from the CLI and an MCP tool so agents publish directly** [new]
- Need: the doc that gets shared is the one the agent just wrote; the share command must live where the doc appears (terminal, agent session), not inside a writing surface.
- Demand: about 12 people plus the strongest counter-signal in the corpus: an 8.5k-user web editor added public links and "less than 10 people have ever used it". Obsidian Headless + Publish got 1,179 likes; Copilot CLI shipped /share gist; MDtoLink, plsreadme, Draftmark, markshare all added MCP or CLI publish in 2026; Pagecast commenter: "MCP would be a nice addition."
- WTP: none directly; this is the funnel into the paid tier, not the paid feature.
- Side: server API + local CLI. Effort: M. Competitor gap: no native Mac reader offers it; Marked Share (Aug 2026, free) is the only native-app-to-link flow and has no agent entry point.
- Quotes:
  - "For my app mdedit.ai with 8.5k users, i added support for markdown public link sharing, and less than 10 people have ever used it." (r/Markdown, 2026-06-12) https://www.reddit.com/r/Markdown/comments/1u3tpkl/
  - "Obsidian Headless now supports Obsidian Publish so you can publish to your site without the desktop app." (X, 1,179 likes, 2026-03-25) https://x.com/obsdmd/status/2036880481980146149
  - "after the 50th time of writing 'convert your last message to markdown and save it into `scatch/zfs-tips.md`' I finally mustered the energy to spend 5 seconds googling." (GitHub, claude-code #859, 2026-02-27) https://github.com/anthropics/claude-code/issues/859

**F5. Expiring links** [candidate]
- Need: share something "usually just for a short period of time"; corporate and client contexts.
- Demand: about 9 people. Reddit 2 (mdto.page launch, 32 upvotes; "for a short period of time"), X 2 (MaypazOr "Auto-expires in 24h", xadhish), HN/PH 3 (saltwounds, tmplink "content you only need for a few days", Uselink feature list), reviews 1 (business user: "user expiration"), Craft praise for "expiry dates".
- WTP: observed but as part of a bundle (Craft Plus, Uselink planned tier, JotBird). Free competitors use expiry as the free-tier limiter, not as a feature.
- Side: server. Effort: S. Bundle with F2 as "Link controls".
- Quotes:
  - "I often find myself writing notes or documentation in Markdown and needing to share them as a proper webpage, but usually just for a short period of time." (r/Markdown, 32 upvotes, 2026-01-16) https://www.reddit.com/r/Markdown/comments/1qefqx7/i_made_a_tool_to_publish_a_markdown_file_as_a/
  - "AI agents give you markdown. You need shareable pages." and "One command. Clean URL. Auto-expires in 24h." (X, 52 likes, 2026-04-06) https://x.com/MaypazOr/status/2041128587080692160

**F6. Mermaid and KaTeX rendering, in the reader and on the shared page** [new, roadmap item]
- Need: AI-generated docs increasingly contain diagrams and math; the doc is unreadable wherever they do not render.
- Demand: about 20 people. Reddit 7 ("that's showing up more in ai-generated docs"), HN/PH 5, reviews 4 (swift-markdown-ui #300 is the top-voted issue on Seshat's own renderer, +38), claude-code issues 220 reactions on math, Cursor forum on Mermaid.
- WTP: none for the reader (must stay free); on the shared page it is table stakes for the paid link to be worth sending.
- Side: local rendering plus web rendering. Effort: L on macOS (MarkdownUI has no LaTeX; needs a WKWebView fallback), M on web.
- Quotes:
  - "any plans for mermaid diagram support? that's showing up more in ai-generated docs" (r/macapps, 2026-03-01) https://www.reddit.com/r/macapps/comments/1rhwmmz/
  - "GitHub's mobile web view doesn't render Mermaid, and most markdown viewer apps I found don't either." (r/Markdown, 2026-07-06) https://www.reddit.com/r/Markdown/comments/1upe3x3/markdown_with_mermaid_diagrams_the_instant_you/
  - "Currently 'Claude Code for VS Code' plugin does not render LaTeX." (GitHub, 142 reactions, 2026-01) https://github.com/anthropics/claude-code/issues/16446

**F7. Free tier as a visible quota, not a time trial** [candidate: quota vs unlimited]
- Need: the first share must be free so links spread; the wall must never hit mid-task.
- Demand: 7 people on HN/PH asked for a clearly permanent free tier; 26 Craft one-star reviews on quota walls; Git Blog: "$2.99 just to see how the ONE free draft looks on my site? I might love it, but shy away from extortion."; amarkdown: "'Try it' → 'Log in' → close tab".
- WTP: category consensus. Free tiers in this space: MDtoLink 5 docs with 7-day expiry, JotBird 30-day expiry, Pika 50 posts, HackMD 1 MB images, Bear Blog and Mataroa free with custom domain paid. RevenueCat 2026: hard paywalls convert 10.7% vs freemium 2.1%, but freemium is what keeps a share link viral.
- Side: server policy. Effort: S. See section 5 for the proposal.
- Quotes:
  - "Having it per site feels like nickel-and-diming for small things that's kept me on Notion for a lot of miscellaneous web-published projects." (HN, on Obsidian Publish, 2025-02-20) https://news.ycombinator.com/item?id=43118805
  - "is it free all-time ? or i have one (flowershow) domain for all docs ?" and "a 100mb will make a fear for personal using for one like me" (Product Hunt, Flowershow, 2026-03) https://www.producthunt.com/products/flowershow

### Tier 2: cheap paid perks and free funnel features

**F8. Version history on re-push** [new]
- Need: when a link is updated in place, keep prior versions; comment or reference anchors should not drift.
- Demand: about 5 people (Pagecast "do you keep older versions anywhere", Uselink "does the comment stay anchored", sharemd built it, HackMD gates 10 versions free vs unlimited paid).
- WTP: observed indirectly (HackMD Prime, Notion 7/30/90-day history by tier).
- Side: server. Effort: M (store blobs per push, diff view later). Ship "last 10 versions" in paid.
- Quote: "When a URL is re-synced, do you keep older versions anywhere or does the new deployment completely replace them?" (HN, Pagecast thread, 2026-06) https://news.ycombinator.com/item?id=48590505

**F9. Custom slug / vanity URL** [new]
- Need: a link that reads as a title, and branded-looking links for client work.
- Demand: about 6 (TXTD "custom URLs" 19 upvotes old, JotBird Pro "custom URLs", MDtoLink Pro "custom slugs", MDX Limo "Custom URLs for branded links", Notion "URLs are even messier than those on Medium", Craft "customizable URL" praised).
- WTP: observed; three competitors sell it in their lowest paid tier.
- Side: server. Effort: S. Paid perk.

**F10. View count per shared doc** [candidate: view stats]
- Need: "did my manager actually open it".
- Demand: weak. Zero mentions on Reddit, X, HN, PH; one explicit HN ask in the Anthropic thread ("I can add super lightweight analytics so I know who actually reads my things"); two Obsidian forum requests from 2021; Anthropic's framing "the chance of someone actually reading your spec".
- WTP: none observed directly. Mataroa and rentry give a counter for free; Notion, Craft, Bear Blog gate analytics behind paid.
- Side: server. Effort: S (a counter, no cookies, no dashboard charts). Verdict: include in paid as a single number per doc, do not lead with it, do not build charts.
- Quote: "I can add super lightweight analytics so I know who actually reads my things or interacts with my prototypes." (HN, 2026-05-09) https://news.ycombinator.com/item?id=48072197

**F11. Print and PDF stylesheet from the reader and the shared page** [new, local]
- Need: PDF is the incumbent share format and it hurts (page breaks, cut-off code blocks, lost links). Offering a good one for free pulls people in; the link then replaces it.
- Demand: about 20 people. Reddit 7 (30-upvote "I export mine as pdf" plus "the page breaks are a bit clunky"), reviews 21 low-star export complaints across 7 apps, HN 5 ("First class (free) printing support for rendered markdown seems like a lacuna"), AI lane 5.
- WTP: none; must be free (zero marginal cost).
- Side: local. Effort: S on web (print CSS), M on macOS.
- Quotes:
  - "I export mine as pdf and send it that way. External links are preserved. Formatting preserved (though sometimes the page breaks are a bit clunky) ." (r/ObsidianMD, 30 upvotes top comment, 2026-04-09) https://www.reddit.com/r/ObsidianMD/comments/1sgom74/
  - "I thought 'markdown → PDF' would be trivial in 2025. It hasn't been so far." (Ask HN, 2025-11-05) https://news.ycombinator.com/item?id=45822274

**F12. Quick Look extension and default .md handler** [new, local]
- Need: Finder shows raw text; Xcode bounces; QLMarkdown is deprecated on Homebrew and broken on Tahoe.
- Demand: about 15 people. X 8 (Shpigford 869 likes shipping one; three separate Xcode complaints), PH showmd 202 upvotes and Marked QL 159, QLMarkdown issues +17 and +3, HN "Quick Look extension is the right surface".
- WTP: none; free. This is the reader adoption funnel.
- Side: local. Effort: M.
- Quote: "Every AI tool spits out Markdown. macOS still opens .md as raw text." (X, 2026-07-18) https://x.com/yashbanka123/status/2078459197084295556

**F13. Copy for Slack / copy as rich text from the reader** [new, local]
- Need: half the time the destination is Slack, Google Docs, or email, and pasting markdown there breaks tables, fences, and nested lists.
- Demand: 14 people in the AI lane alone; three of them built their own Slack converters.
- WTP: none; free.
- Side: local. Effort: S.
- Quote: "Over the years I've spent hours fixing the formatting of Markdown content I pasted into Slack: removing stray asterisks, rebuilding links, and re-indenting nested lists. Especially in the last months where half my messages come from ChatGPT or Claude." (HN, 2026-03-10) https://news.ycombinator.com/item?id=47319011

**F14. Recency view in the library ("what did the agent write in the last hour")** [new, local]
- Demand: about 8 people (HN 5, AI lane 4: "easily see recent file that changed to help you find the 75th file your agent just wrote for you"; PH: "plans and handoff notes end up scattered across folders and I end up grepping just to find what changed").
- Side: local, free. Effort: S (sort by modified, badge new).

**F15. Full-text search across the library** [new, local, roadmap item]
- Demand: about 7 people (HN "My actual problem with markdown isn't previewing, it's search", reviews 2 one-star "No Cmd-F in preview mode", AI lane "grep -r is all I've got").
- Side: local, free. Effort: M.

**F16. Export, delete, and portability of shared docs (no lock-in)** [new, table stakes]
- Demand: 4 reviewers reject app-owned silos ("I'm not keen on my writing being held hostage in a database should I ever cancel my sub"); telegra.ph is criticised for pages you cannot delete; Uselink asked about "retention/deletion".
- Side: server. Effort: S. Free. Say it on the pricing page.

**F17. Abuse reporting and spam control on public slugs** [new, operational]
- Demand: 3 (mdto.page: "phishers will abuse it"; Publish Markdown: "be careful of bot or fraudster"; Bear Blog's spam war, where the paid tier doubles as the filter).
- Side: server. Effort: S. Required before the free tier opens.

### Tier 3: defer to a second tier or a later version

**F18. Custom domain (docs.yourdomain.com)** [candidate]
- Need: branded client deliverables; "publish with zero web knowledge".
- Demand: about 12, mostly indirect. HN/PH 5 ("I would have upgraded to a paid subscription if you let me point domains at it", old), X 5 (folder/domain cluster, 93 likes max), reviews 3 (Obsidian custom-domain setup pain), AI lane 1, Reddit 0 users (2 vendor feature lists).
- WTP: observed and strong in the category: custom domain is the single most common paid gate (Bear Blog, Mataroa 9/yr, Write.as, Pika, Montaigne 2/mo, Notion 96/yr for the domain alone).
- Side: server. Effort: M (CNAME + automatic TLS; Obsidian's Cloudflare-only path is the anti-pattern).
- Verdict: do not fold into 8.99. Competitors price it at 24 to 108/yr; it is the natural anchor for a second tier at 19 to 29/yr.
- Quote: "Why can't I post to custom domains. I would have upgraded to a paid subscription if you let me point domains at it." (HN, 2023-10, old, 62-point thread) https://news.ycombinator.com/item?id=37776935

**F19. Publish a folder as a mini site (sidebar, search)** [candidate]
- Need: onboard a team that does not use your tool; a paying Obsidian Publish user still could not share with a new company.
- Demand: about 12. Reddit 6 (474-upvote Git auto-publish post; "I pay for Catalyst, Sync & Publish. I'm working with a new company and they're not already using Obsidian"), reviews: Craft "mini website" praise and four Obsidian plugins shipping this in 2025-2026, HN/PH 0 unmet asks (Flowershow, Quartz, Publish exist), AI lane 0 direct.
- WTP: observed in the category (Obsidian Publish 96/yr, Flowershow 5/mo, GitBook 65/site/mo) but none of it is Seshat's audience saying it.
- Side: server. Effort: L. Identity risk: this is where Seshat starts to look like a site builder. Verdict: defer; if built, keep it as "a folder of pamphlets with an index", no themes, no nav config.
- Quote: "The same repo also auto-publishes my Markdown sites, so editing a note on my phone updates the site without me touching anything." (r/ObsidianMD, 474 upvotes, 2026-09-02) https://www.reddit.com/r/ObsidianMD/comments/1w544z2/two_years_syncing_obsidian_with_git_heres_the/

**F20. Team-scoped links (allowlist by email or org)** [new]
- Demand: about 6 (Claudebin "so I can share the sessions only with my team", agency thread "clients seeing each other", MDX Limo "email-based sharing", Claude Team plans that cannot share publicly).
- Side: server. Effort: M. A v2 of F2, after password links.

**F21. Text-size control** [new, conflicts with "not configurable"]
- Demand: 4 (HN "First thing that blocks me from adopting it is lack of ability to adjust text size", One Markdown one-star for paywalled font size, dark-mode legibility). Verdict: the evidence is real but small; a keyboard zoom (Cmd +/-) is the minimal concession that does not become a settings panel. Never paywall it.

### Kill or keep out

**F22. Library sync across Macs** [candidate]. KILL for now.
- Demand: zero direct requests on Reddit, X, PH; two weak HN mentions; the technical audience uses Git (474-upvote post) or iCloud.
- Risk: charging for sync is the most resented pattern found: 15 Bear one-star reviews ("Why is a sub required to sync my devices using iCloud?"), 7 Obsidian Sync price complaints, 6 sync data-loss one-stars across apps. Telescopo sells iCloud sync in a 49.99 one-time tier, not a subscription.
- If ever built: only if it runs on Seshat's own servers, said plainly, and only after F1 to F5 are shipped.

**F23. Inline comments on the shared page** [new]. Keep out, with a note.
- Demand: about 8 (X "god obsidian publish doesn't allow comments?!?!", Uselink and Draftmark ship it, Plannotator, about 8,500 GitHub stars, with a paid "shared plans" tier coming, Claude Code issue #82643 "annotate this file", Anthropic shipped and then removed Ultraplan in Aug 2026).
- Verdict: the evidence is moderate, not overwhelming, and it contradicts "not a collaboration tool". The plan-review niche is real and being served by Plannotator (about 8,500 stars, verified 2026-09-06). Revisit only if paying users ask; if built, the minimum is "reader leaves a note, owner sees it in the dashboard", no threads, no presence.

**F24. Live collaboration, co-editing** . Out. Requested mostly by Bear and Notion reviewers who want Apple Notes style sharing; wrong product.

**F25. Themes, fonts, density toggles**. Out. Three reviewers want margin control; the "not configurable" position is a feature to the audience ("Trusts taste over toggles"). Note the counter-evidence exists (One Markdown: "Adjustable margins", "Fixed width") and answer it with a good default measure and F21.

---

## 3. AI-workflow section: how people share AI-generated markdown today

This is the wedge. About 60 independent people across GitHub issues (claude-code, codex, cline, gemini-cli, glow), HN, Cursor and OpenAI forums, dev.to, Substack, and Reddit describe the same loop: an agent writes a long .md, a human has to read it, then hand it to someone.

### The demand, ranked by independent people

| # | Friction | People | Strongest evidence |
|---|---|---|---|
| 1 | Pasting agent output into a rich-text destination (Google Docs, Notion, Slack, Word, email) breaks tables, fences, nested lists | 14 | Slackfmt: "half my messages come from ChatGPT or Claude" |
| 2 | Terminal and IDE are poor reading surfaces for long markdown: raw syntax, hard wraps, no Mermaid or math, preview pane dies with the session | 13+, plus Gemini CLI maintainer and Anthropic | claude-code #13600 (61 reactions), #43113 (66), #14375 (53), #16446 (142); Cursor forum 4 threads on plan.md not opening |
| 3 | No clean way to get markdown out of the agent (copy loses structure, "ask it to write a file") | 9, 395+ reactions on two issues | claude-code #18170 (291 reactions), #15199 (104) |
| 4 | Sharing a .md with a non-developer fails: no reader on their machine, gist looks technical, attachment renders as plain text | 8 | "good luck getting your manager to open it" (47-like Substack) |
| 5 | Chat-vendor share links are the wrong object: a frozen snapshot of a chat, dies on delete, org-only on Team, attachments excluded, indexed by Google | 5 sources, 2 incidents | OpenAI community; amitkoth.com; Bitdefender (Aug 2025); Neowin (Jul 2026) |
| 6 | PDF is the fallback and it is painful | 5 | Ask HN "I thought 'markdown → PDF' would be trivial in 2025. It hasn't been so far." |
| 7 | Agent files pile up: 50 to 150 .md files, need recency and search | 4 | "grep -r is all I've got and it's terrible for this" |
| 8 | Plans are the artefact people keep and pass around; reviewing them needs a real surface | 5, plus Plannotator (about 8,500 stars) | Ultraplan shipped by Anthropic then removed 2026-08-04 |

### Current workaround, and what breaks (OBSERVED unless marked)

| Workaround | What breaks |
|---|---|
| Read in terminal scrollback | raw `#` and `**`, pipe tables, no Mermaid or KaTeX, hard-wrapped at pane width, cannot reflow |
| VS Code or Cursor preview pane | splits the editor, closes with the session, no Mermaid without an extension, scroll jank, blank or crash on agent-written files |
| Finder Quick Look | raw text unless a plugin is installed; QLMarkdown deprecated on Homebrew, broken on Tahoe |
| Obsidian | file must live in a vault, no CLI open, wrong shape for transient output |
| glow, mdcat, bat | degrade when stdout is not a TTY, buffer the whole doc, no TOC, search, or watch |
| "Write it to a file" | files scatter across repos, nobody reads them, grep is the only search |
| Ask the agent for HTML, upload to S3, R2, or a shared server | needs a bucket and a URL; HTML is not co-editable with the agent; the Anthropic thread's own counter-argument |
| Copy from terminal or VS Code panel | leading indent, hard breaks, structure stripped |
| Paste into Google Docs | tables become pipes, code fences literal, "Paste from Markdown" partial |
| Paste into Notion | tables, code blocks, LaTeX break; import "broken for years" |
| Paste into Slack | asterisks and `##` literal, nested lists flatten |
| Attach .md to email or chat | recipient has no renderer; Zoho Cliq shows plain text; "won't open it" |
| GitHub Gist | needs an account, "look terrible" (420 likes), secret is not private |
| ChatGPT or Claude share link | shares the chat as a chat, breaks on delete, frozen, org-only on Team, files excluded, was indexed by Google |
| Export to PDF | typography poor, page breaks bad, not updatable (INFERRED); Perplexity and Gemini exports lossy |
| Notion MCP from Claude Code | 30 minutes of setup, doc still lives in Notion |
| Paste into a share-markdown site (mdbin, mdto.page, MDtoLink) | no local images, 7-day expiry on free tiers, GitHub-style design, another account |

### The counter-position to answer

"HTML is the new markdown" (Thariq Shihipar, Claude Code team; 12,079 likes, 528-point HN thread) argues for switching the output format to HTML and uploading it. Anthropic followed with shareable HTML artifacts from Claude Code (2,144 likes), Teams first. The HN thread's own rebuttal is Seshat's position: "by gravitating to HTML you lose the ability for a human (you!) to easily co-author the document with the LLM." Seshat keeps the .md as the source of truth and makes the reader and the link look as good as HTML. Say this on the landing page.

Two more objections with real support, to answer in copy: "VS Code preview pane is fine" and "Quick Look is the right surface, full apps overshoot" (that argues for F12), and "just ask Claude to push to Cloudflare Pages" (that argues for F4 being one command with no config).

### Which features win this use case

Strong: F1 (update in place with a stable URL is the gap in every chat share link and every Google Docs copy), F3 (images are the first missing feature users hit), F2 (agent files are sensitive; two indexing incidents), F4 (agents publishing on your behalf is now the expected entry point), F6 (Mermaid and math are in every 2026 viewer's feature list).
Moderate: F10 (one explicit ask), F11, F13, F14, F15.
Weak in this lane: custom domain (one client-facing ask), folder site and library sync (no direct asks).

---

## 4. Competitor matrix and pricing

Checked 2026-09-06. Full 60-tool matrix with sources in `lane4-competitors.md`. Legend: Y yes, N no, P paid tier only, ? unverified.

### Features by tool

| Tool | Free tier publishes a link | Image hosting | Private or password | Expiring | Custom domain | View stats | Update in place / versions | Same look as the app |
|---|---|---|---|---|---|---|---|---|
| Seshat Share (today) | Y | N | N | N | N | N | Y / no history | Y |
| Obsidian Publish | N (paid only) | Y, 50 MB/file | site-wide password only | N | Y, Cloudflare only | via GA embed | Y / no history | Y (own theme) |
| Notion Sites | Y | Y, 5 MB free | N on any plan | N | P, +8/mo per domain | P | Y / 7d free | N ("janky", messy URLs) |
| HackMD | Y | Y, 1 MB free, 20 MB paid | Y | N | Enterprise | P | Y / 10 versions free | N |
| Craft | Y (Starter) | Y | P | P | P | P | Y / 7d free | Y |
| Bear | N (no public link) | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| iA Writer, Ulysses | N (push to WordPress, Ghost, Medium) | via target | via target | N | via target | via target | partial | N |
| Typora, Marked 2 | N (local; Marked Share is separate, free) | n/a | Marked Share: Y | ? | ? | ? | Marked Share: Y | n/a |
| GitHub Gist | Y | N | unlisted only | N | N | N | Y / full history | N ("look terrible") |
| GitHub Pages | Y (public repo) | Y | N | N | Y | N | via git | N |
| Google Docs publish | Y | Y | N | N | N | N | Y | N (formatting breaks) |
| rentry.co | Y, no account | flaky | edit code only | N | N | Y counter | Y | N |
| telegra.ph | Y, no account | Y | N | N | N | via bot | cookie-bound | N |
| mdto.page | Y, no login | N | N | Y 1 to 30 days | N | N | N | N |
| MDtoLink | Y, 5 docs, 7-day expiry | ? | P | free tier expires | P (108/yr tier) | ? | Y | N |
| JotBird | Y, 30-day expiry | Y, expires | P | Y | ? | ? | Y | N |
| Mataroa | Y | Y, 100 MB | N | N | P, 9/yr | Y | Y | N (blog) |
| Bear Blog | Y | N | N | N | P | P | Y | N (blog) |
| Flowershow | Y, 1 site, 100 MB, badge | Y | P | N | P | ? | Y | N |
| Marked Share (Aug 2026) | Y, free, account | Y | Y | ? | ? | ? | Y, live | N |
| Uselink (alpha) | Y | ? | Y | Y | asked for | ? | Y, versions | N |

### Pricing

| Tool | Free tier | Paid | Period | Custom domain tier | Source |
|---|---|---|---|---|---|
| Seshat Share | TBD (see section 5) | 8.99/yr | yearly only | n/a | |
| Mataroa | nearly everything | 9/yr | yearly only | Premium | mataroa.blog |
| JotBird | 30-day expiry | Pro 29/yr | yearly only | ? | jotbird.com |
| Bear (notes) Pro | free app | 29.99/yr or 2.99/mo (no publishing) | both | n/a | bear.app |
| Marked 3 | Marked Share free | 29.99/yr intro, 49.99 standard; 89.99 unlock | all three | ? | markedapp.com |
| MDtoLink | 5 docs, 7 days | Pro 36/yr (6/mo); Publisher 108/yr | both | Publisher | mdtolink.com |
| Ulysses | trial | 39.99/yr or 5.99/mo | both | n/a | ulysses.app |
| Obsidian Sync | none | 48/yr Standard, 96/yr Plus | both | n/a | obsidian.md/pricing |
| Bear Blog | subdomain | 5/mo or about 49/yr; lifetime 189 (reported) | all three | paid | bearblog.dev |
| Hashnode Pro | free blog | 50/yr | both | free | hashnode.com/pro |
| Montaigne | free incl. domain | Start 50/yr; domain-only add-on 2/mo | both | Start | montaigne.io/pricing |
| Pika | 50 posts | 60/yr | both | Pro | pika.page |
| Flowershow | 1 site, badge | from 5/mo | both | paid | producthunt.com/products/flowershow |
| Write.as | 1 blog, no images | Pro 72/yr (6/mo annual) | both | Pro | write.as/pricing |
| Craft | 1,500 blocks | Plus about 96/yr (8/mo) | both | Plus | craft.do/pricing |
| Obsidian Publish | none | 96/yr per site (8/mo annual), 10 monthly | both | included, Cloudflare | obsidian.md/pricing |
| Notion | unlimited sites | Plus 120/yr per user + 96/yr per custom domain | both | Plus + add-on | notion.com/pricing |
| HackMD Prime | 1 MB images, 10 versions | about 48 to 60/yr (display inconsistent) | both | Enterprise | hackmd.io/pricing |
| Vercel / Netlify Pro | hobby free | 240/yr; password on Vercel +150/mo | monthly | free | vercel.com, netlify.com |
| GitBook Premium | 1 user | 780/yr per site | both | Premium | gitbook.com/pricing |
| rentry, telegra.ph, LFMarkdown, Gist, Marked Share, Simplenote publish | free, permanent | none | n/a | no | respective sites |

Gaps no one fills well (OBSERVED across the matrix): a native Mac app that yields a permanent link in one step (Bear has none; Marked Share is the only one, and it is a month old); paste-and-link services that are permanent, host images, and update in place (each free one lacks at least one); private or password links under 40/yr (only JotBird and MDtoLink); a link that looks like the app (every paste service is GitHub-style; Notion and Google Docs draw "janky" and "messy" complaints); custom domain under 25/yr (only Mataroa and Montaigne).

---

## 5. Free vs paid tier proposal

Rule from the brief: zero-marginal-cost local features free; server cost paid. The evidence sharpens that into three more rules: never gate reading or local editing (Ulysses' read-only paywall is the largest one-star cluster found, 53 reviewers); never charge for cosmetics or for sync that rides on iCloud (Bear, 15 reviewers); show every quota before it hits (Craft, 26 reviewers).

### Free forever (local, zero marginal cost)

| Feature | Evidence |
|---|---|
| Reader, library, outline, live reload, CLI `seshat open`, VS Code extension | 11 HN posters say a subscription is tolerated only when it pays for hosting; Typora's 15 USD one-time is the reader reference point |
| Quick Look extension (F12) | showmd 202 PH upvotes, Shpigford 869 likes |
| Mermaid and KaTeX in the reader (F6) | 20 people; table stakes |
| Print and PDF (F11) | 21 low-star export reviews; this is the incumbent share path, give it away |
| Copy for Slack / rich text (F13) | 14 people; three built their own |
| Recency and search (F14, F15) | 15 people |
| Export and delete of shared docs (F16) | 4 reviewers on silos; "held hostage in a database" |

### Seshat Share, free tier (server, capped)

- 3 active public links, permanent (no expiry), update in place, seshat.page slug, delete anytime.
- No image uploads (images referenced by URL still work).
- Counter visible in the dashboard and in the CLI output ("2 of 3 free links used").
- Evidence: MDtoLink free is 5 docs with 7-day expiry and JotBird free expires at 30 days, so 3 permanent links is already more generous where it matters (permanence). Craft's mid-task wall and Git Blog's "$2.99 just to see how the ONE free draft looks" show the first share must be free and the cap must be visible. The viral loop is the link itself: every free page is a Seshat page a recipient sees.

### Seshat Share, paid (8.99/yr at launch)

- Unlimited active links.
- Image hosting with a quota (INFERRED: 500 MB to 1 GB; Mataroa gives 100 MB free, Obsidian 50 MB per file, HackMD 20 MB per image on Prime; storage is the one line item that costs money).
- Link controls: unlisted (noindex), password, expiry (F2, F5).
- Custom slug (F9).
- View count per doc (F10).
- Last 10 versions (F8).
- Evidence: these five are exactly what the free-forever competitors (rentry, telegra.ph, LFMarkdown, Gist, Marked Share) lack, and what JotBird (29/yr) and MDtoLink (36/yr) sell.

### Second tier, later (19 to 29/yr, INFERRED)

- Custom domain with CNAME and automatic TLS (F18). Competitors price it at 24 to 108/yr.
- Folder as a mini site (F19), only if identity can be preserved.
- Team-scoped links (F20).

### Quota-based free tier vs 14-day trial

Quota wins on the evidence. RevenueCat 2026 shows hard paywalls convert about 5x better (10.7% vs 2.1% at day 35), but that data is for apps whose value is private to the user. Seshat Share's value spreads through the link; a time trial ends the loop after two weeks and, per RevenueCat, "55% of all trial cancellations happen on Day 0". Every comparable in the category (Bear Blog, Mataroa, Pika, HackMD, Craft, Notion, Flowershow) is quota or feature-gated freemium; the only no-free-tier products are Obsidian Publish (the canonical "quite expensive") and blog hosts at 60/yr and up. Bear Blog's spam experience adds a second reason: the paid tier doubles as the abuse filter for public slugs, so the free tier should be small.

---

## 6. Pricing sanity check

**Is 8.99 USD/year positioned right?** Yes for launch, with a plan to raise.

Price clusters the evidence supports (all individual, text publishing):

| Cluster | Yearly | Who | Notes |
|---|---|---|---|
| Tip-sized | 9 to 10 | Mataroa (9, yearly only) | Founder: "The current upkeep cost is around €7 per month" and "I can afford to sell it as low as $9 per year". In 2022, 67 of 1,826 accounts paid (3.7%); 24% of payers had zero posts. Goodwill pricing. |
| Domain-like identity fee | 20 to 40 | omg.lol 20 (rising to 50), Bear notes 29.99, Marked 3 29.99, Paste 29.99, JotBird 29, MDtoLink 36, Agenda 34.99, 1Password 35.88, Ulysses 39.99 | The dominant indie-utility price. HN on omg.lol: "for a very reasonable, imo, $20USD a year". omg.lol concluded 20 could not fund full-time work. |
| Hosting | 48 to 96 | Obsidian Sync 48, Bear Blog 49, Pika 60, Write.as 72, Obsidian Publish 96 | Contested: on one HN thread 60/yr is "fair enough" to one person and "very steep" to another. Obsidian Publish at 96 per site is the canonical "quite expensive" and "nickel-and-diming". |

What the evidence says about 8.99:

1. It is what the loudest sentiment asks for: "The trend of everything being $5-10/month is ridiculous, this is nice to see" (HN on Mataroa, old). Students and non-US users repeatedly call 8/month too much; 8.99/year is under every threshold named.
2. It is the best-retaining SKU shape: RevenueCat 2025 reports low-priced annual plans retain 53.7% after one year versus 17.0% for monthly. Caveat from the same report: nearly 30% of annual subscribers cancel auto-renew in the first month, so the first month decides the renewal.
3. It is a supporter price, not a business price. The only benchmark at this level is a hobby with no salary. RevenueCat's median first-year realized LTV for low-priced apps is 10.69 USD, roughly what 8.99 nets after Polar's fee (about 0.95 USD, INFERRED from a reported 5% + 0.50 schedule).
4. Yearly-only is structurally forced and has precedent: every product under 25/yr in the category (Mataroa, omg.lol) is yearly-only; every one above 48/yr offers monthly. A hypothetical 0.99/month would lose about 56% to per-transaction fees. The anti-annual-only literature (Paddle, Baremetrics) is about 50 USD and up SaaS.

**Range the evidence supports:** 9 to 29 USD/year for the link layer as scoped; 29 to 49 as the ceiling once custom domain ships (Bear Blog 49 and Pika 60 draw "steep").

**Recommendation (INFERRED):** launch at 8.99 as an early-bird price with an explicit grandfather promise. Bear 2 ("We will not raise prices on any existing subscribers") and Obsidian Publish's early-bird show this defuses later increases. Plan the standard price for 19 to 29 once images and link controls ship. Do not add monthly billing below 24/yr.

**Lifetime tier:** no evidence supports one at this price. Category lifetimes run 2.5x to 4x annual (Scribbles 229 vs 90, Agenda 119.99 vs 34.99, Bear Blog about 189 vs 49), which at 8.99 would be 22 to 36 USD locking in server cost forever. Freemius (2026) reports lifetime buyers "generated 30-40% more support tickets" and that "15-20% of LTD buyers were warm leads" who would have gone annual. The review corpus adds the user-side risk: Taio's lifetime buyers now call it "abandoned" and "fraud" (4 reviewers). Every pro-lifetime quote found is about local software (Sublime Merge, Sketch), not hosting. Revisit only after a price rise to the 20 to 40 cluster, at 3 to 4x.

---

## 7. Top 20 verbatim quotes for landing page copy

Grouped by need. All OBSERVED; URLs verified (see section 9).

### "I just want to send you this thing to read"

1. "Sometimes I have one Markdown doc - notes, a short guide, AI research findings, something from my knowledge base - and I just want to send someone a readable link. Not really publish a whole site, not set up a repo, not export to PDF, just "here's the page"." (r/Markdown, 17 upvotes, 2026-06-12, vendor) https://www.reddit.com/r/Markdown/comments/1u3tpkl/how_do_you_share_single_markdown_files_quickly/
2. "Sending the raw .md file assumes they already have a viewer, while converting to PDF removes easy revisions and can break links or diagrams." (r/Markdown, 22 upvotes, 2026-08-21) https://www.reddit.com/r/Markdown/comments/1vu538c/what_is_the_least_confusing_way_to_share_a/
3. "Sometimes I just want to share one note with someone. But the options feel a bit heavy" (r/ObsidianMD, 19 upvotes, 2026-04-09) https://www.reddit.com/r/ObsidianMD/comments/1sgom74/is_there_a_good_way_to_share_a_single_obsidian/
4. "whenever I wanted to show something to a friend, I had to send them the actual file. I just wanted to send a link and have them see exactly what I was seeing." (r/developersIndia, 2026-09-06, vendor) https://www.reddit.com/r/developersIndia/comments/1w8sy3g/built_rendermd_because_i_was_tired_of_sending/
5. "Sharing context with a teammate is a URL, not a tarball" (X, 134 likes, 2026-05-09) https://x.com/ghumare64/status/2053106700324897063

### "The reader is not technical"

6. "A non technical person doesn’t want to read markdown formatting or html tags. I work at a Microsoft office kind of place." (r/Markdown, 10 upvotes top comment, 2026-08-21) https://www.reddit.com/r/Markdown/comments/1vu538c/
7. "I can barely read raw markdown (the plain text format Claude Code uses) myself - good luck getting your manager to open it." (Substack, 47 likes, 2026-01-26) https://hannahstulberg.substack.com/p/claude-code-for-everything-draft-in-claude-code-collaborate-in-notion
8. "They have to make an account, or the link just looks kind of janky and unprofessional. Had a client once tell me it looked unfinished." (r/Notion, 2026-03-26) https://www.reddit.com/r/Notion/comments/1s4mq9x/how_do_you_guys_share_notion_pages_with_clients/
9. "GitHub Gists are useful but look terrible." (X, 420 likes, 2026-03-10) https://x.com/linuz90/status/2031377772145422635

### "Long AI markdown is a slog"

10. "I find it difficult to read a markdown file of more than a hundred lines." (Thariq Shihipar, Claude Code team, 2026-05) https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html
11. "It's so obvious in hindsight: while .md is simple to write and agents can read it well, it's a total slog to eyeball as a human." (X, 436 likes, 2026-05-18) https://x.com/clairevo/status/2056428390773825701
12. "Whether it's plans or documentation that I've asked my agent to generate for me, it seems that I spend more time reading markdown than code." (Show HN Marky, 75 points, 2026-04-16) https://news.ycombinator.com/item?id=47795468
13. "Every AI tool spits out Markdown. macOS still opens .md as raw text." (X, 2026-07-18) https://x.com/yashbanka123/status/2078459197084295556
14. "when I'm claude-coding in plan mode, I grab the plan link and open it in Typora for a much nicer reading experience." (X, 2026-01-07) https://x.com/linuz90/status/2008840566633857244

### "The link should update, and it should be mine"

15. "I have a couple notes that I want to be able to share with non-Obsidian using folks & have the notes update when I change them on my end." (r/ObsidianMD, 10 upvotes, 2026-07-23) https://www.reddit.com/r/ObsidianMD/comments/1v4oerl/share_a_note_that_updates_when_i_make_changes_to/
16. "each share is a frozen snapshot, which is fine for status updates and less ideal for live docs." (r/selfhosted, 2026-04-30, vendor admitting the gap) https://www.reddit.com/r/selfhosted/comments/1t07xjn/markdownpdf_workbench_with_postgresbacked_share/
17. "Copy-paste into Google Docs? Now you have two versions, and any edits in Google Docs don't automatically sync back." (Substack, 2026-01-26) https://hannahstulberg.substack.com/p/claude-code-for-everything-draft-in-claude-code-collaborate-in-notion

### "Some eyes only"

18. "As the project is only in very early stages, it's for some eyes only." (r/ObsidianMD, 2026-06-26) https://www.reddit.com/r/ObsidianMD/comments/1ucu4ef/sortable_tables_lists_publish/
19. "Every time you hit "Share" on a Claude or ChatGPT chat, that creates a public page. Not a private link." (X, 2026-07) https://x.com/alex_prompter/status/2081327819800576085

### "Priced like a domain, not like a SaaS"

20. "A blog hosting price that's actually reasonable! The trend of everything being $5-10/month is ridiculous, this is nice to see." (HN on Mataroa 9/yr, 2022, old) https://news.ycombinator.com/item?id=32129706

---

## 8. Risks and anti-features

What users in this space explicitly hate, with the count of independent people and the source lane.

1. **A "free" listing with a hard paywall, or gating the base activity.** 53 Ulysses reviewers: "It is locked in 'read only' mode so you can only view their sales pitches". Say on every surface: the reader is free, nothing local is gated, Share is 8.99/yr.
2. **Quota walls that fire mid-task.** 26 Craft reviewers ("all of a sudden I'm met with an error that says I ran out of free space"). Show the link counter before the third share, not after.
3. **Charging for sync that rides on iCloud, or for cosmetics.** 15 Bear reviewers; One Markdown one-stars for paywalled dark mode and font size. Never paywall appearance; do not ship a paid iCloud sync.
4. **Per-site and tier-split pricing.** Obsidian Publish "nickel-and-diming" (HN), "I think it's stupid that Sync and Publish are two separate pricing tiers" (forum). One plan, flat.
5. **Lost links on churn and lock-in.** "I'm not keen on my writing being held hostage in a database should I ever cancel my sub" (Ulysses reviewer); telegra.ph pages cannot be deleted; Omnivore shut down with two weeks' notice. Proposal (INFERRED): on lapse, links stay live and read-only up to the free quota, nothing is deleted without notice, export is always one click. Publish this policy.
6. **Surprise renewals.** HackMD: "They autobilled me for another year and refused to give me a refund." Craft: "I just got an alert from my card saying I was charged for $95.99 a year." Send a renewal reminder email 14 days before; Polar supports this.
7. **Public pages that leak or get indexed.** Notion editor emails (220 likes); ChatGPT and Claude shared chats in Google (two incidents). Noindex by default on unlisted links; never render the author's email.
8. **Free public hosting attracts phishers.** mdto.page and Publish Markdown threads; Bear Blog's spam war. Ship report-a-page and a small free quota from day one.
9. **AI bolted on, or moralised about.** Notion "Critical features get hidden behind AI features"; iA Writer's anti-AI messaging drew a one-star. Stay quiet on the topic in the product.
10. **Support silence and newsletter spam.** 7 reviewers across Craft, Ulysses, Byword. Answer mail; no marketing email without opt-in.
11. **Lifetime deals that outlive the developer's interest.** Taio, 4 reviewers ("The lifetime purchase was a waste of money"). No lifetime tier.
12. **Reader-only apps sold for money.** Marked 2 two-star: "Dafür, dass man mit Marked 2 nur ausgeben und nicht einmal schreiben kann, ist eine eher seltene Nutzung eigentlich abzusehen." Keep the reader free; the market has 12+ free viewers.
13. **Product-identity objections to have answers for:** "VS Code preview pane is fine", "Quick Look is the right surface", "how is this different from a Notion site", "just ask Claude to push to Cloudflare Pages", "my problem is search, not preview", "why should I read AI output at all" (33-upvote reply on r/ClaudeAI). The last one matters: reading comfort alone is not a purchase reason; skimmability (outline) and the handoff (link) are.

---

## 9. Appendix

### 9.1 Coverage and honest gaps

- Reddit: 20 paid API calls (about 0.03 USD) covering r/Markdown, r/ObsidianMD, r/macapps, r/ClaudeAI, r/ClaudeCode, r/Notion, r/selfhosted, r/Slack, r/ChatGPT, r/CraftDocs. Not reached: r/technicalwriting, r/ProductManagement, r/productivity, r/writing, r/webdev, r/programming, r/cursor, r/vscode (nothing usable). No Reddit hit for "view stats" or "custom domain" as a user request.
- X: 25 paid API calls (about 0.04 USD). Empty: "I'd pay for" and "why is there no" phrasings; Bear, iA Writer, Ulysses, Craft, Quarto, Docusaurus, Hashnode, Marked 2 had no engaged complaint threads in the window.
- HN: about 47 Algolia queries. Empty: "markdown to website", bearblog/write.as/mataroa/telegra.ph/rentry stories, quartz/"digital garden", "I'd pay" markdown comments. Algolia ANDs multi-term comment queries, so several empties are narrow rather than proof of absence.
- Product Hunt: 19 pages fetched; write-md 403; Marked 3 and Markdown Studio had no comments captured.
- Reviews: 2,901 Mac App Store reviews (15 apps, 5 storefronts) and 538 iOS reviews. G2, Capterra, Setapp review text, Slashdot, Product Hunt reviews for Obsidian and HackMD were CAPTCHA-walled or empty.
- Pricing: 60 price points, nearly all first-party. Unreachable: bearblog.dev pricing, home.omg.lol, pastebin.com/pro, standardnotes.com (secondary sources used and marked INFERRED). No survey specific to markdown publishing exists as far as we could find.
- Not searched: Discord summaries, YouTube transcripts (no free path).

### 9.2 Verification report

Two verification passes ran on 2026-09-06 after the lanes finished. Full tables are in `verify-top10.md` and `verify-sample.md` next to this report.

| Pass | URLs checked | PASS | PARTIAL | FAIL | UNREACHABLE | Pass rate (of reachable) |
|---|---|---|---|---|---|---|
| Every URL behind the top-10 features | 72 | 71 | 1 | 0 | 0 | 98.6% |
| Seeded random 20% of the remaining 433 URLs (seed 20260906) | 87 | 78 | 1 | 2 | 6 | 96.3% |
| Combined | 159 | 149 | 2 | 2 | 6 | 97.4% |

Matching rule: PASS = at least 6 consecutive words of the quote found verbatim at the source (whitespace, smart-quote, and HTML-entity normalization allowed); for pricing pages, the figure appears on the page. Reddit and X quotes were matched against the raw API payloads saved with the lane files, since both sites block fetching.

Failures and what was done:
- Plannotator star count (AI-workflow lane, F28): the lane said 251 stars; GitHub reports about 8,488. Corrected everywhere in this report and marked in the lane file. The quote in that finding is from a review site, not GitHub, and was not affected.
- TechRadar "spectacularly ugly documents" (AI-workflow lane, F53 context note): the phrase is not on the page. Dropped; it was never used in this report.

Partials:
- Neowin, Claude share links indexed by Google (AI-workflow lane, F56): the live page is bot-walled; the Wayback copy confirms the incident for shared chats. The lane's added claim that published artifacts also leaked is not on the page and is not used in this report.
- r/ClaudeAI cross-post of ViewMD (Reddit lane, #40): the quote is verbatim in the primary r/macapps post; the cross-post pointer does not carry it. The finding stands on the primary URL.

Unreachable (6): G2 (GitBook, Notion, Obsidian Publish), Capterra Obsidian, softwareworld.co HackMD, and one 2024 r/htmx post sourced from pullpush.io. The four review-site URLs are cited in the competitor lane only as "bot-blocked, no quote taken", so nothing in this report depends on them. The r/htmx post (TXTD, custom URLs) is cited once in F9 with a vendor flag.

Minor wording notes counted as PASS: two X quotes had line breaks between sentences that the lane joined with a space; one HN quote had quotation marks around "per site" dropped; the Claude blog quote is verbatim in the raw HTML though the fetch summarizer paraphrased it.

### 9.3 Full source list

514 unique URLs cited across the seven lanes, with the lane(s) that cited each and the date of the source where the lane recorded one. Reddit and X URLs were verified against the raw API payloads saved alongside the lane files.

- https://www.reddit.com/r/Markdown/comments/1vu538c/what_is_the_least_confusing_way_to_share_a/ (Reddit; 2026-08-21)
- https://www.reddit.com/r/Markdown/comments/1vu538c/ (Reddit; 2026-08-21)
- https://www.reddit.com/r/Markdown/comments/1u3tpkl/how_do_you_share_single_markdown_files_quickly/ (Reddit; 2026-06-12)
- https://www.reddit.com/r/Markdown/comments/1u3tpkl/ (Reddit; 2026-06-12)
- https://www.reddit.com/r/ObsidianMD/comments/1sgom74/is_there_a_good_way_to_share_a_single_obsidian/ (Reddit; 2026-04-09)
- https://www.reddit.com/r/ObsidianMD/comments/1sgom74/ (Reddit; 2026-04-09)
- https://www.reddit.com/r/ObsidianMD/comments/1v4oerl/share_a_note_that_updates_when_i_make_changes_to/ (Reddit; 2026-07-23)
- https://www.reddit.com/r/ObsidianMD/comments/1v0x5ib/do_you_ever_have_the_just_share_some_notes_on/ (Reddit; 2026-07-19)
- https://www.reddit.com/r/ObsidianMD/comments/1v5dut5/how_can_i_publish_on_an_internal_website_or_share/ (Reddit; 2026-07-24)
- https://www.reddit.com/r/ObsidianMD/comments/1ucu4ef/sortable_tables_lists_publish/ (Reddit; 2026-06-26)
- https://www.reddit.com/r/ObsidianMD/comments/1stnbcx/built_a_plugin_to_publish_obsidian_notes_as_a/ (Reddit; 2026-04-23)
- https://www.reddit.com/r/ObsidianMD/comments/1sdv4cq/enhanced_obsidian_zola_another_alternative_to/ (Reddit; 2026-04-06)
- https://www.reddit.com/r/ObsidianMD/comments/1w544z2/two_years_syncing_obsidian_with_git_heres_the/ (Reddit; 2026-09-02)
- https://www.reddit.com/r/Notion/comments/1s4mq9x/how_do_you_guys_share_notion_pages_with_clients/ (Reddit; 2026-03-26)
- https://www.reddit.com/r/Notion/comments/1uz28v7/how_are_you_sharing_notion_with_clients_in_2026/ (Reddit; 2026-07-17)
- https://www.reddit.com/r/Slack/comments/1vy2zut/how_do_you_share_a_markdown_document_in_slack/ (Reddit; 2026-08-25)
- https://www.reddit.com/r/developersIndia/comments/1w8sy3g/built_rendermd_because_i_was_tired_of_sending/ (Reddit; 2026-09-06)
- https://www.reddit.com/r/selfhosted/comments/1t07xjn/markdownpdf_workbench_with_postgresbacked_share/ (Reddit; 2026-04-30)
- https://www.reddit.com/r/htmx/comments/1fkt0e6/txtd_instant_markdown_page_sharing_go_htmx_sqlite/ (Reddit; 2024-09-19)
- https://www.reddit.com/r/commandline/comments/1rm46uh/toss_a_minimal_cli_to_deploy_and_share_static/ (Reddit; 2026-03-06)
- https://www.reddit.com/r/Markdown/comments/1qefqx7/i_made_a_tool_to_publish_a_markdown_file_as_a/ (Reddit; 2026-01-16)
- https://www.reddit.com/r/Markdown/comments/1rx2ssm/publish_markdown_as_a_nice_site_via_web_or_cli_in/ (Reddit; 2026-03-18)
- https://www.reddit.com/r/Markdown/comments/1sm1sct/opensource_markdown_to_pdf_tool_fully_clientside/ (Reddit; 2026-04-15)
- https://www.reddit.com/r/ChatGPT/comments/1rlbcji/sick_of_messy_formatting_when_copying_from_ai_use/ (Reddit; 2026-03-05)
- https://www.reddit.com/r/ChatGPT/comments/1tt6klu/i_built_a_free_tool_to_export_full_chatgpt/ (Reddit; 2026-05-31)
- https://www.reddit.com/r/ObsidianMD/comments/1spx7qw/your_thoughts_on_this_use_of_obsidian/ (Reddit; 2026-04-19)
- https://www.reddit.com/r/selfhosted/comments/1to72gh/leafwiki_v0100_selfhosted_wiki_single_go_binary/ (Reddit; 2026-05-26)
- https://www.reddit.com/r/ClaudeAI/comments/1w0jpzo/im_tired_of_reading_specs_and_plans/ (Reddit; 2026-08-28)
- https://www.reddit.com/r/ClaudeAI/comments/1w0jpzo/ (Reddit; 2026-08-28)
- https://www.reddit.com/r/ClaudeAI/comments/1vlwqlq/opensource_topdown_md_visualizer/ (Reddit; 2026-08-11)
- https://www.reddit.com/r/macapps/comments/1rhwmmz/os_pixley_reader_read_the_markdown_files_your_ai/ (Reddit; 2026-03-01)
- https://www.reddit.com/r/macapps/comments/1rhwmmz/ (Reddit; 2026-03-01)
- https://www.reddit.com/r/macapps/comments/1qki0f5/viewmd_a_viewonly_markdown_reader_i_built_for/ (Reddit; 2026-01-23)
- https://www.reddit.com/r/ClaudeAI/comments/1qkhw9h/ (Reddit; 2026-01-23)
- https://www.reddit.com/r/ClaudeAI/comments/1s54dmy/simple_tool_that_made_my_claude_code_workflow/ (Reddit; 2026-03-27)
- https://www.reddit.com/r/ClaudeAI/comments/1ujfbsw/i_built_a_free_ios_app_to_read_the_markdown_files/ (Reddit; 2026-06-30)
- https://www.reddit.com/r/Markdown/comments/1upe3x3/markdown_with_mermaid_diagrams_the_instant_you/ (Reddit; 2026-07-06)
- https://www.reddit.com/r/macapps/comments/1uyno3w/mdv_a_clean_markdown_viewer_for_mac_from_the/ (Reddit; 2026-07-17)
- https://www.reddit.com/r/macapps/comments/1tqchj9/telescopo_7_free_native_markdown_viewer_now_with/ (Reddit; 2026-05-28)
- https://www.reddit.com/r/Markdown/comments/1uxzq67/markdownblaze_a_free_offline_markdown_viewer_that/ (Reddit; 2026-07-16)
- https://www.reddit.com/r/selfhosted/comments/1upxfsd/ive_been_building_a_selfhosted_markdown_knowledge/ (Reddit; 2026-07-07)
- https://www.reddit.com/r/CraftDocs/comments/1tyb8zo/from_markdown_to_stylised_docx_and_pdf/ (Reddit; 2026-06-06)
- https://www.reddit.com/r/ChatGPT/comments/1ritdy9/how_to_make_chatgpt_get_me_a_usable_copypaste_md/ (Reddit; 2026-03-02)
- https://www.reddit.com/r/ClaudeCode/comments/1vztrja/i_spent_months_blaming_the_model_the_bugs_were_in/ (Reddit; 2026-08-27)
- https://x.com/trq212/status/2052811606032269638 (X; 2026-05-08)
- https://x.com/trq212/status/2067021344341098670 (X; 2026-06-16)
- https://x.com/trq212/status/2067682475611242546 (X; 2026-06-18)
- https://x.com/clairevo/status/2056428390773825701 (X; 2026-05-18)
- https://x.com/ghumare64/status/2053106700324897063 (X; 2026-05-09)
- https://x.com/NoahEpstein_/status/2053057504473416096 (X; 2026-05-09)
- https://x.com/kunchenguid/status/2054010987871883764 (X; 2026-05-12)
- https://x.com/kunchenguid/status/2054269845966041426 (X; 2026-05-12)
- https://x.com/theo/status/2054456151308369952 (X; 2026-05-13)
- https://x.com/0xwhrrari/status/2061107868883947953 (X; 2026-05-31)
- https://x.com/hanakoxbt/status/2060836730589028421 (X; 2026-05-31)
- https://x.com/wilczyn/status/2088234188172333206 (X; 2026-08-14)
- https://x.com/TAbrodi/status/2052814887852933172 (X; 2026-05-08)
- https://x.com/Shpigford/status/2034365122638954924 (X; 2026-03-18)
- https://x.com/yashbanka123/status/2078459197084295556 (X; 2026-07-18)
- https://x.com/linuz90/status/2045445639476330980 (X; 2026-04-18)
- https://x.com/linuz90/status/2008840566633857244 (X; 2026-01-07)
- https://x.com/irl_danB/status/2090101401506512927 (X; 2026-08-19)
- https://x.com/DannyAziz97/status/1943026482952946013 (X; 2025-07-09)
- https://x.com/davis7/status/1819897282088603825 (X; 2025-07-09)
- https://x.com/walkingriver/status/1763230781495718085 (X; 2025-07-09)
- https://x.com/om_patel5/status/2077191346813653175 (X; 2026-07-15)
- https://x.com/AIandTechh87/status/2077598637539123552 (X; 2026-07-15)
- https://x.com/patrickmineault/status/2037907043063832669 (X; 2026-03-28)
- https://x.com/davidmarcus/status/2037973301876908395 (X; 2026-03-28)
- https://x.com/robjama/status/2008748294059815155 (X; 2026-01-07)
- https://x.com/burkov/status/1924322379821449627 (X; 2025-05-19)
- https://x.com/xeophon/status/1963198199247634525 (X; 2025-05-19)
- https://x.com/banteg/status/1900969607541789062 (X; 2025-03-15)
- https://x.com/linuz90/status/2031377772145422635 (X; 2026-03-10)
- https://x.com/MaypazOr/status/2041128587080692160 (X; 2026-04-06)
- https://x.com/goldkey/status/2024935050454990853 (X; 2026-02-20)
- https://x.com/goldkey/status/2027469168203936211 (X; 2026-02-20)
- https://x.com/goldkey/status/2070967542806667389 (X; 2026-02-20)
- https://x.com/mmazco/status/2080459330890223754 (X; 2026-07-24)
- https://x.com/frankdilo/status/2009565324061073656 (X; 2026-01-09)
- https://x.com/jfversluis/status/2039689306017759441 (X; 2026-04-02)
- https://x.com/GHCopilotLog/status/2066007753550651412 (X; 2026-06-14)
- https://x.com/strickvl/status/1920167651495563449 (X; 2025-05-07)
- https://x.com/blackgirlbytes/status/2052757292093718965 (X; 2026-05-08)
- https://x.com/tibudiyanto/status/1894255930537382146 (X; 2025-02-25)
- https://x.com/nosilverv/status/1838193238064197782 (X; 2024-09-23)
- https://x.com/td10rpg/status/1973569419755528471 (X; 2025-10-02)
- https://x.com/tom_doerr/status/2072085903913206123 (X; 2026-06-30)
- https://x.com/xdadevelopers/status/1979185782175744454 (X)
- https://x.com/mischavdburg/status/1895878245691662683 (X)
- https://x.com/teej_dv/status/1831443228568289331 (X; 2024-09-04)
- https://x.com/obsdmd/status/2036880481980146149 (X; 2026-03-25)
- https://x.com/networkspirits/status/2037098897831580142 (X; 2026-03-26)
- https://x.com/apoorveth/status/2037151068292080107 (X; 2026-03-26)
- https://x.com/shazow/status/2065104734982218220 (X; 2026-03-26)
- https://x.com/k1rallik/status/2045925731885035877 (X; 2026-04-19)
- https://x.com/alex_prompter/status/2081327819800576085 (X; 2026-07)
- https://x.com/xadhish/status/1897624883225571629 (X; 2025-03-06)
- https://x.com/VazeKshitij/status/2008745266850263343 (X; 2026-01-07)
- https://x.com/aetosdios_/status/2085981438118420888 (X; 2026-08-08)
- https://x.com/joncphillips/status/2044429411689128133 (X; 2026-04-15)
- https://x.com/andrewglynch/status/2069367728641659146 (X)
- https://x.com/rudolfscode/status/2083095294401524189 (X)
- https://x.com/coffeewithone/status/2038796479444496824 (X; 2026-03-31)
- https://x.com/dani_avila7/status/2043512977672765748 (X; 2026-04-13)
- https://x.com/DanielleFong/status/2010114522271625720 (X; 2026-01-10)
- https://news.ycombinator.com/item?id=47777633 (HN/PH, AI workflow; 2026-04-15)
- https://news.ycombinator.com/item?id=47822607 (HN/PH; 2026-04-19)
- https://news.ycombinator.com/item?id=48720506 (HN/PH; 2026-06-29)
- https://news.ycombinator.com/item?id=48431648 (HN/PH; 2026-06-07)
- https://news.ycombinator.com/item?id=47166806 (HN/PH; 2026-02-26)
- https://news.ycombinator.com/item?id=49514729 (HN/PH; 2026-08-31)
- https://news.ycombinator.com/item?id=47795468 (HN/PH, AI workflow; 2026-04-16)
- https://news.ycombinator.com/item?id=48200226 (HN/PH; 2026-05-19)
- https://news.ycombinator.com/item?id=47015111 (HN/PH; 2026-02-14)
- https://news.ycombinator.com/item?id=49111536 (HN/PH; 2026-07-30)
- https://news.ycombinator.com/item?id=48400742 (HN/PH; 2026-06-04)
- https://news.ycombinator.com/item?id=46318191 (HN/PH; 2025-12-18)
- https://www.producthunt.com/products/glance-native-macos-markdown-viewer (HN/PH; 2026-05-15)
- https://www.producthunt.com/products/showmd-ai-markdown-quicklook-preview (HN/PH; 2026-04-13)
- https://www.producthunt.com/products/md-html-reader (HN/PH; 2026-06-22)
- https://www.producthunt.com/products/looq-3 (HN/PH; 2026-03-20)
- https://www.producthunt.com/products/marked-ql (HN/PH; 2026-07-13)
- https://news.ycombinator.com/item?id=46600762 (HN/PH; 2026-01-13)
- https://news.ycombinator.com/item?id=48410589 (HN/PH; 2026-06-05)
- https://news.ycombinator.com/item?id=46975959 (HN/PH, AI workflow; 2026-02-11)
- https://news.ycombinator.com/item?id=46645942 (HN/PH, Competitors, AI workflow; 2026-01-16)
- https://news.ycombinator.com/item?id=48590505 (HN/PH; 2026-06-18)
- https://news.ycombinator.com/item?id=45002329 (HN/PH; 2025-08-24)
- https://news.ycombinator.com/item?id=37776935 (HN/PH; 2023-10-05)
- https://www.producthunt.com/products/uselink (HN/PH; 2026-06-03)
- https://news.ycombinator.com/item?id=48749414 (HN/PH; 2026-07-01)
- https://www.producthunt.com/products/claudebin (HN/PH; 2026-02-20)
- https://www.producthunt.com/products/flowershow (HN/PH; 2026-03-25)
- https://news.ycombinator.com/item?id=48675435 (HN/PH; 2026-06-25)
- https://news.ycombinator.com/item?id=42207846 (HN/PH; 2024-11-21)
- https://www.producthunt.com/posts/markdown-bin (HN/PH)
- https://www.producthunt.com/products/markdown-share (HN/PH)
- https://news.ycombinator.com/item?id=46896623 (HN/PH; 2026-02-05)
- https://www.producthunt.com/products/git-blog (HN/PH; 2026-03-30)
- https://news.ycombinator.com/item?id=43118805 (HN/PH; 2025-02-20)
- https://news.ycombinator.com/item?id=43773645 (HN/PH; 2025-04-23)
- https://news.ycombinator.com/item?id=42572156 (HN/PH; 2025-01-02)
- https://news.ycombinator.com/item?id=43772509 (HN/PH; 2025-04-23)
- https://news.ycombinator.com/item?id=41782438 (HN/PH; 2024-10-08)
- https://news.ycombinator.com/item?id=48181937 (HN/PH; 2026-05-18)
- https://news.ycombinator.com/item?id=29360720 (HN/PH, Competitors; 2021-11-27)
- https://news.ycombinator.com/item?id=41825041 (HN/PH; 2024-10-13)
- https://news.ycombinator.com/item?id=46571980 (HN/PH; 2026-01-11)
- https://news.ycombinator.com/item?id=48767053 (HN/PH; 2026-07-02)
- https://news.ycombinator.com/item?id=46312003 (HN/PH; 2026-07-02)
- https://www.producthunt.com/products/hackmd (HN/PH; 2024-08-29)
- https://www.producthunt.com/products/mataroa (HN/PH)
- https://www.producthunt.com/products/marked-2 (HN/PH; 2026-05-28)
- https://news.ycombinator.com/item?id=13005792 (HN/PH; 2016-11-21)
- https://www.producthunt.com/products/openmarkdown (HN/PH; 2026-07-18)
- https://obsidian.md/pricing (Competitors, Pricing; 2026-09-06)
- https://obsidian.md/help/publish/domains (Competitors; 2026-09-06)
- https://www.notion.com/pricing (Competitors, Pricing; 2026-09-06)
- https://www.notion.com/help/notion-sites-availability-and-pricing (Competitors; 2026-09-06)
- https://hackmd.io/pricing (Competitors, Pricing; 2026-09-06)
- https://homepage.hackmd.io/pricing (Competitors; 2026-09-06)
- https://hackmd.io/@docs/Personal-Prime-subscription-management-en (Competitors; 2026-09-06)
- https://bear.app/faq/features-and-price-of-bear-pro/ (Competitors; 2026-09-06)
- https://ia.net/writer/pricing (Competitors, Pricing; 2026-09-06)
- https://typora.io/ (Competitors; 2026-09-06)
- https://markedapp.com/pricing/ (Competitors; 2026-09-06)
- https://share.markedapp.com/about (Competitors; 2026-09-06)
- https://brettterpstra.com/2026/08/29/marked-share-markdown-publishing/ (Competitors; 2026-09-06)
- https://www.craft.do/pricing (Competitors, Pricing; 2026-09-06)
- https://support.craft.do/hc/en-us/articles/360019332337-Publishing-With-Craft-Web-Links (Competitors; 2026-09-06)
- http://ulysses.app/pricing/ (Competitors, Pricing; 2026-09-06)
- https://help.ulysses.app/publishing (Competitors; 2026-09-06)
- https://quarto.org/docs/publishing/quarto-pub.html (Competitors; 2026-09-06)
- https://quartopub.com/ (Competitors; 2026-09-06)
- https://docs.github.com/en/get-started/writing-on-github/editing-and-sharing-content-with-gists/creating-gists (Competitors, Pricing; 2026-09-06)
- https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits (Competitors; 2026-09-06)
- https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages (Competitors; 2026-09-06)
- https://github.com/pricing (Competitors; 2026-09-06)
- https://hashnode.com/pro (Competitors; 2026-09-06)
- https://mintlify.com/pricing (Competitors; 2026-09-06)
- https://www.gitbook.com/pricing (Competitors; 2026-09-06)
- https://docusaurus.io/docs/deployment (Competitors; 2026-09-06)
- https://vercel.com/pricing (Competitors, Pricing; 2026-09-06)
- https://www.netlify.com/pricing/ (Competitors, Pricing; 2026-09-06)
- https://www.dropbox.com/plans (Competitors; 2026-09-06)
- https://help.dropbox.com/view-edit/paper-faqs (Competitors; 2026-09-06)
- https://directionforward.com/news/2025/end-of-life-for-dropbox-paper-apps (Competitors; 2026-09-06)
- https://support.google.com/docs/answer/183965 (Competitors; 2026-09-06)
- https://workspace.google.com/pricing (Competitors; 2026-09-06)
- https://www.name.com/blog/google-workspace-pricing (Competitors; 2026-09-06)
- https://readme.com/pricing (Competitors; 2026-09-06)
- https://www.jamdesk.com/blog/the-definitive-api-documentation-pricing-comparison-2026-2 (Competitors; 2026-09-06)
- https://rentry.co/what (Competitors; 2026-09-06)
- https://telegra.ph/ (Competitors, Pricing; 2026-09-06)
- https://blog.sakuragawa.moe/some-hints-on-telegra-ph-2020/ (Competitors; 2026-09-06)
- https://write.as/pricing (Competitors, Pricing; 2026-09-06)
- https://bearblog.dev/ (Competitors; 2026-09-06)
- https://makerstack.co/reviews/bear-blog-review/ (Competitors; 2026-09-06)
- https://docs.bearblog.dev/custom-domains/ (Competitors; 2026-09-06)
- https://mataroa.blog/ (Competitors, Pricing; 2026-09-06)
- https://montaigne.io/pricing (Competitors, Pricing; 2026-09-06)
- https://quartz.jzhao.xyz/ (Competitors; 2026-09-06)
- https://silverbullet.md/ (Competitors; 2026-09-06)
- https://getpublii.com/ (Competitors; 2026-09-06)
- https://github.com/jonstodle/obsius-obsidian-plugin (Competitors; 2026-09-06)
- https://obsius.site/ (Competitors; 2026-09-06)
- https://github.com/alangrainger/share-note (Competitors; 2026-09-06)
- https://dillinger.io/ (Competitors; 2026-09-06)
- https://stackedit.io/ (Competitors; 2026-09-06)
- https://hedgedoc.org/ (Competitors; 2026-09-06)
- https://docs.hedgedoc.org/ (Competitors; 2026-09-06)
- https://glasp.co/pricing (Competitors; 2026-09-06)
- https://mdtolink.com/ (Competitors, AI workflow; 2026-09-06)
- https://www.jotbird.com/ (Competitors; 2026-09-06)
- https://lfmarkdown.com/en (Competitors; 2026-09-06)
- https://mdshares.com/ (Competitors; 2026-09-06)
- https://mdshare.live/ (Competitors; 2026-09-06)
- https://www.mdshare.online/ (Competitors; 2026-09-06)
- https://www.pastemd.com/ (Competitors; 2026-09-06)
- https://boomurl.com/guides/markdown-publishing (Competitors; 2026-09-06)
- https://news.ycombinator.com/item?id=45564630 (Competitors; 2026-09-06)
- https://docsify-this.net/ (Competitors; 2026-09-06)
- https://hosted.md/ (Competitors; 2026-09-06)
- https://unmarkdown.com/blog/best-markdown-publishing-tools-2026 (Competitors; 2026-09-06)
- https://news.ycombinator.com/item?id=40249020 (Competitors, Pricing)
- https://forum.obsidian.md/t/obsidian-publish-password-protect-only-parts-of-the-website-individual-notes/13947?page=3 (Competitors)
- https://writing.bobdoto.computer/obsidian-publish-should-not-cost-198-a-year-to-use/ (Competitors)
- https://news.ycombinator.com/item?id=40792970 (Competitors)
- https://pagelive.io/blog/notion-password-protected-page (Competitors)
- https://gridfiti.com/notion-custom-domain/ (Competitors)
- https://www.softwareworld.co/software/hackmd-reviews/ (Competitors)
- https://community.bear.app/t/sharing-a-note-as-a-public-post-online/17588 (Competitors)
- https://community.bear.app/t/collaborate-and-share-notes/18585 (Competitors)
- https://apps.apple.com/us/app/ia-writer/id775737590 (Competitors)
- https://elephas.app/blog/iawriter-review (Competitors)
- https://github.com/typora/typora-issues/issues/4963 (Competitors)
- https://setapp.com/apps/marked/customer-reviews (Competitors)
- https://websites2know.com/craft-do-review/ (Competitors)
- https://www.techrepublic.com/article/craft-review/ (Competitors)
- https://apps.apple.com/us/app/ulysses/id1225571038 (Competitors)
- https://github.com/quarto-dev/quarto-cli/discussions/10965 (Competitors)
- https://github.com/quarto-dev/quarto-cli/discussions/3182 (Competitors)
- https://news.ycombinator.com/item?id=30607367 (Competitors)
- https://blog.greenflux.us/it-might-be-time-to-migrate-your-hashnode-blog/ (Competitors)
- https://blog.derlin.ch/why-and-how-i-left-hashnode/ (Competitors)
- https://news.ycombinator.com/item?id=39730929 (Competitors)
- https://bunnydesk.ai/blog/mintlify-pricing/ (Competitors)
- https://www.featurebase.app/blog/mintlify-pricing (Competitors)
- https://dev.to/mjkloski/we-used-gitbook-for-two-years-heres-the-honest-post-mortem-of-why-we-left-52fm (Competitors)
- https://news.ycombinator.com/item?id=22264969 (Competitors)
- https://github.com/facebook/docusaurus/discussions/11140 (Competitors)
- https://ferndesk.com/blog/docusaurus-review (Competitors)
- https://news.ycombinator.com/item?id=32303052 (Competitors)
- https://community.dropbox.com/en/discussion/839283/migrated-paper-docs-folders-are-all-empty (Competitors)
- https://x.com/kepano/status/1965503282690101340 (Competitors)
- https://support.google.com/docs/thread/294318146/formatting-is-being-messed-up-when-i-publish-doc-on-web?hl=en (Competitors)
- https://support.google.com/docs/thread/201414958/google-docs-web-publishing-formatting-issue?hl=en (Competitors)
- https://support.google.com/docs/thread/42902756?hl=en (Competitors)
- https://www.capterra.com/p/218577/ReadMe/ (Competitors)
- https://updownradar.com/status/rentry.co (Competitors)
- https://www.capterra.com/p/176780/Write-as/reviews/ (Competitors)
- https://news.ycombinator.com/item?id=45372464 (Competitors)
- https://news.ycombinator.com/item?id=45105991 (Competitors)
- https://verysimpleblogging.com/mataroa/ (Competitors)
- https://news.ycombinator.com/item?id=38706190 (Competitors)
- https://github.com/jackyzha0/quartz/issues/2164 (Competitors)
- https://github.com/jackyzha0/quartz/issues/1560 (Competitors)
- https://github.com/jackyzha0/quartz/issues/1828 (Competitors)
- https://news.ycombinator.com/item?id=41567406 (Competitors)
- https://slashdot.org/software/p/HedgeDoc/ (Competitors)
- https://forum.obsidian.md/t/share-note-plugin-share-individual-notes-with-full-support-for-themes-images-dataview-callouts-and-more/42788?page=5 (Competitors)
- https://github.com/typora/typora-issues/issues/710 (Reviews; 2017-05-18)
- https://itunes.apple.com/us/rss/customerreviews/id=6760943472/sortBy=mostRecent/json (Reviews; 2026-08-12)
- https://itunes.apple.com/us/rss/customerreviews/id=1507139439/sortBy=mostRecent/json (Reviews; 2026-07-20)
- https://itunes.apple.com/us/rss/customerreviews/id=775737590/sortBy=mostRecent/json (Reviews; 2026-02-09)
- https://github.com/sbarex/QLMarkdown/issues/161 (Reviews; 2025-08-14)
- https://github.com/sbarex/QLMarkdown/issues/165 (Reviews; 2025-08-27)
- https://github.com/sbarex/QLMarkdown/issues/202 (Reviews; 2026-05-19)
- https://github.com/sbarex/QLMarkdown/issues/162 (Reviews; 2025-08-15)
- https://github.com/gonzalezreal/swift-markdown-ui/issues/300 (Reviews; 2024-02-13)
- https://github.com/gonzalezreal/swift-markdown-ui/issues/264 (Reviews; 2023-10-06)
- https://itunes.apple.com/de/rss/customerreviews/id=890031187/sortBy=mostRecent/json (Reviews; 2026-06-28)
- https://forum.obsidian.md/t/obsidian-publish-single-page-sharing-with-secret-url/23131 (Reviews; 2021-08-25)
- https://forum.obsidian.md/t/obsidian-publish-password-protect-only-parts-of-the-website-individual-notes/13947 (Reviews; 2021-03-03)
- https://forum.obsidian.md/t/71330 (Reviews; 2023-11-15)
- https://forum.obsidian.md/t/support-all-file-types-for-the-publish-service/24908 (Reviews; 2025-12-31)
- https://forum.obsidian.md/t/option-to-pay-for-additional-storage-in-obsidian-publish/49199 (Reviews; 2022-12-09)
- https://forum.obsidian.md/t/publish-compress-images-on-server/99986 (Reviews; 2025-04-25)
- https://forum.obsidian.md/t/alternatives-to-cloudfare-for-custom-domain-publish/11766 (Reviews; 2021-01-21)
- https://help.obsidian.md/Obsidian+Publish/Custom+domains (Reviews; 2023-07-22)
- https://forum.obsidian.md/t/15595 (Reviews; 2021-03-30)
- https://forum.obsidian.md/t/14755 (Reviews; 2021-03-17)
- https://forum.obsidian.md/t/obsidian-publish-alternatives/22886 (Reviews; 2021-08-20)
- https://forum.obsidian.md/t/111466 (Reviews; 2026-02-21)
- https://forum.obsidian.md/t/115856 (Reviews; 2026-07-04)
- https://forum.obsidian.md/t/104086 (Reviews; 2026-07-04)
- https://forum.obsidian.md/t/seeking-an-alternative-to-obsidian-publish-for-sharing-vaults/82466 (Reviews; 2024-05-26)
- https://itunes.apple.com/gb/rss/customerreviews/id=1487937127/sortBy=mostRecent/json (Reviews; 2024-05-24)
- https://itunes.apple.com/us/rss/customerreviews/id=1091189122/sortBy=mostRecent/json (Reviews; 2026-05-26)
- https://itunes.apple.com/gb/rss/customerreviews/id=1232780281/sortBy=mostRecent/json (Reviews; 2025-08-28)
- https://www.softwareadvice.com/project-management/notion-profile/reviews/ (Reviews; 2025-08-28)
- https://www.softwareadvice.com/knowledge-management/obsidian-profile/reviews/ (Reviews; 2025-12-06)
- https://forum.obsidian.md/t/108755 (Reviews; 2025-12-06)
- https://github.com/hackmdio/codimd/issues/35 (Reviews; 2015-10-02)
- https://itunes.apple.com/us/rss/customerreviews/id=1225570693/sortBy=mostRecent/json (Reviews; 2024-01)
- https://itunes.apple.com/de/rss/customerreviews/id=1487937127/sortBy=mostRecent/json (Reviews; 2024-09-22)
- https://itunes.apple.com/us/rss/customerreviews/id=1527036273/sortBy=mostRecent/json (Reviews; 2026-07-12)
- https://forum.obsidian.md/t/your-pricing-model-needs-work/96575 (Reviews, Pricing; 2025-02-12)
- https://forum.obsidian.md/t/6450 (Reviews; 2024-07-16)
- https://forum.obsidian.md/t/26329 (Reviews; 2024-03-12)
- https://itunes.apple.com/us/rss/customerreviews/id=1232780281/sortBy=mostRecent/json (Reviews; 2026-07-23)
- https://www.g2.com/products/obsidian-publish/reviews (Reviews)
- https://www.g2.com/products/hackmd/reviews (Reviews)
- https://www.g2.com/products/gitbook/reviews?qs=cons (Reviews)
- https://www.g2.com/products/notion/reviews (Reviews)
- https://www.capterra.com/p/186596/Notion/reviews/?rating=1,2,3 (Reviews)
- https://www.capterra.com/p/10004063/Obsidian/reviews/ (Reviews)
- https://www.producthunt.com/products/obsidian/reviews (Reviews)
- https://www.producthunt.com/products/hackmd/reviews (Reviews)
- https://github.com/anthropics/claude-code/issues/13600 (AI workflow; 2025-12-10)
- https://github.com/anthropics/claude-code/issues/13600#issuecomment-3779896378 (AI workflow; 2026-01-21)
- https://github.com/anthropics/claude-code/issues/13600#issuecomment-5427058273 (AI workflow; 2026-08-26)
- https://github.com/anthropics/claude-code/issues/13600#issuecomment-5339092499 (AI workflow; 2026-08-19)
- https://github.com/anthropics/claude-code/issues/13600#issuecomment-3725375874 (AI workflow; 2026-01-08)
- https://github.com/anthropics/claude-code/issues/43113 (AI workflow; 2026-04-03)
- https://github.com/anthropics/claude-code/issues/14375 (AI workflow; 2025-12-17)
- https://github.com/anthropics/claude-code/issues/16446 (AI workflow; 2026-01-06)
- https://github.com/anthropics/claude-code/issues/65632 (AI workflow; 2026-06-05)
- https://github.com/openai/codex/issues/11329 (AI workflow; 2026-02-10)
- https://github.com/openai/codex/issues/22015 (AI workflow; 2026-05-10)
- https://github.com/openai/codex/issues/23212 (AI workflow; 2026-05-17)
- https://github.com/google-gemini/gemini-cli/issues/6499 (AI workflow; 2025-08-18)
- https://news.ycombinator.com/item?id=47378374 (AI workflow; 2026-03-14)
- https://github.com/GRVYDEV/marky (AI workflow; 2026-04-16)
- https://news.ycombinator.com/item?id=47805126 (AI workflow; 2026-04-16)
- https://news.ycombinator.com/item?id=47800383 (AI workflow; 2026-04-16)
- https://news.ycombinator.com/item?id=47801215 (AI workflow; 2026-04-17)
- https://news.ycombinator.com/item?id=47806667 (AI workflow; 2026-04-17)
- https://news.ycombinator.com/item?id=47801418 (AI workflow; 2026-04-17)
- https://news.ycombinator.com/item?id=47801737 (AI workflow; 2026-04-17)
- https://news.ycombinator.com/item?id=47822293 (AI workflow; 2026-04-15)
- https://news.ycombinator.com/item?id=47825767 (AI workflow; 2026-04-19)
- https://news.ycombinator.com/item?id=47821948 (AI workflow; 2026-04-19)
- https://news.ycombinator.com/item?id=47822640 (AI workflow; 2026-04-19)
- https://dev.to/arthur_teb/i-got-tired-of-reading-claude-codes-md-files-in-vs-code-so-i-built-a-native-mac-viewer-4glb (AI workflow; 2026-07-08)
- https://macmdviewer.com/blog/read-claude-code-plans-mac (AI workflow; 2026-07-30)
- https://macmdviewer.com/blog/view-ai-markdown-output-mac (AI workflow; 2026-05-14)
- https://mdhero.app/blogs/viewing-markdown-mac-2026/ (AI workflow; 2026-04-22)
- https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html (AI workflow; 2026-05-08)
- https://news.ycombinator.com/item?id=48071940 (AI workflow; 2026-05-08)
- https://news.ycombinator.com/item?id=48072400 (AI workflow; 2026-05-09)
- https://news.ycombinator.com/item?id=48072393 (AI workflow; 2026-05-09)
- https://news.ycombinator.com/item?id=48072368 (AI workflow; 2026-05-09)
- https://news.ycombinator.com/item?id=48072214 (AI workflow; 2026-05-09)
- https://news.ycombinator.com/item?id=48073056 (AI workflow; 2026-05-09)
- https://news.ycombinator.com/item?id=48072197 (AI workflow; 2026-05-09)
- https://forum.cursor.com/t/cant-view-plan-on-markdown-mode/136853 (AI workflow; 2025-10-09)
- https://forum.cursor.com/t/plan-mode-markdown-file-cant-be-previewed/140762 (AI workflow; 2025-11-03)
- https://forum.cursor.com/t/cursor-markdown-rendering-formatting-tables-mermaid/147558 (AI workflow; 2025-12-29)
- https://forum.cursor.com/t/markdown-file-woes/147088 (AI workflow; 2025-12-23)
- https://news.ycombinator.com/item?id=47021389 (AI workflow; 2026-02-15)
- https://news.ycombinator.com/item?id=47455670 (AI workflow; 2026-03-20)
- https://news.ycombinator.com/item?id=46674404 (AI workflow; 2026-01-19)
- https://github.com/backnotprop/plannotator (AI workflow; 2026-08-04)
- https://vibecodinghub.org/tools/plannotator (AI workflow; 2026-08-04)
- https://claudelog.com/faqs/what-is-ultraplan-in-claude-code/ (AI workflow; 2026-08-04)
- https://github.com/anthropics/claude-code/issues/82643 (AI workflow; 2026-07-30)
- https://github.com/charmbracelet/glow/issues/968 (AI workflow; 2026-06-01)
- https://news.ycombinator.com/item?id=49546673 (AI workflow; 2026-09-03)
- https://news.ycombinator.com/item?id=48402462 (AI workflow; 2026-06-04)
- https://blog.steveendow.com/2025/11/working-with-markdown-md-files-in-age.html (AI workflow; 2025-11-22)
- https://help.zoho.com/portal/en/community/topic/feature-request-render-markdown-md-files-in-zoho-cliq (AI workflow; 2025-20)
- https://github.com/anthropics/claude-code/issues/11651 (AI workflow; 2025-11-14)
- https://github.com/anthropics/claude-code/issues/34196 (AI workflow; 2026-03-13)
- https://github.com/anthropics/claude-code/issues/859 (AI workflow; 2025-04-24)
- https://github.com/anthropics/claude-code/issues/859#issuecomment-3788769504 (AI workflow; 2026-01-23)
- https://github.com/anthropics/claude-code/issues/859#issuecomment-3975731909 (AI workflow; 2026-02-27)
- https://github.com/anthropics/claude-code/issues/5512 (AI workflow; 2025-08-10)
- https://github.com/anthropics/claude-code/issues/18170 (AI workflow; 2026-01-14)
- https://github.com/anthropics/claude-code/issues/15199 (AI workflow; 2025-12-23)
- https://github.com/anthropics/claude-code/issues/54670 (AI workflow; 2026-04-29)
- https://github.com/anthropics/claude-code/issues/13714 (AI workflow; 2025-12-11)
- https://github.com/anthropics/claude-code/issues/2887 (AI workflow; 2025-07-02)
- https://github.com/anthropics/claude-code/issues/39587 (AI workflow; 2026-03-26)
- https://github.com/anthropics/claude-code/issues/209 (AI workflow; 2025-02-27)
- https://github.com/cline/cline/issues/13 (AI workflow; 2024-07-20)
- https://dev.to/gregce10/built-a-cli-wrapper-that-auto-saves-your-claude-code-chats-as-markdown-files-3ld9 (AI workflow; 2025-06-26)
- https://hannahstulberg.substack.com/p/claude-code-for-everything-draft-in-claude-code-collaborate-in-notion (AI workflow; 2026-01-26)
- https://dev.to/bunty_shah_fac2bef694e9c9/gemini-is-the-best-ai-for-deep-research-and-the-worst-for-actually-using-the-output-453m (AI workflow; 2026-03-26)
- https://support.google.com/gemini/thread/348490672/export-deep-research-report-without-loss (AI workflow)
- https://support.google.com/gemini/thread/384844921/cannot-export-gemini-to-docs-without-losing-formatting (AI workflow)
- https://support.google.com/docs/thread/356697768/paste-from-markdown-now-creates-unwanted-code-blocks (AI workflow)
- https://news.ycombinator.com/item?id=47331366 (AI workflow; 2026-03-11)
- https://news.ycombinator.com/item?id=46970531 (AI workflow; 2026-02-11)
- https://news.ycombinator.com/item?id=42845165 (AI workflow; 2025-01-27)
- https://news.ycombinator.com/item?id=47319011 (AI workflow; 2026-03-10)
- https://news.ycombinator.com/item?id=47186130 (AI workflow; 2026-02-27)
- https://news.ycombinator.com/item?id=43382252 (AI workflow; 2025-03-16)
- https://pactify.io/blog/how-to-export-chatgpt-to-notion-without-losing-formatting (AI workflow; 2026-01-31)
- https://news.ycombinator.com/item?id=45822274 (AI workflow; 2025-11-05)
- https://community.openai.com/t/exporting-deep-research-reports/1149810 (AI workflow; 2025-03-22)
- https://www.techradar.com/computing/artificial-intelligence/this-new-chatgpt-feature-solves-the-most-annoying-thing-about-deep-research (AI workflow; 2025-03-22)
- https://community.openai.com/t/get-a-public-link-of-chatgpt-reply/985795 (AI workflow; 2024-10-20)
- https://amitkoth.com/claude-share-link-not-working/ (AI workflow; 2026-07-31)
- https://www.bitdefender.com/en-us/blog/hotforsecurity/your-shared-chatgpt-chats-may-be-publicly-searchable-heres-how-to-delete-them (AI workflow; 2026-07-25)
- https://www.neowin.net/news/your-claude-conversations-may-have-leaked-online-if-you-did-this/ (AI workflow; 2026-07-25)
- https://community.mindstudio.ai/t/deep-research-agent-editing-downloading-output/866 (AI workflow; 2025-05-12)
- https://forum.obsidian.md/t/notes-sharing/85371 (AI workflow; 2024-07-15)
- https://github.com/alangrainger/share-note/issues/5 (AI workflow; 2024-07-15)
- https://news.ycombinator.com/item?id=46974121 (AI workflow; 2026-02-11)
- https://blog.sivaramp.com/blog/introducing-mdbin/ (AI workflow; 2025-10-15)
- https://www.markshare.to/blog/how-to-share-markdown-online (AI workflow; 2026-01-09)
- https://news.ycombinator.com/item?id=48090474 (AI workflow; 2026-05-11)
- https://news.ycombinator.com/item?id=48622133 (AI workflow)
- https://unmarkdown.com/blog/the-ai-formatting-problem (AI workflow; 2026-03-02)
- https://news.ycombinator.com/item?id=47790227 (AI workflow; 2026-04-16)
- https://omglol.news/2026/06/25/omg-lol-membership-price-increases-august-1 (Pricing; 2026-08-01)
- https://linkage.lol/omglol-is-the-best-thing-on-the-internet/ (Pricing; 2026-08-01)
- https://news.ycombinator.com/item?id=38937143 (Pricing; 2024-01-10)
- https://verysimpleblogging.com/bear-blog/ (Pricing; 2024-01-10)
- https://boringcashcow.com/interview/interview-with-the-founder-of-bearblog (Pricing; 2024-01-10)
- https://pika.page/ (Pricing; 2026-08-01)
- https://scribbles.page/ (Pricing; 2026-08-01)
- https://obsidian.md/blog/standard-plan/ (Pricing; 2024-03-20)
- https://hackmd.io/@docs/yearly-payment-faq-en (Pricing; 2022-07-19)
- https://micro.blog/pricing (Pricing; 2024-03-20)
- https://www.manton.org/2024/02/21/simplified-pricing-in.html (Pricing; 2024-03-20)
- https://help.micro.blog/t/annual-plan/843 (Pricing; 2024-03-20)
- https://blot.im/pricing (Pricing; 2022-07-19)
- https://posthaven.com/ (Pricing)
- https://neocities.org/supporter (Pricing)
- https://ghost.org/pricing/ (Pricing)
- https://www.hey.com/pricing/ (Pricing)
- https://substack.com/going-paid (Pricing)
- https://buttondown.com/pricing (Pricing)
- https://rentry.org/what (Pricing)
- https://simplenote.com/ (Pricing; 2017-12)
- https://carbon.now.sh/ (Pricing; 2017-12)
- https://getkap.co/ (Pricing; 2017-12)
- https://www.tldraw.com/ (Pricing; 2017-12)
- https://x.com/pastebin/status/939420462098059264 (Pricing; 2017-12)
- https://pasteapp.io/pricing (Pricing; 2017-12)
- https://www.raycast.com/pricing (Pricing; 2017-12)
- https://readwise.io/pricing (Pricing; 2017-12)
- https://toolradar.com/tools/standard-notes/pricing (Pricing; 2023-04-17)
- https://blog.bear.app/2023/04/bear-2-will-have-a-new-price-only-for-new-customers/ (Pricing; 2023-04-17)
- https://brettterpstra.com/2026/05/18/marked-3-is-officially-out/ (Pricing; 2023-04-17)
- https://www.macsparky.com/blog/2026/06/marked-3-is-officially-out/ (Pricing; 2023-04-17)
- https://aiproductivity.ai/pricing/craft/ (Pricing; 2023-04-17)
- https://www.cloudwards.net/dropbox-paper-review/ (Pricing)
- https://cleanshot.com/pricing (Pricing)
- https://www.loom.com/pricing (Pricing)
- https://zight.com/pricing/ (Pricing)
- https://droplr.com/pricing/ (Pricing)
- https://plus.excalidraw.com/pricing (Pricing)
- https://aiproductivity.ai/pricing/typefully/ (Pricing)
- https://usefathom.com/pricing (Pricing)
- https://plausible.io/#pricing (Pricing)
- https://tinylytics.app/ (Pricing)
- https://developers.cloudflare.com/pages/platform/limits/ (Pricing)
- https://bunny.net/pricing/ (Pricing)
- https://masto.host/pricing/ (Pricing)
- https://tailscale.com/pricing (Pricing)
- https://1password.com/personal-pricing (Pricing)
- https://setapp.com/pricing (Pricing)
- https://agenda.community/t/price-for-premium-or-for-subscription/33302 (Pricing)
- https://www.morgen.so/blog-posts/fantastical-pricing (Pricing; 2026-05-26)
- https://mjtsai.com/blog/2020/01/29/fantastical-3/ (Pricing; 2026-05-26)
- https://nova.app/buy/ (Pricing; 2026-05-26)
- https://www.stackscored.com/pricing/domain-registrars/namecheap/ (Pricing; 2026-05-26)
- https://tld-list.com/registrars/hover (Pricing; 2026-05-26)
- https://news.ycombinator.com/item?id=32129706 (Pricing; 2022-07-17)
- https://gleamr.io/blog/omnivore-shut-down-alternatives (Pricing; 2024-11-15)
- https://smallweb.page/home (Pricing; 2026-05-26)
- https://news.ycombinator.com/item?id=32127363 (Pricing; 2022-07-17)
- https://news.ycombinator.com/item?id=39274376 (Pricing; 2024-02-06)
- https://news.ycombinator.com/item?id=41447086 (Pricing; 2024-09-04)
- https://news.ycombinator.com/item?id=38596361 (Pricing; 2023-12-11)
- https://news.ycombinator.com/item?id=34270301 (Pricing; 2023-01-06)
- https://news.ycombinator.com/item?id=40249764 (Pricing; 2024-05-03)
- https://news.ycombinator.com/item?id=32251249 (Pricing; 2022-07-27)
- https://news.ycombinator.com/item?id=33192436 (Pricing; 2022-10-13)
- https://forum.obsidian.md/t/a-free-open-source-obsidian-publish-alternative/36178 (Pricing; 2022-04-22)
- https://forum.obsidian.md/t/obsidian-publish-standard-price/23851 (Pricing; 2021-09-08)
- https://news.ycombinator.com/item?id=39281266 (Pricing; 2024-02-07)
- https://news.ycombinator.com/item?id=19957768 (Pricing; 2019-05-20)
- https://news.ycombinator.com/item?id=19950414 (Pricing; 2019-05-18)
- https://news.ycombinator.com/item?id=37257415 (Pricing; 2023-08-25)
- https://news.ycombinator.com/item?id=33293315 (Pricing; 2022-10-22)
- https://news.ycombinator.com/item?id=22462664 (Pricing; 2020-03-02)
- https://news.ycombinator.com/item?id=11863913 (Pricing; 2016-06-08)
- https://news.ycombinator.com/item?id=35569442 (Pricing; 2023-04-14)
- https://herman.bearblog.dev/running-a-blogging-platform/ (Pricing; 2022-05-18)
- https://hey.mataroa.blog/p/mataroa-is-cheap/ (Pricing; 2022-08-25)
- https://hey.mataroa.blog/p/whos-paying-for-a-minimal-blogging-platform/ (Pricing; 2022-08-26)
- https://www.revenuecat.com/state-of-subscription-apps-2025 (Pricing; 2026-01-28)
- https://www.revenuecat.com/state-of-subscription-apps (Pricing; 2026-01-28)
- https://www.revenuecat.com/blog/growth/subscription-app-trends-benchmarks-2026 (Pricing; 2026-01-28)
- https://baremetrics.com/blog/annual-vs-monthly-pricing-better-retention (Pricing; 2026-01-28)
- https://www.paddle.com/blog/annual-vs-monthly-billing (Pricing; 2021-06-29)
- https://www.lennysnewsletter.com/p/monthly-churn-benchmarks (Pricing; 2022-02-08)
- https://herman.bearblog.dev/the-chatgpt-vs-bear-blog-spam-war/ (Pricing; 2023-04-16)
- https://www.indiehackers.com/post/subscriptions-vs-one-time-payments-a-developers-honest-take-f153e48960 (Pricing; 2025-07-16)
- https://appopportunity.com/blog/indie-app-revenue-models-2026 (Pricing; 2026-03-08)
- https://freemius.com/blog/saas-lifetime-deals/ (Pricing; 2026-03-18)
- https://thebootstrappedfounder.com/lifetime-deals-and-saas-businesses/ (Pricing; 2021-04-01)
- https://www.indiehackers.com/post/whats-new-don-t-offer-lifetime-deals-191668f974 (Pricing; 2022-09-29)
- https://docs.msgfiler.com/buy/thoughts-on-subscriptions (Pricing; 2026-03-18)
- https://techcrunch.com/2017/08/11/popular-writing-app-ulysses-switches-to-subscription-model/ (Pricing; 2017-08)
- https://chartmogul.com/blog/how-ulysses-pulled-off-a-controversial-pivot-to-subscription/ (Pricing; 2017-08)
- https://mjtsai.com/blog/2021/05/12/sketch-subscriptions/ (Pricing; 2026-05-18)
- https://daringfireball.net/linked/2020/02/04/fantastical-3-app-store (Pricing; 2026-05-18)
- https://www.buildmvpfast.com/blog/lemon-squeezy-vs-polar-paddle-merchant-of-record-2026 (Pricing)
