# Lane 6: AI-workflow demand for reading and sharing AI-generated markdown

Research date: 2026-09-06. Sources: GitHub issues API (anthropics/claude-code, openai/codex, cline/cline, google-gemini/gemini-cli, charmbracelet/glow, Aider-AI/aider), HN Algolia API, Cursor forum, OpenAI/Google/Obsidian/MindStudio community forums, dev.to, Substack, vendor blogs. Reddit was unreachable from this environment (www/old.reddit.com JSON 403, r.jina.ai proxy 403, pullpush.io empty, redlib mirrors empty, WebSearch blocks reddit.com); one Reddit quote is included second-hand via a blog that cited it and is marked as such. Lane 1 owns Reddit.

House style: em-dashes inside verbatim quotes are rendered as " - " so the file contains none; wording is otherwise exact.

Tags: READING (consuming md in terminal/IDE/desktop), SHARING (getting md to another human), WRITING (copy/export out of the tool as raw md). Engagement is reactions/points/comments as shown by the API on 2026-09-06.

---

## A. READING: the terminal and IDE are bad places to read long markdown

### F1. Claude Code CLI shows raw markdown syntax
- URL: https://github.com/anthropics/claude-code/issues/13600
- Date: 2025-12-10 (still open, +1s through 2026-08-26). Author: stagefright5
- Quote: "Currently, Claude Code CLI displays raw markdown syntax in responses. When Claude outputs formatted content, users see the literal markdown characters (`**bold**`, `# Header`, `code blocks`, etc.) rather than rendered formatting."
- Use case listed by author: "1. Plan review 2. Agent creation 3. Skill Creation 4. Rules creation"
- Need: read agent output with visual hierarchy, tables, headings.
- Engagement: 61 reactions, 13 comments.
- Tag: READING. OBSERVED.

### F2. Same thread, follow-ups (4 more independent people)
- chashamm, 2026-01-21: "Currently the raw markdown syntax makes output harder to scan quickly." https://github.com/anthropics/claude-code/issues/13600#issuecomment-3779896378
- bgoewert-seiler, 2026-08-26: "Please add heading support at least. or stop stripping `#/##/###/####` so we can identify headings" https://github.com/anthropics/claude-code/issues/13600#issuecomment-5427058273
- Bisyk, 2026-08-19: "It would be really useful and convenient to evaluate solutions at a high level" https://github.com/anthropics/claude-code/issues/13600#issuecomment-5339092499
- YoyoSaur, 2026-01-08: "A config option to use Glow, or a custom one" https://github.com/anthropics/claude-code/issues/13600#issuecomment-3725375874
- Need: headings and structure survive so long output can be skimmed.
- Tag: READING. OBSERVED.

### F3. Claude Code hard-wraps prose so it can never reflow
- URL: https://github.com/anthropics/claude-code/issues/43113
- Date: 2026-04-03. Author: jfdube
- Quote: "Because Claude Code inserts \n for word wrapping, all its output is treated as hard-wrapped and can never be reflowed"
- Need: prose that reflows to the reading surface, not fixed to a 45-column pane.
- Engagement: 66 reactions, 15 comments.
- Tag: READING. OBSERVED.

### F4. Mermaid diagrams cannot render in the terminal
- URL: https://github.com/anthropics/claude-code/issues/14375
- Date: 2025-12-17. Author: 0xroko
- Quote: "Claude Code excels at this type of tasks and outputs general Markdown summary. I also quite often prompt it to generate simple and high level ASCII diagrams." ... "diagrams often look misaligned and more importantly, give 1D feel"
- Need: architecture summaries with real diagrams; terminal is the wrong renderer.
- Engagement: 53 reactions, 19 comments.
- Tag: READING. OBSERVED.

### F5. Math does not render (two issues, 220 combined reactions)
- https://github.com/anthropics/claude-code/issues/16446 (2026-01-06, 142 reactions): "Currently 'Claude Code for VS Code' plugin does not render LaTeX."
- https://github.com/anthropics/claude-code/issues/65632 (2026-06-05, 79 reactions): "When Claude's reply contains inline math wrapped in si[ngle dollars]..." regression.
- Need: research and technical writeups with formulas need a real renderer (KaTeX) at read time.
- Tag: READING. OBSERVED.

### F6. Codex CLI: plans shown as raw markdown
- URL: https://github.com/openai/codex/issues/11329
- Date: 2026-02-10. Author: yuiti-ara
- Quote: "Codex CLI shows plan responses as raw Markdown text instead of rendered formatting."
- Need: same as F1 but on OpenAI's tool; problem is cross-vendor.
- Engagement: 1 reaction, 2 comments.
- Tag: READING. OBSERVED.

### F7. Codex CLI: pipe tables not rendered
- URL: https://github.com/openai/codex/issues/22015
- Date: 2026-05-10. Author: goolen988
- Quote: "The Codex CLI TUI renders GitHub-style Markdown pipe tables as raw Markdown text instead of a readable terminal table."
- Need: tables (the most common AI output structure) readable.
- Engagement: 4 reactions.
- Tag: READING. OBSERVED.

### F8. Codex Desktop: .md files sometimes shown raw
- URL: https://github.com/openai/codex/issues/23212
- Date: 2026-05-17. Author: danielvalon
- Quote: "Codex Desktop sometimes displays a local `.md` file as raw source text instead of using the Markdown-rendered preview" ... "I am intentionally not attaching the original file because it contained workspace/client-sensitive content"
- Need: reliable rendering of agent-written files; note the file is client-sensitive (privacy matters for any share layer).
- Engagement: 2 reactions.
- Tag: READING. OBSERVED.

### F9. Gemini CLI maintainer admits terminal tables can never be perfect
- URL: https://github.com/google-gemini/gemini-cli/issues/6499
- Date: 2025-08-18. Author: jacob314 (Gemini CLI team)
- Quote: "no solution we do for rendering markdown tables to the terminal will be perfect (truncation, ascii art limitations) so giving the users the escape hatch to view the raw output would be useful."
- Need: vendor-side acknowledgement that the terminal is a ceiling, not a fix.
- Tag: READING. OBSERVED.

### F10. HN: "why would I want raw markdown in a terminal"
- URL: https://news.ycombinator.com/item?id=47378374
- Date: 2026-03-14. Author: beemboy
- Quote: "To read the plan output of Claude code, why would I want raw markdown in a terminal when I can read the formatted output as intended in a different tool?"
- Need: a separate reading surface for plans.
- Tag: READING. OBSERVED.

### F11. Show HN Marky: "I spend more time reading markdown than code"
- URL: https://news.ycombinator.com/item?id=47795468 (repo https://github.com/GRVYDEV/marky, 275 stars)
- Date: 2026-04-16. Author: GRVYDEV. 75 points, 38 comments.
- Quote: "Whether it's plans or documentation that I've asked my agent to generate for me, it seems that I spend more time reading markdown than code. I've tried a few different solutions to make it easier to read such as Obsidian however I've found their Vault system to be quite limiting for this use case and I've found TUI solutions to not quite be as friendly to read as I've wanted"
- Follow-up (https://news.ycombinator.com/item?id=47805126): "opening a markdown file that did not live in a vault wasn't possible. Second there was not a CLI that made it easy to quickly open files"
- Need: a reader (not editor, not PKM) with a CLI to open any file. This is Seshat's exact shape.
- Tag: READING. OBSERVED.

### F12. Marky thread: 5 independent replies confirming the pain
- FailMore, 2026-04-16 (https://news.ycombinator.com/item?id=47800383): "This problem has risen to the top of many people's minds at this moment (including mine!)."
- mschulkind, 2026-04-17 (https://news.ycombinator.com/item?id=47801215): "easily see recent file that changed to help you find the 75th file your agent just wrote for you"
- sleazebreeze, 2026-04-17 (https://news.ycombinator.com/item?id=47806667): "VS codes preview of markdown files scrolls very poorly on my Mac. It jumps around and scrolls slowly through certain sections."
- msluyter, 2026-04-17 (https://news.ycombinator.com/item?id=47801418): "First class (free) printing support for rendered markdown seems like a lacuna in the overall ecosystem."
- alsetmusic, 2026-04-17 (https://news.ycombinator.com/item?id=47801737): "First thing that blocks me from adopting it is lack of ability to adjust text size."
- Need: recency/what-changed view, smooth scrolling, print, text size.
- Tag: READING. OBSERVED.

### F13. Show HN SmallDocs: "annoying to read/preview and fiddly to share/receive"
- URL: https://news.ycombinator.com/item?id=47777633
- Date: 2026-04-15. Author: FailMore. 92 points, 50 comments.
- Quote: "The more we work with command line based agents the more `.md` files are part of our daily lives. Their output is great for agents to produce, but a little bit frustrating for humans: Markdown files are slightly annoying to read/preview and fiddly to share/receive."
- Also (https://news.ycombinator.com/item?id=47822293): "I feel like we (certainly I) check my code editor way less frequently than before. Because of that (for me) easily reading/rendering Markdown files has become more of a pain than it used to be."
- Also: "The `.md` files our agents produce contain some of the most sensitive information we have (about codebases, unresolved bugs, production logs, etc.)."
- Need: read + share, with privacy. Almost verbatim the Seshat thesis.
- Tag: READING + SHARING. OBSERVED.

### F14. SmallDocs thread: search across scattered agent files
- URL: https://news.ycombinator.com/item?id=47825767
- Date: 2026-04-19. Author: saadn92
- Quote: "My actual problem with markdown isn't previewing, it's search. I've got maybe 50 .md files scattered across different project directories from AI coding sessions. Three weeks from now when I'm trying to remember where I wrote down how to fix some specific issue, grep -r is all I've got and it's terrible for this."
- Need: a library over agent-generated files with search (Seshat's ~/Seshat/ plus roadmap search).
- Tag: READING. OBSERVED.

### F15. SmallDocs thread: pushback (2 people)
- petersumskas, 2026-04-19 (https://news.ycombinator.com/item?id=47821948): "the ability to easily read the plain text version has always been the killer feature. Rendering as html is a nice bonus."
- franga2000, 2026-04-19 (https://news.ycombinator.com/item?id=47822640): "'Fiddly to send/receive'?? Just send the file like you would any other."
- Need: none; this is the counter-position (devs who are fine with raw md and attachments). Marks the segment boundary: Seshat's buyer is the person who has to hand md to non-devs.
- Tag: READING/SHARING. OBSERVED (counter-evidence).

### F16. Show HN MEVA: "most markdown apps are built for writing, not reading"
- URL: https://news.ycombinator.com/item?id=46975959
- Date: 2026-02-11. Author: ss_meva
- Quote: "I work with AI tools (Claude, ChatGPT, Copilot) daily and end up with dozens of markdown files - design docs, API specs, architecture notes, explanations. VS Code previews split your workspace, browser renderers don't watch files, and most markdown apps are built for writing, not reading."
- Need: read-only, file-watching viewer. Independent builder converging on the same product.
- Tag: READING. OBSERVED.

### F17. dev.to: "By the end of a sprint I'd have five .md files I hadn't actually read properly"
- URL: https://dev.to/arthur_teb/i-got-tired-of-reading-claude-codes-md-files-in-vs-code-so-i-built-a-native-mac-viewer-4glb
- Date: 2026-07-08. Author: Arthur (MacMD Viewer, $19.99 one-time)
- Quote: "It drops markdown files everywhere. CLAUDE.md, plan.md, architecture notes after every session, progress summaries I didn't ask for." ... "There's this constant friction between 'reading mode' and 'dev mode' that I couldn't shake."
- Reader comment (FromZeroToShip): "you didn't build an editor with a preview, you built a reader. Same reason people read books on a Kindle and not in Word."
- Need: reading mode separate from dev mode. Direct competitor evidence; also validates "reader not editor".
- Tag: READING. OBSERVED.

### F18. Vendor blog (MacMD Viewer): plan approval fatigue
- URL: https://macmdviewer.com/blog/read-claude-code-plans-mac
- Date: 2026-07-30. Vendor content, weight accordingly.
- Quote: "The plan I regret approving was four screens long and I read two of them." ... "It's hard to review a multi-page plan. Making matters worse, if you give it feedback, it would respond with a whole new version of the multi-page plan."
- Workarounds listed: Ctrl+G opens plan in $EDITOR; Finder QuickLook; VS Code preview (no Mermaid); Ultraplan (unstable).
- Need: sustained reading of long plans before approving.
- Tag: READING. OBSERVED (vendor).

### F19. Vendor blog (MacMD Viewer): why VS Code preview fails for agent output
- URL: https://macmdviewer.com/blog/view-ai-markdown-output-mac
- Date: 2026-05-14 (updated 2026-07-11). Vendor content.
- Quote: "The preview pane competes with editing. Cursor and VS Code split your screen between code and preview." ... "The preview doesn't survive a session. Close the editor and the preview pane closes with it."
- Need: persistent reading window independent of editor.
- Tag: READING. OBSERVED (vendor).

### F20. Vendor blog (MDHero): "Launching it just to read a note pulls in 400MB of editor"
- URL: https://mdhero.app/blogs/viewing-markdown-mac-2026/
- Date: 2026-04-22. Vendor content (MDHero, free/open source).
- Quote: "Markdown used to be a developer thing. Now it's the default for READMEs, LLM output, Claude Code plans, Substack drafts, Obsidian notes, and every product spec written after 2022." ... "Quick Look shows raw text with no rendering - headings, lists, and code blocks all look the same." ... "VS Code is an IDE. Launching it just to read a note pulls in 400MB of editor, a file tree you don't want, and a title bar that says 'workspace.'"
- Need: lightweight native reader. Note: at least 6 Mac viewers launched Jan-Aug 2026 (Marky, MEVA, MacMD Viewer, MDHero, MarkViewer, Glimpse, mdreader, cwmarkdown, Smackdown, QuickLookMD): crowded on READING alone.
- Tag: READING. OBSERVED (vendor).

### F21. Anthropic (Thariq Shihipar): "difficult to read a markdown file of more than a hundred lines"
- URL: https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html (HN: https://news.ycombinator.com/item?id=48071940, 528 points, 274 comments)
- Date: 2026-05-08 (X article), 2026-05-20 (blog). Author: Thariq Shihipar, Claude Code team.
- Quotes: "I find it difficult to read a markdown file of more than a hundred lines." ... "Markdown files are fairly hard to share since most browsers do not render them natively well." ... "You often have to add them as attachments to emails or messages." ... "I certainly am not able to get anyone else in my organization to read it" ... "The chance of someone actually reading your spec, report, or PR writeup is much higher if it's in HTML." ... "As long as you upload the HTML file, you can share the link easily."
- Need: the single strongest statement of both Seshat problems from the vendor itself. His fix (HTML + upload to S3/R2) is the workaround Seshat Share replaces with one button.
- Tag: READING + SHARING. OBSERVED.

### F22. HN thread on F21: counter-argument, markdown must stay co-editable
- URL: https://news.ycombinator.com/item?id=48072400
- Date: 2026-05-09. Author: tmhrtly
- Quote: "My concern here is that by gravitating to HTML you lose the ability for a human (you!) to easily co-author the document with the LLM." ... "With a HTML doc it is much harder to do that than with MD."
- Also drob518 (https://news.ycombinator.com/item?id=48072393): "Previously, I've had a bias against HTML because it's annoying to read in a text editor."
- Also Kwpolska (https://news.ycombinator.com/item?id=48072368): "the Claude Code VS Code plugin opens plans in preview mode."
- Need: keep the source as markdown, render it beautifully. Seshat's position exactly (md source, HTML-quality reading and link).
- Tag: READING. OBSERVED.

### F23. HN thread on F21: current reading workaround stack
- URL: https://news.ycombinator.com/item?id=48072214
- Date: 2026-05-09. Author: alsetmusic
- Quote: "This is why I read long agent output either by using VIM and MacOS Quicklook (with a markdown extension for rendering) or paste output into MarkEdit (an editor with a preview pane; I think it's cross platform?). Worst case, have an agent build you a simple local web page that interprets Markdown and renders it."
- Need: a first-class reader so nobody has to vibe-code their own.
- Tag: READING. OBSERVED.

### F24. HN thread on F21: sharing HTML by dropping on a shared server; wanting read analytics
- rsolva, 2026-05-09 (https://news.ycombinator.com/item?id=48073056): "I just drop it on my personal ~ folder on the shared server at work and voilà, everyone can check it out and use it immediately!"
- ar_turnbull, 2026-05-09 (https://news.ycombinator.com/item?id=48072197): "I can add super lightweight analytics so I know who actually reads my things or interacts with my prototypes."
- Need: a link others can open with zero setup; evidence for view stats as a paid feature.
- Tag: SHARING. OBSERVED.

### F25. Cursor forum: cannot read plan in markdown mode (8 replies, 4 confirmations)
- URL: https://forum.cursor.com/t/cant-view-plan-on-markdown-mode/136853
- Date: 2025-10-09. Author: jorda0mega
- Quote: "Whenever I generate a plan through plan mode and it creates a [plan].md I am unable to read the plan if it is in markdown mode."
- Tre, 2025-10-29: "With the release of Cursor 2.x today, I can finally see the plans!"
- Need: reading the plan file is the blocking step of the workflow.
- Tag: READING. OBSERVED.

### F26. Cursor forum: plan preview crashes; Mermaid and tables break
- https://forum.cursor.com/t/plan-mode-markdown-file-cant-be-previewed/140762 (2025-11-03, Boling_Fun, 9 replies): "Plan preview crashed"; master3395: "50% of the time, it just says 'cannot open file'"
- https://forum.cursor.com/t/cursor-markdown-rendering-formatting-tables-mermaid/147558 (2025-12-29, davecotter): "Mermaid diagram code blocks are not rendering as visual diagrams in Cursor's markdown preview mode." and "Properly formatted markdown tables are automatically collapsed into a single line when the file is saved, making them unreadable."
- https://forum.cursor.com/t/markdown-file-woes/147088 (2025-12-23, Robert_Burdett): "Markdown files created or modified by AI agents ... cause Cursor to either: Fail to open ... [or] Open but display as blank"
- Need: IDE preview is fragile precisely for agent-written files.
- Tag: READING. OBSERVED.

### F27. HN: the plan file is the artefact / the deliverable
- vidarh, 2026-02-15 (https://news.ycombinator.com/item?id=47021389): "start by asking the model to plan out the changes and write a markdown file with a plan first (I prefer this over e.g. Claude Code's plan mode, because I like to keep that artefact)"
- hombre_fatal, 2026-03-20 (https://news.ycombinator.com/item?id=47455670): "see the 'plan file' as the deliverable that you're polishing over implementation."
- bobjordan, 2026-01-19 (https://news.ycombinator.com/item?id=46674404): "I spend a long time producing FSD (functional specification documents) to exhaustively plan out new features or architecture changes. I'll pass those docs back and forth between gemini, codex/chatgpt-pro, and claude."
- Need: long-lived markdown documents that get re-read and passed around; a library, not a scrollback.
- Tag: READING. OBSERVED.

### F28. Plannotator (251 stars) and Ultraplan: the market already built browser plan review
- Plannotator (VERIFICATION NOTE 2026-09-06: lane originally said 251 stars; GitHub API shows about 8,488): https://github.com/backnotprop/plannotator ; review site quote (https://vibecodinghub.org/tools/plannotator): "plans and diffs are too often approved from cramped terminal text with weak review ergonomics and lots of hand-wavy trust." Paid "Workspaces" tier "coming soon" for "shared plans, review history".
- Ultraplan (Anthropic): https://claudelog.com/faqs/what-is-ultraplan-in-claude-code/ : "the terminal is the worst place to do it because you're scrolling through a wall of plan output with only follow-up messages as your review tool." Removed from Claude Code 2026-08-04.
- Need: read + annotate + share plans in a browser. Anthropic shipped and pulled a web plan surface; a gap reopened in Aug 2026.
- Tag: READING + SHARING. OBSERVED.

### F29. Claude Code: annotate arbitrary long-form markdown, not just plans
- URL: https://github.com/anthropics/claude-code/issues/82643
- Date: 2026-07-30. Author: melissarobertson1119
- Quote: "a long-form document (e.g., a Method-section draft, a design doc, a research writeup) evolves over a long session through many rounds of feedback." ... "A general 'annotate this file' mode ... would remove a lot of friction for iterative document work that isn't code implementation planning (specs, research writeups, decision records, etc.)."
- Need: research writeups and decision records are the documents; editing/commenting on a rendered view.
- Tag: READING + WRITING. OBSERVED.

### F30. glow used as a Claude Code hook renderer, and its limits
- https://github.com/charmbracelet/glow/issues/968 (2026-06-01, TommyLike, 8 reactions): "I am using glow as a markdown renderer embedded within Claude Code" ... "glow detects that stdout is not a terminal and degrades its output, producing uncolored, poorly formatted text."
- https://news.ycombinator.com/item?id=49546673 (2026-09-03, cjcj, mdflow): "Most terminal Markdown renderers, such as glow and mdcat, buffer the entire document before rendering. This makes them poorly suited to live LLM output"
- https://news.ycombinator.com/item?id=48402462 (2026-06-04, RivoLink, leaf): "I used glow before creating leaf, and the more I used it, the more I found myself wanting features like a persistent TOC, search, watch mode, and mouse support."
- Need: people are bolting glow onto agents; they want TOC, watch, search. Terminal renderers hit a ceiling.
- Tag: READING. OBSERVED.

### F31. Non-developer with AI tools: "Word doesn't support Markdown. At all."
- URL: https://blog.steveendow.com/2025/11/working-with-markdown-md-files-in-age.html
- Date: 2025-11-22. Author: Steve Endow (Dynamics GP consultant)
- Quote: "Word doesn't support Markdown. At all. It can't read Markdown. It can't save as Markdown." Tried Typora ("super clean, but not as feature rich"), settled on Markdown Monster to convert to PDF for colleagues.
- Need: non-dev professionals now receive .md from AI and have no reader; they convert to PDF to share.
- Tag: READING + SHARING. OBSERVED.

### F32. Enterprise chat: .md attachments render as plain text
- URL: https://help.zoho.com/portal/en/community/topic/feature-request-render-markdown-md-files-in-zoho-cliq
- Date: 2025-2026 (page undated). Poster unnamed.
- Quote: "When we open these files in Cliq, the content does not render as Markdown - it displays as plain text." ... "forces us to copy/paste the content into an external Markdown viewer to read it properly."
- Need: attaching .md to chat fails for recipients; a link that renders is the fix.
- Tag: SHARING. OBSERVED.

### F33. VS Code chat panel readability (font) requests
- https://github.com/anthropics/claude-code/issues/11651 (2025-11-14, 100 reactions): "the Claude VSCode extension seems to use it own font-family and font-size settings"
- https://github.com/anthropics/claude-code/issues/34196 (2026-03-13, 84 reactions): "The chat panel uses a font size that is smaller than the editor font"
- Need: typography matters to people reading long agent output; 184 reactions on font alone.
- Tag: READING. OBSERVED.

---

## B. WRITING/COPY: getting clean markdown out of the agent

### F34. "it's not possible to copy the raw markdown output"
- URL: https://github.com/anthropics/claude-code/issues/859
- Date: 2025-04-24 (shipped as /copy in v2.1.20, confirmed by bcherny 2026-08-17). Author: mtaran
- Quote: "Claude generates proper markdown, which is rendered nicely in the terminal. But then it's not possible to copy the raw markdown output. Instead you have to ask claude to write it to a file or use the gh cli to create a PR"
- Engagement: 70 reactions, 11 comments.
- Need: markdown as a portable artifact, not a screen.
- Tag: WRITING. OBSERVED.

### F35. Same thread: the "write it to a file" workaround, 3 people
- waynemsmith, 2026-01-23 (https://github.com/anthropics/claude-code/issues/859#issuecomment-3788769504): "I end up asking Claude to write to a file just to get clean output, which adds friction."
- danneu, 2026-02-27 (https://github.com/anthropics/claude-code/issues/859#issuecomment-3975731909): "after the 50th time of writing 'convert your last message to markdown and save it into `scatch/zfs-tips.md`' I finally mustered the energy to spend 5 seconds googling."
- atemate, 2025-11-13: "there's `/export` but it exports in plain text, no markdown"
- Need: people manually accumulate .md files from sessions; those files then need a home and a reader.
- Tag: WRITING. OBSERVED.

### F36. /copy request: share responses with team
- URL: https://github.com/anthropics/claude-code/issues/5512
- Date: 2025-08-10. Author: NightMachinery
- Quote: "Quickly share Claude's responses in documentation ... Share troubleshooting responses with team members"
- Engagement: 139 reactions, 26 comments.
- Follow-ups: weltonrodrigo 2025-10-20: "a lot of times I want to copy the claude message to a colleague on slack." Shadetail 2026-02-13: "the lack of any copy/share mechanism is a real pain point." markusjura 2026-01-09 built a custom /copy that does "converting to Slack message format".
- Need: the copy is for sharing, and Slack is the destination where markdown breaks.
- Tag: WRITING + SHARING. OBSERVED.

### F37. Copy/paste from terminal includes indentation and hard breaks (2 issues, 395 reactions)
- https://github.com/anthropics/claude-code/issues/18170 (2026-01-14, radrob2, 291 reactions, 134 comments): "This makes pasted content require manual cleanup to remove the formatting artifacts."
- https://github.com/anthropics/claude-code/issues/15199 (2025-12-23, pentafive, 104 reactions): "Every copy/paste requires cleanup" ... "Users have resorted to adding prompts in CLAUDE.md memory files"
- Need: the terminal is a lossy source of text; people pay tokens to work around it.
- Tag: WRITING. OBSERVED.

### F38. VS Code extension: copying loses all markdown structure
- URL: https://github.com/anthropics/claude-code/issues/54670
- Date: 2026-04-29. Author: Matt-Ebury
- Quote: "selecting text in the chat panel and pressing `Cmd+C` / `Ctrl+C` copies only the rendered visible text. All markdown formatting is lost - code fences, bullets, headings, bold/italic, links, file-path hyperlinks, tables, etc. all collapse into plain prose."
- Engagement: 37 reactions, 9 comments.
- Tag: WRITING. OBSERVED.

### F39. /export should produce .md and "Rendered HTML for sharing/viewing in browser"
- URL: https://github.com/anthropics/claude-code/issues/13714
- Date: 2025-12-11. Author: mvorpagel-gif
- Quote: "`.html` - Rendered HTML for sharing/viewing in browser" ... "Workaround: Currently requires manually renaming: `mv conversation.txt conversation.md`"
- Related: https://github.com/anthropics/claude-code/issues/2887 (2025-07-02, lycarter): "That version of the conversation would be stored in a markdown file that I could then share with my team"
- Related: https://github.com/anthropics/claude-code/issues/39587 (2026-03-26, priority "Critical - Blocking my work"): "no way to export, archive, or auto-save conversations as readable files"
- Related: https://github.com/anthropics/claude-code/issues/209 (2025-02-27, 36 reactions): wants "a running markdown document of my prompts and the full conversation history like Aider does"
- Need: sessions as shareable rendered documents.
- Tag: WRITING + SHARING. OBSERVED.

### F40. Cline: copy the analysis, not just code
- URL: https://github.com/cline/cline/issues/13
- Date: 2024-07-20. Author: iHopist
- Quote: "It would be great to be able to copy the text it generates. Not always we are looking for code, but for analysis, explanations and critique+improvements."
- Need: prose output is a first-class deliverable.
- Tag: WRITING. OBSERVED.

### F41. dev.to: auto-save Claude Code chats as markdown
- URL: https://dev.to/gregce10/built-a-cli-wrapper-that-auto-saves-your-claude-code-chats-as-markdown-files-3ld9
- Date: 2025-06-26. Author: Greg Ceccarelli
- Quote: "Claude Code is amazing but the JSONLs are gnarly."
- Need: markdown as the human-readable archive format of agent work.
- Tag: WRITING. OBSERVED.

---

## C. SHARING: getting AI markdown to a teammate, manager, or client

### F42. Substack: "good luck getting your manager to open it"
- URL: https://hannahstulberg.substack.com/p/claude-code-for-everything-draft-in-claude-code-collaborate-in-notion
- Date: 2026-01-26. Author: Hannah Stulberg. 47 likes, 11 restacks, 12+ comments.
- Quote: "I can barely read raw markdown (the plain text format Claude Code uses) myself - good luck getting your manager to open it." ... "Copy-paste into Google Docs? Now you have two versions, and any edits in Google Docs don't automatically sync back." ... "The gap between 'drafted in Claude Code' and 'ready for team input' was killing my workflow."
- Need: one source of truth that renders for non-devs and updates in place. Her fix is a 30-minute Notion MCP setup; Seshat Share is the zero-setup version.
- Tag: SHARING. OBSERVED.

### F43. dev.to: Gemini Deep Research "worst for actually using the output"
- URL: https://dev.to/bunty_shah_fac2bef694e9c9/gemini-is-the-best-ai-for-deep-research-and-the-worst-for-actually-using-the-output-453m
- Date: 2026-03-26. Author: Bunty Shah
- Quote: "All formatting gone. Bullet points become paragraph soup. Tables disappear." ... "You're either sharing a screen or copy-pasting chaos into Slack." ... "There's no native export. No 'Save as PDF.' No 'Download as Markdown.' Nothing."
- Need: a deliverable format for research reports.
- Tag: SHARING. OBSERVED.

### F44. Google Gemini community threads (titles; bodies blocked)
- https://support.google.com/gemini/thread/348490672/export-deep-research-report-without-loss (title: "Export deep research report without loss")
- https://support.google.com/gemini/thread/384844921/cannot-export-gemini-to-docs-without-losing-formatting (title: "Cannot export Gemini to Docs without losing formatting")
- https://support.google.com/docs/thread/356697768/paste-from-markdown-now-creates-unwanted-code-blocks (title: "'Paste from Markdown' now creates unwanted code blocks")
- Need: Google's own export path loses formatting. Thread bodies could not be fetched (429/JS); cite titles only.
- Tag: SHARING. OBSERVED (title-level).

### F45. HN Show: Gemini Exporter
- URL: https://news.ycombinator.com/item?id=47331366
- Date: 2026-03-11. Author: backrun
- Quote: "getting the formatted output - especially complex markdown, tables, and code blocks - into my workspace was a frustrating copy-paste exercise that often broke the formatting."
- Tag: SHARING. OBSERVED.

### F46. HN Show: ChatGPT to PDF, "the last mile"
- URL: https://news.ycombinator.com/item?id=46970531
- Date: 2026-02-11. Author: backrun (same person as F45; count once)
- Quote: "I use ChatGPT for specs, drafts, client notes, and internal docs. The annoying part was always the last mile: copy-paste, fix formatting, make it readable, then share."
- Need: named workflow: spec/draft/client note, then share.
- Tag: SHARING. OBSERVED.

### F47. HN Show: Markdown Converter Pro
- URL: https://news.ycombinator.com/item?id=42845165
- Date: 2025-01-27. Author: YuvalFatal
- Quote: "I've been dealing with a lot of AI-generated Markdown lately, and honestly, converting it to Google Docs, Word, or PDF has been a pain. Manually copying and reformatting everything was driving me nuts"
- Tag: SHARING. OBSERVED.

### F48. HN Show: Slackfmt, "half my messages come from ChatGPT or Claude"
- URL: https://news.ycombinator.com/item?id=47319011
- Date: 2026-03-10. Author: cauethenorio
- Quote: "Over the years I've spent hours fixing the formatting of Markdown content I pasted into Slack: removing stray asterisks, rebuilding links, and re-indenting nested lists. Especially in the last months where half my messages come from ChatGPT or Claude."
- Need: Slack paste breaks; a link that renders sidesteps it.
- Tag: SHARING. OBSERVED.

### F49. HN: Perplexity export "a fraudulent scam"
- URL: https://news.ycombinator.com/item?id=47186130
- Date: 2026-02-27. Author: eth0up
- Quote: "Their 'export to pdf/markdown/doc' is a fraudulent scam and I've about 50 exports that all looked fine and well at the time of export(*), but later revealed the whole beginning half of the session was omitted in the export." ... "the Perplexity UI actively prevents Select-All - Copy/Paste"
- Tag: SHARING/WRITING. OBSERVED.

### F50. HN: Notion markdown import broken for years (same person, 2 threads)
- https://news.ycombinator.com/item?id=43382252 (2025-03-16, pimeys): "The markdown import has been broken for years, and it is not easy to export your writeups for storage outside Notion" ... "We just do markdown in Linear, which you can copy and paste from an editor easily."
- Tag: SHARING. OBSERVED.

### F51. Pactify blog citing r/Notion (second-hand Reddit)
- URL: https://pactify.io/blog/how-to-export-chatgpt-to-notion-without-losing-formatting
- Date: 2026-01-31; cites r/Notion thread of 2026-01-19 (no URL given)
- Quotes (blog): "Table columns collapsed into tab-separated text" ... "Python code lost all indentation (making it syntactically invalid)". Cited Reddit: "Affected Characters... $ (dollar sign), @ (at sign), Backticks... [The code block] content gets cut off or broken."
- Tag: SHARING. OBSERVED (second-hand for the Reddit part).

### F52. Ask HN: markdown to PDF "hasn't been trivial"
- URL: https://news.ycombinator.com/item?id=45822274
- Date: 2025-11-05. Author: waleedk
- Quote: "I thought 'markdown → PDF' would be trivial in 2025. It hasn't been so far." ... "Pandoc: Powerful but requires deep LaTeX knowledge to get good results." ... "npm packages: Most produce poor typography, awkward page breaks"
- Need: typographically good rendering of AI reports; PDF path is painful.
- Tag: SHARING. OBSERVED.

### F53. OpenAI community: export Deep Research with formatting preserved
- URL: https://community.openai.com/t/exporting-deep-research-reports/1149810
- Date: 2025-03-22. Author: miggins. 5 replies.
- Quote: "I'd love a simple, built-in option that exports or downloads my entire chat conversation with formatting preserved."
- kwesi.walker, 2025-05-12: "Copy and paste doesn't retain images and links"
- Context: OpenAI shipped Deep Research PDF export May 2025; a TechRadar article covers the launch (https://www.techradar.com/computing/artificial-intelligence/this-new-chatgpt-feature-solves-the-most-annoying-thing-about-deep-research). VERIFICATION NOTE 2026-09-06: the phrase "spectacularly ugly documents" originally attributed to that article is not on the page and has been dropped.
- Tag: SHARING. OBSERVED.

### F54. OpenAI community: public link of a single reply; link dies if chat deleted
- URL: https://community.openai.com/t/get-a-public-link-of-chatgpt-reply/985795
- Date: 2024-10-20. 2 replies.
- Quote (OP): "I would like to have chatgpt to store its reply and be able to have a public link of it where I could share that reply"
- Reply (EricGT): "If you delete the conversation the link will cause an error. Conversations are currently not duplicated before sharing."
- Need: a durable link to a document, decoupled from the chat.
- Tag: SHARING. OBSERVED.

### F55. Claude share links: org-only on Team/Enterprise, attachments excluded, snapshot frozen
- URL: https://amitkoth.com/claude-share-link-not-working/
- Date: 2026-07-31 (updated 2026-08-26). Author: Amit Kothari
- Quotes (citing Anthropic docs): "Users on Team and Enterprise plans can only share chats with other members of the same organization, not publicly." ... "If you share a chat that contains an attached file, the file itself is not included in the shared snapshot and remains private." ... "All messages sent after sharing a chat will remain private by default."
- Need: a share link that is public when wanted, includes the document, and can be updated. Claude's share is a chat snapshot, not a document.
- Tag: SHARING. OBSERVED.

### F56. Share-link privacy incidents (ChatGPT Aug 2025, Claude Jul 2026)
- ChatGPT: https://www.bitdefender.com/en-us/blog/hotforsecurity/your-shared-chatgpt-chats-may-be-publicly-searchable-heres-how-to-delete-them (shared chats indexed by Google; OpenAI removed discoverability)
- Claude: https://www.neowin.net/news/your-claude-conversations-may-have-leaked-online-if-you-did-this/ (2026-07-25 to 07-27, shared chats and published artifacts appeared in Google results)
- Need: trust in share links is damaged; private/password/expiring links and explicit noindex are table stakes.
- Tag: SHARING. OBSERVED.

### F57. MindStudio: "can only share them by sending people the link, and can't edit them"
- URL: https://community.mindstudio.ai/t/deep-research-agent-editing-downloading-output/866
- Date: 2025-05-12. Author: MitchS. 11 replies.
- Quote: "I've created a few reports using Deep Research and I'm wondering if there's a way to download them as pdf, rtf and/or MS Word files. Right now I can only share them by sending people the link, and can't edit them at all as far as I can tell."
- Ken's workaround: "download the report HTML, open it in a browser, then use 'print to PDF'"
- Tag: SHARING. OBSERVED.

### F58. Obsidian forum: "just send .md files by mail, whatsapp etc."
- URL: https://forum.obsidian.md/t/notes-sharing/85371
- Date: 2024-07-15. Author: PAV. 4 replies.
- Quote (PAV, rejecting Share Note plugin): "something simple - just send .md files by mail, whatsapp etc."
- Share Note plugin issue tracker shows the pain of a plugin-based share (large notes fail, upload errors): https://github.com/alangrainger/share-note/issues/5 , /issues/83
- Tag: SHARING. OBSERVED.

### F59. Show HN mdto.page: "without setting up a GitHub repo or configuring a static site generator"
- URL: https://news.ycombinator.com/item?id=46645942
- Date: 2026-01-16. Author: hjinco. 58 points, 31 comments.
- Quote: "I often needed a quick way to share Markdown notes or documentation as a proper webpage, without setting up a GitHub repo or configuring a static site generator."
- Thread: acrophiliac: "I'm guessing it doesn't handle images because you'd have to upload the image, right?" (author: "It doesn't support local images yet"). NamlchakKhandro: "Or just upload as gist". hjinco: "I felt like most of the current tools lack good design."
- Need: image hosting is the first thing users hit; design quality is the differentiator the builder names.
- Tag: SHARING. OBSERVED.

### F60. Show HN tmplink: "GitHub Gists require an account, pastebins don't render Markdown"
- URL: https://news.ycombinator.com/item?id=46974121
- Date: 2026-02-11. Author: ponyo877
- Quote: "I wanted a zero-friction way to share Markdown. GitHub Gists require an account, pastebins don't render Markdown, and anything else feels like overkill for content you only need for a few days."
- Tag: SHARING. OBSERVED.

### F61. MdBin: "Raw markdown looks like gibberish to most people"
- URL: https://blog.sivaramp.com/blog/introducing-mdbin/
- Date: 2025-10-15. Author: Sivaram Pandariganthan
- Quote: "there's no good way to share markdown content while preserving its formatting." ... "Messaging apps (Telegram, WhatsApp, Signal)? They squish everything together with zero control over wrapping or formatting." ... "Raw markdown looks like gibberish to most people, and I needed something that 'just works.'"
- Tag: SHARING. OBSERVED.

### F62. Markshare positioning: gist "Looks 'technical' to non-developers"
- URL: https://www.markshare.to/blog/how-to-share-markdown-online
- Date: 2026-01-09. Vendor content.
- Quote (on Gist): "Looks 'technical' to non-developers"; (on paste services): "Links may expire", "No syntax highlighting". Ships a `/markshare` Claude Code command.
- Tag: SHARING. OBSERVED (vendor).

### F63. pagebowl (HN): built "to allow users to share AI generated files easier"
- URL: https://news.ycombinator.com/item?id=48090474
- Date: 2026-05-11. Author: yuegui
- Quote: "The use case I am targeting at is: to allow users to share AI generated files easier and have a place to render and host them for a short period of time."
- Tag: SHARING. OBSERVED.

### F64. MDtoLink pricing and MCP publish (competitor benchmark)
- URL: https://mdtolink.com/
- Free: 5 documents, 7-day expiry, branding. Pro: $3/mo annual, unlimited, never expire, custom slugs, API. Publisher: $9/mo annual, custom domains, 5 team members. "Claude Code, Cursor, Windsurf, and Cline can publish documents on your behalf via MCP."
- Also plsreadme (MCP server, "no accounts"), Draftmark (inline comments, CLI `dm create -`, REST API "for AI agents"), Tot (git-backed share links, https://news.ycombinator.com/item?id=48622133).
- Need: agents publishing on your behalf (MCP/CLI) is becoming the expected entry point; $3-9/mo is the going rate, which makes $8.99/yr aggressive.
- Tag: SHARING. OBSERVED.

### F65. Unmarkdown: scale framing of the paste problem
- URL: https://unmarkdown.com/blog/the-ai-formatting-problem
- Date: updated 2026-03-02. Vendor content.
- Quote: "Tables become rows of pipe characters. Headings show up as hash marks. Bold text appears as asterisks." ... "almost none of it arrives at its destination looking the way it should" ... "The last mile from markdown to destination is where the entire workflow breaks down"
- Tag: SHARING. OBSERVED (vendor).

### F66. SmallDocs thread: branded share for clients
- URL: https://news.ycombinator.com/item?id=47790227
- Date: 2026-04-16. Author: FailMore
- Quote: "One potential use case I have for it is being able to make 'branded' markdown if you need to share something with a client/public facing."
- Need: custom domain / branding for client deliverables.
- Tag: SHARING. OBSERVED.

---

## SUMMARY

### Friction points ranked by independent-source count (people, deduplicated)

1. Agent output pasted into a rich-text destination breaks (Google Docs, Notion, Slack, Word, email, chat apps): 14 independent people. F42, F43, F45/46 (one person), F47, F48, F50, F51 (second-hand), F53 x2, F57, F58, F61, F65, F32, F31. Tables, code fences, headings, nested lists are the casualties.
2. Terminal/IDE is a poor reading surface for long markdown (raw syntax, no tables, no Mermaid/math, no reflow, preview pane fragile, plan too long to read): 13+ people plus 2 vendors. F1, F2 (4 people), F3, F4, F5, F6, F7, F9 (Gemini maintainer), F10, F11, F13, F16, F17, F21 (Anthropic), F25, F26 (3 people), F30 (3 people).
3. No clean way to get markdown out of the agent (copy loses structure, indentation artifacts, "ask it to write a file"): 9 people, 395+ reactions on two issues. F34, F35 (3), F36 (3), F37 (2), F38, F40.
4. Sharing a .md with a non-developer fails (no reader on their machine, gist looks technical, attachment renders as plain text): 8 people. F21, F31, F32, F42, F59, F60, F61, F62.
5. Chat-vendor share links are the wrong object (snapshot of a chat, not a document; dies on delete; org-only; attachments excluded; indexed by Google): 5 sources. F54, F55, F56 (2 incidents), F57.
6. PDF is the fallback and it is ugly/painful: 5 people. F31, F43, F46, F52, F57.
7. Agent files pile up and need a home with recency and search: 4 people. F14, F12 (mschulkind), F17, F35.
8. Plans are the artefact people keep and pass around; reviewing them needs a real surface: 5 people plus Plannotator (251 stars) and Ultraplan (Anthropic shipped, then removed Aug 2026). F27 (3), F28, F29, F18.
9. Images in shared markdown are the first missing feature users hit: 2 sources. F59, F53.
10. View stats / who actually read it: 1 explicit (F24 ar_turnbull), implied by F21 ("chance of someone actually reading").

### Current workaround -> what breaks (OBSERVED unless marked INFERRED)

| Workaround | What breaks | Evidence |
|---|---|---|
| Read in terminal scrollback | raw `#`/`**`, pipes, no Mermaid/KaTeX, hard-wrapped at pane width, cannot reflow | F1, F3, F4, F5, F7 OBSERVED |
| VS Code / Cursor preview pane | splits the editor, closes with session, no Mermaid without extension, scroll jank, blank/crash on agent-written files | F16, F19, F12, F25, F26 OBSERVED |
| Finder QuickLook | raw text unless you install a plugin | F20, F23 OBSERVED |
| Obsidian | file must live in a vault, no CLI open, wrong shape for transient output | F11, F19 OBSERVED |
| glow / mdcat / bat | degrades when not a TTY, buffers whole doc, no TOC/search/watch | F30 OBSERVED |
| Ask agent "write it to a file" | files scatter across repos, nobody reads them, grep is the only search | F35, F14, F17 OBSERVED |
| Ask agent for HTML, upload to S3/R2/shared server | need a bucket and a URL, HTML not co-editable, "put this in production" confusion | F21, F22, F24 OBSERVED |
| Copy from terminal / VS Code panel | leading indent, hard breaks, structure stripped | F37, F38 OBSERVED |
| Paste into Google Docs | tables become pipes, code fences literal, "Paste from Markdown" partial | F42, F44, F47 OBSERVED |
| Paste into Notion | tables/code blocks/LaTeX break, escape bugs on `$` `@` backticks, import broken | F50, F51 OBSERVED |
| Paste into Slack | double asterisks, `##` literal, nested lists flatten | F36, F48 OBSERVED |
| Attach .md to email/chat | recipient has no renderer, sees plain text, "won't open it" | F31, F32, F42, F58 OBSERVED |
| GitHub Gist | needs account, looks technical, no TOC, secret != private | F59, F60, F62 OBSERVED |
| ChatGPT / Claude share link | shares the whole chat as a chat, breaks on delete, snapshot frozen, org-only on Team, files excluded, indexed by Google | F54, F55, F56 OBSERVED |
| Export to PDF | typography poor, page breaks bad, not updatable, Perplexity/Gemini exports lossy | F52, F49, F43, F53 OBSERVED; "not updatable" INFERRED |
| Notion MCP sync from Claude Code | 30 minutes of setup, still lives in Notion | F42 OBSERVED |
| Paste into a share-markdown site (mdbin, mdto.page, markshare, MDtoLink) | no local images, 7-day expiry on free tiers, generic design, another account | F59, F64 OBSERVED; "generic design" is the builder's own claim (F59) |

### Which candidate paid features win this use case

Strong evidence:
- Image hosting: first missing feature in mdto.page thread (F59); Deep Research users cite lost images (F53). Required for research reports.
- Private / password / expiring links: sensitivity of agent files stated outright (F13, F8); two vendors' share links got indexed by Google (F56); Team/Enterprise users cannot share publicly at all (F55). Expiry is the default on 3 competitors (mdto.page, tmplink, MDtoLink free).
- Update in place with a stable URL: the core gap in every chat share link (F54 dies on delete, F55 snapshot frozen) and in the Google Docs copy (F42 "two versions"). This is the differentiator; nobody in the corpus offers "push again, same link" from a native reader.
- Free tier quota vs paid: market anchors at 5 docs / 7-day expiry free, $3-9/mo paid (F64). $8.99/yr is cheap enough to be an impulse; consider a small free quota (3-5 live links) so the first share is free.

Moderate evidence:
- View stats: one explicit ask (F24) plus Anthropic's framing that the goal is "someone actually reading" (F21). Cheap to build, good for the "did my manager open it" moment.
- Custom domain: one client-facing ask (F66) and MDtoLink's $9 tier. Lower priority.
- Publish a folder as a mini site: implied by the plans/specs/decision-records pattern (F27, F29) and Marky's folder workspaces (F11), but no one asked for it directly. Ship later.
- Library sync: no direct evidence in this lane.

### NEW features this lane suggests (not in the candidate list)

1. Agent-side publish: a `seshat share file.md` CLI and an MCP tool so Claude Code / Cursor / Cline can push a document and return the seshat.page URL. Every competitor that launched in 2026 added this (F64: MDtoLink, plsreadme, Draftmark, markshare). It also plugs directly into the "ask it to write a file" habit (F35).
2. Copy-as-Slack / copy-for-destination from the reader: 3 people built their own Slack converters (F36, F48). A "Copy for Slack / Copy for Google Docs (rich text)" button in Seshat removes the paste problem for the cases where a link is not wanted.
3. Recency view in the library ("what did the agent write in the last hour"): F12 mschulkind, F17. Sort by modified, badge new files.
4. Search across the library: F14 explicitly ("grep -r is all I've got").
5. Inline comments on the shared page: Plannotator, Draftmark, Ultraplan and CC #82643 (F28, F29, F64) all converge on annotate-then-send-back. Even a lightweight "comment on a paragraph, owner sees it in the dashboard" would beat every markdown-share competitor except Draftmark.
6. Print / PDF from the reader with good typography: F12 msluyter, F52. Seshat already has the typography; a print stylesheet is cheap and answers the PDF fallback.
7. Mermaid and KaTeX in reader and on seshat.page: repeated across F4, F5, F26, and every 2026 viewer's feature list. Table stakes for AI-generated docs; already on Seshat's roadmap.
8. Text-size control: F12 alsetmusic. Cheap, blocks adoption if missing.

### Queries that came up empty or were blocked

- Reddit entirely (r/ClaudeAI, r/ClaudeCode, r/ChatGPT, r/ChatGPTPro, r/cursor, r/vibecoding, r/ObsidianMD, r/macapps): www and old JSON endpoints 403, r.jina.ai proxy 403, pullpush.io returned empty arrays, redlib mirrors returned no results, WebSearch refuses reddit.com. Lane 1 must cover.
- GitHub search on getcursor/cursor and sst/opencode returned "Validation Failed" (repos renamed or private); cursor forum used instead.
- "claude code output to pdf" as a phrase: no direct hits; PDF pain found via Ask HN and Deep Research threads instead.
- "share claude code plan with team" as a phrase: no direct user posts; demand surfaced indirectly via Plannotator's "shared plans" paid tier and CC #2887.
- Explicit complaints that ChatGPT share links "look like a chat, not a document" or "require login": not found verbatim; the closest are F54 (dies on delete), F55 (org-only, snapshot), and markshare's "Shares the entire conversation, not just one response". Mark the "looks like a chat" framing as INFERRED.
- NotebookLM export complaints: only a third-party exporter product (LM Exporter) found, no user quotes.
- Obsidian Share Note plugin complaints: issue tracker shows upload/size failures but no 2025-2026 forum complaints.
- Discord summaries and YouTube transcripts: not searched (no free JSON path).
- Google support thread bodies (Gemini export, Docs paste): blocked by 429/JS rendering; titles only.
