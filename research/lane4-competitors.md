# Lane 4: Competitor feature and pricing matrix for Seshat Share

Date checked for all pricing: 2026-09-06. Prices in USD unless stated. "UNVERIFIED" means I could not load an official page that states the fact; "reported" means a secondary source (review site, blog) stated it. Quotes are verbatim from the cited URL and were extracted by fetch; anything older than Sept 2024 is flagged "(older)".

Seshat Share benchmark band: 8.99 USD per year, yearly only, roughly 0.75 USD per month.

---

## 1. Feature matrix (features x tools)

Legend: Y = yes, N = no, P = paid tier only, ? = UNVERIFIED, n/a = not applicable (not a hosted service).

| Tool | Free tier publishes a link | Image hosting | Private / password | Expiring links | Custom domain | View stats | Comments / co-edit | Export | Update in place / versions |
|---|---|---|---|---|---|---|---|---|---|
| Obsidian Publish | N (paid only) | Y, 50 MB per file | Y, site-wide passwords (all-or-nothing) | N | Y (Cloudflare only officially) | Via GA/Plausible/Fathom embed | N native comments; "collaborative editing" listed | Source is your vault | Y update; no version history listed |
| Notion (public pages / Sites) | Y, unlimited sites, 1 notion.site domain | Y, 5 MB per file free, unlimited paid | N (no native password; most-requested) | N | P, +8/mo/domain annual, +10 monthly | P, Google Analytics on paid | Y comments (in workspace), multi-editor | MD, HTML, PDF | Y; history 7d free / 30d Plus / 90d Business |
| HackMD | Y | Y, 1 MB/img free, 20 MB Prime | Y note permissions (private/limited/public) | N | Enterprise only (Team+ reported) | "Note insights" on Prime | Y real-time co-edit and comments | MD, HTML, PDF (Prime) | Y; 10 versions free, unlimited Prime |
| Bear | N (no public link; Bear Web beta is private access) | n/a | n/a | n/a | n/a | n/a | N | PDF, HTML, DOCX, JPG (Pro) | n/a |
| iA Writer | N (publishes to WordPress/Medium/Ghost/Micro.blog/Micropub) | Via target platform | Via target | N | Via target | Via target | N | MD, HTML, PDF, DOCX | Via target |
| Typora | N (local editor; uploads images via iPic/PicGo) | Via image host | n/a | n/a | n/a | n/a | N | PDF, DOCX, ODT, LaTeX, MediaWiki, EPUB | n/a |
| Marked 2/3 + Marked Share | Y (Marked Share free, account needed) | Y (zip with images, TextBundle) | Y Private/Unlisted/Public | ? | ? (wildcard *.markedb.in mentioned) | ? | Y reader highlights and feedback | HTML, PDF, DOCX from app | Y update via API, live updates to viewers |
| Craft | Y (Starter can share links) | Y, 25 MB media, 1 GB free | Y password, email-domain restriction (paid) | Y expiration date (paid) | P (Plus and up) | Y on paid plans | Y comments on shared pages | MD, PDF, DOCX | Y; history 7d free / 30d Plus |
| Ulysses | N (publishes to WordPress/Ghost/Medium/Micro.blog/Substack/Basecamp) | Via target | Via target | N | Via target | Via target | N | MD, HTML, PDF, DOCX, EPUB | Update only for WordPress, Ghost, Micro.blog; not Medium |
| Quarto Pub | Y (being replaced by Posit Connect Cloud) | Y, 100 MB site cap | N, all public | N | N | N | N | Static site | Y republish |
| GitHub Gist | Y | N (no upload; must link) | "Secret" gists are unlisted, not private | N | N | N | Y comments, revisions | Raw, git clone | Y, full revision history |
| GitHub Pages | Y (public repo on Free; private repo needs Pro/Team) | Y in repo, 1 GB site | N | N | Y free | N (add your own) | Via git | Static | Y via git |
| Hashnode | Y | Y | N | N | Y free (reported); Pro adds features | Y | Y comments | MD backup to GitHub (reportedly removed from UI) | Y |
| Mintlify | Y Starter | Y | Authentication on Starter | N | Y Starter | Pro | Editors 5 on Starter | MD source | Y via git |
| GitBook | Y (1 user) | Y | P Ultimate (authenticated access) | N | P Premium 65/site/mo | P Premium | Y comments, git sync | PDF export Premium+ | Y version history all tiers |
| Docusaurus (self-host on Vercel/Netlify/GH Pages) | Y (free host tiers) | Y in repo | P (Vercel Advanced Protection 150/mo; Netlify password on Pro 20/mo) | N | Y free on Vercel/Netlify/GH Pages | Netlify 30-day analytics on Pro; Vercel 50K events free | Via git | Static | Y via git |
| Dropbox Paper (web only after Oct 9 2025) | Y (Basic) | Y | Password links and expiry on Standard/Advanced | Y (paid) | N | N | Y comments, co-edit | PDF, DOCX, MD | Y |
| Google Docs "Publish to web" | Y | Y | N (published page is public or org-only) | N | N | N | Y in doc, not in published view | DOCX, PDF, MD | Y auto-republish toggle |
| ReadMe | Y Starter | Y | P Pro (site password, private docs) | N | Y free | Basic metrics free | Y team collab | ? | 1 version free, unlimited Pro |
| rentry.co | Y, no account | Y (image links; uploads reported flaky) | Edit code; no password viewing | N (permanent) | N | Y (view counter every 10 min) | Shared edit code | Raw MD | Y edit in place, 200K chars max |
| telegra.ph | Y, no account | Y | N | N | N | Y via @telegraph bot | N | N | Y edit (cookie-bound), cannot delete |
| write.as | Y (1 blog) | P (Snap.as on Pro) | P (password/private blogs on Pro) | N | P Pro | P Pro | N | Export, ePub add-on | Y |
| Bear Blog | Y | N (no image hosting even on paid, reported) | N | N | P (5/mo or 50/yr) | P | N | Y | Y |
| Mataroa | Y | Y, 1 MB/img, 100 MB total | N | N | P, 9/yr | Y free | N | Y auto-export by email, epub | Y |
| Montaigne (Apple Notes) | Y | Y (from Notes) | ? | N | P Start 5/mo | P Pro | N | Notes | Y auto-publish |
| Quartz | n/a (SSG, free) | In repo | N | N | Via host | Via plugin | Via git | Static | Via git |
| SilverBullet | n/a (self-hosted PKM) | Self | Self | N | Self | N | N | MD | Self |
| Publii | n/a (desktop SSG, GPL-3) | In site | N | N | Via host | Via plugin | N | Static | Y |
| Obsius (Obsidian plugin, obsius.site) | Y free | "Only plain text and simple styling" | N | N | N | N | N | N | Y update and delete |
| Share Note (Obsidian plugin, note.sx) | Y free, MIT, self-hostable | Y (attachments stored unencrypted) | Y encrypted by default | ? | N (self-host instead) | N | N | N | Y re-share |
| Dillinger | N (editor; export only) | N | n/a | n/a | n/a | n/a | N | MD, HTML, PDF | n/a |
| StackEdit | N (editor; publishes to Blogger/WordPress/Zendesk/GitHub) | N | n/a | n/a | n/a | n/a | Y workspace comments | MD, HTML | Via target |
| markdownlivepreview.com | N (preview only) | N | n/a | n/a | n/a | n/a | N | N | n/a |
| readme.so | N (README editor) | N | n/a | n/a | n/a | n/a | N | MD | n/a |
| markdown.new | N (URL to MD converter, 500 req/day) | n/a | n/a | n/a | n/a | n/a | N | MD | n/a |
| HedgeDoc | n/a (self-hosted, AGPL-3; demo server) | Y (S3/MinIO backends) | Y permission dropdown | N | Self | N | Y real-time | MD, HTML (PDF removed) | Y revisions |
| Glasp | N (highlighter; export MD free) | n/a | P | n/a | n/a | n/a | N | MD, HTML, CSV, JSON | n/a |
| MDtoLink | Y, 5 docs, 7-day expiry | ? | P Pro (private docs) | Y (free links expire) | P Publisher 108/yr | ? | Team 5 on Publisher | MD | Y republish same filename |
| JotBird | Y, 30-day expiry (90 with account) | Y hosted, expire with page | P Pro password | Y | ? (Pro "custom URLs") | ? | N | ? | Y update or delete |
| LFMarkdown | Y, permanent, no account | ? | N (random URL + delete link) | Optional 1h to 30d | N | Y cookieless Matomo count | N | Raw | N, immutable |
| mdshare.live | Y, 10 MB, no login | ? | N | ? | N | N | Real-time via MCP | MD | ? |
| mdshare.online | Y, 30-day auto-delete | ? | Client-side encryption, burn after reading | Y | N | N | N | MD | N |
| PasteMD | Y | ? | Password (reported) | Y incl never | N | N | N | Raw | ? |
| boomurl | Y, 50 MB / 500 files per site | Y alongside MD | N | N | N (your-name.boomurl.me); banner removal 2/mo | N | N | Static | Y |
| mdto.page | Y, no login | N (no image upload per HN) | N | Y 1/7/14/30 days | N | N | N | N | N |
| Docsify-This | Y (renders a public raw .md URL) | Y from repo | Via private repo + Pages | N | Alias domains only | N | N | Source stays on GitHub | Y edit source |
| hosted.md | Y subdomain with branding | Y | ? | N | P 10/mo | ? | Git or editor | Static | Y on push |
| Marked Share (markedb.in) | Y free, no paid tier | Y | Y Private/Unlisted/Public | ? | ? | ? | Y highlights and review notes | ? | Y live updates |

---

## 2. Pricing table

| Tool | Free tier | Paid price | Period | Custom domain tier | Source URL | Checked |
|---|---|---|---|---|---|---|
| Obsidian Publish | None (Obsidian app free) | 8/site/mo annual (96/yr); 10/site/mo monthly. Sync 4/mo annual, 5 monthly | Monthly or yearly | Included; Cloudflare only officially supported | https://obsidian.md/pricing ; https://obsidian.md/help/publish/domains | 2026-09-06 |
| Notion | Free: unlimited Sites, 1 notion.site domain, 5 MB uploads, 7-day history | Plus 10/user/mo annual (12 monthly); Business 20 annual (24 monthly). Custom domain add-on 8/mo/domain annual, 10 monthly, max 25 | Monthly or yearly | Plus and up, plus add-on fee | https://www.notion.com/pricing ; https://www.notion.com/help/notion-sites-availability-and-pricing | 2026-09-06 |
| HackMD | Free: 3 teammates, 1 MB images, 10 versions, 20 GitHub pushes/mo | Prime 5/seat/mo (page shows both monthly and annual as 5; "$15/month billed annually" as a 3-seat bundle). Prime Personal reported 6/mo monthly or 48/yr (UNVERIFIED which is current). Enterprise custom | Monthly or yearly | Enterprise (Team+ reported at 16.67/seat) | https://hackmd.io/pricing ; https://homepage.hackmd.io/pricing ; https://hackmd.io/@docs/Personal-Prime-subscription-management-en | 2026-09-06 |
| Bear | Free app, no sync | Pro 2.99/mo or 29.99/yr, 7-day trial | Monthly or yearly | n/a (no publishing) | https://bear.app/faq/features-and-price-of-bear-pro/ | 2026-09-06 |
| iA Writer | 7-day trial | Mac 49.99, iOS 49.99, Windows 29.99, one-time ("One Time is not Lifetime"); Android subscription | One-time per platform | n/a (publishes to third parties) | https://ia.net/writer/pricing | 2026-09-06 |
| Typora | 15-day trial | 14.99 one-time, 3 devices | Lifetime | n/a | https://typora.io/ | 2026-09-06 |
| Marked 2 / Marked 3 | Marked Share free, no paid tier | Marked 2: 14.99 one-time (App Store shows 13.99). Marked 3: 2.99/mo intro then 4.99; 29.99/yr intro then 49.99; permanent unlock 69.99 intro then 89.99; Marked 3 Pro 69.99 one-time | Monthly, yearly, or lifetime | Marked Share: UNVERIFIED (wildcard *.markedb.in mentioned) | https://markedapp.com/pricing/ ; https://share.markedapp.com/about ; https://brettterpstra.com/2026/08/29/marked-share-markdown-publishing/ | 2026-09-06 |
| Craft | Starter: 1500 blocks, 1 GB, 25 MB media, 7-day history, link sharing | Plus 8/mo monthly, page currently shows 6.40 (annual promo; other sources 4.80 to 8); Family 15/mo (2 to 6 accounts); Team 50/mo (10 accounts) | Monthly or yearly | Plus and up; password/expiry links on paid | https://www.craft.do/pricing ; https://support.craft.do/hc/en-us/articles/360019332337-Publishing-With-Craft-Web-Links | 2026-09-06 |
| Ulysses | 14-day trial | 5.99/mo or 39.99/yr; student 10.99 (period UNVERIFIED) | Monthly or yearly | n/a (publishes to third parties) | http://ulysses.app/pricing/ ; https://help.ulysses.app/publishing | 2026-09-06 |
| Quarto Pub | Free only, 100 MB per site, 10 GB/mo bandwidth, all public | None; being replaced by Posit Connect Cloud, site says closed to new sign-ups | n/a | Not supported | https://quarto.org/docs/publishing/quarto-pub.html ; https://quartopub.com/ | 2026-09-06 |
| GitHub Gist | Free, public or "secret" (unlisted, not private) | n/a | n/a | No | https://docs.github.com/en/get-started/writing-on-github/editing-and-sharing-content-with-gists/creating-gists | 2026-09-06 |
| GitHub Pages | Free for public repos; 1 GB site, 100 GB/mo soft bandwidth, 10 builds/hr | Pro/Team needed for Pages from private repos; Team 4/user/mo | Monthly | Free | https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits ; https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages ; https://github.com/pricing | 2026-09-06 |
| Hashnode | Free blog | Pro 5/mo or 50/yr | Monthly or yearly | Free (reported); UNVERIFIED on official page | https://hashnode.com/pro | 2026-09-06 |
| Mintlify | Starter free: custom domain, 5 editors, auth, web editor | Pro 450/mo annual (540 monthly, reported), 10K AI credits then 0.01/credit; Enterprise custom | Monthly or yearly | Starter (free) | https://mintlify.com/pricing | 2026-09-06 |
| GitBook | Free: 1 user, git sync, unlimited page views | Premium 65/site/mo annual (79 monthly, reported); Ultimate 249/site/mo (299 monthly); plus 12/user/mo annual (15 monthly) | Monthly or yearly | Premium | https://www.gitbook.com/pricing | 2026-09-06 |
| Docusaurus + host | Docusaurus MIT free. Vercel Hobby free (non-commercial, 100 GB). Netlify Free (300 credits). GH Pages free | Vercel Pro 20/mo (+150/mo Advanced Deployment Protection for password); Netlify Pro 20/mo flat (password protection on Pro, 30-day analytics) | Monthly | Free on all three | https://docusaurus.io/docs/deployment ; https://vercel.com/pricing ; https://www.netlify.com/pricing/ | 2026-09-06 |
| Dropbox Paper | Basic free, 2 GB, web only (apps retired Oct 9 2025) | Plus 9.99/mo; Standard 15/user/mo; Advanced 24/user/mo (password links and expiry on Standard/Advanced) | Monthly (annual discounts exist, UNVERIFIED) | No | https://www.dropbox.com/plans ; https://help.dropbox.com/view-edit/paper-faqs ; https://directionforward.com/news/2025/end-of-life-for-dropbox-paper-apps | 2026-09-06 |
| Google Docs | Free personal account; "Publish to the web" free | Workspace Business Starter 7/user/mo annual, 8.40 flexible (page served TRY locally; USD via name.com) | Monthly or annual commit | No | https://support.google.com/docs/answer/183965 ; https://workspace.google.com/pricing ; https://www.name.com/blog/google-workspace-pricing | 2026-09-06 |
| ReadMe | Starter free: custom domain, 1 version, metrics | Pro 250/mo annual (300 monthly, reported); Enterprise custom, annual only; add-ons Ask AI 150/mo, Dev Dashboard 100/mo | Monthly or yearly | Free | https://readme.com/pricing ; https://www.jamdesk.com/blog/the-definitive-api-documentation-pricing-comparison-2026-2 | 2026-09-06 |
| rentry.co | Free forever, no account, 200K chars | Donations only | n/a | No | https://rentry.co/what | 2026-09-06 |
| telegra.ph | Free, no account | None | n/a | No | https://telegra.ph/ ; https://blog.sakuragawa.moe/some-hints-on-telegra-ph-2020/ | 2026-09-06 |
| write.as | Free: 1 blog, no images, no domain | Pro 6/mo annual (72/yr) or 9 monthly; Team 25/mo annual or 30 monthly | Monthly or yearly | Pro | https://write.as/pricing | 2026-09-06 |
| Bear Blog | Free: unlimited posts, subdomain, RSS | 5/mo or 50/yr (reported; official upgrade page bot-blocked). Older sources: 49/yr, 59/yr, lifetime 189 | Monthly or yearly | Paid | https://bearblog.dev/ ; https://makerstack.co/reviews/bear-blog-review/ ; https://docs.bearblog.dev/custom-domains/ | 2026-09-06 |
| Mataroa | Free: nearly everything, images 1 MB / 100 MB total, analytics, export | Premium 9/yr | Yearly only | Premium | https://mataroa.blog/ | 2026-09-06 |
| Montaigne | Free: unlimited sites and notes, no domain | Start 5/mo or 50/yr; Pro 12/mo or 120/yr; domain-only add-on 2/mo | Monthly or yearly | Start | https://montaigne.io/pricing | 2026-09-06 |
| Quartz | Free, open source | n/a | n/a | Via host | https://quartz.jzhao.xyz/ | 2026-09-06 |
| SilverBullet | Free, open source, self-hosted | n/a | n/a | Self | https://silverbullet.md/ | 2026-09-06 |
| Publii | Free, GPL-3; paid themes optional | n/a | n/a | Via host | https://getpublii.com/ | 2026-09-06 |
| Obsius | Free | UNVERIFIED (no pricing page found) | n/a | No | https://github.com/jonstodle/obsius-obsidian-plugin ; https://obsius.site/ | 2026-09-06 |
| Share Note | Free, MIT, self-host via docker | None | n/a | Self-host | https://github.com/alangrainger/share-note | 2026-09-06 |
| Dillinger | Free, open source | None | n/a | n/a | https://dillinger.io/ | 2026-09-06 |
| StackEdit | Free, Apache-2 | Sponsorship UNVERIFIED | n/a | n/a | https://stackedit.io/ | 2026-09-06 |
| HedgeDoc | Free, AGPL-3, self-host; demo.hedgedoc.org | None | n/a | Self | https://hedgedoc.org/ ; https://docs.hedgedoc.org/ | 2026-09-06 |
| Glasp | Free highlights, export free | Pro 12.50/mo or 150/yr; Unlimited 30/mo or 360/yr | Monthly or yearly | n/a | https://glasp.co/pricing | 2026-09-06 |
| MDtoLink | Free: 5 docs, 7-day expiry, branding | Pro 6/mo or 36/yr (3/mo annual); Publisher 18/mo or 108/yr | Monthly or yearly | Publisher | https://mdtolink.com/ | 2026-09-06 |
| JotBird | Free: unlisted pages, 30-day expiry (90 with account), hosted images | Pro 29/yr: never expire, password, custom URLs | Yearly only | UNVERIFIED (Pro "custom URLs") | https://www.jotbird.com/ | 2026-09-06 |
| LFMarkdown | Free, no account, no ads, permanent, immutable | None | n/a | No | https://lfmarkdown.com/en | 2026-09-06 |
| mdshares.com | Free, no sign-up (limits UNVERIFIED) | UNVERIFIED | n/a | UNVERIFIED | https://mdshares.com/ | 2026-09-06 |
| mdshare.live | Free, 10 MB, MCP sharing | None found | n/a | No | https://mdshare.live/ | 2026-09-06 |
| mdshare.online | Free, 30-day auto-delete, burn after reading | None found | n/a | No | https://www.mdshare.online/ | 2026-09-06 |
| PasteMD | Free (paid UNVERIFIED) | UNVERIFIED | n/a | No | https://www.pastemd.com/ | 2026-09-06 |
| boomurl | Free, 50 MB / 500 files per site | Banner removal 2/mo per site | Monthly | No | https://boomurl.com/guides/markdown-publishing | 2026-09-06 |
| mdto.page | Free, no login, expiry 1 to 30 days | None | n/a | No | https://news.ycombinator.com/item?id=46645942 | 2026-09-06 |
| PublishMarkdown.com | Show HN Oct 2025, custom link + password; pricing UNVERIFIED | UNVERIFIED | n/a | UNVERIFIED | https://news.ycombinator.com/item?id=45564630 | 2026-09-06 |
| Docsify-This | Free, open source (needs public raw .md URL) | None | n/a | Alias domains only | https://docsify-this.net/ | 2026-09-06 |
| hosted.md | Free subdomain with branding, small storage | 10/mo flat per site (reported) | Monthly | Paid | https://hosted.md/ ; https://unmarkdown.com/blog/best-markdown-publishing-tools-2026 | 2026-09-06 |
| Unmarkdown | Free | 8 to 10/mo Pro (reported) | Monthly | ? | https://unmarkdown.com/blog/best-markdown-publishing-tools-2026 | 2026-09-06 |

### Tools in or near Seshat's benchmark band (yearly-only or under 30 USD/yr)

- Mataroa: 9/yr, yearly only. Closest analogue in price and philosophy (minimal, paid feature is custom domain).
- JotBird Pro: 29/yr, yearly only. Closest analogue in product shape (paste MD, get link, password, hosted images, no expiry on paid).
- Bear Pro: 29.99/yr (but no publishing).
- MDtoLink Pro: 36/yr (3/mo annual) or 6 monthly. Nearest CLI-first competitor; custom domain pushed to 108/yr tier.
- boomurl: 24/yr equivalent (2/mo per site) just for banner removal.
- Montaigne domain-only add-on: 24/yr equivalent.
- Bear Blog: 50/yr. Hashnode Pro: 50/yr. Write.as Pro: 72/yr. Obsidian Publish: 96/yr per site. Notion custom domain alone: 96/yr on top of Plus (120/yr).
- Fully free and permanent with no paid tier: rentry.co, telegra.ph, LFMarkdown, Marked Share, GitHub Gist, mdshare.live, Docsify-This.

---

## 3. Per-tool complaints (verbatim, with URL)

### Obsidian Publish
1. "For once, Obsidian publish is quite expensive." balder1991, HN, May 3 2024. https://news.ycombinator.com/item?id=40249020
2. "Still wondering about this feature...I would much rather have everything be in one publish site, but I stopped working on it ages ago because of this missing but obviously necessary feature." TheMathGuyd, Obsidian forum, May 16 2024 (per-note password protection). https://forum.obsidian.md/t/obsidian-publish-password-protect-only-parts-of-the-website-individual-notes/13947?page=3
3. "users are paying almost $200 a year, a premium not associated with any other platform, to help develop Publish into a publishing platform with basic functionality." Bob Doto, Feb 16 2022 (older). https://writing.bobdoto.computer/obsidian-publish-should-not-cost-198-a-year-to-use/

### Notion public pages / Notion Sites
1. "The URLs are even messier than those on Medium. Yikes!" tuttyboy, HN, Jun 25 2024. https://news.ycombinator.com/item?id=40792970
2. No native password protection: "Notion does not offer native per-page password protection—not on Free, not on Enterprise—and this hasn't changed as of March 2026" (third-party blog, not a user quote). https://pagelive.io/blog/notion-password-protected-page
3. Custom domain cost stacking: "Plus plan costs $10-12 per month, plus an additional $8-10 per month for custom domain access, totaling $18-22/month just to use your own domain" (Gridfiti guide). https://gridfiti.com/notion-custom-domain/

### HackMD
1. "The platform is not friendly on mobile phones with some minor issues popping out the keyboard on Android" (review aggregator summary; direct reviewer quotes on G2/SourceForge were bot-blocked). https://www.softwareworld.co/software/hackmd-reviews/
2. Free plan gates: "Up to 1MB per image", "Recent 10 versions", "Up to 3 teammate" (official page, limits users hit). https://hackmd.io/pricing
3. Custom domain is Enterprise-only: "Custom domain" listed under Enterprise. https://homepage.hackmd.io/pricing
(No verbatim user complaints found on open forums in the last 24 months. UNVERIFIED for Reddit; Reddit blocked fetching.)

### Bear
1. "It would be great if bear could generate a link so that I can share my note to the world." santhip, Bear Community, Jul 9 2025. https://community.bear.app/t/sharing-a-note-as-a-public-post-online/17588
2. "One thing I think is missing most is a collaboration or shared feature to work together on one note with other people." sebaswoz, Bear Community, Dec 22 2025. https://community.bear.app/t/collaborate-and-share-notes/18585
3. "Some sort of notes sharing via web would be amazing!" TarFabius, Bear Community, Jan 15 2026. https://community.bear.app/t/collaborate-and-share-notes/18585

### iA Writer
1. "lately it's become frustratingly slow on the Mac" with "the dreaded spinning beachball". LL-NYC, Mac App Store, Nov 10 2025. https://apps.apple.com/us/app/ia-writer/id775737590
2. "No real-time collaboration features for working with editors or multiple authors" (review listing, Dec 29 2025). https://elephas.app/blog/iawriter-review
3. "Separate purchase required for each platform instead of a universal license" (same review). https://elephas.app/blog/iawriter-review
Also: Medium "will not issue any new API integration tokens" affects iA and Ulysses publishing. https://help.ulysses.app/publishing

### Typora
1. "The price of $15, the limitation of only 3 activations and the requirement to be connected to the internet to check the activation status is the deal breaker for me." HN, Nov 2021 (older). https://news.ycombinator.com/item?id=29360720
2. "The DRM is the problem, and paid software is perfectly capable of existing without DRM." HN, Nov 2021 (older). https://news.ycombinator.com/item?id=29360720
3. "I would really like to know Typora's plan for future updates. It is just unpromising without a Roadmap." Undomeno, GitHub, Dec 30 2021 (older). https://github.com/typora/typora-issues/issues/4963
(Typora shipped 1.11 in Jul 2025 and 1.13 in Mar 2026, so "abandoned" complaints are stale.)

### Marked 2 / Marked 3
1. "Consistently mis-renders Markdown, and the print versions it produces are wonky". Sean Gilbertson, Setapp, Jul 24 2026. https://setapp.com/apps/marked/customer-reviews
2. "The latest version has made the app pretty much unusable. It will either hang or take 10's of seconds to open." Patrick Coleman, Setapp, Jun 26 2026. https://setapp.com/apps/marked/customer-reviews
3. "Version 3 really messed things up for me…opened various requests to address annoying bugs and did not see any progress." Christian Saborio, Setapp, Aug 15 2026. https://setapp.com/apps/marked/customer-reviews
Note: Marked Share (markedb.in) launched Aug 29 2026, free, no paid tier. Too new for complaints. https://brettterpstra.com/2026/08/29/marked-share-markdown-publishing/

### Craft
1. "the block counter doesn't warn you before you hit the 1,500-block ceiling — you just get a blocked 'upgrade to continue editing' modal mid-sentence" (reviewer, 2026). https://websites2know.com/craft-do-review/
2. "Higher-tier plans can get quite expensive." TechRepublic, Jun 7 2024. https://www.techrepublic.com/article/craft-review/
3. "No priority support for any plan under the Team plan." TechRepublic, Jun 7 2024. https://www.techrepublic.com/article/craft-review/
(G2 and Capterra user reviews were bot-blocked; user-level quotes UNVERIFIED.)

### Ulysses
1. "they burned me by billing my Apple account for a full year without my knowledge or approval". toddhunt, App Store, Jun 22 2020 (older). https://apps.apple.com/us/app/ulysses/id1225571038
2. "if you're a casual writer who's only needs are 'something to type on with an auto-save feature', there are free options". penny-per-thought, App Store, Nov 1 2022 (older). https://apps.apple.com/us/app/ulysses/id1225571038
3. Official limitation: updating published posts "is only available for WordPress, Ghost and Micro.blog. You cannot update Medium posts." https://help.ulysses.app/publishing

### Quarto Pub
1. "Are resource/bandwidth limits specified for serving assets (web pages, etc.) through Quarto.pub?" davidpassmore, Oct 3 2024; answer: "Quarto Pub sites are publicly visible, can be no larger than 100 MB and have a soft limit of 10 GB of bandwidth per month." cderv. https://github.com/quarto-dev/quarto-cli/discussions/10965
2. "Is there a way to publish my website privately which can not be seen by anyone or comes up in Google searches?" samarzayan, Nov 5 2022 (older). https://github.com/quarto-dev/quarto-cli/discussions/3182
3. Service is winding down: "Quarto Pub is being replaced by Posit Connect Cloud." https://quarto.org/docs/publishing/quarto-pub.html

### GitHub Gist and GitHub Pages
1. "Secret gists aren't private. If you send the URL of a secret gist to a friend, they'll be able to see it." (official docs). https://docs.github.com/en/get-started/writing-on-github/editing-and-sharing-content-with-gists/creating-gists
2. "Been using gists for a while now and been concerned about privacy but been too lazy to implement myself." HaejuJ, HN, Mar 9 2022 (older). https://news.ycombinator.com/item?id=30607367
3. Pages from private repos requires paid plan: "in public and private repositories with GitHub Pro, GitHub Team, GitHub Enterprise Cloud, and GitHub Enterprise Server". https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages

### Hashnode
1. "Ten's of support forum posts >30+ days old, with no reply from support". GreenFlux, Jul 7 2025. https://blog.greenflux.us/it-might-be-time-to-migrate-your-hashnode-blog/
2. "No updates to change log since November 2024." GreenFlux, Jul 7 2025. https://blog.greenflux.us/it-might-be-time-to-migrate-your-hashnode-blog/
3. "I had been editing a page on an 'incognito' window for days, and after logging back in, all of my changes were gone." derlin, Jan 2026. https://blog.derlin.ch/why-and-how-i-left-hashnode/

### Mintlify
1. "Their Github app asked for permissions to access all my repos and there was no way to get around that." brycelarkin, HN, Mar 17 2024. https://news.ycombinator.com/item?id=39730929
2. "Pricing for additional seats is not published — you need to contact Mintlify's sales team to get a number". BunnyDesk, Mar 3 2026. https://bunnydesk.ai/blog/mintlify-pricing/
3. "a few users on Reddit have complained that the platform feels overpriced for what it actually does" (Featurebase summary, not verbatim user). https://www.featurebase.app/blog/mintlify-pricing

### GitBook
1. "GitBook's pricing page says $8/user/month. That's technically true and practically misleading." mjkloski, dev.to, Mar 23 2026. https://dev.to/mjkloski/we-used-gitbook-for-two-years-heres-the-honest-post-mortem-of-why-we-left-52fm
2. "GitBook's OpenAPI integration only overwrites. It doesn't merge." same post. https://dev.to/mjkloski/we-used-gitbook-for-two-years-heres-the-honest-post-mortem-of-why-we-left-52fm
3. "i now realise Gitbook is a cloud service with a subscription, which is costly". Ask HN, Feb 2020 (older). https://news.ycombinator.com/item?id=22264969

### Docusaurus on Vercel/Netlify/GitHub Pages
1. "The site does build, on a Linux machine (16 cores & 64GB of RAM) after about an hour and fifteen minutes." tyler-mairose-sp, GitHub, May 1 2025. https://github.com/facebook/docusaurus/discussions/11140
2. "You're responsible for uptime, SSL certificates, CDN configuration, and scaling." Ferndesk, Jan 5 2026. https://ferndesk.com/blog/docusaurus-review
3. "this is so incredibly over-engineered it's comical to me. React components, MDX, TypeScript config files, CSS-in-JS? Do you really need all that to write docs?" brabel, HN, Aug 1 2022 (older). https://news.ycombinator.com/item?id=32303052

### Dropbox Paper
1. Apps retired: "The mobile apps will no longer be available to update or download on the App Store or Play Store." (Oct 9 2025). https://directionforward.com/news/2025/end-of-life-for-dropbox-paper-apps
2. Migration data loss threads: "Migrated Paper Docs" folders are all empty (thread title; body could not be fetched). https://community.dropbox.com/en/discussion/839283/migrated-paper-docs-folders-are-all-empty
3. "It's so strange that a company designed around syncing files created the .paper format which only stores a URL, and no actual content." kepano (Obsidian CEO), X, Sept 2025. https://x.com/kepano/status/1965503282690101340

### Google Docs "Publish to the web"
1. "I have tried having the tabs fixed, using pagerless vs pages, and nothing appears to be working" (formatting broken when published), Google Docs community, Sep 1 2024. https://support.google.com/docs/thread/294318146/formatting-is-being-messed-up-when-i-publish-doc-on-web?hl=en
2. Thread: "Google Docs Web Publishing Formatting Issue", Feb 10 2023 (older). https://support.google.com/docs/thread/201414958/google-docs-web-publishing-formatting-issue?hl=en
3. Thread: "Published (to the web) Google document is suddenly displayed in a horrible way.", Apr 28 2020 (older). https://support.google.com/docs/thread/42902756?hl=en

### ReadMe
1. "Very basic features, no image library, buggy search, proprietary Markdown (tables, images, code blocks, etc.), almost unusable on mobile." Yossi K., Capterra, Mar 14 2022 (older). https://www.capterra.com/p/218577/ReadMe/
2. "Not fully supporting OpenAPI 3.0, we have to write some script to workaround the issue." Anonymous, Capterra, Sep 1 2022 (older). https://www.capterra.com/p/218577/ReadMe/
3. Add-on stacking: Pro "$300 + $150 + $100" for Ask AI and analytics (Jamdesk, Apr 20 2026). https://www.jamdesk.com/blog/the-definitive-api-documentation-pricing-comparison-2026-2

### rentry.co
1. "it appears that i cant link new images at all. probably a temporary bug." user, updownradar, ~Oct 2025. https://updownradar.com/status/rentry.co
2. "it won't let me use image links. like when ever I press preview after inserting the link, it just dosent show anything." user, ~Sep 2025. https://updownradar.com/status/rentry.co
3. "my rentry don't work for three days now" user, ~2023 (older). https://updownradar.com/status/rentry.co

### telegra.ph
1. "UNABLE to change the automatically generated URL". sakuragawa, Aug 14 2020 (older). https://blog.sakuragawa.moe/some-hints-on-telegra-ph-2020/
2. "if you compose a advertisement but somehow want it deleted, you are not able to". same (older). https://blog.sakuragawa.moe/some-hints-on-telegra-ph-2020/
3. "you need to use the same browser with the same profile as when you create the article to edit it. If you lost that cookie...you will not be able to edit your articles". same (older). https://blog.sakuragawa.moe/some-hints-on-telegra-ph-2020/

### write.as
1. "The writing interface and editor can be improved a lot. It's very barebones when compared to rivals like Ghost blogging." Asit K., Capterra, Jan 31 2020 (older). https://www.capterra.com/p/176780/Write-as/reviews/
2. "A little hard to customize unless you're fluent in CSS and javascript." Mason P., Capterra, Nov 25 2020 (older). https://www.capterra.com/p/176780/Write-as/reviews/
3. "It also lacks in formatting, reach/share functionality and discoverability for authors." Sebastisn Ö., Capterra, Oct 30 2020 (older). https://www.capterra.com/p/176780/Write-as/reviews/

### Bear Blog
1. "I don't get HN's appeal for the bearblog platform? If anything else, if one wants to resurrect the 'Old Web', one shouldn't do it on someone else's platform." wiether, HN, ~Oct 2025. https://news.ycombinator.com/item?id=45372464
2. "No image hosting, you need to use external services for images" MakerStack review, Mar 20 2026. https://makerstack.co/reviews/bear-blog-review/
3. "No built-in comments system" same review. https://makerstack.co/reviews/bear-blog-review/

### Mataroa
1. Only positive HN comment found (Sep 2 2025): "Seems like one of the best (cleanest, simplest, fairest?) blogging platforms." wonger_. https://news.ycombinator.com/item?id=45105991
2. "comes with the downside of very limited customization options" (Very Simple Blogging review). https://verysimpleblogging.com/mataroa/
3. Hard limits: "1MB per file, 100MB total per account, 1,000 images maximum". https://mataroa.blog/

### Montaigne
1. Lock-in worry: commenter "worried about being 'trapped in Apple Notes'". mrweasel, HN, Dec 20 2023 (older). https://news.ycombinator.com/item?id=38706190
2. "features that are hard to mingle in Notes alone, i.e. custom themes, metadata, automatically generated home page". oneearedrabbit, HN, Dec 20 2023 (older). https://news.ycombinator.com/item?id=38706190
3. No password protection documented. UNVERIFIED. https://montaigne.io/pricing

### Quartz
1. "I can't deploy github pages following the instructions. I get this error: Error: Liquid syntax error (line 256)". EthoGarden, GitHub, Oct 15 2025. https://github.com/jackyzha0/quartz/issues/2164
2. "I am trying to add Umami analytics to my Quartz setup, but it's not hooking up correctly." unapologeticaf, GitHub, Nov 2 2024. https://github.com/jackyzha0/quartz/issues/1560
3. Font build failures issue #1828, Mar 2025. https://github.com/jackyzha0/quartz/issues/1828

### HedgeDoc
1. "Why was the PDF Export feature removed?" is an official FAQ entry (feature loss). https://hedgedoc.org/
2. HN: "HedgeDoc uses really old library versions" (Static HedgeDoc renderer thread, Sep 2024, summary). https://news.ycombinator.com/item?id=41567406
3. No user reviews on Slashdot ("No User Reviews"). UNVERIFIED beyond that. https://slashdot.org/software/p/HedgeDoc/

### Obsius
No complaints found. Limitation from README: "Only plain text and simple styling is supported". https://github.com/jonstodle/obsius-obsidian-plugin

### Share Note (Obsidian)
1. "the published note doesn't support the default 'closed callout'". almoo, Obsidian forum, Sep 29 2023 (older). https://forum.obsidian.md/t/share-note-plugin-share-individual-notes-with-full-support-for-themes-images-dataview-callouts-and-more/42788?page=5
2. "line `---` isn't working" and "`[[Linked Note]]` isn't showing the link". cs-mshah, Oct 12 2023 (older). same URL
3. Attachments are not encrypted: "It does not apply to attachments, which are stored unencrypted." README. https://github.com/alangrainger/share-note

### mdto.page (Show HN, Jan 2026) and the paste-and-link cohort
1. "I really suggest adding some way to report pages because phishers and spammers will abuse it when they find it." KomoD. https://news.ycombinator.com/item?id=46645942
2. "Because you can't use it in a CI" (Turnstile blocks curl). wiether. https://news.ycombinator.com/item?id=46645942
3. "I'm guessing it doesn't handle images because you'd have to upload the image, right?" acrophiliac. https://news.ycombinator.com/item?id=46645942

### Dillinger, StackEdit, markdownlivepreview, readme.so, markdown.new, Glasp, SilverBullet, Publii
These are editors, converters, or SSGs, not link-hosting services. No hosted-link complaints apply. StackEdit copyright notice stops at 2019 (stale). Glasp Pro at 150/yr is a highlighter, not a publisher.

---

## 4. Synthesis

### Gaps nobody fills well

1. Native Mac app to permanent link in one step. Bear (the most-loved native Mac markdown app) has no public link at all, and its forum shows fresh requests in Jul 2025, Dec 2025 and Jan 2026. iA Writer and Ulysses only push to third-party CMSs (and Medium tokens are dead). Typora and Marked render locally. Marked Share (Aug 29 2026) is the only native-app-to-link flow shipped, and it is free with an account.
2. Paste-and-link services are ephemeral or spammy. mdto.page, MDtoLink free, JotBird free, mdshare.online, LFMarkdown optional expiry all default to short lifetimes; the free-forever ones (rentry, telegra.ph, LFMarkdown) have no images, no edit-in-place, cookie-bound editing, or flaky uploads. Permanence plus update-in-place plus images is the paid-tier trigger everywhere (JotBird 29/yr, MDtoLink 36/yr).
3. Password or private links at a low price. Obsidian Publish passwords are site-wide only (still requested in 2024). Notion has none, even on Enterprise. Craft needs Plus (~96/yr). Vercel wants 150/mo. JotBird Pro (29/yr) and MDtoLink Pro (36/yr) are the only sub-40 options that offer private or password pages.
4. Typography. Every paste service renders GitHub-style; Notion and Google Docs published pages are widely mocked for URLs and broken formatting. Nobody ships the same reading experience in the app and on the link. This is Seshat's one clear differentiator and no competitor claims it.
5. Custom domain under 25/yr. Only Mataroa (9/yr) and Montaigne's 2/mo add-on. Notion charges 96/yr for the domain alone, GitBook 780/yr per site, MDtoLink 108/yr.
6. Reliability of tiny free services. rentry has recurring image and outage complaints; Quarto Pub is winding down; Hashnode went silent; Dropbox Paper retired its apps. Users of free link hosts are repeatedly burned, which is an argument for a cheap paid tier with an owner who answers.

### Where Seshat Share at 8.99/yr sits

- Price: below every hosted competitor except Mataroa (9/yr, same band, blog not doc-share). It is 3x cheaper than JotBird Pro (29/yr), 4x cheaper than MDtoLink Pro (36/yr), 10x cheaper than Obsidian Publish (96/yr per site), and cheaper than a single month of Craft Plus or Notion Plus with a domain.
- Risk: at 8.99/yr the "why not free" question is real, since rentry, LFMarkdown, Marked Share and Gist are free and permanent. The paid features that free tools consistently lack are: hosted images without expiry, edit-in-place with a stable slug, private or password links, and view counts. Ship those and the free cohort stops being a substitute.
- Positioning: "the link looks like the app" plus "permanent, editable, private-able, from a native Mac app and a CLI" is a combination no one in the matrix offers under 29/yr. JotBird is the closest product shape; Mataroa is the closest pricing philosophy; Marked Share is the closest native-app flow and it is free, so Seshat's typography and reader-first rendering must carry the difference.
- Yearly-only billing has precedent (Mataroa, JotBird Pro) and matches the low price point; under 1 USD/month is not worth monthly billing overhead.
- Custom domain and folder-as-mini-site are plausible upsells to a second tier later, because those are the features competitors price at 24 to 108/yr; do not fold them into 8.99.
