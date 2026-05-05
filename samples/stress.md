# Seshat Typography Stress Test

A stress-test document for iterating on the Seshat reader theme. Renders every common GFM construct so visual regressions show up immediately.

## Body paragraphs and inline styles

The quick brown fox jumps over the lazy dog. Reading should feel calm and unhurried — the body text uses **SF Pro Text** at sixteen points with a relaxed line-height. *Italic emphasis* should feel light, while **bold weight** should anchor without shouting. You'll occasionally encounter inline code like `String(contentsOf:)` or short identifiers such as `seshatPaper`, which should sit comfortably inside the prose without breaking the rhythm.

Long paragraphs reveal flaws. This sentence intentionally wraps across two or three lines, depending on viewport, so we can see whether the line-height and the column width work in concert. The 720pt content cap mimics the Notion narrow-column trick — wide enough to feel generous, narrow enough that the eye doesn't lose its place at the end of each line.

A second paragraph sits below with sixteen points of breathing room. Margins, not separators, do the work of structuring prose.

## Headings

### A medium third-level heading

The third-level heading uses serif at 20pt semibold — quieter than h2, but still distinctly different from body. Mixed with `code` it should still align cleanly.

#### Fourth-level — sans, semibold

We drop to sans here to signal a stylistic shift. Reserved for nested sections.

##### Fifth-level — quieter

###### SIXTH LEVEL — SMALL CAPS

The sixth level uses small-caps in muted color, intended for things like "Last updated" or category tags.

## Lists

- Plain unordered list item with reasonable line height
- Second item
- Third item with a [link inside it](https://example.com) to test underline alignment
  - Nested item that wraps the line and continues across multiple visible lines, so we can check whether the indent feels right and whether the bullet glyph is the right weight
  - Another nested item
- Back to the top level

1. Ordered item — numbers should match the body color
2. Second ordered item
3. Third — with **bold** and *italic* and `code` mixed in
   1. Nested ordered
   2. Another nested

- [ ] An unchecked task
- [x] A completed task — strikethrough and muted
- [ ] Another unchecked task with [a link](https://example.com)

## Blockquotes

> "Outside of a dog, a book is man's best friend. Inside of a dog, it's too dark to read."
>
> — Groucho Marx

A nested blockquote, just to make sure indentation doesn't compound oddly:

> The first level of quotation establishes context and uses the warm gold rule on the left.
>
> > A second-level quote inherits the same italic treatment but should still be visually distinguishable.

## Code blocks

Inline `let library = "Seshat"` sits within prose. A fenced block with a language tag follows:

```swift
import SwiftUI
import MarkdownUI

extension Theme {
    static let seshat = Theme()
        .text {
            FontFamily(.system())
            FontSize(16)
            ForegroundColor(.seshatBodyText)
        }
        .heading1 { configuration in
            configuration.label
                .markdownMargin(top: 32, bottom: 18)
                .markdownTextStyle {
                    FontFamily(.system(.serif))
                    FontWeight(.bold)
                    FontSize(36)
                }
        }
}
```

```bash
# A bash example, just in case
brew install xcodegen
cd apps/macos && xcodegen generate
open Seshat.xcodeproj
```

```
A plain code block with no language hint —
should still get the warm gray background
and monospaced font.
```

## Tables

| Element        | Font                | Size | Color           |
|----------------|---------------------|-----:|-----------------|
| Body           | SF Pro Text         | 16pt | `seshatBodyText` |
| H1             | NY (system serif)   | 36pt | `seshatHeading`  |
| H2             | NY (system serif)   | 26pt | `seshatHeading`  |
| Inline code    | SF Mono             | 14pt | `seshatCodeText` |
| Code block bg  | —                   |   —  | `seshatCodeBg`   |

## Horizontal rule

Below this line is a thematic break — should sit centered, narrow, and warm.

---

After the rule, content resumes. Spacing above and below the rule should feel deliberate.

## Links and edge cases

A bare URL: <https://github.com/gonzalezreal/swift-markdown-ui>.

A linked phrase: [the swift-markdown-ui repository](https://github.com/gonzalezreal/swift-markdown-ui) which we depend on.

A reference-style link: [Apple's Human Interface Guidelines][hig]. Reference defined at the bottom.

Footnote-style[^1] inline.

[^1]: Footnote content lives down here.

[hig]: https://developer.apple.com/design/human-interface-guidelines

## Closing

If everything above looks calm, deliberate, and pleasant to read for ten minutes straight — the theme is working. If anything yells, fights, or feels loud — that's the next thing to fix.
