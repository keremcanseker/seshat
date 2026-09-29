# Lane 1: Reddit pain mining for Seshat / Seshat Share

Method note. Reddit blocks WebFetch, WebSearch (reddit.com is on the crawler blocklist), curl (403 "network security"), api.reddit.com, RSS, jina proxy, and every redlib mirror (Anubis proof-of-work). pullpush.io worked for exactly one query before a sustained 429. Nearly all findings come from the Monid tikhub Reddit search (20 calls, the hard cap) plus that one pullpush result. Post bodies and comments are quoted verbatim from the API payloads saved in this scratchpad (lane1-monid-1.json to lane1-monid-20.json). Vendor-authored posts (someone launching a tool) are marked VENDOR; they still count as evidence that a builder felt the pain, but they are weighted lower in the ranking than a plain user asking for help.

Tags: SHARING, READING, WRITING. Everything is OBSERVED unless marked INFERRED.

---

## A. Sharing a single markdown doc as a link

### 1. Least confusing way to share md with a non-technical teammate
- URL: https://www.reddit.com/r/Markdown/comments/1vu538c/what_is_the_least_confusing_way_to_share_a/
- Date: 2026-08-21, r/Markdown
- Quote: "Sending the raw .md file assumes they already have a viewer, while converting to PDF removes easy revisions and can break links or diagrams. Is there a simple workflow that gives the recipient a readable link, preserves formatting, and lets the author update the source without resending a new export?"
- Need: a readable link, formatting preserved, author updates in place.
- Engagement: 22 upvotes, 35 comments
- Pain: SHARING

### 2. Non-technical people do not want markdown syntax (top comment on #1)
- URL: https://www.reddit.com/r/Markdown/comments/1vu538c/ (comment t1_p4zno5v, u/protowings)
- Date: 2026-08-21, r/Markdown
- Quote: "A non technical person doesn’t want to read markdown formatting or html tags. I work at a Microsoft office kind of place."
- Need: rendered output for office-culture recipients; the author currently round-trips through Word with pandoc scripts.
- Engagement: 10 upvotes (top comment)
- Pain: SHARING

### 3. Product folks hated multipage PDFs; updates are the hard part (comment on #1)
- URL: https://www.reddit.com/r/Markdown/comments/1vu538c/ (comment t1_p5iad6k, u/imrsn)
- Date: 2026-08-24, r/Markdown
- Quote: "updating source is tricky. i have this problem and i found the answer was pdf for most of the product folks so i made a markdown reader that exports pdfs as a big page (they all hated them being saved them as multipage)."
- Need: one continuous page, not paginated; a way to push updates. VENDOR (leaftext.com).
- Engagement: 3 upvotes
- Pain: SHARING

### 4. Workaround: send the .md plus an HTML twin (comment on #1)
- URL: https://www.reddit.com/r/Markdown/comments/1vu538c/ (comment t1_p4yp7pz, u/sabre23t)
- Date: 2026-08-21, r/Markdown
- Quote: "I often share MD files accompanied by an HTML version of it. The non technical recipient can easily view the HTML file if they don't know how to directly use the MD file."
- Need: a rendered artifact the recipient can open with zero tooling.
- Engagement: 3 upvotes
- Pain: SHARING

### 5. GitHub solves viewing, not editing (comment on #1)
- URL: https://www.reddit.com/r/Markdown/comments/1vu538c/ (comment t1_p55xfm5, u/sohang-3112, replying to "I use GitHub exactly for this purpose", 7 upvotes)
- Date: 2026-08-22, r/Markdown
- Quote: "That solves viewing problem, not editing. Non technical person won't be able to edit markdown files on github."
- Need: GitHub is the default "viewer" for devs; editing by the recipient is a separate ask (out of Seshat scope, but worth knowing it comes up).
- Engagement: 3 upvotes; parent 7 upvotes
- Pain: SHARING

### 6. "Just here's the page", not a site, repo, or PDF
- URL: https://www.reddit.com/r/Markdown/comments/1u3tpkl/how_do_you_share_single_markdown_files_quickly/
- Date: 2026-06-12, r/Markdown
- Quote: "Sometimes I have one Markdown doc - notes, a short guide, AI research findings, something from my knowledge base - and I just want to send someone a readable link. Not really publish a whole site, not set up a repo, not export to PDF, just “here’s the page”."
- Need: one-off share of one doc. VENDOR (Flowershow maintainer), explicitly asking whether the need is common.
- Engagement: 17 upvotes, 6 comments
- Pain: SHARING

### 7. COUNTER-SIGNAL: public links barely used inside an editor product (comment on #6)
- URL: https://www.reddit.com/r/Markdown/comments/1u3tpkl/ (comment t1_or7v113, u/System_Independent)
- Date: 2026-06-12, r/Markdown
- Quote: "For my app mdedit.ai with 8.5k users, i added support for markdown public link sharing, and less than 10 people have ever used it. So at least for my product the demand for this feature is low, but for i can see this being useful for users of your app."
- Need: caution. When the share button lives inside a web editor, almost nobody pressed it. INFERRED: the wedge has to be the doc that already exists on disk (AI output), not a doc written in the tool.
- Engagement: 0 upvotes
- Pain: SHARING (negative evidence)

### 8. Public vs private split in practice (comment on #6)
- URL: https://www.reddit.com/r/Markdown/comments/1u3tpkl/ (comment t1_orjtcqk, u/sspaeti)
- Date: 2026-06-14, r/Markdown
- Quote: "I use Quartz for public content and HackMD for private."
- Need: two tools because one link product does not cover both public and private.
- Engagement: 1 upvote
- Pain: SHARING

### 9. Share one Obsidian note without publishing the vault
- URL: https://www.reddit.com/r/ObsidianMD/comments/1sgom74/is_there_a_good_way_to_share_a_single_obsidian/
- Date: 2026-04-09, r/ObsidianMD
- Quote: "Sometimes I just want to share one note with someone. But the options feel a bit heavy:" [Obsidian Publish publishes a full site, GitHub is overkill, copy/paste loses formatting] "I don’t always want to expose my whole vault or set up a publish flow just for one note."
- Need: single-note link. The OP built a CLI ("npx sharemd path/to/note.md") with version history, optional password, no login. VENDOR-ish.
- Engagement: 19 upvotes, 23 comments
- Pain: SHARING

### 10. PDF is the incumbent answer (top comment on #9)
- URL: https://www.reddit.com/r/ObsidianMD/comments/1sgom74/ (comment t1_of6m6y9, u/slicehamm)
- Date: 2026-04-09, r/ObsidianMD
- Quote: "I export mine as pdf and send it that way. External links are preserved. Formatting preserved (though sometimes the page breaks are a bit clunky) ."
- Need: what people actually do today; the acknowledged cost is clunky page breaks. Three replies agree ("I do the same!", "This is the answer").
- Engagement: 30 upvotes (top comment), 4 agreeing replies
- Pain: SHARING

### 11. "Apparently I'm a luddite, I just export notes as a PDF" (comment on #9)
- URL: https://www.reddit.com/r/ObsidianMD/comments/1sgom74/ (comment t1_of6nflv, u/Hellomynameis99_)
- Date: 2026-04-09, r/ObsidianMD
- Quote: "Apparently I'm a luddite, I just export notes as a PDF :D"
- Need: same as #10; the commenter then lists Share Note, QuickShare, Just Share Please plugins as the alternatives they found. One reply: "I use sharenote. It works great." (3 upvotes)
- Engagement: 6 upvotes
- Pain: SHARING

### 12. Pastor wants a note that updates for non-Obsidian people
- URL: https://www.reddit.com/r/ObsidianMD/comments/1v4oerl/share_a_note_that_updates_when_i_make_changes_to/
- Date: 2026-07-23, r/ObsidianMD
- Quote: "I have a couple notes that I want to be able to share with non-Obsidian using folks & have the notes update when I change them on my end." "I've tried searching here, but none of the solutions seem to address my use case."
- Need: live-updating link for a secretary and pianist. Non-developer persona.
- Engagement: 10 upvotes, 13 comments
- Pain: SHARING

### 13. Selective share at work; gists blocked, whole vault on GitHub is a no
- URL: https://www.reddit.com/r/ObsidianMD/comments/1v0x5ib/do_you_ever_have_the_just_share_some_notes_on/
- Date: 2026-07-19, r/ObsidianMD
- Quote: "Putting all my vault on GH is a no go for me. Having different vaults for things I might want to publish or not, sounds again too much trouble." "I could not find a plugin that allow "selective" share, like just copy a specific note and push it."
- Need: push one note, privately, from a corporate Mac.
- Engagement: 7 upvotes, 5 comments
- Pain: SHARING

### 14. Pays for Publish, still cannot share with a team that does not use Obsidian
- URL: https://www.reddit.com/r/ObsidianMD/comments/1v5dut5/how_can_i_publish_on_an_internal_website_or_share/
- Date: 2026-07-24, r/ObsidianMD
- Quote: "I pay for Catalyst, Sync & Publish. I'm working with a new company and they're not already using Obsidian but I do." "Is there a tool which can generate a static website or do you have a better idea ?"
- Need: publish a folder of notes for colleagues who do not use your tool.
- Engagement: 13 upvotes, 10 comments
- Pain: SHARING

### 15. Wants password protection; free publish routes lack it
- URL: https://www.reddit.com/r/ObsidianMD/comments/1ucu4ef/sortable_tables_lists_publish/ (comment t1_otxgf1x)
- Date: 2026-06-26, r/ObsidianMD
- Quote: "Pity the digital garden & forestry.md route doesn't do password protect, while obsidian publish doesn't support bases (yet)." "As the project is only in very early stages, it's for some eyes only."
- Need: password-protected share for early-stage work.
- Engagement: 2 upvotes
- Pain: SHARING

### 16. Portfolio stayed outdated because publishing meant a dev workflow
- URL: https://www.reddit.com/r/ObsidianMD/comments/1stnbcx/built_a_plugin_to_publish_obsidian_notes_as_a/
- Date: 2026-04-23, r/ObsidianMD
- Quote: "I kept my portfolio perpetually outdated because updating it meant leaving Obsidian and going through a whole dev workflow. So I built a plugin that removes that friction."
- Need: publish from the writing tool; frontmatter flag selects notes; supports images. VENDOR.
- Engagement: 10 upvotes, 29 comments
- Pain: SHARING

### 17. Free Publish alternatives are unmaintained
- URL: https://www.reddit.com/r/ObsidianMD/comments/1sdv4cq/enhanced_obsidian_zola_another_alternative_to/
- Date: 2026-04-06, r/ObsidianMD
- Quote: "After searching for an alternative to Obsidian Publish, I stumbled upon Obsidian Zola. The project has a lot potential however, it's not actively maintained and lacks some essential features."
- Need: a maintained, cheaper Publish. VENDOR (fork author).
- Engagement: 18 upvotes, 5 comments
- Pain: SHARING

### 18. Git-based sync also auto-publishes sites (high engagement, Obsidian)
- URL: https://www.reddit.com/r/ObsidianMD/comments/1w544z2/two_years_syncing_obsidian_with_git_heres_the/
- Date: 2026-09-02, r/ObsidianMD
- Quote: "The same repo also auto-publishes my Markdown sites, so editing a note on my phone updates the site without me touching anything." "This is for people who know Git or really need a free option."
- Need: sync plus publish in one motion; explicitly framed as the free, technical route.
- Engagement: 474 upvotes, 83 comments
- Pain: SHARING

### 19. Notion links look "janky and unprofessional" to clients
- URL: https://www.reddit.com/r/Notion/comments/1s4mq9x/how_do_you_guys_share_notion_pages_with_clients/
- Date: 2026-03-26, r/Notion
- Quote: "They have to make an account, or the link just looks kind of janky and unprofessional. Had a client once tell me it looked unfinished."
- Need: a client-facing link that looks finished and needs no account. Also: "Exporting to PDF every time? Copying everything into Google Docs?"
- Engagement: 1 upvote, 5 comments
- Pain: SHARING

### 20. Agencies: client privacy and no-account access
- URL: https://www.reddit.com/r/Notion/comments/1uz28v7/how_are_you_sharing_notion_with_clients_in_2026/
- Date: 2026-07-17, r/Notion
- Quote: "What’s actually working for agencies with 10+ clients? Especially curious about privacy (clients seeing each other) and whether clients need Notion accounts."
- Need: per-client private links, no sign-up.
- Engagement: 6 upvotes, 7 comments
- Pain: SHARING

### 21. Markdown in Slack falls apart; hosted preview link considered
- URL: https://www.reddit.com/r/Slack/comments/1vy2zut/how_do_you_share_a_markdown_document_in_slack/
- Date: 2026-08-25, r/Slack
- Quote: "Pasting Markdown into a message can flatten headings, nested lists, tables, and long code blocks. Uploading the .md file preserves the source, but then the recipient may need to download it and find a separate viewer."
- Need: the OP explicitly weighs "a hosted preview link when the document will keep changing".
- Engagement: 11 upvotes, 8 comments
- Pain: SHARING

### 22. "I just wanted to send a link and have them see exactly what I was seeing"
- URL: https://www.reddit.com/r/developersIndia/comments/1w8sy3g/built_rendermd_because_i_was_tired_of_sending/
- Date: 2026-09-06, r/developersIndia
- Quote: "whenever I wanted to show something to a friend, I had to send them the actual file. I just wanted to send a link and have them see exactly what I was seeing."
- Need: link renders identically to the author's view. VENDOR.
- Engagement: 4 upvotes, 6 comments
- Pain: SHARING

### 23. Self-hosted share links; admits frozen snapshots are the weak spot
- URL: https://www.reddit.com/r/selfhosted/comments/1t07xjn/markdownpdf_workbench_with_postgresbacked_share/
- Date: 2026-04-30, r/selfhosted
- Quote: "Optional public share links (anyone with the URL can view a doc, no account needed)" and "each share is a frozen snapshot, which is fine for status updates and less ideal for live docs."
- Need: update-in-place is the missing feature even in a tool that has share links. VENDOR.
- Engagement: 0 upvotes, 10 comments
- Pain: SHARING

### 24. Instant markdown page with custom URLs (older, 2024)
- URL: https://www.reddit.com/r/htmx/comments/1fkt0e6/txtd_instant_markdown_page_sharing_go_htmx_sqlite/
- Date: 2024-09-19, r/htmx (flag: 24 months old)
- Quote: "Introducing TXTD - a minimalist platform for creating and sharing Markdown-based pages and notes with custom URLS."
- Need: custom slugs. VENDOR. Source: pullpush.io (the one query that succeeded).
- Engagement: 19 upvotes, 13 comments
- Pain: SHARING

### 25. CLI to get a share link for a report.md on your own server
- URL: https://www.reddit.com/r/commandline/comments/1rm46uh/toss_a_minimal_cli_to_deploy_and_share_static/
- Date: 2026-03-06, r/commandline (seen via a mirror comment)
- Quote: "To quickly share Markdown docs and static content, I made toss, a CLI for deploying and managing static sites on your own server."
- Need: CLI-first "get me a link for this file". VENDOR.
- Engagement: unknown (mirror comment only)
- Pain: SHARING

### 26. Private links as a shipped feature
- URL: comment t1 on pagoti.com (permalink not returned by the API; post title not returned)
- Date: 2026-01-12
- Quote: "Just got done adding private links, which is kewl if you wanna share markdown pages with people privately..."
- Need: private links. VENDOR, low-quality source.
- Engagement: 1 upvote
- Pain: SHARING

### 27. Upload a file, share the link, "usually just for a short period of time"
- URL: https://www.reddit.com/r/Markdown/comments/1qefqx7/i_made_a_tool_to_publish_a_markdown_file_as_a/
- Date: 2026-01-16, r/Markdown
- Quote: "I often find myself writing notes or documentation in Markdown and needing to share them as a proper webpage, but usually just for a short period of time."
- Need: no-login, short-lived links (supports the expiring-link feature). VENDOR (mdto.page).
- Engagement: 32 upvotes, 14 comments
- Pain: SHARING

### 28. Flowershow's feature list is the competitor baseline
- URL: https://www.reddit.com/r/Markdown/comments/1rx2ssm/publish_markdown_as_a_nice_site_via_web_or_cli_in/
- Date: 2026-03-18, r/Markdown
- Quote: "It also comes with stuff like search, comments, custom domains, password protection, and theme customization, plus a few official themes to start from. And it's open source!"
- Need: what a free, open-source hosted competitor already offers: custom domains, password protection, single file or full site. VENDOR.
- Engagement: 12 upvotes, 4 comments
- Pain: SHARING

### 29. Markdown-to-PDF: cut-off elements and page breaks
- URL: https://www.reddit.com/r/Markdown/comments/1sm1sct/opensource_markdown_to_pdf_tool_fully_clientside/
- Date: 2026-04-15, r/Markdown
- Quote: "I kept running into the same problems with Markdown-to-PDF tools, especially on multi-page output. Elements getting cut off, awkward page breaks, and layouts not fitting properly across pages were the main issues for me."
- Need: the PDF route (the incumbent in #10, #11) is itself painful. VENDOR.
- Engagement: 0 upvotes, 20 comments
- Pain: SHARING

### 30. AI output pasted into Word or email is "a total disaster"
- URL: https://www.reddit.com/r/ChatGPT/comments/1rlbcji/sick_of_messy_formatting_when_copying_from_ai_use/
- Date: 2026-03-05, r/ChatGPT
- Quote: "We’ve all been there: you ask an AI to write a report or a blog post, you hit copy, and when you paste it into your editor/Word/Email, the formatting is a total disaster."
- Need: a rendered surface for AI markdown that survives handoff; the OP's fix is a markdown-to-HTML previewer as an intermediary.
- Engagement: 1 upvote, 10 comments
- Pain: SHARING

### 31. Long ChatGPT chats cannot be copied whole
- URL: https://www.reddit.com/r/ChatGPT/comments/1tt6klu/i_built_a_free_tool_to_export_full_chatgpt/
- Date: 2026-05-31, r/ChatGPT
- Quote: "ChatGPT removed the ability to select and copy entire conversations. If you have a long chat, you're stuck copying message by message."
- Need: getting long AI output out as .md at all (upstream of Seshat). VENDOR.
- Engagement: 5 upvotes, 22 comments
- Pain: SHARING (adjacent)

### 32. Recipients who refuse to install the author's tool
- URL: https://www.reddit.com/r/ObsidianMD/comments/1spx7qw/your_thoughts_on_this_use_of_obsidian/ (comment t1_oh43xqs quoting the OP, an EMT building onboarding notes)
- Date: 2026-04-19, r/ObsidianMD
- Quote (OP text as quoted in the comment): "What if someone doesn't want to use/download Obsidian? I am not going to pressure someone to download some strange"
- Need: readers should not need the author's app.
- Engagement: 2 upvotes
- Pain: SHARING

### 33. Pasting a screenshot into docs is "three clicks, a file dialog, wrong folder"
- URL: https://www.reddit.com/r/selfhosted/comments/1to72gh/leafwiki_v0100_selfhosted_wiki_single_go_binary/
- Date: 2026-05-26, r/selfhosted
- Quote: "And every time I wanted to paste a screenshot, it was three clicks, a file dialog, wrong folder. That gets old fast."
- Need: images in markdown docs are a chore; relevant to the image-hosting feature. VENDOR (wiki, not a share tool).
- Engagement: 197 upvotes, 69 comments
- Pain: WRITING

---

## B. Reading long AI-generated markdown

### 34. "I'm tired of reading specs and plans"
- URL: https://www.reddit.com/r/ClaudeAI/comments/1w0jpzo/im_tired_of_reading_specs_and_plans/
- Date: 2026-08-28, r/ClaudeAI
- Quote: "Now I find myself reading a lot of generated content: long specs, implementation plans, Markdown files, explanations, etc. Sometimes I find myself spending more time reading the specs and implementation plans generated by the agent than actually writing code."
- Need: the reading load from AI tools is now the bottleneck. Note the OP asks about audio, not better rendering.
- Engagement: 70 upvotes, 56 comments
- Pain: READING

### 35. COUNTER-SIGNAL: people want less to read, not prettier reading (top comments on #34)
- URL: https://www.reddit.com/r/ClaudeAI/comments/1w0jpzo/ (comments t1_p6dhokz u/Signal_Till_933, t1_p6dlae5 u/Infamous-Bed-7535)
- Date: 2026-08-28, r/ClaudeAI
- Quote: "The generated stuff that gets output by my team is so incredibly verbose sometimes, I know for a fact they haven’t read it. Why should I then?" and "I handle all purely ai generated documents as not made for me! Probably even the author have not read it, ehy should I?"
- Need: INFERRED: a reader will not sell on "read more comfortably"; it has to sell on "get through it faster" (outline, skim, jump) and on the sharing step.
- Engagement: 33 and 5 upvotes
- Pain: READING (negative evidence)

### 36. "I got tired of reading .md after .md"
- URL: https://www.reddit.com/r/ClaudeAI/comments/1vlwqlq/opensource_topdown_md_visualizer/
- Date: 2026-08-11, r/ClaudeAI
- Quote: "I got tired of reading .md after .md and thought it would be nice to create a visual framework for Markdown files."
- Need: relief from serial reading of AI markdown; this OP's answer is visual maps. VENDOR (open source).
- Engagement: 143 upvotes, 40 comments
- Pain: READING

### 37. "no dedicated app for reading them without opening a code editor" (direct competitor)
- URL: https://www.reddit.com/r/macapps/comments/1rhwmmz/os_pixley_reader_read_the_markdown_files_your_ai/
- Date: 2026-03-01, r/macapps
- Quote: "AI coding tools dump specs, docs, and changelogs into your project folders, but there's no dedicated app for reading them without opening a code editor." "VS Code buries markdown among source files and its preview pane fights for editor space."
- Need: Seshat's exact wedge, stated by a competitor (Pixley Reader, free, open source, Mac App Store). VENDOR.
- Engagement: 26 upvotes, 32 comments
- Pain: READING

### 38. "the 'ai writes, you read' workflow is definitely becoming a thing" (comment on #37)
- URL: https://www.reddit.com/r/macapps/comments/1rhwmmz/ (comment t1_o82pi6n, u/Responsible-Job1455)
- Date: 2026-03-01, r/macapps
- Quote: "for the live reload - does it handle rapid successive updates well? some ai tools write in bursts and i've seen other preview tools struggle with that" "any plans for mermaid diagram support? that's showing up more in ai-generated docs"
- Need: live reload that survives burst writes; Mermaid; prefers Mac App Store over "random dmg downloads".
- Engagement: 4 upvotes
- Pain: READING

### 39. COUNTER-SIGNAL: a plain text editor is enough for some (comment on #37)
- URL: https://www.reddit.com/r/macapps/comments/1rhwmmz/ (comment t1_o82oiet, u/Sidze)
- Date: 2026-03-01, r/macapps
- Quote: "I use Coteditor for that. Reads and creates txt, md, json, css, everything I need."
- Need: none; reply asks "Does coteeditor give you markdown preview?" (it does not render).
- Engagement: 2 upvotes
- Pain: READING (negative evidence)

### 40. ViewMD: "overkill when I just want to quickly review documentation that Claude/ChatGPT spat out"
- URL: https://www.reddit.com/r/macapps/comments/1qki0f5/viewmd_a_viewonly_markdown_reader_i_built_for/
- Date: 2026-01-23, r/macapps (also posted to r/ClaudeAI: https://www.reddit.com/r/ClaudeAI/comments/1qkhw9h/)
- Quote: "I kept opening Markdown files in full editors just to read them, these are overkill when I just want to quickly review documentation that Claude/ChatGPT spat out. I wanted something that would just render the file beautifully and get out of the way."
- Need: view-only, renders Mermaid/LaTeX, default .md handler, $5.99 one-time. VENDOR, direct competitor.
- Engagement: 7 upvotes, 23 comments (r/ClaudeAI copy: 1 upvote, 10 comments)
- Pain: READING

### 41. Live-reloading viewer beside the terminal (Linux)
- URL: https://www.reddit.com/r/ClaudeAI/comments/1s54dmy/simple_tool_that_made_my_claude_code_workflow/
- Date: 2026-03-27, r/ClaudeAI
- Quote: "I got tired of switching to VS Code just to read them, so I built a lightweight viewer that stays open alongside my terminal." "VS Code preview requires the file to be open in the editor. md-viewer watches any file independently."
- Need: reader that watches files Claude writes, independent of the editor. VENDOR (open source).
- Engagement: 1 upvote, 4 comments
- Pain: READING

### 42. Claude's .md files on iPhone are raw text
- URL: https://www.reddit.com/r/ClaudeAI/comments/1ujfbsw/i_built_a_free_ios_app_to_read_the_markdown_files/
- Date: 2026-06-30, r/ClaudeAI
- Quote: "On a Mac that's fine, but open one on your iPhone and iOS just shows raw text with no rendering. It bugged me enough that I made a small, free viewer specifically for this."
- Need: mobile reading of AI markdown (a share link solves this without an app). VENDOR.
- Engagement: 0 upvotes, 6 comments
- Pain: READING

### 43. "why can't I just read this on my phone", and Mermaid does not render on GitHub mobile
- URL: https://www.reddit.com/r/Markdown/comments/1upe3x3/markdown_with_mermaid_diagrams_the_instant_you/
- Date: 2026-07-06, r/Markdown
- Quote: "GitHub's mobile web view doesn't render Mermaid, and most markdown viewer apps I found don't either."
- Need: Mermaid rendering wherever the doc is read. VENDOR.
- Engagement: 2 upvotes, 6 comments
- Pain: READING

### 44. "quite a few Markdown viewers are popping up lately" (category is hot)
- URL: https://www.reddit.com/r/macapps/comments/1uyno3w/mdv_a_clean_markdown_viewer_for_mac_from_the/
- Date: 2026-07-17, r/macapps
- Quote: "Since quite a few Markdown viewers are popping up lately, I wanted to bring attention to this one, from a dev we trust."
- Need: trust and provenance matter in a crowded category; MDV (free) ships a CLI, TOC sidebar, file watcher, Quick Look extension. Non-vendor post.
- Engagement: 70 upvotes, 26 comments
- Pain: READING

### 45. Telescopo: "generic cross-platform editors or full note-taking systems"
- URL: https://www.reddit.com/r/macapps/comments/1tqchj9/telescopo_7_free_native_markdown_viewer_now_with/
- Date: 2026-05-28, r/macapps
- Quote: "A lot of Markdown tools either feel like generic cross-platform editors or full note-taking systems. I wanted a Mac-first app that makes Markdown beautiful to view, practical to edit, and easier to start from structured templates instead of a blank page."
- Need: native Mac reading. Pricing signal: free viewer, $49.99 one-time "Studio" (PDF export, iCloud Sync, Mermaid, live monitoring of AI-updated files). VENDOR.
- Engagement: 14 upvotes, 40 comments
- Pain: READING

### 46. Read a folder of docs like a little website
- URL: https://www.reddit.com/r/Markdown/comments/1uxzq67/markdownblaze_a_free_offline_markdown_viewer_that/
- Date: 2026-07-16, r/Markdown
- Quote: "You point it at a .md file and it renders a clean, readable document with a sidebar and navigation." "Click a link to another .md file and it opens in-app - so a folder of docs behaves like a wiki"
- Need: folder browsing, outline sidebar, auto-refresh, local images inline. VENDOR (open source, cross-platform).
- Engagement: 110 upvotes, 25 comments
- Pain: READING

### 47. Markdown that "looks good by default"
- URL: https://www.reddit.com/r/selfhosted/comments/1upxfsd/ive_been_building_a_selfhosted_markdown_knowledge/
- Date: 2026-07-07, r/selfhosted
- Quote: "The original goal hasn't changed though: I wanted Markdown documents to look good by default, without spending time formatting them afterwards."
- Need: typography as the product. VENDOR (Alexandrie).
- Engagement: 69 upvotes, 29 comments
- Pain: READING

---

## C. Writing / export pains (adjacent)

### 48. Writers want professional output templates from markdown
- URL: https://www.reddit.com/r/CraftDocs/comments/1tyb8zo/from_markdown_to_stylised_docx_and_pdf/
- Date: 2026-06-06, r/CraftDocs
- Quote: "The one thing a writer needs is markdown output to certain professional templates in .docx and .pdf"
- Need: styled export; the complaint is that using a second app just to style output "makes no sense".
- Engagement: 14 upvotes, 7 comments
- Pain: WRITING

### 49. ChatGPT cannot hand over a clean .md file
- URL: https://www.reddit.com/r/ChatGPT/comments/1ritdy9/how_to_make_chatgpt_get_me_a_usable_copypaste_md/
- Date: 2026-03-02, r/ChatGPT
- Quote: "Let's say I want it to generate a README.MD and it prints out text that I cannot simply copy-paste"
- Need: getting AI markdown out intact (upstream of Seshat).
- Engagement: 0 upvotes, 6 comments
- Pain: WRITING

### 50. Doc sprawl from agents: 150 files, 70 percent dead
- URL: https://www.reddit.com/r/ClaudeCode/comments/1vztrja/i_spent_months_blaming_the_model_the_bugs_were_in/
- Date: 2026-08-27, r/ClaudeCode
- Quote: "I started like everyone: one CLAUDE.md, a couple of skills, 10 files. Magic! Everything I added worked, so I kept adding. Skills, agents, context docs, plans. At some point I crossed 150 files."
- Need: volume of agent-written markdown is real; managing it (a library) is a felt problem.
- Engagement: 3 upvotes, 34 comments
- Pain: READING (adjacent)

---

## Summary

### Top 8 needs, ranked by independent sources (people, not posts; vendor posts counted but noted)

1. **"Give me a readable link for this one .md file", not a site, a repo, or a PDF.** 10 independent sources: #1, #6 (vendor), #9, #12, #13, #21, #22 (vendor), #23 (vendor), #25 (vendor), #27 (vendor). Five are plain users asking for help, which is the strongest signal in this lane.
2. **The recipient is non-technical or does not use my tool, and must not need an account or a viewer.** 9 sources: #1, #2, #4, #12, #14, #19, #20, #21, #32.
3. **The link must update in place when the source changes.** 7 sources: #1, #3, #12, #16, #21, #23 (vendor admitting the gap), #9 (built it as a feature).
4. **PDF is the incumbent and it hurts: page breaks, cut-off elements, no revisions.** 7 sources: #1, #3, #10 (30 upvotes, top comment), #11, #19, #21, #29. Seshat Share's first competitor is "Export as PDF".
5. **Private, password-protected, or short-lived links.** 8 sources: #8, #9, #13, #15, #20, #26 (vendor), #27 (vendor), #28 (vendor). Strong support for the private/password/expiring feature.
6. **Reading AI-generated markdown outside the editor (dedicated reader, live reload, Mermaid).** 10 sources: #34, #36, #37, #38, #40, #41, #42, #44, #45, #46. Mostly vendor posts; at least six Mac viewers launched in the last 8 months (Pixley, ViewMD, MDV, Telescopo, MarkdownBlaze, md-viewer). The reader category is crowded and mostly free.
7. **Mermaid and diagrams must render everywhere the doc is read or shared.** 7 sources: #1, #23, #38, #40, #41, #42, #43.
8. **Publish a folder as a small site for a team that does not use your tool.** 6 sources: #14, #16, #17, #18 (474 upvotes), #28, #46.

Weak or absent signals for the candidate paid features:
- **Custom domain**: 2 mentions, both vendor feature lists (#24, #28). No user asked for it.
- **View stats**: 0 mentions across all 20 searches and 5 comment threads.
- **Library sync across Macs**: 0 direct requests; Telescopo sells iCloud sync as a paid upgrade (#45) and the Git post (#18) shows the technical crowd solves sync themselves.
- **Image hosting**: 3 indirect mentions (#16 "Supports images", #46 local images inline, #33 screenshot paste pain). Real but nobody framed it as a share problem.
- **Free tier quota**: no data either way. Pricing anchors seen: ViewMD $5.99 one-time, Telescopo Studio $49.99 one-time, Flowershow and mdto.page free, Obsidian Publish implicitly "too much for one note".

Counter-signals to carry forward:
- #7: an 8.5k-user markdown editor added public links and fewer than 10 people used them. INFERRED: the share button must sit next to a doc that already exists on disk (AI output), not inside a writing surface.
- #35: the most upvoted reaction to "tired of reading specs" is "why should I read it at all". Reading comfort alone is not a purchase reason; skimmability and the handoff are.
- #39: some people are fine with a plain text editor.

### Queries tried
Monid tikhub (all RELEVANCE unless noted): "share markdown link" (TOP, noise), "subreddit:ObsidianMD publish alternative share note", "\"share markdown\" link" (comments), "subreddit:macapps markdown viewer reader", "subreddit:ClaudeAI markdown files read viewer render", "subreddit:ChatGPT markdown output share formatting copy paste", "subreddit:Notion share page public link", "subreddit:selfhosted publish markdown share link simple", "subreddit:Markdown share publish link viewer" (all time), "share markdown non-technical client link render", "subreddit:ClaudeCode markdown files read viewer plan.md", "\"obsidian publish\" expensive OR alternative share note" (comments), "markdown viewer mac read claude output" (comments), "markdown to pdf client send document ugly", "subreddit:cursor OR subreddit:vscode markdown preview read plan long file", plus post-comment fetches for t3_1vu538c, t3_1sgom74, t3_1w0jpzo, t3_1u3tpkl, t3_1rhwmmz.
pullpush.io: "\"share markdown\"" (worked), "\"publish markdown\"" (worked, nothing relevant), then 429 on every later query.
WebSearch site:reddit.com and allowed_domains reddit.com: 13 queries, all returned non-Reddit results or a 400 (domain blocked for the crawler).

### Queries that came up empty
- Monid comment search "markdown viewer mac read claude output": 0 results.
- Monid "subreddit:cursor OR subreddit:vscode markdown preview read plan long file": 7 results, none relevant (r/cursor and r/vscode produced nothing usable).
- Monid "subreddit:ChatGPT ...": only one weakly relevant post (#30); r/ChatGPT does not talk about sharing markdown output as a link.
- pullpush "\"publish markdown\"": 6 results, none relevant.
- Nothing found for r/technicalwriting, r/ProductManagement, r/productivity, r/writing, r/webdev, r/programming (pullpush 429 before reaching them; Monid budget spent on higher-yield subreddits).
- No Reddit hit at all for "view stats", "analytics" on shared markdown, or "custom domain" as a user request.

### Monid calls used
20 of 20 (15 searches, 5 post-comment fetches). Approximately 0.03 USD. Raw payloads: lane1-monid-1.json through lane1-monid-20.json in this scratchpad.
