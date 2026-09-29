# Lane 3: Hacker News + Product Hunt findings for Seshat

Method: Algolia HN API (stories + item comment trees + comment search), Product Hunt launch pages fetched directly (r.jina.ai is CAPTCHA-blocked; direct fetch and curl work, comment bodies pulled from the page JSON). Dates are ISO. Engagement = HN points/comments or PH upvotes. Quotes are verbatim; where a quote contained an em-dash it was replaced with a comma and flagged [dash normalized]. Where the fetch tool returned an excerpt with an ellipsis, it is flagged [excerpt].

Tags: READING / WRITING / SHARING / PRICING. Age flag: [OLD] = older than 24 months.

---

## A. READING pain: AI-generated markdown is unpleasant to read in dev tools

### 1. SmallDocs author (HN)
- URL: https://news.ycombinator.com/item?id=47777633 (Show HN: SmallDocs, 2026-04-15, 92 pts / 50 comments)
- Who: FailMore (author)
- Quote: "Markdown files are slightly annoying to read/preview and fiddly to share/receive."
- Need: a dedicated reader plus a frictionless share path, in one tool.
- Tag: READING, SHARING

### 2. petersumskas on SmallDocs (HN)
- URL: https://news.ycombinator.com/item?id=47777633 (2026-04)
- Quote: "easily reading/rendering Markdown files has become more of a pain than it used to be" [excerpt, context: agent-based workflows]
- Need: reading volume of .md exploded with agents; old habits (editor preview) no longer scale.
- Tag: READING

### 3. franga2000 on SmallDocs (HN), objection
- URL: https://news.ycombinator.com/item?id=47822607 (2026-04-19)
- Quote: "When I click on a Markdown file, it opens in my code editor with the preview pane already open. Then I close it when I'm done."
- Need: none; this is the "VS Code preview is fine" objection Seshat must answer. He also lists MarkLite, Obsidian, LibreOffice as viewers.
- Tag: READING (objection)

### 4. saadn92 on SmallDocs (HN), adjacent need
- URL: https://news.ycombinator.com/item?id=47777633 (2026-04)
- Quote: "My actual problem with markdown isn't previewing, it's search" [excerpt]
- Need: finding a note weeks later; library search, not rendering.
- Tag: READING (adjacent)

### 5. tmanchester on cwmarkdown (HN)
- URL: https://news.ycombinator.com/item?id=48720506 (Show HN: macOS Native Markdown Reader with Vim Keybinding, 2026-06-29, 7 pts / 2 comments)
- Quote: "Looks nice! Finally a way to view all these md plans my agents make me lol"
- Need: a place to read agent plan files.
- Tag: READING

### 6. Kite author (HN)
- URL: https://news.ycombinator.com/item?id=48431648 (Show HN: Markdown Editor and Reader for Mac, 2026-06-07, 7 pts / 5 comments)
- Who: antonynjoro (author)
- Quote: "I read Markdown all day, mostly Claude .md, and other AI outputs. Every app I have tried felt janky or too much work to just read an md file."
- Need: a reader that is just a reader; sold as one-time purchase, no subscription. Two commenters asked for Windows.
- Tag: READING, PRICING

### 7. Simple Viewers author (HN)
- URL: https://news.ycombinator.com/item?id=47166806 (Show HN: Simple Viewers, 2026-02-26, 2 pts / 2 comments)
- Who: ryanlitalien (author)
- Quote: "When I would cmd+click into a newly created markdown plan, macOS would open Xcode. This was slow, didn't have native rendered viewing, the list goes on."
- Need: native, fast rendered view for Claude Code plan-mode files. Commenter ericb asked "Can it open multiple files at a time?"
- Tag: READING

### 8. docreator on Markdown Viewer and Editor (HN)
- URL: https://news.ycombinator.com/item?id=49514729 (2026-08-31, 34 pts / 20 comments)
- Quote: "Was just looking for one today, cuz wherever .MD is produced - not always has a preview like in VSCode or Cursor."
- Need: .md shows up outside the IDE (downloads, chat exports) with no preview.
- Tag: READING

### 9. shambo on same thread (HN)
- URL: https://news.ycombinator.com/item?id=49514729 (2026-08-31)
- Quote: "Most loved feature for me is the able to print/pdf the preview as-is and pre-view column width adjuster."
- Need: PDF export of the rendered view; adjustable measure.
- Tag: READING

### 10. Marky thread (HN), feature asks
- URL: https://news.ycombinator.com/item?id=47795468 (Show HN: Marky, markdown viewer for agentic coding, 2026-04-16, 75 pts / 38 comments)
- alsetmusic: "First thing that blocks me from adopting it is lack of ability to adjust text size."
- zmmmmm: "I want to add is the git and live update features though. I think those would be a game changer" [excerpt]
- mech422: "I tend to use 'bat' or 'glow' though I've tried 'mdlook' and 'mdcat' as well."
- gknapp: "I was using obsidian before this. There were two main frustrations for me with obsidian."
- slava_ (objection): "I don't think having this in a separate window adds value."
- hresvelgr (objection): "And since when is forking a web view 'light weight' too?"
- Need: text size control, live reload on agent writes, non-Electron; incumbents are glow/bat/Obsidian/Typora.
- Tag: READING (5 independent people)

### 11. rajatarya, native viewer built with agents (HN)
- URL: https://news.ycombinator.com/item?id=48200226 (2026-05-19, 6 pts / 1 comment)
- Quote: "I built Markdown Viewer because every Markdown app I found was either bloated (VS Code, Obsidian) or too bare-bones."
- Need: the middle ground between IDE and cat.
- Tag: READING

### 12. Markdown Prism thread (HN)
- URL: https://news.ycombinator.com/item?id=47015111 (2026-02-14, 5 pts / 3 comments)
- hulryung (author): "I wanted a lightweight Markdown viewer on macOS that wasn't Electron-based."
- unmarkdown: "Nice to see a native viewer. The electron fatigue is real."
- Leftium: "I've been using mdserve. A nice feature is a sidebar that lists all the MD files in a directory."
- Need: native, plus directory sidebar (Seshat's library sidebar matches).
- Tag: READING (3 people)

### 13. Scriptum author (HN)
- URL: https://news.ycombinator.com/item?id=49111536 (Show HN: Scriptum, 2026-07-30, 1 pt / 2 comments)
- Who: MS8080 (author)
- Quote: "The preview live reloads when another program writes the file, not just when you type." and "No accounts, no subscription. Files stay on disk as plain text. Paid app, one-time purchase."
- alwillis: "So many of my markdown files have YAML front matter, it would be nice for Scriptum to render it properly."
- Need: live reload when an agent writes the file; front matter rendering.
- Tag: READING, PRICING

### 14. leaf author (HN)
- URL: https://news.ycombinator.com/item?id=48400742 (2026-06-04, 3 pts)
- Who: RivoLink
- Quote: "I used glow before creating leaf, and the more I used it, the more I found myself wanting features like a persistent TOC, search, watch mode, and mouse support."
- Need: persistent outline, search, watch mode (Seshat outline overlay matches).
- Tag: READING

### 15. Nimbalyst thread (HN)
- URL: https://news.ycombinator.com/item?id=46318191 (2025-12-18, 29 pts / 5 comments)
- radial_symmetry: "I like that I can see the changes in rendered markdown instead of having to view them plaintext"
- Need: rendered view of agent edits.
- Tag: READING

### 16. Glance (Product Hunt)
- URL: https://www.producthunt.com/products/glance-native-macos-markdown-viewer (launched 2026-05-15, 81 upvotes, free; editing is "Glance Pro" $9.99 once after 14-day trial)
- Maker Klim Falkenberg: "Markdown is everywhere now: README.md, CLAUDE.md, AGENTS.md, specs, notes, and AI-generated docs from Claude Code or Codex. But in Finder, .md files are still awkward to preview."
- Roman Milyushkevich: "Opening Cursor or VS Code just to read a README is a small friction I hit ten times a day."
- Naor Sabag (objection to full apps): "Quick Look extension is the right surface. Most markdown viewers overshoot by being full apps."
- Leon M.: "After getting tired of Xcode preview I gave this a try."
- Need: instant rendered preview; note the counter-position that a full app is overkill.
- Tag: READING, PRICING (4 people)

### 17. showmd (Product Hunt)
- URL: https://www.producthunt.com/products/showmd-ai-markdown-quicklook-preview (launched 2026-04-13, 202 upvotes, free)
- Maker Johannes N: "I work with Markdown files all day. CLAUDE.md, AGENTS.md, README.md, they're everywhere now. But every time I hit Space in Finder to Quick Look one, I'd get a wall of raw text." [dash normalized]
- Dmytro Klymentiev: "I have a folder of nothing but .md files...opening any of them in Finder has been genuinely painful for two years." [excerpt]
- Thomas Schranz: "finally a good way to look at my markdown files that have mathematical formulas in them"
- unnamed commenter: "math is not really what shows up in my regular md files, but frontmatter and xml tags are. so happy to have this finally rendered in a 2026-ready way."
- Need: render CLAUDE.md-era markdown properly (front matter, XML tags, math).
- Tag: READING (4 people)

### 18. MD+HTML Reader (Product Hunt)
- URL: https://www.producthunt.com/products/md-html-reader (launched 2026-06-22, 117 upvotes; 30-day free trial then paid "intentionally low" price)
- Maker Ahab: "I built MD+HTML Reader because AI coding workflows created a new problem in my own work: the output is useful, but reviewing it is messy."
- Liam Kim: "This is the exact mess I deal with after a Claude Code session, plans and handoff notes end up scattered across folders and I end up grepping just to find what changed."
- Valeria: "The read-only review step after an agent generates docs is the part I'd actually use, I keep opening plan.md in my editor and half-editing it out of reflex." [dash normalized]
- Ashish Kushwaha: asked for Linux.
- Need: read-only review workspace over a project folder, "recently changed" docs, no accidental edits.
- Tag: READING (3 people)

### 19. Looq (Product Hunt)
- URL: https://www.producthunt.com/products/looq-3 (launched 2026-03-20, 98 upvotes; 7-day trial, one-time payment)
- ray_artlas: "I write a lot of docs in Markdown and always have to open a separate editor just to check if the diagrams render correctly. Does it support live-reloading, like if I edit and save a file while Quick Look is open?"
- Need: Mermaid rendering plus live reload.
- Tag: READING

### 20. Marked QL (Product Hunt)
- URL: https://www.producthunt.com/products/marked-ql (launched 2026-07-13, 159 upvotes; Brett Terpstra; listed $4.99 then price changed)
- Rizwan Haider: "Nice, Quick Look for markdown is one of those things macOS should have shipped with." [dash normalized]
- Arash Rahimi: "Since Quick Look runs sandboxed, does it resolve relative image paths and links inside the markdown file correctly"
- Lucas Haley: "Interesting, but definitely not "$4.99 on the Mac App Store"."
- Need: relative image resolution; pricing transparency.
- Tag: READING, PRICING (3 people)

### 21. mdview.io thread (HN), typography
- URL: https://news.ycombinator.com/item?id=46600762 (2026-01-13, 4 pts / 5 comments)
- treetalker: "My one criticism is that the color of dark-mode headings makes them almost illegible."
- Need: dark mode typography done right.
- Tag: READING

### 22. Ask HN llm.txt thread (HN)
- URL: https://news.ycombinator.com/item?id=48410589 (2026-06-05, 36 pts / 57 comments)
- onion2k: "The only annoyance is web browsers like chrome do not render the markdown."
- solumos: "Now, it would be super cool to get markdown and zero javascript bundles"
- Need: plain markdown as a reading format for humans, rendered somewhere.
- Tag: READING, SHARING

### 23. MEVA (HN, category signal only)
- URL: https://news.ycombinator.com/item?id=46975959 (Show HN: MEVA, a desktop Markdown reader for AI-generated docs, 2026-02-11, 1 pt / 0 comments)
- Signal: at least 12 "markdown reader/viewer for AI docs" Show HNs in 2026 alone (MEVA, Marky, Kite, cwmarkdown, mdreader, Glimpse, Smackdown, Mrkd, Attn, Markdific, MarkView, quicklookmd). Crowded, low-engagement category; reader alone is not a moat.
- Tag: READING

---

## B. SHARING pain: get a .md to someone as a link

### 24. mdto.page author (HN)
- URL: https://news.ycombinator.com/item?id=46645942 (Show HN: mdto.page, 2026-01-16, 58 pts / 31 comments)
- Who: hjinco (author)
- Quote: "I often needed a quick way to share Markdown notes or documentation as a proper webpage, without setting up a GitHub repo or configuring a static site generator."
- Need: upload .md, get URL, nothing else.
- Tag: SHARING

### 25. mdto.page commenters (HN)
- URL: https://news.ycombinator.com/item?id=46645942
- acrophiliac: "I'm guessing it doesn't handle images because you'd have to upload the image"
- saltwounds: "I like the idea and expiration dates."
- KomoD: "I really suggest adding some way to report pages because phishers will abuse it"
- wiether: "Because you can't use it in a CI" ; souvlakee: "Adding an API can significantly increase the number of users"
- moeadham (on client-side URL sharing limits): "For desktop chrome it's 2MB, but for mobile Safari its 80KB."
- Igor_Wiwi: "In mdview.io I implemented sharing via url encoding so no server is needed"
- Need: image hosting, expiring links, abuse reporting, CLI/API publish. Serverless (URL-encoded) sharing hits size caps, which argues for a hosted layer.
- Tag: SHARING (6 people)

### 26. Pagecast author (HN)
- URL: https://news.ycombinator.com/item?id=48590505 (Show HN: Pagecast, 2026-06-18, 54 pts / 13 comments)
- Who: amaldavid (author)
- Quote: "I built this because I kept generating HTML/Markdown reports from Claude Code/Codex and needed a permanent share link instead of a localhost tunnel."
- Need: permanent link for agent-generated reports.
- Tag: SHARING

### 27. Pagecast commenters (HN)
- URL: https://news.ycombinator.com/item?id=48590505
- hbcondo714: "Is there by chance a way to password protect the generated site?"
- karthickrmchn: "When a URL is re-synced, do you keep older versions anywhere or does the new deployment completely replace them?"
- crisscrosscrash: "MCP would be a nice addition. Remote MCP could even allow you to share it with coworkers"
- mpeg (objection): "I don't see much of a difference between just asking claude to write a wrangler config to push to cf pages"
- rolymath: "Readme needs screenshots."
- Need: password links, version history on update-in-place, agent-callable publish. Objection: devs can DIY on Cloudflare Pages.
- Tag: SHARING (4 people)

### 28. Publish Markdown thread (HN)
- URL: https://news.ycombinator.com/item?id=45002329 (Show HN: Publish Markdown, 2025-08-24, 8 pts / 7 comments)
- Author: "I built this tool because I couldn't find a simpler solution to my problem (publish a markdown file and make it available online so other people can see)."
- zscc: "password protection is necessary. Add account features." [excerpt]
- pkstr: "I like that you don't force people to sign up to use your product. But be careful of bot or fraudster though."
- Need: password protection; no-signup publishing vs abuse.
- Tag: SHARING (3 people)

### 29. amarkdown thread (HN) [OLD, high engagement]
- URL: https://news.ycombinator.com/item?id=37776935 (2023-10-05, 62 pts / 60 comments)
- millerhooks: "Why can't I post to custom domains. I would have upgraded to a paid subscription if you let me point domains at it."
- stronglikedan: "This was my experience: 'Try it' → 'Log in' → close tab"
- Need: custom domain is a stated upgrade trigger; forced login before trying kills conversion.
- Tag: SHARING, PRICING (2 people)

### 30. Uselink (Product Hunt)
- URL: https://www.producthunt.com/products/uselink (launched 2026-06-03, 151 upvotes, free alpha, pricing "coming soon" with a "cup of coffee" tier planned)
- Maker (nathan_tran2): "i make pages and docs with ai all the time. a one-pager, a little report, a landing page i put together with Claude. and I hate having this nice HTML sitting in a chat window with no real way to share it. so i'd screenshot it. or paste the code into a file and email it." [excerpt]
- Ngoc Hoang: "The 'made something great in Claude and now it's stuck in a chat window' problem is painfully real."
- Hoang Anh Cao: "Claude creates it, Uselink hosts and shares it, and I end up looking much more put together."
- Khanh Phan: "if a reader comments on a paragraph and I later edit that paragraph in a new version, does the comment stay anchored or does it drift?"
- Thami Benjelloun: "How do you prevent spam when comments are open, especially on links that get shared widely?"
- Rob (robmcd85): "Could I ask when you are coming up with pricing, that you consider a limited free option for very small or small non-profits?"
- Reviews page summary: recurring asks were custom domain, password protection, comment anchoring across versions.
- Need: AI output stuck in chat window; update-in-place with versions; access control; free tier expectation.
- Tag: SHARING, PRICING (6 people)

### 31. HT-ML.app author (HN), counter-signal
- URL: https://news.ycombinator.com/item?id=48749414 (2026-07-01, 1 pt / 2 comments)
- Who: nsmith22
- Quote: "Like many others, I have moved away from markdown for planning features; I prefer html for any sort of shared documentation." and "I wanted to something that was 1) free 2) didn't require account signup 3) secure enough (password protection on pages) 4) scalable"
- Need: free, no-signup, password-protected sharing. Counter-signal: some people share HTML artifacts, not .md.
- Tag: SHARING

### 32. Claudebin (Product Hunt)
- URL: https://www.producthunt.com/products/claudebin (launched 2026-02-20, 258 upvotes, #4 of day, free, open source)
- Maker: "after a long session, there isn't a simple way to share exactly what happened with someone else. Prompts, responses, file edits, and tool calls all stay inside the terminal."
- Temian Mihai: "I've always wanted to share my Claude sessions with my team"; asked for organizations "so I can share the sessions only with my team".
- agraciag: "Is there an option to make it private by default?"
- Andrian Valeanu: "sharing the process with teammates is basically impossible without screenshots or messy summaries." [excerpt]
- Curious Kitty: asked about "redaction, encryption, access control, retention/deletion".
- Need: share agent output with a team; private-by-default and team scoping are the first asks.
- Tag: SHARING (5 people)

### 33. Flowershow (Product Hunt)
- URL: https://www.producthunt.com/products/flowershow (launched 2026-03-25, 174 upvotes, #7 of day; free plan 1 site on subdomain with 100MB soft limit and footer badge; premium from $5/mo for custom domain, remove branding, full-text search)
- swati_paliwal: "does it support easy custom domains and RSS feeds out of the box for better sharing?"
- ban_scio: "is it free all-time ? or i have one (flowershow) domain for all docs ?" and "a 100mb will make a fear for personal using for one like me"
- jens_deryckere1: "any plans to support multiple sites under one account?"
- borrellr_: "Can you connect it directly to an Obsidian vault or does it require a separate markdown repo?"
- Need: custom domain, permanence of free tier, quota anxiety, publish straight from the local vault.
- Tag: SHARING, PRICING (4 people)

### 34. kbar13 on OpenKnowledge (HN)
- URL: https://news.ycombinator.com/item?id=48675435 (2026-06-25, 381 pts / 173 comments)
- Quote: "obsidian: great for LLMs (local markdown files), bad for collaboration; notion: not great for LLMs, great for collaboration"
- pcthrowaway (same thread): asked about syncing "for individuals who might want to edit their notes from multiple devices"
- Need: local markdown that can still be shared; multi-Mac sync.
- Tag: SHARING (2 people)

### 35. Private viewer vs share link (HN)
- URL: https://news.ycombinator.com/item?id=42207846 (Show HN: stupid simple private Markdown viewer, 2024-11-21, 5 pts / 4 comments)
- zhanghao2018: "Unable to share link?"
- freakynit (author): "Wanted to add this functionality.. but then it won't remain private.. hence, didn't add."
- Need: the first thing asked of a private viewer is a share link; privacy and sharing are the tension to design for.
- Tag: SHARING

### 36. Markdown Bin (Product Hunt) [OLD]
- URL: https://www.producthunt.com/posts/markdown-bin (2019, 76 upvotes)
- Maker Cristian Antohe: "Something I did because a friend was complaining about sharing some longer pieces of text via a link."
- Need: no-account paste-and-share with a secret edit link. Pattern still valid.
- Tag: SHARING

### 37. Markdown Share (Product Hunt)
- URL: https://www.producthunt.com/products/markdown-share (2024, 2 upvotes, free)
- Maker: "I found it really hard when using websites like sourcebin to share code as I need to also add explanations and more so I created this site for sharing markdown"
- Need: code plus prose sharing beyond gist/pastebin. Very low engagement.
- Tag: SHARING

### 38. md2cb (HN)
- URL: https://news.ycombinator.com/item?id=46896623 (2026-02-05, 12 pts / 7 comments)
- letientai299 (author): "At work I need to use Teams. It supports a few Markdown features, but the editing experience for long message isn't smooth."
- Need: getting markdown into chat tools as rich text; adjacent to "send a link instead".
- Tag: SHARING (adjacent)

### 39. Git Blog (Product Hunt)
- URL: https://www.producthunt.com/products/git-blog (launched 2026-03-30, 149 upvotes; free with IAP)
- Serge Punchev: "The image resize and optimise step is the part that would actually save me the most time"
- Nithin S (objection): "how is this different from publishing a Notion site?"
- Dave Campbell: "$2.99 just to see how the ONE free draft looks on my site? I might love it, but shy away from extortion."
- Need: image handling is the valued part; paywalling the first publish reads as extortion.
- Tag: SHARING, PRICING (3 people)

---

## C. PRICING reactions

### 40. Obsidian Publish price complaints (HN comments)
- crooked-v, https://news.ycombinator.com/item?id=43118805 (2025-02-20): "Having it per site feels like nickel-and-diming for small things that's kept me on Notion for a lot of miscellaneous web-published projects. It would be more appealing for at least me if it was something with a higher flat rate that then doesn't care about the exact divisions between your projects."
- packetlost, https://news.ycombinator.com/item?id=43773645 (2025-04-23): "The one issue I have with Obsidian Publish is it's a bit of a pain to put your own SSL-secured domain in front of it. I can see why someone would not want to pay $8/m for it though when there are a ton of free options out there."
- wonger_, https://news.ycombinator.com/item?id=42572156 (2025-01-02): "Although it's a paid service and it seems a little clunky."
- microtonal, https://news.ycombinator.com/item?id=43772509 (2025-04-23): shout-out to Quartz; would prefer Obsidian Publish but hit "rendering performance issues" [paraphrase from fetch]
- FalconSensei, https://news.ycombinator.com/item?id=41782438 (2024-10-08): "I could use Quartz or some other alternative for building a site from my obsidian vault but... none will just work out of the box, from your phone"
- rbits, https://news.ycombinator.com/item?id=48181937 (2026-05-18): "since all Obsidian notes are in plain markdown there are already many free alternatives."
- Two 2022 blog posts on HN titled "Obsidian Publish Should Not Cost $198 a Year to Use" (ids 31515918, 30348129, 2 pts each) [OLD].
- Need: flat, cheap, not per-site; custom domain with SSL must be painless; "works out of the box" beats free DIY. 8.99/yr flat sits far below the $96/yr reference point.
- Tag: PRICING (6 people)

### 41. One-time purchase preference (HN)
- Typora 1.0 thread, https://news.ycombinator.com/item?id=29360720 (2021-11-27, 145 pts / 100 comments) [OLD, high engagement]: PhilipTrauner "A one time 15$ purchase is a steal for all the value I got out of the beta versions over the years."; skinkestek "I just realized I wanted to buy it even if I don't use it just because it is an honest one time purchase."; digitalsanctum "I've gladly paid the one time fee and plan to continue using it over Obsidian and Roam."
- IF thread, https://news.ycombinator.com/item?id=41825041 (2024-10-13, 11 pts / 66 comments): Brajeshwar "Typora is a one-time buy of $15; the app here, IF, is $3 /mo."; indrora "It's not free and not an alternative to Typora."
- Ferrite thread, https://news.ycombinator.com/item?id=46571980 (2026-01-11, 241 pts / 190 comments): gregman1 "The $15 price tag for Typora seems a bit steep considering the fundamental features it provides."; swiftcoder "The price of a fancy burger doesn't seem all that unreasonable for a piece of software one finds even moderately useful"; Arubis "I happily paid money for Typora"
- Recent app authors positioning explicitly against subscriptions: hsaikia https://news.ycombinator.com/item?id=48767053 (2026-07-02) "Karja Pro will never have a subscription-based model"; martylamb https://news.ycombinator.com/item?id=46312003 (2025-12-18) "It's a one-time purchase, not a subscription."; MS8080 (Scriptum, above); Kite (above); Wrangle PH $19 one-time.
- Need: HN strongly prefers one-time for local apps; a subscription is tolerated only when it pays for hosting. Seshat's split (free app, paid hosted Share) matches this exactly. Say so explicitly on the pricing page.
- Tag: PRICING (11 people)

### 42. HackMD billing complaint (Product Hunt)
- URL: https://www.producthunt.com/products/hackmd (3.0/5 from 4 reviews; latest launch 2024-08-29, 19 upvotes)
- Matt UI369: "They autobilled me for another year and refused to give me a refund."
- Need: annual plans must warn before renewal; refund policy visible.
- Tag: PRICING

### 43. Mataroa benchmark (Product Hunt)
- URL: https://www.producthunt.com/products/mataroa (2022, 102 upvotes, #11) [OLD]
- Pricing: free, $9/year for custom domain. Pratul: "I immediately cancelled my Posthaven subscription"
- Need: $9/yr for custom domain is an accepted price point among minimalists. Direct comparable to Seshat Share at 8.99/yr.
- Tag: PRICING

### 44. Marked 3 (Product Hunt / web)
- URL: https://www.producthunt.com/products/marked-2 (launched 2026-05-28, 14 upvotes); pricing per macsparky.com: $2.99/mo or $29.99/yr, plus a permanent unlock, also on Setapp.
- Need: incumbent Mac previewer moved to subscription with a buyout escape hatch; PH reception was flat (14 upvotes vs 159 for its own free-ish Quick Look plugin).
- Tag: PRICING

### 45. kyledrake on markdownsites (HN) [OLD]
- URL: https://news.ycombinator.com/item?id=13005792 (2016-11-21, 291 pts / 156 comments)
- Quote: "don't be afraid to ask for money - at least $5/mo" [excerpt; Neocities founder]
- Need: hosted publishing has been priced at $5/mo since 2016; 8.99/yr is an order of magnitude cheaper.
- Tag: PRICING

---

## D. WRITING / editing (out of Seshat's core, but relevant to its conflict detection)

### 46. OpenMarkdown (Product Hunt)
- URL: https://www.producthunt.com/products/openmarkdown (launched 2026-07-18, 189 upvotes, #5, free)
- Dipankar Sarkar: "When an agent edited a CLAUDE.md I was mid-sentence in, the pain wasn't a merge conflict, it was losing my cursor position and undo history to a wholesale rewrite"
- Valeria: "When the agent and I write to the same section at once, how does it reconcile: file-watch reload with last-write-wins, or an actual diff merge so my in-flight edits aren't clobbered?"
- Need: agent-writes-while-I-edit must preserve cursor and undo; validates Seshat's external-change detection but raises the bar (section-level diff, not reload).
- Tag: WRITING (2 people)

### 47. Ferrite thread, media handling (HN)
- URL: https://news.ycombinator.com/item?id=46571980 (2026-01-11)
- vunderba: "I really like its ability to auto-create a related assets folder for embedded media"
- fmichel42: "the main feature Ferrite is currently lacking to be used for most applications where I use Typora is a way to easily write and render maths formula"
- Need: local image asset handling; math rendering.
- Tag: WRITING, READING

### 48. dolmen on SmallDocs (HN)
- URL: https://news.ycombinator.com/item?id=47777633
- Quote: "Gemini is very bad at producing them... the Markdown was broken from the closing first code block." [excerpt]
- Need: renderer must be forgiving of malformed AI markdown (unclosed fences).
- Tag: READING

---

## SUMMARY

### Top needs ranked by independent-source count
1. Read agent/AI-generated .md outside the IDE, natively and fast (about 20 people: FailMore, petersumskas, tmanchester, antonynjoro, ryanlitalien, docreator, rajatarya, hulryung, unmarkdown, Klim Falkenberg, Roman Milyushkevich, Dmytro Klymentiev, Johannes N, Ahab, Liam Kim, Valeria, Rizwan Haider, radial_symmetry, GRVYDEV, onion2k). READING.
2. Share a .md as a link without repo, SSG, or signup (about 13: hjinco, amaldavid, Uselink maker, Ngoc Hoang, Hoang Anh Cao, Cristian Antohe, Publish Markdown author, Flowershow makers, kbar13, Andrian Valeanu, Temian Mihai, nsmith22, Markdown Share maker). SHARING.
3. One-time purchase over subscription for the local app; subscription acceptable only for hosting (about 11 named). PRICING. Seshat's model matches; state it loudly.
4. Private, password, or team-scoped links, private by default (7: hbcondo714, zscc, nsmith22, agraciag, Curious Kitty, Temian Mihai, Uselink reviewers). SHARING. Strongest paid-feature signal after the link itself.
5. Flat cheap pricing, not per-site; free tier that is clearly permanent (7: crooked-v, packetlost, Dave Campbell, robmcd85, ban_scio, Lucas Haley, Matt UI369). PRICING.
6. Custom domain as the upgrade trigger (5: millerhooks, swati_paliwal, packetlost, Uselink reviewers, Mataroa $9/yr precedent). SHARING, PRICING.
7. Live reload when an agent writes the file, plus "what changed recently" (5: zmmmmm, MS8080, RivoLink, ray_artlas, Liam Kim). READING.
8. Mermaid, LaTeX, front matter, XML tags render correctly (5: ray_artlas, Thomas Schranz, fmichel42, msravi, showmd commenter). READING.
9. Images in shared docs (4: acrophiliac, vunderba, Serge Punchev, Arash Rahimi). SHARING.
10. Folder sidebar, persistent TOC, search across files (4: Leftium, RivoLink, FailMore, saadn92). READING.
11. Update in place with version history and comment anchoring (3: karthickrmchn, Khanh Phan, Mofoluwasho Jimoh). SHARING.
12. Text size / measure / dark-mode typography controls (3: alsetmusic, shambo, treetalker). READING.
13. Expiring links (2: saltwounds, Uselink feature list). SHARING. Weak signal.
14. Library sync across devices (2: pcthrowaway, FalconSensei "from your phone"). Weak signal on HN/PH.
15. View stats: zero mentions anywhere. Publish-folder-as-mini-site: only as Flowershow/Quartz/Obsidian Publish (existing crowded category), no unmet asks found.

Objections to have an answer for (7 people): "VS Code preview pane is fine" (franga2000), "Quick Look is the right surface, full apps overshoot" (Naor Sabag), "separate window adds no value" (slava_), "just ask Claude to push to Cloudflare Pages" (mpeg), "how is this different from a Notion site" (Nithin S), "plain markdown already has many free publish alternatives" (rbits), "my problem is search, not preview" (saadn92).

### Notable tools found, with pricing
- Uselink (PH 151, 2026-06): paste HTML/MD, link under handle, comments, versions, password/expiry/view limit; free alpha, pricing TBD, "cup of coffee" tier planned.
- Flowershow (PH 174, 2026-03): free 1 site, 100MB, footer badge; premium from $5/mo for custom domain, no branding, search.
- Claudebin (PH 258, 2026-02): share Claude Code sessions as URLs; free, open source.
- Pagecast (HN 54): CLI publish MD/HTML to Cloudflare Pages, password flag; free/OSS.
- mdto.page (HN 58): upload MD, public URL, expiration, two themes; free.
- SmallDocs sdocs.dev (HN 92): client-side, content in URL fragment; free.
- Publish Markdown, JotBird, wrds.cc, md2.website, markdown.link, tmplink, Webklip: tiny 2025-2026 paste-and-share tools, all 0-8 pts on HN.
- Obsidian Publish: $8/mo per site ($96/yr), widely called nickel-and-diming.
- Mataroa: free, $9/yr custom domain. Bear Blog, write.as, telegra.ph, rentry: no HN/PH discussion found in window.
- HackMD: PH rating 3.0/5, autobilling complaint.
- Readers: Glance (free, Pro $9.99 once), showmd (free), Looq (one-time, trial), Marked QL (about $4.99 to $9.99, price changed), Marked 3 ($2.99/mo, $29.99/yr, or permanent unlock), Kite (one-time), Scriptum (one-time), Wrangle ($19 one-time), MD+HTML Reader (trial then low paid), Typora ($15 once, the reference point), Marky/mrkd/MEVA/Glimpse/Smackdown/Attn (free).

### Queries tried
HN Algolia (stories): "markdown" share link (points>20); show hn markdown; show hn markdown viewer; show hn markdown publish; paste markdown link; "markdown to website"; "gist alternative"; "obsidian publish"; "claude code" markdown; "self-hosted" docs markdown; "notion alternative" markdown; markdown reader mac; "share a document" link; markdown "custom domain"; hackmd; typora; "iA Writer"; "marked 2"/typora/"ia writer" OR combo; chatgpt share output markdown; publish markdown folder site; "quick look" markdown; markdown claude/ai-generated viewer (2025+); markdown pastebin/paste/expire; ask_hn markdown viewer; ask_hn "markdown" "share" "link"; bearblog/write.as/mataroa/telegra.ph/rentry; quartz/"digital garden".
HN Algolia (comments): "obsidian publish" (2024-09+); "share" "markdown" "link" claude; "markdown" "read" "claude" plan file; "I'd pay" markdown; "markdown" "vs code" preview ugly; "markdown" "password" share; hedgedoc/hackmd share; notion "public page"; "markdown" agents "read" obsidian/vs code; "glow" markdown terminal; "markdown" "subscription" "one-time"; "bear blog"; rentry/telegra.ph/write.as; notion "publish"/"share to web"; "custom domain" "per year"; markdown claude obsidian plans; "plan mode" markdown open.
Product Hunt (via WebSearch site: then direct fetch): markdown share/publish; markdown viewer mac; "paste markdown"/"markdown to link"; markdown blog gist alternative; share ChatGPT/Claude output as link; bearblog/mataroa/montaigne/write.as/notepin/telegra.ph; obsidian publish/quartz/hackmd/rentry; markdown reader "AI-generated"/"Claude Code"; markdown publish "custom domain" 2025/2026. Pages fetched: uselink (+reviews), flowershow, markdown-bin, markdown-share, glance, marked-2, looq-3, showmd, claudebin, markdown-studio, marked-ql, md-html-reader, wrangle-4, hackmd, mataroa, pagecord, openmarkdown, git-blog, gist-3/alternatives.

### Empty or useless queries
- HN "markdown to website" (0), "marked 2" OR typora OR "ia writer" points>30 (0; Algolia does not honor OR), "iA Writer" points>30 (2 hits, neither about sharing), hackmd stories (only documents hosted on hackmd, no product discussion), bearblog/write.as/mataroa/telegra.ph/rentry stories points>15 (0), quartz/"digital garden" (0), "self-hosted" docs markdown (2 hits, off-topic).
- HN comment searches returning 0: "I'd pay" markdown (2023+); "markdown" "vs code" preview ugly/hard to read; hedgedoc/hackmd share; notion "public page"/"share publicly"; markdown agents read obsidian/vs code preview; "bear blog"; rentry/telegra.ph/write.as; notion publish/share to web; "custom domain" per year blog; markdown claude obsidian plans; "plan mode" markdown open/view/read. Multi-term comment queries are ANDed by Algolia, so several of these were too narrow; the topic may still exist under other phrasing.
- HN "markdown" "read" "claude" plan file comments: many hits about writing plans, none about where they are read.
- Product Hunt: write-md returned 403; gist-3/alternatives page is polluted with unrelated audio apps; Marked 3 page had no reviews; Markdown Studio page had no comments captured.
- No HN or PH mention found of view stats for shared markdown, or of "publish a folder as a mini site" as an unmet need.
