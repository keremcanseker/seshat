# Verification of top-10 feature sources

Checked 2026-09-06. Method per source type: Reddit and X quotes grepped in the raw Monid payloads (lane1-monid-*.json, lane2-x-*.json) with permalink/post id or tweet id_str confirmed in the same payload; HN via hn.algolia.com/api/v1/items; GitHub via api.github.com issues + comments; Discourse via <thread>.json; Apple reviews via the RSS feed pages 1-10; Product Hunt via the cached page HTML saved by lane 3 (ph_*.html); everything else via WebFetch or curl. Matching is case-insensitive with whitespace, smart-quote and dash normalization. PASS = a 6+ word substring of the quote is present at the cited source.

| # | URL | Lane finding | Verdict | Note |
|---|---|---|---|---|
| 1 | reddit.com/r/Markdown/comments/1vu538c/ | lane1 #1, #2, #3 | PASS | All three quotes in payloads (monid-9/10 for OP, monid-16 for comments) with post id 1vu538c |
| 2 | reddit.com/r/ObsidianMD/comments/1sgom74/ | lane1 #9, #10 | PASS | OP quotes in monid-2, top comment "I export mine as pdf" in monid-17, id present |
| 3 | reddit.com/r/ObsidianMD/comments/1v4oerl/ | lane1 #12 | PASS | monid-2 |
| 4 | reddit.com/r/Slack/comments/1vy2zut/ | lane1 #21 | PASS | monid-10 |
| 5 | reddit.com/r/selfhosted/comments/1t07xjn/ | lane1 #23 | PASS | Both quotes in monid-8 |
| 6 | reddit.com/r/Notion/comments/1s4mq9x/ | lane1 #19 | PASS | monid-7 |
| 7 | reddit.com/r/Markdown/comments/1u3tpkl/ | lane1 #6, #7 | PASS | OP in monid-9/10, mdedit.ai counter-signal in monid-19 |
| 8 | forum.obsidian.md/t/23131 | lane5 B1 | PASS | maebert "hidden, non-indexed URL" and Scotty "paste into Craft" both in thread JSON |
| 9 | itunes.apple.com/gb/.../id=1487937127 | lane5 B9 | PASS | All three phrases present in gb feed (pages 1-10) |
| 10 | hannahstulberg.substack.com/p/claude-code-for-everything... | lane6 F42 | PASS | "good luck getting your manager to open it", "Now you have two versions", "ready for team input" all verbatim |
| 11 | community.openai.com/t/985795 | lane6 F54 | PASS | OP and EricGT reply both in thread JSON |
| 12 | news.ycombinator.com/item?id=48590505 | lane3 #26, #27 | PASS | Author "permanent share link instead of a localhost tunnel", hbcondo714 password, karthickrmchn versions all present |
| 13 | news.ycombinator.com/item?id=46645942 | lane3 #24, #25 | PASS | hjinco OP, acrophiliac images, saltwounds expiration all present |
| 14 | claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html | lane6 F21 | PASS | Raw HTML contains exact "I find it difficult to read a Markdown file of more than a hundred lines" plus all four sharing sentences. (WebFetch summary called it a paraphrase; the raw page has both this sentence and the separate "100-line" sentence.) |
| 15 | x.com/linuz90/status/2031377772145422635 | lane2 D1 | PASS | lane2-x-12, id_str matches |
| 16 | x.com/trq212/status/2052811606032269638 | lane2 A1 | PASS | lane2-x-8 and -20 (text has "\n\n" after "markdown."); fxtwitter confirms text, 12,079 likes, 4.46M views |
| 17 | x.com/trq212/status/2067021344341098670 | lane2 A2 | PASS | lane2-x-8 |
| 18 | x.com/ghumare64/status/2053106700324897063 | lane2 A5 | PASS | Both quotes in lane2-x-5 |
| 19 | news.ycombinator.com/item?id=47777633 | lane3 #1, lane6 F13 | PASS | "slightly annoying to read/preview and fiddly to share/receive" and "The more we work with command line based agents" present |
| 20 | producthunt.com/products/uselink | lane3 #30 | PASS | Maker quote in cached ph_uselink.html |
| 21 | blog.sivaramp.com/blog/introducing-mdbin/ | lane6 F61 | PASS | All three phrases verbatim, Oct 15 2025 |
| 22 | forum.obsidian.md/t/13947 | lane5 B2 | PASS | mtikhonov OP quote in thread JSON |
| 23 | x.com/networkspirits/status/2037098897831580142 | lane2 F1 | PASS | lane2-x-6 |
| 24 | x.com/k1rallik/status/2045925731885035877 | lane2 F3 | PASS | lane2-x-7 |
| 25 | x.com/MaypazOr/status/2041128587080692160 | lane2 D2 | PASS | lane2-x-1; both quotes present (line breaks between sentences) |
| 26 | producthunt.com/products/claudebin | lane3 #32 | PASS | Maker quote in cached ph_claudebin.html |
| 27 | news.ycombinator.com/item?id=45002329 | lane3 #28 | PASS | Author quote and zscc "password protection is necessary" present |
| 28 | reddit.com/r/Notion/comments/1uz28v7/ | lane1 #20 | PASS | monid-7 |
| 29 | reddit.com/r/ObsidianMD/comments/1ucu4ef/sortable_tables_lists_publish/ | lane1 #15 | PASS | monid-12 |
| 30 | reddit.com/r/Markdown/comments/1qefqx7/ | lane1 #27 | PASS | monid-9 |
| 31 | reddit.com/r/ObsidianMD/comments/1v0x5ib/ | lane1 #13 | PASS | monid-2 |
| 32 | neowin.net/news/your-claude-conversations-may-have-leaked-online-if-you-did-this/ | lane6 F56 | PARTIAL | Live URL is Cloudflare-walled (WebFetch 403, curl and r.jina.ai "Just a moment"). Read via Wayback snapshot 2026-08-24 of the 2026-07-27 article by David Uzondu. Incident confirmed: Claude share links (site:claude.ai/share) indexed by Google, no noindex tags, Google delisting. The lane's "and published artifacts" claim is not on this page (no occurrence of "artifact"). |
| 33 | forum.obsidian.md/t/82466 | lane5 B8 | PASS | joeweb list quote present |
| 34 | amitkoth.com/claude-share-link-not-working/ | lane6 F55 | PASS | All three quoted sentences verbatim, Jul 31 2026 (updated Aug 26) |
| 35 | forum.obsidian.md/t/24908 | lane5 B3 | PASS | "Why only 50MB?" present |
| 36 | forum.obsidian.md/t/49199 | lane5 B3 | PASS | "exceed 4gb" quote present |
| 37 | github.com/typora/typora-issues/issues/2476 | lane5 B14 | PASS | "hope support PicGo for image upload" in issue body |
| 38 | community.openai.com/t/1149810 | lane6 F53 | PASS | miggins OP and kwesi.walker reply present |
| 39 | producthunt.com/products/git-blog | lane3 #39 | PASS | Serge Punchev quote in cached ph_git-blog.html |
| 40 | x.com/obsdmd/status/2036880481980146149 | lane2 E7 | PASS | lane2-x-2 |
| 41 | mdtolink.com/ | lane4 pricing, lane6 F64 | PASS | Free 5 docs / 7-day expiry; Pro $6/mo or $3/mo ($36/yr); Publisher $18/mo or $9/mo ($108/yr); MCP sentence naming Claude Code, Cursor, Windsurf, Cline verbatim |
| 42 | github.com/anthropics/claude-code/issues/859 | lane6 F34, F35 | PASS | OP quote, waynemsmith and danneu comments all present |
| 43 | github.com/anthropics/claude-code/issues/5512 | lane6 F36 | PASS | Both OP phrases present |
| 44 | x.com/jfversluis/status/2039689306017759441 | lane2 D6 | PASS | lane2-x-12 |
| 45 | github.com/anthropics/claude-code/issues/14375 | lane6 F4 | PASS | Both phrases present |
| 46 | github.com/anthropics/claude-code/issues/16446 | lane6 F5 | PASS | "plugin does not render LaTeX" present |
| 47 | reddit.com/r/macapps/comments/1rhwmmz/ | lane1 #37, #38 | PASS | OP in monid-4, live-reload comment in monid-20 |
| 48 | forum.cursor.com/t/147558 | lane6 F26 | PASS | Both davecotter sentences present |
| 49 | github.com/gonzalezreal/swift-markdown-ui/issues/300 | lane5 A8 | PASS | Issue body matches |
| 50 | news.ycombinator.com/item?id=48072197 | lane6 F24 | PASS | ar_turnbull quote matches |
| 51 | forum.obsidian.md/t/15595 | lane5 B5 | PASS | Present |
| 52 | forum.obsidian.md/t/14755 | lane5 B5 | PASS | Joschua quote present |
| 53 | news.ycombinator.com/item?id=37776935 | lane3 #29 | PASS | millerhooks quote present in item tree |
| 54 | forum.obsidian.md/t/11766 | lane5 B4 | PASS | OP quote present |
| 55 | news.ycombinator.com/item?id=43773645 | lane3 #40 packetlost | PASS | Matches |
| 56 | mataroa.blog/ | lane4/lane7 $9/yr | PASS | "Premium — all features $9/year"; free tier "No custom domain"; 1MB/100MB image limits shown |
| 57 | producthunt.com/products/flowershow | lane3 #33 | PASS | swati_paliwal quote in cached ph_flowershow.html |
| 58 | reddit.com/r/ObsidianMD/comments/1v5dut5/ | lane1 #14 | PASS | monid-2 |
| 59 | reddit.com/r/ObsidianMD/comments/1w544z2/ | lane1 #18 | PASS | monid-2 |
| 60 | obsidian.md/pricing | lane4 8/site/mo annual, 10 monthly | PASS | "$8 USD Per site, per month, billed annually", "$10 USD ... billed monthly"; Sync $4/$5 |
| 61 | news.ycombinator.com/item?id=43118805 | lane3 #40 crooked-v | PASS | Matches; source has quotation marks around "per site" which the lane dropped (Having it "per site" feels like nickel-and-diming) |
| 62 | news.ycombinator.com/item?id=32129706 | lane7 Groxx | PASS | "The trend of everything being $5-10/month is ridiculous" present |
| 63 | hey.mataroa.blog/p/mataroa-is-cheap/ | lane7 #38 | PASS | Both phrases verbatim, 2022-08-25 |
| 64 | revenuecat.com/state-of-subscription-apps-2025 | lane7 44.1% vs 17.0%, 53.7% | PASS | 44.1%, 17.0%, 53.7%, 48.3% and the "Yearly plans significantly outperform" sentence all on page |
| 65 | jotbird.com/ | lane4 Pro 29/yr | PASS | "$29/year"; free links expire 30 days (90 with account); password, custom URLs, hosted images listed |
| 66 | itunes.apple.com/us/.../id=1225570693 | lane5 C1 | PASS | "A Paid App Disguised as Free" and "Deceptive Pricing" both in us feed |
| 67 | itunes.apple.com/de/.../id=1487937127 | lane5 C3 | PASS | "Nur 10 Dokumente" in de feed |
| 68 | forum.obsidian.md/t/96575 | lane5 C7 / lane7 #16 | PASS | Both trueschool phrases present |
| 69 | producthunt.com/products/hackmd | lane3 #42 | PASS | Matt UI369: "They autobilled me for another year and refused to give me a refund and cancel after 1 day"; rating 3.0/5 from 4 reviews |
| 70 | itunes.apple.com/us/.../id=1091189122 | lane5 C2 | PASS | "Why $$ to sync to iCloud?" in us feed |
| 71 | itunes.apple.com/us/.../id=775737590 | lane5 A11 | PASS | "looks exactly as the output in the LLM" in us feed |
| 72 | reddit.com/r/ClaudeAI/comments/1w0jpzo/ | lane1 #34, #35 | PASS | OP in monid-5, counter-signal comments in monid-18 |

## Totals

- PASS: 71
- PARTIAL: 1 (#32)
- FAIL: 0
- UNREACHABLE: 0
- Pass rate: 71 / 72 = 98.6%

## Minor wording notes (still PASS)

- #14: lane6 F21 attributes the "more than a hundred lines" sentence to the claude.com blog; confirmed verbatim in the raw HTML. WebFetch's summarizer only surfaced the neighbouring "100-line" sentence, so do not trust that summary if re-checking.
- #61: lane3 dropped the quotation marks around "per site" in crooked-v's comment.
- #16 and #25: the tweets contain line breaks between the quoted sentences; the lane joined them with a space.
- #32: neowin is only reachable through the Wayback Machine (snapshot 20260824195005); cite that snapshot URL if the live page stays walled.
