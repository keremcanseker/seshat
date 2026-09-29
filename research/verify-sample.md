# Verification sample (20% of non-top10 URLs)

Population: 433 unique URLs across the seven lane files after excluding the 72 URLs handled by verifier-top10. Sample: 87 URLs (20%, rounded up), shuffled with random.seed(20260906). Selection saved in verify-sample-list.json before verification; scripts: verify-sample-build.py, verify-run.py, verify-follow.py.

Matching rule: PASS = 6+ consecutive quote words verbatim at the source (whitespace, smart quotes, dashes, HTML entities normalized), or the cited price/fact on the page. PARTIAL = source reached, meaning present, wording or attribution differs materially. FAIL = source reached, quote or fact absent. UNREACHABLE = no method loaded the source.

Sources used: hn.algolia.com items API, api.github.com issues and comments, Discourse .json, iTunes customer-review RSS (us, gb, de, au, ca, pages 1-2), local lane1-monid-*.json and lane2-x-*.json payloads with id match, api.fxtwitter.com, curl with browser UA, WebFetch, r.jina.ai. No Monid calls were made.

| # | URL | Lane | Verdict | Note |
|---|---|---|---|---|
| 0 | https://community.bear.app/t/collaborate-and-share-notes/18585 | lane4-competitors | PASS | Discourse JSON: sebaswoz quote 9/22 consecutive words (rest split by punctuation, same meaning); TarFabius quote 10/10. |
| 1 | https://x.com/coffeewithone/status/2038796479444496824 | lane2-x | PASS | Found in lane2-x-17.json and fxtwitter, id matches. |
| 2 | https://github.com/anthropics/claude-code/issues/13600#issuecomment-3725375874 | lane6-ai-workflow | PASS | GitHub API comment 3725375874 by YoyoSaur, 10/10. |
| 3 | https://blog.bear.app/2023/04/bear-2-will-have-a-new-price-only-for-new-customers/ | lane7-pricing | PASS | Curl: grandfathering sentence 18/18; $2.99, $29.99, $1.49, $14.99 all on page. |
| 4 | https://x.com/aetosdios_/status/2085981438118420888 | lane2-x | PASS | lane2-x-17.json and fxtwitter, 10/10. |
| 5 | https://apps.apple.com/us/app/ulysses/id1225571038 | lane4-competitors | PASS | Curl of App Store page: both 2020 and 2022 reviews present verbatim (17/17, 9/9). |
| 6 | https://news.ycombinator.com/item?id=22462664 | lane7-pricing | PASS | Algolia: guessmyname 2020-03-02, 8/10 words (punctuation split). |
| 7 | https://support.google.com/docs/answer/183965 | lane4-competitors | PASS | Help page loads, 'Publish to the web' present. |
| 8 | https://www.reddit.com/r/ClaudeAI/comments/1qkhw9h/ | lane1-reddit | PARTIAL | Sampled URL is the r/ClaudeAI cross-post; its body (lane1-monid-5.json) differs and does not contain the quote. The quote is verbatim in the primary r/macapps post 1qki0f5 (lane1-monid-4.json), which the finding cites as its main URL. |
| 9 | https://news.ycombinator.com/item?id=22264969 | lane4-competitors | PASS | Algolia: story text by maxbaines 2020-02-07, 14/14. |
| 10 | https://news.ycombinator.com/item?id=40792970 | lane4-competitors | PASS | Algolia: tuttyboy comment in thread 40792970, 10/10. |
| 11 | https://x.com/blackgirlbytes/status/2052757292093718965 | lane2-x | PASS | lane2-x-23.json and fxtwitter, 13/13. |
| 12 | https://forum.obsidian.md/t/104086 | lane5-reviews | PASS | Discourse JSON: topic title contains the phrase, 9/9. |
| 13 | https://news.ycombinator.com/item?id=29360720 | lane3-hn-ph | PASS | Algolia: PhilipTrauner comment, 22/22. |
| 14 | https://www.producthunt.com/posts/markdown-bin | lane3-hn-ph | PASS | Curl of PH page: maker quote 18/18. |
| 15 | https://www.dropbox.com/plans | lane4-competitors | PASS | Curl: 9.99, $15, $24 present. |
| 16 | https://x.com/trq212/status/2067682475611242546 | lane2-x | PASS | lane2-x-8.json and fxtwitter, 19/19. |
| 17 | https://posthaven.com/ | lane7-pricing | PASS | Curl: both quotes and $5 present. |
| 18 | https://github.com/backnotprop/plannotator | lane6-ai-workflow | FAIL | Lane says '251 stars'. GitHub API today: stargazers_count 8,488 (forks 635). The number in the lane file is not what the repo shows. Quote in the finding is attributed to vibecodinghub.org, not this URL. |
| 19 | https://help.zoho.com/portal/en/community/topic/feature-request-render-markdown-md-files-in-zoho-cliq | lane6-ai-workflow | PASS | WebFetch and r.jina.ai: both sentences verbatim (dash normalized). |
| 20 | https://www.notion.com/pricing | lane4-competitors | PASS | WebFetch: Plus $10, Business $20, custom domain $8 annual / $10 monthly, 5MB free upload all present; monthly $12/$24 not visible in fetched render. |
| 21 | https://macmdviewer.com/blog/read-claude-code-plans-mac | lane6-ai-workflow | PASS | Curl: 15/15 and 7/7. |
| 22 | https://support.google.com/gemini/thread/384844921/cannot-export-gemini-to-docs-without-losing-formatting | lane6-ai-workflow | PASS | Curl: thread title present 8/8 (bodies not verified, lane cites title only). |
| 23 | https://news.ycombinator.com/item?id=47331366 | lane6-ai-workflow | PASS | Algolia: backrun 2026-03-11, 13/26 consecutive (dashes/em-dash split), rest verbatim. |
| 24 | https://news.ycombinator.com/item?id=48072214 | lane6-ai-workflow | PASS | Algolia: alsetmusic, 26/26. |
| 25 | https://itunes.apple.com/us/rss/customerreviews/id=6760943472/sortBy=mostRecent/json | lane5-reviews | PASS | iTunes RSS us page 1-2: both reviews 16/16. |
| 26 | https://www.reddit.com/r/Markdown/comments/1rx2ssm/publish_markdown_as_a_nice_site_via_web_or_cli_in/ | lane1-reddit | PASS | lane1-monid-9.json, 15/15. |
| 27 | https://news.ycombinator.com/item?id=48181937 | lane3-hn-ph | PASS | Algolia: rbits, 14/14. |
| 28 | https://github.com/anthropics/claude-code/issues/11651 | lane6-ai-workflow | PASS | GitHub API issue body 13/13. |
| 29 | https://x.com/hanakoxbt/status/2060836730589028421 | lane2-x | PASS | lane2-x-14.json and fxtwitter, 7/7. |
| 30 | https://news.ycombinator.com/item?id=33192436 | lane7-pricing | PASS | Algolia: roessland 2022-10-13, 19/19. |
| 31 | https://www.softwareworld.co/software/hackmd-reviews/ | lane4-competitors | UNREACHABLE | curl 513-char stub, WebFetch 403, r.jina.ai empty. Lane calls it an aggregator summary. |
| 32 | https://plausible.io/#pricing | lane7-pricing | PASS | Curl: $9, 10k, 2 months free, 30-day present. |
| 33 | https://www.reddit.com/r/CraftDocs/comments/1tyb8zo/from_markdown_to_stylised_docx_and_pdf/ | lane1-reddit | PASS | lane1-monid-14.json, 17/17. |
| 34 | https://www.indiehackers.com/post/whats-new-don-t-offer-lifetime-deals-191668f974 | lane7-pricing | PASS | Curl: 'Investors hate nonrecurring revenue' and 9/9 second quote. |
| 35 | https://directionforward.com/news/2025/end-of-life-for-dropbox-paper-apps | lane4-competitors | PASS | Curl: 19/19. |
| 36 | https://ghost.org/pricing/ | lane7-pricing | PASS | Curl: 'Starter ... $ 18 USD / mo Billed yearly' present. |
| 37 | https://www.g2.com/products/gitbook/reviews?qs=cons | lane5-reviews | UNREACHABLE | Curl 1.7KB block page; lane itself lists this URL as CAPTCHA-walled, no quote attributed. |
| 38 | https://masto.host/pricing/ | lane7-pricing | PASS | Curl: Moon, $6, 5 active users, 20 GB present. |
| 39 | https://github.com/anthropics/claude-code/issues/82643 | lane6-ai-workflow | PASS | GitHub API issue body 23/23. |
| 40 | https://github.com/sbarex/QLMarkdown/issues/161 | lane5-reviews | PASS | GitHub API 30/30. |
| 41 | https://aiproductivity.ai/pricing/craft/ | lane7-pricing | PASS | Curl: Plus $8/mo, $4.8/mo annual, 1,500 blocks, 1 GB, 25 MB present. |
| 42 | https://1password.com/personal-pricing | lane7-pricing | PASS | Curl: '$2.99 USD ... Per month. Paid annually', $4.49 present. |
| 43 | https://freemius.com/blog/saas-lifetime-deals/ | lane7-pricing | PASS | Curl: 25/25 and 12/12. |
| 44 | https://www.manton.org/2024/02/21/simplified-pricing-in.html | lane7-pricing | PASS | Curl: $5/$10/$15 per-blog history present; $20 Studio not on this 2024 post (row also cites micro.blog/pricing). |
| 45 | https://unmarkdown.com/blog/the-ai-formatting-problem | lane6-ai-workflow | PASS | Curl: 17/17 and 14/14. |
| 46 | https://x.com/DannyAziz97/status/1943026482952946013 | lane2-x | PASS | lane2-x-24.json and fxtwitter, 10/10. |
| 47 | https://news.ycombinator.com/item?id=48090474 | lane6-ai-workflow | PASS | Algolia: yuegui, 24/24. |
| 48 | https://news.ycombinator.com/item?id=48431648 | lane3-hn-ph | PASS | Algolia: antonynjoro story, 29/29. |
| 49 | https://www.producthunt.com/products/showmd-ai-markdown-quicklook-preview | lane3-hn-ph | PASS | Curl of PH page: maker quote 19/19, Schranz 16/16. |
| 50 | https://zight.com/pricing/ | lane7-pricing | PASS | Curl: 9.95, $12, 1 GB, 15-sec present. |
| 51 | https://www.notion.com/help/notion-sites-availability-and-pricing | lane4-competitors | PASS | Curl: $8, $10, 5 MB, notion.site present. |
| 52 | https://www.g2.com/products/notion/reviews | lane5-reviews | UNREACHABLE | Curl 1.7KB block page; lane lists it as CAPTCHA-walled. |
| 53 | https://x.com/rudolfscode/status/2083095294401524189 | lane2-x | PASS | lane2-x-17.json and fxtwitter, 15/15. |
| 54 | https://toolradar.com/tools/standard-notes/pricing | lane7-pricing | PASS | Curl: $90, $120, Productivity, Professional present. |
| 55 | https://docs.hedgedoc.org/ | lane4-competitors | PASS | WebFetch: demo.hedgedoc.org and self-host install docs present; AGPL not on this page (row also cites hedgedoc.org). |
| 56 | https://vercel.com/pricing | lane4-competitors | PASS | Curl: $20, $150, Hobby, 100 GB, Advanced Deployment Protection present. |
| 57 | https://news.ycombinator.com/item?id=48073056 | lane6-ai-workflow | PASS | Algolia: rsolva, 16/25 consecutive (voila accent), rest verbatim. |
| 58 | https://www.jamdesk.com/blog/the-definitive-api-documentation-pricing-comparison-2026-2 | lane4-competitors | PASS | Curl: $300, $150, $100, $250, Ask AI present. |
| 59 | https://x.com/yashbanka123/status/2078459197084295556 | lane2-x | PASS | lane2-x-11.json and fxtwitter, 13/13. |
| 60 | https://x.com/pastebin/status/939420462098059264 | lane7-pricing | PASS | fxtwitter: 'just $19.95 instead of the normal $49.95. 60% off' present, matches table fact. |
| 61 | https://readme.com/pricing | lane4-competitors | PASS | Curl: Pro $250/month billed annually, Ask AI $150/mo present. |
| 62 | https://support.google.com/docs/thread/356697768/paste-from-markdown-now-creates-unwanted-code-blocks | lane6-ai-workflow | PASS | Curl: thread title present. |
| 63 | https://x.com/alex_prompter/status/2081327819800576085 | lane2-x | PASS | Not in local X payloads (lane says search snippet); fxtwitter returns the tweet, 20/20. |
| 64 | https://itunes.apple.com/us/rss/customerreviews/id=1232780281/sortBy=mostRecent/json | lane5-reviews | PASS | iTunes RSS: 19/19 and 13/13. |
| 65 | https://www.producthunt.com/products/marked-ql | lane3-hn-ph | PASS | Curl of PH page: 14/14 and 18/18. |
| 66 | https://itunes.apple.com/us/rss/customerreviews/id=1507139439/sortBy=mostRecent/json | lane5-reviews | PASS | iTunes RSS: 13/13, 15/15, 7/7. |
| 67 | https://x.com/TAbrodi/status/2052814887852933172 | lane2-x | PASS | lane2-x-23.json and fxtwitter, 22/22. |
| 68 | https://setapp.com/apps/marked/customer-reviews | lane4-competitors | PASS | Curl: 11/11 and 21/21. |
| 69 | https://www.reddit.com/r/macapps/comments/1tqchj9/telescopo_7_free_native_markdown_viewer_now_with/ | lane1-reddit | PASS | lane1-monid-4.json, 20/20. |
| 70 | https://news.ycombinator.com/item?id=46896623 | lane3-hn-ph | PASS | Algolia: letientai299 story, 22/22. |
| 71 | https://www.capterra.com/p/10004063/Obsidian/reviews/ | lane5-reviews | UNREACHABLE | Curl 5KB block page; lane lists it as CAPTCHA/timeout. |
| 72 | https://bunny.net/pricing/ | lane7-pricing | PASS | Curl: $0.01, $1, minimum present. |
| 73 | https://www.g2.com/products/obsidian-publish/reviews | lane5-reviews | UNREACHABLE | Curl 1.7KB block page; lane lists it as CAPTCHA-walled. |
| 74 | https://news.ycombinator.com/item?id=46674404 | lane6-ai-workflow | PASS | Algolia: bobjordan, 31/31. |
| 75 | https://github.com/sbarex/QLMarkdown/issues/165 | lane5-reviews | PASS | GitHub API 23/23. |
| 76 | https://x.com/nosilverv/status/1838193238064197782 | lane2-x | PASS | lane2-x-2.json and fxtwitter, 6/6. |
| 77 | https://hackmd.io/@docs/yearly-payment-faq-en | lane7-pricing | PASS | Curl: '6 USD', Prime, yearly present. |
| 78 | https://news.ycombinator.com/item?id=45372464 | lane4-competitors | PASS | Algolia: wiether 2025-09-25, 18/28 consecutive (quote marks split), rest verbatim. |
| 79 | https://news.ycombinator.com/item?id=45822274 | lane6-ai-workflow | PASS | Algolia: waleedk story, 10/14 (arrow char split), rest verbatim. |
| 80 | https://markedapp.com/pricing/ | lane4-competitors | PASS | Curl: 14.99, 2.99, 4.99, 29.99, 49.99, 69.99, 89.99 all present. |
| 81 | https://x.com/xadhish/status/1897624883225571629 | lane2-x | PASS | lane2-x-1.json and fxtwitter, 8/8. |
| 82 | https://news.ycombinator.com/item?id=49546673 | lane6-ai-workflow | PASS | Algolia: cjcj 2026-09-03, 24/24. |
| 83 | https://www.techradar.com/computing/artificial-intelligence/this-new-chatgpt-feature-solves-the-most-annoying-thing-about-deep-research | lane6-ai-workflow | FAIL | Full 2.1MB article HTML fetched by curl; 'spectacularly ugly documents' and the word 'ugly' do not appear anywhere. WebFetch render also lacks it. Phrase is not on this page. |
| 84 | https://github.com/pricing | lane4-competitors | PASS | Curl: 'Team ... $ 4 USD per user/month' present. |
| 85 | https://github.com/quarto-dev/quarto-cli/discussions/10965 | lane4-competitors | PASS | Discussion HTML: question 12/12 and cderv answer 25/25. |
| 86 | https://www.reddit.com/r/htmx/comments/1fkt0e6/txtd_instant_markdown_page_sharing_go_htmx_sqlite/ | lane1-reddit | UNREACHABLE | Not in lane1-monid payloads (lane says pullpush was the source); pullpush now rate-limits, WebFetch and r.jina.ai blocked for reddit.com, reddit .json returns a block page. |

## Totals

- PASS: 78
- PARTIAL: 1
- FAIL: 2
- UNREACHABLE: https://www.reddit.com/r/htmx/comments/1fkt0e6/txtd_instant_markdown_page_sharing_go_htmx_sqlite/
- Pass rate (PASS / (PASS + PARTIAL + FAIL)): 78/81 = 96.3%

## FAIL and PARTIAL detail

- [PARTIAL] https://www.reddit.com/r/ClaudeAI/comments/1qkhw9h/ (lane1-reddit): Sampled URL is the r/ClaudeAI cross-post; its body (lane1-monid-5.json) differs and does not contain the quote. The quote is verbatim in the primary r/macapps post 1qki0f5 (lane1-monid-4.json), which the finding cites as its main URL.
- [FAIL] https://github.com/backnotprop/plannotator (lane6-ai-workflow): Lane says '251 stars'. GitHub API today: stargazers_count 8,488 (forks 635). The number in the lane file is not what the repo shows. Quote in the finding is attributed to vibecodinghub.org, not this URL.
- [FAIL] https://www.techradar.com/computing/artificial-intelligence/this-new-chatgpt-feature-solves-the-most-annoying-thing-about-deep-research (lane6-ai-workflow): Full 2.1MB article HTML fetched by curl; 'spectacularly ugly documents' and the word 'ugly' do not appear anywhere. WebFetch render also lacks it. Phrase is not on this page.

## UNREACHABLE detail

- https://www.softwareworld.co/software/hackmd-reviews/ (lane4-competitors): curl 513-char stub, WebFetch 403, r.jina.ai empty. Lane calls it an aggregator summary.
- https://www.g2.com/products/gitbook/reviews?qs=cons (lane5-reviews): Curl 1.7KB block page; lane itself lists this URL as CAPTCHA-walled, no quote attributed.
- https://www.g2.com/products/notion/reviews (lane5-reviews): Curl 1.7KB block page; lane lists it as CAPTCHA-walled.
- https://www.capterra.com/p/10004063/Obsidian/reviews/ (lane5-reviews): Curl 5KB block page; lane lists it as CAPTCHA/timeout.
- https://www.g2.com/products/obsidian-publish/reviews (lane5-reviews): Curl 1.7KB block page; lane lists it as CAPTCHA-walled.
- https://www.reddit.com/r/htmx/comments/1fkt0e6/txtd_instant_markdown_page_sharing_go_htmx_sqlite/ (lane1-reddit): Not in lane1-monid payloads (lane says pullpush was the source); pullpush now rate-limits, WebFetch and r.jina.ai blocked for reddit.com, reddit .json returns a block page.
