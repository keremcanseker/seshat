# Lane 5: Review mining for Seshat

Collected 2026-09-06. Method: pulled the Apple customer-review RSS feeds (us, gb, de, au, ca; pages 1-2) for 15 Mac App Store apps (2,901 unique reviews) plus the iOS feeds for Obsidian and Notion (538 reviews), then grepped for low ratings and share/publish/export/price keywords. GitHub issues via the `gh` CLI (search API sorted by reactions). Obsidian forum via its Discourse JSON endpoints. Review aggregators via r.jina.ai where they were not CAPTCHA-walled.

Caveats:
- Apple RSS feeds for universal apps (Bear, Craft, Ulysses, iA Writer, Taio, Drafts) mix iOS and Mac reviews; quotes are labelled with the storefront country, not the device.
- Apple review URLs are not addressable per review. The URL given is the feed the review was pulled from; the title and date identify it.
- OBSERVED = quoted from source. INFERRED = my reading of what the reviewer needs.
- Quotes are verbatim, max two sentences, typos preserved.

Legend: READING / WRITING / SHARING / PRICING. Star ratings shown where the source has them.

---

## A. READING (rendering, layout, navigation, reader-only tools)

### A1. Typora: "just want to read them and reference them"
- URL: https://github.com/typora/typora-issues/issues/710
- Date: 2017-05-18 (OLDER than 24 months; still open, +62 reactions, comments through 2018)
- Quote (issue body): "when i read some article that is myself or everybody. i don't want to change anything i don't want to change."
- Quote (comment, shesgottadevelopit, 2017-05-25): "I found this program searching for a solution for just viewing/reading markdown files. I have a lot of markdown files for class and I just want to read them and reference them, not make any changes unintentionally."
- Need: a pure reader that cannot accidentally edit and where links are clickable without modifier keys (vassudanagunta, 2018-07-25, +6: "One should be able to click on links without having to hold down the command key to navigate them.")
- Tag: READING. OBSERVED. Independent voices in thread: 4+.

### A2. Read.md (MAS): no live reload when the file changes on disk
- URL: https://itunes.apple.com/us/rss/customerreviews/id=6760943472/sortBy=mostRecent/json (app id 6760943472)
- Date: 2026-08-12, 3 stars, "Not a bad app, needs some polish"
- Quote: "However, it doesn't seem to detect when the md file has been edited, it doesn't auto refresh, or offer a popup notifying you the file has changed and offers to reload there. That feature would gain another star from me."
- Need: reader must watch the file and re-render (Seshat already does this via FSEvents; a marketing point).
- Tag: READING. OBSERVED.

### A3. Read.md (MAS): rendering breaks offline
- URL: same feed as A2
- Date: 2026-05-26, 3 stars, "Really great rendering, but buggy when offline"
- Quote: "I have a lot of .md files I need to quickly open and use as reference. But when I don't have an internet connection, I get a spinning wheel in the rendering frame."
- Need: a native, offline renderer (web-view-based readers fail here).
- Tag: READING. OBSERVED.

### A4. One Markdown (MAS): fixed width and no margin control
- URL: https://itunes.apple.com/us/rss/customerreviews/id=1507139439/sortBy=mostRecent/json
- Date: 2026-07-20, 3 stars, "Great app, missing 1 critical feature." Quote: "Great app for writing and reviewing markdown, but it's missing one critical feature…. Adjustable margins. No matter how wide the window, the margins remain the same size with no adjustable options."
- Date: 2026-04-15, 3 stars, "Fixed width". Quote: "This tool cuts off the right side of the markdown. I tried widening the window and it still cuts off the right side of the markdown."
- Also Paper (id 1143513744), au, 2023-01-25, 3 stars (OLDER): "The margins are too wide and there doesn't seem to be any option to reduce them."
- Need: measure/width that adapts to window; wide code blocks must not clip. Seshat's 720/920pt clamp is exactly this design decision; expect one segment of users to ask for a width slider.
- Tag: READING. OBSERVED. Independent reviewers: 3.

### A5. One Markdown (MAS): no search in preview mode, no search inside files
- URL: same feed as A4
- Date: 2026-06-20, 2 stars, "No Cmd-F in preview mode". Quote: "There is a search feature in the edit mode (raw md file), but in preview mode, there is no search. Uninstalling because of this."
- Date: 2024-07-25 (gb), 3 stars, "Great but doesn't search within files". Quote: "Unfortunately I only afterwords realised that when I search it only searches for the name of files and not inside the notes which makes it unsuitable for finding things."
- Need: Cmd-F in the rendered view, and full-text search across the library.
- Tag: READING. OBSERVED. Independent reviewers: 2.

### A6. iA Writer (MAS): no table of contents
- URL: https://itunes.apple.com/us/rss/customerreviews/id=775737590/sortBy=mostRecent/json
- Date: 2026-02-09, 1 star, "No table of contents"
- Quote: "What's so difficult about providing a table of contents. One Markdown, MultiMarkdown Composer, Drafts, Bear, Up Note and others have found a way."
- Related: QLMarkdown issue #161 (2025-08-14, +2) "Is there a way to add a table of contents as a sidebar in one of the next releases? I think it would be really useful esp. for long documents." https://github.com/sbarex/QLMarkdown/issues/161
- Need: outline/TOC for long documents (Seshat's outline overlay).
- Tag: READING. OBSERVED. Independent reviewers: 2.

### A7. QLMarkdown (Quick Look reader) is rotting: Homebrew deprecation and Tahoe breakage
- URL: https://github.com/sbarex/QLMarkdown/issues/165 (2025-08-27, +17, "Deprecated on Homebrew!") Quote: "As stated in the `brew info` response, it looks like it will be deprecated soon, if still mantained, can you please fix it?"
- URL: https://github.com/sbarex/QLMarkdown/issues/202 (2026-05-19, +3, "Don't work in macos tahoe.26.5") Quote: "I installed it through brew, opened the app, and it still doesn't appear in the quicklook list."
- Need: a maintained way to preview .md from Finder on current macOS. Gap Seshat could fill with a Quick Look extension or "Open With" story.
- Tag: READING. OBSERVED.

### A8. Mermaid and math in the reader
- QLMarkdown #162 (2025-08-15, +7): "Would it be possible to support rendering of mermaid charts?" https://github.com/sbarex/QLMarkdown/issues/162 ; #175 (2025-12-28, +2) "Please render inline Mermaid charts"
- swift-markdown-ui #300 (2024-02-13, +38, the top-voted issue on Seshat's own rendering dependency): "It would be great to incorporate Latex support." https://github.com/gonzalezreal/swift-markdown-ui/issues/300
- Taio (id 1527036273), de, 2024-04-23, 1 star: "Taio is a great editor, but the Mermaid plugin definitely need an update."
- Need: diagrams and math render in the reader.
- Tag: READING. OBSERVED. Independent voices: 4.

### A9. swift-markdown-ui: text selection limited to one paragraph
- URL: https://github.com/gonzalezreal/swift-markdown-ui/issues/264
- Date: 2023-10-06 (OLDER), +23 reactions, open
- Quote: "When multiple paragraph strings are presented in a `MarkdownUI` view, the user can only select text from one paragraph at a time."
- Need: copy a whole passage from a rendered doc. Directly affects Seshat since it uses this library; a reviewer will hit it.
- Tag: READING. OBSERVED.

### A10. Reader-only tool judged poor value at 14 EUR (Marked 2)
- URL: https://itunes.apple.com/de/rss/customerreviews/id=890031187/sortBy=mostRecent/json
- Date: 2026-06-28 (de), 2 stars, "Der Nutzen hält sich in der Praxis in Grenzen"
- Quote: "Dafür, dass man mit Marked 2 nur ausgeben und nicht einmal schreiben kann, ist eine eher seltene Nutzung eigentlich abzusehen. Leider wird das Programm ausschließlich auf englisch zur Verfügung gestellt."
- Need: (INFERRED) a paid reader-only app is a hard sell; supports keeping Seshat's reader free and charging for hosting instead.
- Tag: READING / PRICING. OBSERVED quote, INFERRED implication.

### A11. Reading LLM output: "looks exactly as the output in the LLM" but cannot share it well
- URL: https://itunes.apple.com/us/rss/customerreviews/id=775737590/sortBy=mostRecent/json (iA Writer)
- Date: 2025-04-15, 3 stars, "Misses pagination"
- Quote: "With iA Writer the document looks exactly as the output in the LLM. But what it is missing is the proper conversion to PDF to share AI output."
- Need: paste/open AI-generated markdown, read it properly, then hand it to someone. This is Seshat's exact wedge (long markdown from dev tools is unpleasant to read and share).
- Tag: READING / SHARING. OBSERVED.

### A12. Performance with long documents and large folders
- Ulysses (id 1225570693), us, 2026-09-04, 1 star: "Above 400 words per sheet on my 13" iPad Pro m5 and the Magic Keyboard, and the typing lag is unbearable."
- Ulysses, us, 2025-11-25, 1 star: "About a week ago, working on a (n admittedly long, about 250 pages?) document, doing anything with the sidebar or window view would lock up the application."
- Markdown Editor (id 1458220908), us, 2026-02-12, 1 star: "Opened a basic MD file, and set about making edits. Within minutes simply typing text ground to a halt, and I watched as a backlog of characters ever so slowly dripped out."
- Taio (id 1527036273), de, 2024-05-22, 3 stars: "Tried to add my obsidian vault (1500 Files) and even with this relatively small vault it crashes constantly :("
- iA Writer, us, 2025-11-10, 3 stars: "I have a new-ish MacBookAir (M3) and iA Writer is literally the only app I see the dreaded spinning beachball with."
- Need: long docs and 1,000+ file libraries must stay fluid. Seshat renders each section as a separate MarkdownUI view; stress-test against samples/stress.md before launch.
- Tag: READING / WRITING. OBSERVED. Independent reviewers: 5.

### A13. Users reject app-owned libraries; they want plain files where they already live
- Bear (id 1091189122), us, 2025-01-02, 2 stars, "Can't open/save.": "You CAN open a file… but only by import. You CAN save it… but only by export."
- MWeb (id 1183407767), us, 2025-01-02, 3 stars, "Library is a nuisance": "I've already got an absolutely lovely file system. What I want is an outlining, folding, markdown editor."
- Obsidian iOS (id 1557175442), gb, 2026-05-12, 1 star, "Limited to saving to vault": "No, I don't want to be limited to some weird location that then needs its own synch sub system, just use native network capabilities & let me decide where I keep things"
- Ulysses, gb, 2026-07-24, 4 stars: "However, I'm not keen on my writing being held hostage in a database should I ever cancel my sub. For that reason, I have actually cancelled my sub and switched to iA Writer, mainly because that app stores everything in easily readable plain text files."
- Need: file-first. Watch-out for Seshat: the managed ~/Seshat/ folder must never feel like a silo; `seshat open any/path.md` and "Open With" matter.
- Tag: READING / WRITING. OBSERVED. Independent reviewers: 4 (the MWeb/Taio/Markdown Editor/One Markdown reviews dated 2025-01-02 read as one person and are counted once).

---

## B. SHARING / PUBLISHING

### B1. Obsidian Publish: "publishing a single file to a hidden, non-indexed URL"
- URL: https://forum.obsidian.md/t/obsidian-publish-single-page-sharing-with-secret-url/23131
- Date: 2021-08-25 (OLDER), 7 posts, 18 likes, 6,275 views
- Quote (maebert): "I'd be more than happy to pay for Obsidian publish, but to my best knowledge it doesn't cover the one use case I care about: publishing a single file (and, recursively, linked files) to a hidden, non-indexed URL."
- Quote (maebert, same post): "Craft does this rather well: you click the „secret url" button, and it will publish your document at a random URL. Changes are automatically update, you just have to share the URL."
- Quote (Scotty, 2021-09-25): "My current workaround is to paste into Craft and then share the URL."
- Need: one-doc, one-link, update-in-place, unlisted. This is Seshat Share's core loop, stated by a user five years ago and still unmet in Obsidian core.
- Tag: SHARING. OBSERVED. Independent voices: 3 in thread.

### B2. Obsidian Publish: per-note password protection (biggest Publish thread found)
- URL: https://forum.obsidian.md/t/obsidian-publish-password-protect-only-parts-of-the-website-individual-notes/13947
- Date: 2021-03-03 (OLDER, thread active to 2024), 70 posts, 152 likes, 6,644 views
- Quote (mtikhonov): "I want to share some of the notes with my students and coworkers Current publish option doesn't suggest to have passwords page-based, you can only password the entire website"
- Quote (camilo, 2021-08-30): "Yeah, how is this not a thing??? It's really holding me up on sharing some content I'd like to be more selective about."
- Related: https://forum.obsidian.md/t/71330 (2023-11-15) "Currently, a password closes the entire Publish website, with no public access to anything at all."
- Need: per-document private/password links, not site-wide. Validates "private/password links" as a paid feature.
- Tag: SHARING. OBSERVED. Independent voices: 4+ quoted, 152 likes.

### B3. Obsidian Publish: storage cap and image handling
- URL: https://forum.obsidian.md/t/support-all-file-types-for-the-publish-service/24908 (post by pbhopeful, 2025-12-31): "The limitations on publish are incredibly frustrating. Why only 50MB?" and "This is going to push me in a self-hosting direction because frankly given the options the convenience of publish simply becoming not worth it for the hassle at the price point."
- URL: https://forum.obsidian.md/t/option-to-pay-for-additional-storage-in-obsidian-publish/49199 (2022-12-09, OLDER, 32 likes): "I would like to be able to use Obsidian to organize and share (using Publish) collections of images and photographs, and these would fairly soon exceed 4gb. I would rather keep everything in Obsidian."
- URL: https://forum.obsidian.md/t/publish-compress-images-on-server/99986 (2025-04-25): "Obsidian Publish storage limits forces us to be mindful of image usage."
- Need: image hosting inside shared docs with a sane quota and server-side compression; willingness to pay for more storage is explicit.
- Tag: SHARING / PRICING. OBSERVED. Independent voices: 3.

### B4. Obsidian Publish: custom domain is painful
- URL: https://forum.obsidian.md/t/alternatives-to-cloudfare-for-custom-domain-publish/11766 (2021-01-21, OLDER): "I'm a student who would like to have a custom domain for his Obsidian Publish. CloudFare is suggested in the help doc, because of the SSL certificate."
- Forum search hits (2023-07-22 developermct, 2025-01-28 JohnnyBallz): "This could be a skill issue, but AFAIK I've been following https://help.obsidian.md/Obsidian+Publish/Custom+domains the docs to an absolute T. The custom domain simply isn't working."
- Need: custom domain that is a CNAME plus automatic TLS, no Cloudflare worker gymnastics.
- Tag: SHARING. OBSERVED. Independent voices: 3.

### B5. Obsidian Publish: no view stats
- URL: https://forum.obsidian.md/t/15595 (2021-03-30, OLDER): "The ability to view basic analytics on site and page access history."
- URL: https://forum.obsidian.md/t/14755 (Joschua, 2021-03-17, OLDER): "Unfortunately Publish doesn't show analytics yet."
- Need: simple per-doc view counts. Low volume; treat as nice-to-have.
- Tag: SHARING. OBSERVED. Independent voices: 2, both old.

### B6. Obsidian Publish alternatives thread: price drives students to self-host
- URL: https://forum.obsidian.md/t/obsidian-publish-alternatives/22886
- Date: 2021-08-20 (OLDER, still updated), 25 posts, 58 likes, 23,465 views
- Quote: "Obsidian Publish is great, but as a student, I can't afford the 8 dollars/mth so I've been trying to find alternatives."
- Need: a cheap hosted link layer. Seshat at 8.99/year is one month of Publish.
- Tag: SHARING / PRICING. OBSERVED.

### B7. Third parties keep building "click publish, get a URL" for Obsidian (demand signal)
- JotBird, https://forum.obsidian.md/t/111466 (2026-02-21, by the author of markdownguide.org): "The idea is simple: click publish and get a URL you can share with anyone. That's it!"
- DocFerry, https://forum.obsidian.md/t/115856 (2026-07-04); Obsidian Friday, https://forum.obsidian.md/t/104086 (2025-08-15): "Turn any note or folder into a themed website"; Share Note (share.note.sx) question 2026-05-24: "are shared notes stored permanently by default, or is there a plan to implement auto-deletion / storage limits in the future?"
- Need: INFERRED. At least four independent plugin authors in 2025-2026 shipped one-click share links; the market is validating the loop, and "publish a folder as a mini site" is explicitly one of them.
- Tag: SHARING. OBSERVED quotes, INFERRED demand.

### B8. Business user lists what Publish lacks
- URL: https://forum.obsidian.md/t/seeking-an-alternative-to-obsidian-publish-for-sharing-vaults/82466
- Date: 2024-05-26
- Quote: "Share specific vaults or folders from a vault to a website Upload and offer linked files (of any extension) for download on the published site Provide comprehensive user management (including full user details, user expiration, and link sharing), unlike the basic password solution offered by Obsidian"
- Need: folder-level publishing, attachments, expiring access. Matches "publish a folder" and "expiring links" candidates.
- Tag: SHARING. OBSERVED.

### B9. Craft users praise exactly the loop Seshat is building (positive validation)
- URL: https://itunes.apple.com/gb/rss/customerreviews/id=1487937127/sortBy=mostRecent/json
- 2024-05-24 (gb), 5 stars, "Removing paper": "The ability to update a single document on craft which is then automatically shared across the web shared link is fantastic."
- 2024-05-22 (gb), 5 stars: "As a teacher, the ability to "publish" and turn any craft document into a mini website, with a customizable URL, is just awesome."
- 2023-08-26 (gb), 5 stars: "It's share page options are great with links, passwords and expiry dates too."
- 2024-05-27 (gb), 5 stars: "I get a lot of positive comments on how the notes look - with a couple of people asking to know the software so that they can use it."
- 2025-10-05 (us), 5 stars: "You can create and share without others needing a Craft account."
- Need: update-in-place links, mini-site from a doc, password and expiry, recipient needs no account, the rendered page itself is the advert. 34 Craft reviews since 2023 mention share/publish/website, overwhelmingly positive.
- Tag: SHARING. OBSERVED. Independent reviewers: 5 quoted, 34 total.

### B10. Craft sharing failures (the flip side)
- 2024-02-06 (de), 3 stars: "Unfortunately, when I share a link that should enable anyone, even those without an account, to edit the given document, this does not work in Safari on iPads."
- 2023-11-04 (de), 2 stars, "Sharing an image to a doc takes minutes..": ".. and often times fails, which means you lose all the notes you wrote down in the share menu."
- 2026-09-03 (us), 1 star: "Does anybody know why, with the latest update, the PDF export option in the iOS version does not do anything after clicking the "Export" button?"
- Need: share links must work in every browser; image upload must be fast and never lose the doc.
- Tag: SHARING. OBSERVED. Independent reviewers: 3.

### B11. "Convert to PDF to share" is the default, and it is a chore
- Ulysses, us, 2025-09-30, 3 stars: "I love this app but the problem is you have to convert it to PDF to share it with anything and it reformats it and makes more work."
- Ulysses, gb, 2025-03-06, 1 star: "I wrote a 20,000 word ebook and when I exported it the text was a mess. I had to reformat everything."
- Ulysses, gb, 2023-06-20 (OLDER), 3 stars: "I often have to export to Word and it loses all formatting, forcing me to spend time tidying up before I can share."
- Obsidian iOS, us, 2026-02-04, 1 star, "Lacks Print and PDF Export on iOS": "You're about to go into an important meeting and need to share a note with a colleague. You can't print out a copy."
- Markdown Editor, au, 2026-01-28, 3 stars: "Seems decent except that it crashes every single time I try to export to PDF or print."
- One Markdown, us, 2025-10-22, 3 stars: "I must often distribute documents as PDF. I use the standard method of commanding "print", then "save as PDF". The output is beautiful, BUT links in the text often do not work."
- iA Writer, us, 2024-06-11, 4 stars: "Additionally, while the PDF export works great and looks good, the exported documents are not accessible to the voice over feature on apple products."
- Need: a link that renders the doc as-is beats a lossy export. 21 low-star reviews since 2024 mention export/PDF problems across the sampled apps.
- Tag: SHARING. OBSERVED. Independent reviewers: 7 quoted, 21 total.

### B12. Bear: no way to share a note with family without leaving the app
- URL: https://itunes.apple.com/us/rss/customerreviews/id=1091189122/sortBy=mostRecent/json
- Date: 2026-05-26, 1 star, "Let Me Collaborate"
- Quote: "To share a grocery list with my wife or a camping list with my kids, I have to switch to Apple Notes, which means keeping information in two separate places. The community has been requesting collaboration for years, and it's disappointing that the feature still isn't on the roadmap."
- Also 2026-08-06, 5 stars: "Bear does everything that Evernote but much better except a few caveats, like live collab note sharing"
- Need: sharing out of a markdown app. Collaboration is out of Seshat scope, but read-only link sharing would cover a slice of this.
- Tag: SHARING. OBSERVED. Independent reviewers: 2.

### B13. Publishing to blogs from markdown apps is fragile
- Byword (id 420212497), us, 2025-04-06, 4 stars: "I really like Byword and have used it for a number of years but not (2025) it doesn't seem to be able to publish to Wordpress sites."
- Typora #438 (2016-11-27, OLDER, +28): "What do you think of an integration to publish directly to Medium.com?"
- Typora #6047 (2024-05-07): "The idea is to create an environment (sort of gist) where one or more users can publish a document and contribute in the browser powered by the Typora engine."
- Need: a first-party hosted target that does not rot when a CMS API changes.
- Tag: SHARING. OBSERVED. Independent voices: 3.

### B14. Image hosting is a long-standing want in markdown editors
- Typora #2476 (2019-05-06, OLDER, +54): "hope support PicGo for image upload"
- Typora #88 (2016, OLDER, +67): "This would prevent the need to maintain external images and the proper paths (which becomes tricky when working on multiple devices)."
- Typora #4767 (2021, OLDER): "It is possible to use a compressed format or to implement a new file format for sharing local images to each other."
- iA Writer, us, 2024-11-15, 3 stars: "Like the app but not supporting native pasting of images is a big downside in today's world where there's more we do with visual content than any other type of content."
- Need: images that travel with the doc. Confirms "image hosting in shared docs" as a paid feature with real pull.
- Tag: SHARING. OBSERVED. Independent voices: 4.

### B15. Notion: paying per seat just to let someone view
- URL: https://itunes.apple.com/gb/rss/customerreviews/id=1232780281/sortBy=mostRecent/json
- Date: 2025-08-28 (gb), 3 stars, "Great except the subscription model"
- Quote: "Paying per member when you might just want to give someone view access."
- Software Advice, Tim K., Aug 2026, 4-5 stars: "The permissions setup gets messy when you're sharing specific pages with clients but not everything" (https://www.softwareadvice.com/project-management/notion-profile/reviews/)
- Software Advice, Doga I., Aug 2026: "Not the best when you need to export your page into a PDF, as it's not aligned or the page doesn't look the same"
- Need: share one page with an outsider, no seat, no workspace exposure.
- Tag: SHARING / PRICING. OBSERVED. Independent reviewers: 3.

### B16. Obsidian: sharing with teammates is clunky
- URL: https://www.softwareadvice.com/knowledge-management/obsidian-profile/reviews/
- James M., May 2026, 5 stars: "Sharing notes with other teammates is not as convenient as it needs to be"
- Forum https://forum.obsidian.md/t/108755 (Kaleo1, 2025-12-06): "Obsidian Sync provides excellent end-to-end encrypted (E2EE) synchronization across devices, but lacks native sharing of individual files or folders with collaborators" (quote trimmed at source blurb)
- Need: share a single file with a non-user.
- Tag: SHARING. OBSERVED. Independent voices: 2.

### B17. HackMD/CodiMD: invite-only links
- URL: https://github.com/hackmdio/codimd/issues/35
- Date: 2015-10-02 (OLDER), +51, top-reacted issue in the org
- Quote: "Should support a permission of invitee only. Only the invitee from email or link can edit the note."
- Need: link-scoped access. Old but the most-upvoted request in HackMD's public tracker.
- Tag: SHARING. OBSERVED.

---

## C. PRICING / SUBSCRIPTION

### C1. Ulysses: "free" listing with a hard paywall is the single largest complaint cluster found
- URL: https://itunes.apple.com/us/rss/customerreviews/id=1225570693/sortBy=mostRecent/json (and gb, de, ca, au)
- 53 of the 1-2 star reviews since 2024-01 mention pay/subscription/free (out of 116 low-star reviews).
- 2026-04-24 (us), 1 star, "A Paid App Disguised as Free": "It is locked in 'read only' mode so you can only view their sales pitches while prompting you to either pick a free trial or pay to edit files. If you want to pay gate content, at least sell the app upfront."
- 2025-12-09 (us), 1 star: "Most apps with the same functions as Ulysses offer a single payment, without a subscri" (truncated at source)
- 2026-03-21 (us), 1 star, "Deceptive Pricing": "Shows in app purchases but that's not the case you can't use the app unless you start a 7 day trial which isn't long enough to evaluate something like this, or pay $39.99 a year."
- 2025-11-13 (us), 2 stars: "If you're not going to email me or send an alert to let me know the trial is ending, don't say you're going to."
- 2026-02-02 (de), 1 star: "7 Tage frei dann 40€ im Jahr ist doch nicht schwer hier in die Beschreibung zu schreiben."
- Need: be upfront about what is free and what costs money; never gate the base activity. Seshat's "reader is free, Share is paid" split is the right shape, but the App Store listing must say so plainly.
- Tag: PRICING. OBSERVED. Independent reviewers: 53.

### C2. Bear: charging a subscription for iCloud sync
- URL: https://itunes.apple.com/us/rss/customerreviews/id=1091189122/sortBy=mostRecent/json
- 2024-04-24 (us), 1 star, "Why $$ to sync to iCloud?": "Why is a sub required to sync my devices using iCloud? This is infrastructure created and maintained by Apple."
- 2025-10-31 (us), 1 star, "Great product, greedy devs": "Charge $30 for a one-time purchase that unlocks themes and iCloud and I'm in. Charge me every month for the privilege to use my own money to pay for my own storage? Nope, hard pass."
- 2025-02-05 (us), 1 star: "I'm not paying for a subscription my entire life for the SIMPLE NEED of seeing my notes on all devices, a feature I get for free on other notes apps."
- 2025-05-23 (gb), 1 star, "Greedy dev": "I don't mind subscriptions but locking away basic features like export settings behind a paywall is dirt behaviour."
- 2024-04-05 (gb), 3 stars, "Price hike": "Love this product be really disappointed in the sudden more than double price increase."
- 15 low-star Bear reviews since 2024 mention subscription/paywall/price.
- Need: do not charge for sync that rides on the user's own iCloud. Warning for the "library sync across Macs" candidate: if it is iCloud-based, charging for it will draw this exact review. If Seshat runs its own sync servers, say so.
- Tag: PRICING. OBSERVED. Independent reviewers: 15.

### C3. Craft: free-tier quota (documents, blocks, storage) triggers 1-star reviews
- URL: https://itunes.apple.com/de/rss/customerreviews/id=1487937127/sortBy=mostRecent/json (and us, gb)
- 2024-09-22 (de), 1 star, "Nur 10 Dokumente": "Danach Abo für 100€ im Jahr benötigt."
- 2025-08-27 (us), 1 star, "Price for Blocks": "To get more than only a few blocks, it costs every cent you have. While for small projects I would still recommend this, large projects are impossible without spending 80+ dollars."
- 2025-07-11 (us), 1 star: "I was using it to organize my summer classes' work and then all of a sudden I'm met with an error that says I ran out of free space or something of the sorts. $9.99 a month to continue using the service."
- 2025-09-23 (us), 3 stars: "I'll stick to Apple Notes for $99 a year."
- 2025-05-10 (us), 1 star, "Low rating reasoning - no trial": "Was told it was a week for trial then payment starts. I just got an alert from my card saying I was charged for $95.99 a year."
- 2024-02-13 (de), 2 stars, "Drastic price increase and no more focus on personal users": "it became increasingly clear that Craft shifted focus away from individual users to business users."
- 2026-08-02 (de), 2 stars: "Als Free User habe ich keine Rechtschreibprüfung. Auch ist von einem Dokument kein Export als Text möglich."
- 26 low-star Craft reviews since 2024 mention price/subscription/limit.
- Need: quotas must be generous and visible before the wall hits mid-task; a quota that blocks in the middle of "my summer classes" earns 1 star. Relevant to "free tier quota vs paid unlimited": cap the number of *shared* docs, never the local library.
- Tag: PRICING. OBSERVED. Independent reviewers: 26.

### C4. Gating cosmetic basics (dark mode, font size) reads as "rentware"
- URL: https://itunes.apple.com/us/rss/customerreviews/id=1507139439/sortBy=mostRecent/json (One Markdown)
- 2025-08-27 (us), 1 star, "Rentware": "Have to pay to use dark mode."
- 2024-11-25 (de), 1 star, "Bezahlen für Darkmode???": "Ich kann es überhaupt nicht verstehen das man für den Darkmode bezahlen muss"
- 2025-10-25 (us), 1 star: "改个字体大小都要付费 不如直接上架买断版" (paying to change the font size; would rather buy outright)
- Need: never paywall reader appearance. Seshat's stance (reader free, not configurable) avoids this.
- Tag: PRICING. OBSERVED. Independent reviewers: 3.

### C5. Lifetime purchase, then abandonment (Taio)
- URL: https://itunes.apple.com/us/rss/customerreviews/id=1527036273/sortBy=mostRecent/json
- 2026-07-12 (us), 1 star, "2-Years & No Updates": "Despite having a roadmap on Trello the fact this app has no Z-E-R-O updates in 2 years means it's likely abandoned - you have been warned."
- 2024-05-28 (us), 1 star: "It seems the developer has lost interest, and there are hardly any updates, with no new features added. The lifetime purchase was a waste of money."
- 2025-12-14 (de), 1 star: "Seite 2 Jahren keine Updates mehr, ich bezahle, also erwarte ich auch Aktualisierungen."
- 2025-11-06 (ca), 1 star: "haven't updated for the bug for 2 years, and no reply for this from the developer, which seems like a fraud since I purchased this app on early bird price for lifetime."
- Need: (INFERRED) users accept a subscription only if updates visibly continue; a lifetime deal creates the opposite resentment when they stop. Supports a cheap yearly plan over lifetime unlocks.
- Tag: PRICING. OBSERVED. Independent reviewers: 4.

### C6. iA Writer: one-time price is loved by some, called overpriced by others
- URL: https://itunes.apple.com/us/rss/customerreviews/id=775737590/sortBy=mostRecent/json
- 2025-11-08 (us), 5 stars: "I also appreciate the payment model. No subscription ( do not ever change this!)."
- 2026-05-12 (ca), 1 star: "This app is really bad for the price. Should be 10$ max. I paid 80$."
- 2023-12-24 (de, OLDER), 2 stars: "Man bezahlt über 50 € für die Mac Version nochmal über 50 € für die IOS Version."
- Need: a 50-80 USD one-time price for a text tool feels steep to a visible minority; 8.99/year is under that pain threshold.
- Tag: PRICING. OBSERVED. Independent reviewers: 3.

### C7. Obsidian Sync/Publish: separate tiers and per-GB cost resented
- Forum https://forum.obsidian.md/t/your-pricing-model-needs-work/96575 (2025-02-12): "I think it's stupid that Sync and Publish are two separate pricing tiers, it's not great that all collaborators on sync'd documents also have to have Sync licenses to view notes" and "People don't like being nickled-and-dimed."
- Forum https://forum.obsidian.md/t/6450 (alvarez.luizfernando, 2024-07-16): "And the price is a real issue now, since the 50 dollars from publish is already very expensive in my country."
- Forum https://forum.obsidian.md/t/26329 (Faterson, 2024-03-12): "I'm very disappointed it's impossible to purchase Obsidian Sync, Obsidian Publish and Dynalist in a single discounted package."
- Obsidian iOS (id 1557175442), gb, 2025-11-17, 2 stars, "Sync is ridiculously bad.": "1gb space for £3.04 a month, and that is the only offer? For that much money it should far, far more."
- Obsidian iOS, gb, 2024-10-02, 1 star: "In 2024, paying to sync is just bad. very bad."
- Obsidian iOS, us, 2026-06-08, 3 stars: "I love this for world building but I don't want to pay 4 dollars a month to sync the vaults once!"
- Obsidian iOS, us, 2026-03-08, 1 star: "Switched phones and after I logged in they tried to charge me 45-over 100$ to import my old notes."
- Need: one cheap plan that covers sharing (and sync if offered), priced for non-US wallets; make the free path obvious.
- Tag: PRICING. OBSERVED. Independent voices: 7.

### C8. "No reason this should be subscription software" (Drafts, Paper)
- Drafts (id 1435957248), gb, 2024-06-07, 1 star, "Subscription": "There is no reason this should be subscription software, go with MWeb instead."
- Paper (id 1143513744), de, 2025-11-24, 2 stars, "Overpriced": "There is no world where 20 Euros a month is justified for an App used to write. I quickly decided to use one of many alternatives that has the same features for free."
- Need: the subscription has to be attached to an ongoing service (hosting), not to the local app. Seshat's split matches.
- Tag: PRICING. OBSERVED. Independent reviewers: 2.

### C9. Notion paid subscriber: app got slower, features hidden behind AI
- URL: https://itunes.apple.com/us/rss/customerreviews/id=1232780281/sortBy=mostRecent/json
- 2026-07-23 (us), 1 star: "I have paid for the Notion Plus subscription for some time. I was worried when they introduced AI features but I stuck with it because I liked the product and they had been good so far."
- 2026-07-15 (us), 1 star: "Each update makes the app slower. Critical features get hidden behind AI features - like search."
- Craft, au, 2024-06-05, 3 stars: "It has followed the trajectory of many other apps/websites in trying to leverage unnecessary AI stuff (I really didn't want to use it), and tripping over itself when it comes to UX."
- iA Writer, us, 2025-11-13, 1 star (the opposite complaint): "the constant and overt and unasked for anti-artificial intelligence messages and FEATURES are truly fascist in nature."
- Need: (INFERRED) do not bolt AI onto the reader; also do not moralise about it. Stay quiet on the topic.
- Tag: PRICING / WRITING. OBSERVED. Independent reviewers: 4.

---

## D. WRITING (secondary, kept short)

### D1. Sync reliability across devices is a top 1-star driver for every app that syncs
- Drafts, gb, 2024-08-28, 1 star: "syncing between them and my Macbook works only in one direction - from the Mac to IOS."
- Taio, ca, 2025-11-06, 1 star: "Auto delete the list and content, haven't updated for the bug for 2 years"
- Ulysses, ca, 2026-04-07, 2 stars: "Add iCloud sync to the list of things in Ulysses that have become unreliable."
- Craft, de, 2025-12-06, 2 stars: "Mit der externen Speicherfunktion hatte ich gehofft über iCloud eine Lösung zu finden. Diese ist aber unzuverlässig"
- Bear, us, 2024-03-14, 1 star: "Bear version 2 data (synced to the cloud) will corrupt data on any device and may crash the device, that is still using Bear version 1."
- Obsidian iOS, us, 2026-05-09, 3 stars: "I delete something via Mac Obsidian and- POOF!- it comes right back!"
- Need: if "library sync across Macs" ships, conflict handling and data safety are the whole feature; a sync bug is the fastest route to 1 star.
- Tag: WRITING. OBSERVED. Independent reviewers: 6.

### D2. Data loss / crash on save
- One Markdown, us, 2025-04-14, 1 star: "DO NOT USE THIS FOR COMPOSITION - it randomly quits and loses are your progress."
- One Markdown, us, 2025-01-02, 2 stars: "But my first attempt to save is stuck on a forever beach ball."
- Ulysses, gb, 2024-06-09, 1 star: "Only been using it for about a week (thank god) and it deleted all of my work."
- Ulysses, ca, 2024-08-25, 1 star: "Ulysses has, on more than one occasion, deleted a file that I am working on with no means of retrieving the file from their end when I'm switching between my external files"
- Drafts, us, 2025-05-15, 2 stars: "On the iPhone is is far too easy to accidentally erase chunks of text with absolutely no way to recover them."
- Need: atomic writes and external-change detection (Seshat's DocumentWriter already does both).
- Tag: WRITING. OBSERVED. Independent reviewers: 5.

### D3. Support silence turns 4-star users into 1-star reviewers
- Craft, gb, 2024-12-09, 1 star: "I contacted support a week ago asking about my academic email address. Haven't heard anything at all despite numerous attempts"
- Craft, us, 2026-01-08, 2 stars: "after the iOS and MacOS 26 updates, the app stopped working on two devices and tech support was basically non-existent."
- Ulysses, us, 2025-11-25, 1 star: "TWICE I have reached out to support, detailing the problem, with crash logs attached. Not even an acknowledgement of the support requests."
- Byword, gb, 2025-12-15, 3 stars: "I have sought info from the program author a few times over the past year or so without getting a reply."
- Craft, de/au 2024-06-04, 2026-08-01, 2026-09-03 (3 reviews, 1 star each): newsletter spam after unsubscribing.
- Need: answer support mail; no marketing email without explicit opt-in.
- Tag: WRITING (ops). OBSERVED. Independent reviewers: 7.

### D4. Markdown syntax visible in the editor is the recurring 2-3 star complaint for Ulysses/iA (context only)
- Ulysses, gb, 2026-07-18, 3 stars: "In Ulysses, every element of formatting requires a tag and tags are always visible."
- Ulysses, us, 2026-02-25, 4 stars: "So far (after a year) my only complaint is that Markdown still feels clunky. Would prefer a more WYSIWYG editor."
- Need: not Seshat's problem (reader first), but confirms why per-block edit that keeps the rest rendered (KER-269) is the right editing model.
- Tag: WRITING. OBSERVED. Independent reviewers: 2.

---

## Summary

### Recurring complaint themes, ranked by independent reviewers (2024-2026 unless noted)

| # | Theme | Independent voices | Tag |
|---|-------|-------------------|-----|
| 1 | "Free" app with a hard paywall / misleading trial (Ulysses) | 53 | PRICING |
| 2 | Free-tier quota or block/document limit hits mid-task (Craft) | 26 | PRICING |
| 3 | Export/PDF as the share path is lossy, broken, or crashes (7 apps) | 21 | SHARING |
| 4 | Subscription for sync that rides on the user's iCloud (Bear) | 15 | PRICING |
| 5 | Sharing/publishing loop praised where it works: update-in-place link, mini-site, password + expiry, no account for the recipient (Craft) | 34 mentions, 5 quoted | SHARING |
| 6 | Sync/Publish priced as separate tiers, per-GB cost, non-US affordability (Obsidian) | 7 | PRICING |
| 7 | Support silence and unsolicited email | 7 | ops |
| 8 | Sync reliability / data loss across devices | 6 (+5 crash-on-save) | WRITING |
| 9 | Performance on long docs and 1,000+ file libraries | 5 | READING |
| 10 | Per-note private/password links for Publish | 4+ quoted, 152 likes (older thread) | SHARING |
| 11 | File-first: reject app-owned libraries and import/export silos | 4 | READING |
| 12 | Image hosting / images that travel with the doc | 4 (+3 Obsidian storage) | SHARING |
| 13 | AI bolted on (or moralised about) | 4 | PRICING/WRITING |
| 14 | Lifetime purchase then abandonment | 4 | PRICING |
| 15 | Mermaid / LaTeX in the reader | 4 | READING |
| 16 | Layout width / margins not adjustable | 3 | READING |
| 17 | Paywalled dark mode / font size | 3 | PRICING |
| 18 | Custom domain setup pain (Obsidian) | 3 | SHARING |
| 19 | Search in rendered view and across files | 2 | READING |
| 20 | Table of contents for long docs | 2 | READING |
| 21 | Read-only reader mode (Typora, old but +62) | 4 in thread | READING |
| 22 | Live reload / offline rendering (Read.md) | 2 | READING |
| 23 | View stats for published pages | 2 (old) | SHARING |

### Subset about sharing / publishing (what it says for Seshat Share)
- The core loop is validated twice: by Craft's 5-star reviews ("update a single document on craft which is then automatically shared across the web shared link is fantastic") and by Obsidian users who describe the exact feature they cannot get ("publishing a single file ... to a hidden, non-indexed URL", "Craft does this rather well").
- Candidate feature evidence, strongest to weakest:
  1. Private/password/expiring links: strongest. 152-like Obsidian thread, Craft praise for "links, passwords and expiry dates", business user asking for "user expiration, and link sharing".
  2. Image hosting in shared docs: strong. Explicit willingness to pay for storage (32 likes), 50MB cap called "incredibly frustrating", Typora +54/+67 image-hosting requests, Craft 2-star for image upload failing.
  3. Publish a folder as a mini site: moderate. Craft "mini website, with a customizable URL", joeweb "share specific vaults or folders", four 2025-2026 Obsidian plugins doing exactly this.
  4. Custom domain: moderate. Real pain in Obsidian (Cloudflare, "simply isn't working") but low volume; make it a CNAME + auto TLS or skip.
  5. View stats: weak. Two old requests. Nice-to-have.
  6. Library sync across Macs: demand exists but it is the riskiest feature in the corpus (6 sync-reliability 1-stars, 15 Bear "why pay for iCloud sync" reviews). If shipped, do not charge for an iCloud-backed sync; if it is server-side, say so.
- PDF export as the de-facto share path is broken or lossy in 7 different apps (21 low-star reviews). "A link that looks like the reader" is a clean answer to that.
- The recipient must need no account (Craft praise, Notion "paying per member when you might just want to give someone view access").

### Subset about pricing (what it says for 8.99 USD/year and the free tier)
- The single largest cluster of 1-star reviews in the sample is Ulysses' "free with paywall" listing (53 reviewers). Keep the App Store description explicit: reader is free, Share is 8.99/year, nothing local is gated.
- Quota walls that block mid-task (Craft: 10 documents, blocks, storage) produce 1-star reviews. If the free tier caps shared docs, show the count up front and never block reading or local editing.
- Do not charge for anything cosmetic (dark mode, font size) or for iCloud-backed sync.
- 8.99/year sits well under every stated pain point (Ulysses 40/yr, Craft 96-100/yr, Obsidian Publish 96/yr, iA Writer 50-80 one-time). Students and non-US users repeatedly say 8 USD/month is too much; 8.99/year is below the threshold they name.
- Subscription resentment is aimed at subscriptions for local software. A subscription for a hosted service draws far less fire in this sample (Obsidian Sync reviewers who pay say "Happy to pay for this feature"); the resentment there is about tier splitting and per-GB price, not the existence of the fee.
- Lifetime deals age badly (Taio: 4 reviewers calling it abandoned/fraud). Prefer cheap yearly.

### Sources that were empty or unreachable
- G2 (Obsidian Publish, HackMD, GitBook, Notion): CAPTCHA wall via r.jina.ai. URLs tried: https://www.g2.com/products/obsidian-publish/reviews, https://www.g2.com/products/hackmd/reviews, https://www.g2.com/products/gitbook/reviews?qs=cons, https://www.g2.com/products/notion/reviews (low-score filter).
- Capterra (Notion low-star, Obsidian): CAPTCHA wall. https://www.capterra.com/p/186596/Notion/reviews/?rating=1,2,3 and https://www.capterra.com/p/10004063/Obsidian/reviews/ (timeout).
- Product Hunt (Obsidian, HackMD): 403 / CAPTCHA. https://www.producthunt.com/products/obsidian/reviews, https://www.producthunt.com/products/hackmd/reviews.
- Slashdot software reviews: GitBook and Notion pages loaded but reviews were generic and pre-2024; Obsidian Publish, Craft Docs, HackMD, Mintlify pages returned CAPTCHA or had no reviews.
- Software Advice: Obsidian and Notion pages worked (quoted above); Bear, Craft, GitBook, HackMD profile URLs 404.
- TrustRadius Notion cons page: loaded, but no reviewer metadata and nothing on sharing/publishing beyond speed complaints ("With many blocks, pages, images or large databases, Notion can become slow").
- AlternativeTo: /software/obsidian-publish/about/ is 404; /software/obsidian/about/ had only 5-star praise, nothing on Publish pricing.
- Setapp app pages (Marked, Ulysses, Craft): only developer responses render; user review text is not in the HTML. /reviews sub-path is 404.
- HackMD: hackmdio/hackmd-io is not searchable via the GitHub API; org-wide search returned only old CodiMD issues (2015-2019). No HackMD community forum found with fetchable reviews.
- Marked 2 / Marked 3 GitHub: ttscoff/Marked2 not a searchable repo. MAS feed had 3 low-star reviews since 2024 (one quoted, A10).
- Typora is not on the Mac App Store; used its issue tracker. Publish/share issues are old (2016-2019) except #6047 (2024) and #6334 (2025), each with zero reactions.
- MarkEdit issues: fetched via gh; top requests are preview mode (#41, #179, #902), plugin install, Vim bindings, a folder sidebar (#1389, 2026-04-21). Nothing on sharing or pricing (it is free); low reaction counts (max +8) so not listed as findings.
- Panda (Bear's editor) and MacDown: not on the Mac App Store; no review source found.
- Pine, "Markdown Panda", Marklens, MarkDown Reader (MAS): feeds returned 0-2 reviews each.
- Obsidian forum search for "publish noindex unlisted" returned nothing.
