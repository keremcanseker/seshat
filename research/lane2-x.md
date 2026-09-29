# Lane 2: X / Twitter signal for Seshat

Method: 25 Monid tikhub `fetch_search_timeline` calls (search_type Top, X operators inside keyword), then free WebSearch + fxtwitter/InfoQ fetches for a handful of follow-ups. All quotes are copied from the returned `text` field or a fetched page. Engagement = likes / replies / reposts (views where the API returned them). Dates are tweet `created_at`. OBSERVED = quote and numbers read directly from the API or page. INFERRED = my reading of the underlying need.

Raw JSON: `lane2-x-1.json` .. `lane2-x-25.json` in this scratchpad.

---

## A. "Long AI markdown is unreadable" (READING pain)

### A1. @trq212 (Thariq Shihipar, Claude Code team) — "HTML is the new markdown"
- URL: https://x.com/trq212/status/2052811606032269638
- Date: 2026-05-08
- Quote (tweet): "HTML is the new markdown. I've stopped writing markdown files for almost everything and switched to using Claude Code to generate HTML for me."
- Quote (article, via InfoQ): "Specifically, I find it difficult to read a Markdown file of more than a hundred lines"
- Engagement: 12,079 likes / 898 replies / 1,023 reposts / 4.46M views. OBSERVED.
- Need: agent-written markdown past ~100 lines is not read by humans; it needs a rendered, linkable surface. INFERRED.
- Tag: READING + SHARING
- Note: competing frame (switch format to HTML) but the loudest single validation of Seshat's wedge on X this year. Secondary paraphrase of the sharing argument (explainx.ai): "Markdown in email or Slack is an attachment problem. HTML on any static host ... is one link." (paraphrase, not verbatim Thariq).

### A2. @trq212 — Slack rendering attachments
- URL: https://x.com/trq212/status/2067021344341098670
- Date: 2026-06-16
- Quote: "Slack now renders HTML attachments instead of just showing it as text 😭🙏"
- Engagement: 3,798 / 165 / 68, 537k views. OBSERVED.
- Need: dropping a doc file into chat and having it render, not appear as raw text. INFERRED.
- Tag: SHARING

### A3. @trq212 — Claude Code shareable HTML artifacts (competitive threat)
- URL: https://x.com/trq212/status/2067682475611242546
- Date: 2026-06-18
- Quote: "Claude Code can now upload and edit HTML artifacts that you can share with your team or other Claudes! Starting with teams so you can share internally with your team, coming to Pro and MAX plans soon!"
- Engagement: 2,144 / 130 / 111, 281k views. OBSERVED.
- Need: one-click share-a-link from the agent session. INFERRED. Anthropic is building this for HTML, not .md.
- Tag: SHARING

### A4. @clairevo (Claire Vo, How I AI)
- URL: https://x.com/clairevo/status/2056428390773825701
- Date: 2026-05-18
- Quote: "It's so obvious in hindsight: while .md is simple to write and agents can read it well, it's a total slog to eyeball as a human."
- Engagement: 436 / 44 / 22, 201k views. OBSERVED.
- Need: human-readable rendering of agent markdown. INFERRED.
- Tag: READING

### A5. @ghumare64
- URL: https://x.com/ghumare64/status/2053106700324897063
- Date: 2026-05-09
- Quote: "Markdown is write-only context. The agent generates it, you skim the first 200 characters, you trust or you don't."
- Second quote in same post: "Sharing context with a teammate is a URL, not a tarball"
- Engagement: 134 / 5 / 8, 29.7k views. OBSERVED.
- Need: browseable, searchable rendered view of a folder of .md; share by URL. INFERRED.
- Tag: READING + SHARING

### A6. @NoahEpstein_
- URL: https://x.com/NoahEpstein_/status/2053057504473416096
- Date: 2026-05-09
- Quote: "Nobody reads long Markdown files. Not him, not his team, not you."
- Second quote: "Sharing actually works. Drop the file on S3, send a link, your team opens it. Markdown attachments get ignored."
- Engagement: 26 / 8 / 0, 3.6k views. OBSERVED.
- Need: send a link, not an attachment. INFERRED.
- Tag: READING + SHARING

### A7. @kunchenguid (Lavish, HTML artifact viewer)
- URL: https://x.com/kunchenguid/status/2054010987871883764
- Date: 2026-05-12
- Quote: "when i first saw this “HTML is the new markdown” thing, i quickly dismissed it as “that’s going to waste so many tokens” i was wrong. i just tried it, and it rocks"
- Engagement: 293 / 54 / 6, 54.8k views. Follow-up launch tweet https://x.com/kunchenguid/status/2054269845966041426 got 466 / 35 / 38. OBSERVED.
- Need: a pleasant viewer for agent output; he built one for HTML plans. INFERRED.
- Tag: READING

### A8. @theo (t3.gg)
- URL: https://x.com/theo/status/2054456151308369952
- Date: 2026-05-13
- Quote: "Is HTML the new Markdown? Had a lot of thoughts on Thariq's latest article so obviously I had to make it a vid"
- Engagement: 555 / 71 / 23, 98k views (via fxtwitter). OBSERVED.
- Need: none directly; shows the format-of-agent-output debate reached mainstream dev audience. INFERRED.
- Tag: READING

### A9. @0xwhrrari and @hanakoxbt (secondhand summaries of an Anthropic talk)
- URLs: https://x.com/0xwhrrari/status/2061107868883947953 (245 / 37 / 30), https://x.com/hanakoxbt/status/2060836730589028421 (61 / 17 / 8)
- Dates: 2026-05-31, 2026-05-30
- Quote (0xwhrrari): "No dead specs No messy notes No file nobody reads"
- Quote (hanakoxbt): "No more 200-line markdown files nobody reads."
- Engagement: OBSERVED. Content is engagement-farm restatement, treat as amplification not source.
- Tag: READING

### A10. @wilczyn (poll)
- URL: https://x.com/wilczyn/status/2088234188172333206
- Date: 2026-08-14
- Quote: "what do you write your docs in? - notion - mintlify - readme - markdown files nobody reads"
- Engagement: 15 / 18 / 0. OBSERVED.
- Tag: READING

### A11. @TAbrodi (reply to Thariq)
- URL: https://x.com/TAbrodi/status/2052814887852933172
- Date: 2026-05-08
- Quote: "so you can just plan with HTML, share with the team, and they actually have something pleasant to look at than markdown."
- Engagement: 16 / 1 / 0. OBSERVED.
- Need: share a plan with the team in a form that looks good. INFERRED.
- Tag: SHARING

---

## B. "Mac has no good .md viewer" (READING pain, direct Seshat-reader validation)

### B1. @Shpigford (Josh Pigford)
- URL: https://x.com/Shpigford/status/2034365122638954924
- Date: 2026-03-18
- Quote: "ugh. fine. i'll drop TWO macOS apps. ... simple markdown file viewer/editor (with quick look!)"
- Engagement: 869 / 54 / 36, 64k views. OBSERVED.
- Need: a native Mac markdown viewer with Quick Look; demand strong enough that a well-known indie shipped one. INFERRED.
- Tag: READING

### B2. @yashbanka123 (Marko)
- URL: https://x.com/yashbanka123/status/2078459197084295556
- Date: 2026-07-18
- Quote: "Every AI tool spits out Markdown. macOS still opens .md as raw text."
- Engagement: 25 / 4 / 2. OBSERVED.
- Need: exactly Seshat's reader pitch, stated by a competitor. INFERRED.
- Tag: READING

### B3. @linuz90 (Fabrizio Rinaldi, Typefully) — Mac markdown reader
- URL: https://x.com/linuz90/status/2045445639476330980
- Date: 2026-04-18
- Quote: "Shipped a few more updates to my Mac markdown reader: • App deep links • Mermaid diagrams • Go-to-line with ⌘ L"
- Engagement: 91 / 12 / 1, 10.7k views. OBSERVED.
- Need: reader with outline, deep links, Mermaid, math; he lists exactly the features people ask for. INFERRED.
- Tag: READING

### B4. @linuz90 — opening Claude Code plans in Typora
- URL: https://x.com/linuz90/status/2008840566633857244
- Date: 2026-01-07
- Quote: "Been using Typora to view Markdown files on my Mac. For example, when I'm claude-coding in plan mode, I grab the plan link and open it in Typora for a much nicer reading experience."
- Engagement: 30 / 14 / 1, 5.4k views. OBSERVED.
- Need: this is the Seshat wedge verbatim: read the agent's plan.md somewhere nicer than the terminal. INFERRED.
- Tag: READING

### B5. @irl_danB
- URL: https://x.com/irl_danB/status/2090101401506512927
- Date: 2026-08-19
- Quote: "my final remaining use for any IDE outside of Codex/CC was for writing and commenting on markdown files"
- Second quote: "they’d built me a glorified markdown reader/editor whose AI features I was no longer even using"
- Engagement: 53 / 11 / 2. OBSERVED.
- Need: a fast native Mac app just for reading/commenting on markdown, since agents write the code now. He vibe-coded one ("Margin"). INFERRED.
- Tag: READING + WRITING

### B6. @DannyAziz97, @davis7, @walkingriver (Xcode-opens-.md complaint, three independent)
- URLs: https://x.com/DannyAziz97/status/1943026482952946013 (11 / 3 / 1, 2025-07-09), https://x.com/davis7/status/1819897282088603825 (6 / 2 / 0, 2024-08-04), https://x.com/walkingriver/status/1763230781495718085 (5 / 1 / 0, 2024-02-29)
- Quote (DannyAziz97): "The five stages of opening a markdown file on Mac: 1. Confusion (why nothing happen?) 2. Horror (IS THAT XCODE BOUNCING)"
- Quote (walkingriver): "There is never a time I want to open a Markdown file with Xcode, so I don't know why that's a default on macOS."
- Engagement: low individually, but recurring. OBSERVED.
- Need: a sane default handler for .md on macOS. INFERRED.
- Tag: READING

### B7. @om_patel5 / @AIandTechh87 (markdown notepad, two posts)
- URLs: https://x.com/om_patel5/status/2077191346813653175 (132 / 11 / 17), https://x.com/AIandTechh87/status/2077598637539123552 (53 / 18 / 24)
- Dates: 2026-07-15, 2026-07-16
- Quote: "you know how you just want to open a quick file, jot something down, and close it, without launching some heavy notes app. this is that, except it actually handles markdown properly."
- Engagement: OBSERVED.
- Need: instant-open, no-account, renders-properly markdown app. Supports Seshat's "not a PKM" stance. INFERRED.
- Tag: READING + WRITING

---

## C. "Typora is the reader for the .md world" (READING, incumbent behaviour)

### C1. @patrickmineault
- URL: https://x.com/patrickmineault/status/2037907043063832669
- Date: 2026-03-28
- Quote: "Some small (and not so small) pieces of software that have become very useful since Claude Co-Work got released: - typora (Markdown editor) rather than gdocs/Word/notion"
- Engagement: 267 / 10 / 9, 39.6k views. OBSERVED.
- Need: a markdown-native doc app replacing Docs/Notion once an agent writes the docs. INFERRED.
- Tag: READING + WRITING

### C2. @davidmarcus
- URL: https://x.com/davidmarcus/status/2037973301876908395
- Date: 2026-03-28
- Quote: "Now that we live in a .md world, I can't recommend @Typora enough. Such a delightful, well crafted product."
- Engagement: 26 / 1 / 0, 6.8k views. OBSERVED.
- Tag: READING

### C3. @robjama
- URL: https://x.com/robjama/status/2008748294059815155
- Date: 2026-01-07
- Quote: "realizing to use Claude Code as a personal agent for non-dev stuff I need to move off Notes app need something that works with markdown so it’s either obsidian/typora/cursor"
- Engagement: 15 / 10 / 0. OBSERVED.
- Need: a Mac-native home for markdown that is not an IDE and not a PKM. INFERRED.
- Tag: READING + WRITING

### C4. @burkov and @xeophon (Typora praise)
- URLs: https://x.com/burkov/status/1924322379821449627 (152 / 14 / 6, 2025-05-19), https://x.com/xeophon/status/1963198199247634525 (30 / 5 / 1, 2025-09-03)
- Quote (burkov): "How did I live without using @Typora? It's a WYSIWYG Markdown editor that supports LaTeX, themes, and a seamless optional source editing mode."
- Quote (xeophon): "every time I want to write longform markdown, I somehow come back to @Typora"
- Tag: WRITING

### C5. @banteg (Twitter Articles editor)
- URL: https://x.com/banteg/status/1900969607541789062
- Date: 2025-03-15
- Quote: "tried twitter article editor, it's shit, here is why: - you can't paste markdown or formatted text"
- Engagement: 23 / 8 / 0. OBSERVED.
- Need: publish surfaces that accept markdown as-is. INFERRED.
- Tag: WRITING + SHARING

---

## D. "I just want a link" (SHARING pain, direct Seshat Share validation)

### D1. @linuz90 — gists.sh
- URL: https://x.com/linuz90/status/2031377772145422635
- Date: 2026-03-10
- Quote: "GitHub Gists are useful but look terrible."
- Second quote: "Killer use case: have your AI agent like @openclaw share research, notes, or code with you as a pretty gist. Drop it in a meeting chat and watch the reactions."
- Engagement: 420 / 33 / 23, 34k views. OBSERVED.
- Need: agent output as a good-looking shareable page; typography is the differentiator he leads with. INFERRED. Direct competitor to Seshat Share (free, OSS).
- Tag: SHARING

### D2. @MaypazOr (expiring markdown pages)
- URL: https://x.com/MaypazOr/status/2041128587080692160
- Date: 2026-04-06
- Quote: "AI agents give you markdown. You need shareable pages."
- Second quote: "One command. Clean URL. Auto-expires in 24h."
- Engagement: 52 / 3 / 6, 12k views. OBSERVED.
- Need: CLI push of .md to a URL; expiring links as a feature. INFERRED. Validates "expiring links" candidate.
- Tag: SHARING

### D3. @goldkey — MDX Limo (three posts)
- URLs: https://x.com/goldkey/status/2024935050454990853 (14 / 4 / 2, 2026-02-20), https://x.com/goldkey/status/2027469168203936211 (7 / 0 / 1), https://x.com/goldkey/status/2070967542806667389 (9 / 2 / 1)
- Quote: "The fastest way to manage and share beautiful markdown docs with your AI agents and team. → MCP server for Claude Code, Cursor, and other AI agents → Instant sharing via link"
- Feature list in the same post includes "Private docs with email-based sharing", "Custom URLs for branded links", "Cloud sync for anywhere access", "PDF & markdown export".
- Engagement: low. OBSERVED.
- Need: competitor's feature list overlaps Seshat's paid candidates almost 1:1 (private links, custom URLs, sync). INFERRED.
- Tag: SHARING

### D4. @mmazco (Claude Code to HackMD workflow)
- URL: https://x.com/mmazco/status/2080459330890223754
- Date: 2026-07-24
- Quote: "research and write w claude code export mark down open in hackmd push to github"
- Engagement: 15 / 3 / 2. OBSERVED.
- Need: a hosted rendered view between "agent wrote .md" and "committed to git". INFERRED.
- Tag: SHARING

### D5. @frankdilo (Francesco Di Lorenzo, Typefully)
- URL: https://x.com/frankdilo/status/2009565324061073656
- Date: 2026-01-09
- Quote: "I decided to keep it in the form of one markdown file per day, in a repository, connected to Claude Code."
- Second quote: "At the end of the day, I share this on a # progress Slack channel with the team so everyone is up to speed with everyone else."
- Engagement: 316 / 21 / 12, 27.9k views. OBSERVED.
- Need: daily markdown doc shared to a team channel; today it is pasted, could be a stable updating link. INFERRED.
- Tag: SHARING

### D6. @jfversluis (Copilot CLI /share)
- URL: https://x.com/jfversluis/status/2039689306017759441
- Date: 2026-04-02
- Quote: "/share gist: saves your session as a GitHub Gist /share file: saves as a local markdown file instead"
- Engagement: 65 / 2 / 10. OBSERVED.
- Need: vendors are adding "share as gist" to agent CLIs; the render layer for those gists is still ugly (see D1). INFERRED.
- Tag: SHARING

### D7. @GHCopilotLog
- URL: https://x.com/GHCopilotLog/status/2066007753550651412
- Date: 2026-06-14
- Quote: "Export markdown content as a secret GitHub Gist from plan canvas, markdown editor, and assistant replies"
- Engagement: 27 / 2 / 7. OBSERVED.
- Tag: SHARING

### D8. @strickvl
- URL: https://x.com/strickvl/status/1920167651495563449
- Date: 2025-05-07
- Quote: "This week ChatGPT stopped allowing you to copy markdown with links from their website, so I created a little tampermonkey script that allows you to access and export your chats / reports."
- Engagement: 13 / 2 / 3 (fxtwitter). OBSERVED.
- Need: get deep-research output out of the chat UI as markdown and share it as a gist. INFERRED.
- Tag: SHARING

### D9. @blackgirlbytes (Rizel Scarlett)
- URL: https://x.com/blackgirlbytes/status/2052757292093718965
- Date: 2026-05-08
- Quote: "a community member asked me if we could support downloading sessions as markdown."
- Engagement: 17 / 2 / 2. OBSERVED.
- Tag: SHARING

---

## E. Obsidian Publish: price, limits, churn (SHARING, incumbent weakness)

### E1. @tibudiyanto
- URL: https://x.com/tibudiyanto/status/1894255930537382146
- Date: 2025-02-25
- Quote: "that obsidian publish feature looking juicy nowadays but $8 seems a bit much"
- Engagement: 3 / 2 / 0. OBSERVED. Low engagement but the only explicit price complaint found.
- Need: cheaper publish; Seshat at 8.99/yr vs 8/mo is a 10x gap. INFERRED.
- Tag: SHARING

### E2. @nosilverv
- URL: https://x.com/nosilverv/status/1838193238064197782
- Date: 2024-09-23
- Quote: "god obsidian publish doesn't allow comments?!?!"
- Engagement: 11 / 1 / 0. OBSERVED.
- Tag: SHARING

### E3. @td10rpg
- URL: https://x.com/td10rpg/status/1973569419755528471
- Date: 2025-10-02
- Quote: "I'm slowly migrating the contents of td10 dot org to Substack with the intention of sunsetting Obsidian Publish."
- Engagement: 33 / 2 / 4. OBSERVED.
- Tag: SHARING

### E4. @tom_doerr
- URL: https://x.com/tom_doerr/status/2072085903913206123
- Date: 2026-06-30
- Quote: "Open-source Obsidian Publish alternative for self-hosted markdown notes"
- Engagement: 163 / 1 / 12, 10.6k views. OBSERVED.
- Need: people want a Publish alternative badly enough that a link-only post gets 163 likes. INFERRED.
- Tag: SHARING

### E5. @xdadevelopers, @mischavdburg (alternatives)
- URLs: https://x.com/xdadevelopers/status/1979185782175744454 (11 / 0 / 1, "Why Flowershow is a fantastic, free alternative to Obsidian Publish"), https://x.com/mischavdburg/status/1895878245691662683 (13 / 0 / 0, "# I built my own publishing solution instead of Obsidian Publish")
- Tag: SHARING

### E6. @teej_dv (happy customer, wants more)
- URL: https://x.com/teej_dv/status/1831443228568289331
- Date: 2024-09-04
- Quote: "Hey @kepano, I love Obsidian Publish... any chance there will be more locations to customize behavior/hooks/plugins?"
- Engagement: 24 / 2 / 0. OBSERVED.
- Tag: SHARING

### E7. @obsdmd (Obsidian Headless + Publish)
- URL: https://x.com/obsdmd/status/2036880481980146149
- Date: 2026-03-25
- Quote: "Obsidian Headless now supports Obsidian Publish so you can publish to your site without the desktop app."
- Engagement: 1,179 / 18 / 78. OBSERVED.
- Need: publish from CLI/agents without the GUI, i.e. the `seshat share` shape. INFERRED.
- Tag: SHARING

---

## F. Privacy / private links (SHARING, validates private and expiring links)

### F1. @networkspirits
- URL: https://x.com/networkspirits/status/2037098897831580142
- Date: 2026-03-26
- Quote: "can someone build a privacy focused hackmd that actually works i BEG"
- Engagement: 20 / 5 / 0. OBSERVED.
- Tag: SHARING

### F2. @apoorveth, @shazow (HackMD leavers)
- URLs: https://x.com/apoorveth/status/2037151068292080107 (24 / 1 / 6, "Privacy focused hackmd 👀"), https://x.com/shazow/status/2065104734982218220 (23 / 3 / 6, "my hackmd era is over, i can go full fileverse now")
- Dates: 2026-03-26, 2026-06-11
- Tag: SHARING

### F3. @k1rallik (Notion public page leak)
- URL: https://x.com/k1rallik/status/2045925731885035877
- Date: 2026-04-19
- Quote: "every public Notion page silently exposes the full name, email, and profile photo of everyone who ever touched it"
- Engagement: 220 / 15 / 35. OBSERVED. Also @ohryansbelt 9 / 0 / 2 and @Sox0j 133 / 0 / 28 on same issue.
- Need: public pages that do not leak author identity. INFERRED.
- Tag: SHARING

### F4. @alex_prompter (shared chats indexed)
- URL: https://x.com/alex_prompter/status/2081327819800576085
- Date: 2026-07 (from WebSearch snippet; engagement not retrieved)
- Quote: "Every time you hit "Share" on a Claude or ChatGPT chat, that creates a public page. Not a private link."
- Engagement: not observed (search snippet only).
- Need: share links that are actually private / unlisted. INFERRED.
- Tag: SHARING

### F5. @xadhish (expiring pastebin)
- URL: https://x.com/xadhish/status/1897624883225571629
- Date: 2025-03-06
- Quote: "Paste, share, and it’s gone in 3 days."
- Engagement: 5 / 0 / 0. OBSERVED.
- Tag: SHARING

---

## G. Custom domain / publish a folder as a site (SHARING)

### G1. @VazeKshitij
- URL: https://x.com/VazeKshitij/status/2008745266850263343
- Date: 2026-01-07
- Quote: "since I write everything in Obsidian (a.k.a, Markdown), I'll simply upload the blog as a GitHub gist."
- Second quote: "The only problem? I know 0 about creating a website."
- Engagement: 93 / 22 / 0. OBSERVED.
- Need: publish a folder of markdown as a site with zero web-dev knowledge. INFERRED.
- Tag: SHARING

### G2. @aetosdios_ (Scribe)
- URL: https://x.com/aetosdios_/status/2085981438118420888
- Date: 2026-08-08
- Quote: "spent months tired of my blog fighting me over CSS. built Scribe write markdown, publish on your own site, keep your own domain. no CMS, no lock-in."
- Engagement: 27 / 11 / 8. OBSERVED.
- Tag: SHARING

### G3. @joncphillips
- URL: https://x.com/joncphillips/status/2044429411689128133
- Date: 2026-04-15
- Quote: "The last few sites I’ve built are just plain PHP, markdown files with YAML frontmatter, and Parsedown for markdown-to-HTML rendering. No database, no admin panel, no plugin ecosystem accumulating technical debt."
- Engagement: 27 / 17 / 1. OBSERVED.
- Tag: SHARING

### G4. @andrewglynch, @rudolfscode (low engagement, same need)
- URLs: https://x.com/andrewglynch/status/2069367728641659146 (13 / 4 / 0, moved off Webflow to Jekyll with Claude Code), https://x.com/rudolfscode/status/2083095294401524189 (4 / 2 / 0, "Write your post in markdown, run one command, and it's published on your own domain")
- Tag: SHARING

---

## H. Context: "markdown hosting" as a category

### H1. @coffeewithone (ex-Mintlify intern)
- URL: https://x.com/coffeewithone/status/2038796479444496824
- Date: 2026-03-31
- Quote: "Let me tell you why Mintlify needs 50 people to "host .md files" and why 50 is actually too low."
- Engagement: 388 / 35 / 14, 95k views. OBSERVED.
- Note: the framing "host .md files" is the meme; Mintlify is the enterprise end of the same need.

### H2. @dani_avila7
- URL: https://x.com/dani_avila7/status/2043512977672765748
- Date: 2026-04-13
- Quote: "But something doesn’t click for me, what’s the Obsidian layer actually for? I didn’t find much benefit over just having good git workflows to save the markdown files straight to GitHub"
- Engagement: 31 / 9 / 2. OBSERVED.
- Note: supports Seshat's "not a PKM, just files" position.

### H3. @DanielleFong
- URL: https://x.com/DanielleFong/status/2010114522271625720
- Date: 2026-01-10
- Quote: "because obsidian and claude code share the underlying "just files and folders" ethos, this is a really powerful and natural combination! i never really used obsidian tho."
- Engagement: 106 / 8 / 1. OBSERVED.

---

## Summary

### Top needs ranked by independent-source count

1. **Sharing markdown means an attachment or an ugly gist; people want one clean link** (SHARING): 12 sources (trq212 x2, NoahEpstein_, ghumare64, TAbrodi, linuz90 gists.sh, MaypazOr, goldkey, mmazco, frankdilo, jfversluis, strickvl). Highest-engagement cluster (Thariq threads at 2k to 12k likes; gists.sh 420).
2. **Long agent-written markdown is not read by humans** (READING): 10 sources (trq212, clairevo, ghumare64, NoahEpstein_, kunchenguid, theo, 0xwhrrari, hanakoxbt, wilczyn, linuz90 plan-in-Typora). Caveat: the loudest voices propose HTML as the fix, not a better markdown reader. Seshat's counter is "keep .md, fix the reader and the link".
3. **macOS has no decent default .md viewer** (READING): 8 sources (Shpigford 869 likes, yashbanka123, linuz90, irl_danB, DannyAziz97, davis7, walkingriver, om_patel5). Three separate people shipped a Mac markdown viewer in 2026 (Shpigford, Marko, linuz90) plus irl_danB vibe-coded one. Crowded but proves demand.
4. **Private / unlisted / expiring links** (SHARING): 8 sources (networkspirits, apoorveth, shazow, k1rallik + Sox0j + ohryansbelt on Notion leak, alex_prompter on indexed share pages, MaypazOr expiring, xadhish expiring, goldkey private docs). Strong validation for the private-link and expiring-link paid candidates.
5. **Obsidian Publish is priced monthly, lacks comments, people churn or self-host** (SHARING): 7 sources (tibudiyanto, nosilverv, td10rpg, tom_doerr 163 likes, xdadevelopers, mischavdburg, teej_dv). Only one explicit price complaint, low engagement.
6. **Typora is the de-facto reader for the ".md world"** (READING/WRITING): 6 sources (patrickmineault 267, davidmarcus, linuz90, robjama, burkov, xeophon). Seshat's direct incumbent on Mac.
7. **Publish a folder / custom domain with zero web knowledge** (SHARING): 5 sources (VazeKshitij 93, aetosdios_, joncphillips, andrewglynch, rudolfscode). Moderate.
8. **Image hosting, view stats, library sync**: zero direct X signal found. Only goldkey's feature list mentions cloud sync. INFERRED: not a talking point on X; validate elsewhere.

Competitive notes: Anthropic is shipping shareable HTML artifacts from Claude Code (2,144 likes) and Copilot ships "share as gist". gists.sh (free, OSS, 420 likes) is the closest thing to Seshat Share's rendering pitch. MDX Limo and the MaypazOr tool are small but their feature lists match Seshat's paid candidates.

### Queries tried (25 Monid calls, all returned status ok)
1. "share markdown" min_faves:5
2. "obsidian publish" min_faves:10
3. markdown ("just a link" OR "just want a link" OR "share a link") min_faves:5 — EMPTY
4. "claude code" ("plan.md" OR "pages of markdown" OR "markdown files") read min_faves:10 — only Obsidian+Claude hype threads, nothing on reading pain
5. (chatgpt OR claude) markdown (share OR sharing) link min_faves:10
6. hackmd min_faves:10
7. notion "public page" OR "publish to web" (ugly OR slow OR hate OR wish) — only the email-leak thread
8. from:trq212 (markdown OR html) min_faves:50
9. "iA Writer" (publish OR share OR export) — nothing relevant
10. typora min_faves:10
11. ("marked 2" OR "markdown viewer" OR "markdown reader") mac min_faves:5
12. gist markdown (share OR render OR link) min_faves:10
13. markdown ("non-technical" OR "my client" OR "send it to" OR stakeholders) — noise
14. "nobody reads" markdown min_faves:10
15. ("markdown file" OR ".md file") (long OR pages OR "read it") (claude OR cursor OR chatgpt OR agent) min_faves:20 — noise (Karpathy wiki threads)
16. ("would pay for" OR "pay for" OR "why is there no") markdown (share OR link OR viewer OR reader OR publish) — nothing relevant
17. ("custom domain" OR "own domain") markdown (publish OR docs OR blog OR site)
18. ("bear app" OR ulysses OR craftdocs OR "craft docs") (publish OR "web publishing") — Ulysses noise (Joyce, Grant), nothing on Bear
19. markdown ("just a link" OR "just send a link" OR "just want a link" OR "send them a link") — 1 irrelevant result
20. "HTML is the new markdown" -from:trq212 min_faves:15
21. "obsidian publish" (price OR expensive OR "$8" ...) min_faves:2 — 1 relevant, low engagement
22. ("plan.md" OR "spec.md" OR "plan mode") (claude OR cursor OR codex) (read OR readable OR render) — only plan-mode hype
23. markdown ("with my team" OR "with a client" OR "to my boss") (share OR send)
24. (".md" OR "markdown file") (mac OR macos) ("raw text" OR quicklook OR xcode) (open OR view)
25. ("markdown to html" OR "paste markdown" ...) (share OR link OR page) — noise

Free follow-ups: 5 WebSearch, 8 WebFetch (x.com and r.jina.ai mirrors returned 403; api.fxtwitter.com worked for engagement counts; InfoQ gave the verbatim Thariq article quote).

### Empty or useless queries
3, 9, 13, 15, 16, 18, 19, 22, 25. "I'd pay for" / "why is there no" phrasing found nothing about markdown on X. Bear, iA Writer, Ulysses, Craft, Quarto, Docusaurus, Hashnode, Marked 2: no complaint threads with engagement in the window.

### Cost
25 Monid calls x 0.0015 USD = 0.0375 USD. Cap respected, no BLOCKED or balance errors.
