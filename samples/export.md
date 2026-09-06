# Seshat PDF Export Fixture

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

# Chained headings
## Directly under the H1
Body text that must travel with both headings above it.

## A very long code block

```swift
let value1 = compute(input: 1) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value2 = compute(input: 2) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value3 = compute(input: 3) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value4 = compute(input: 4) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value5 = compute(input: 5) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value6 = compute(input: 6) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value7 = compute(input: 7) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value8 = compute(input: 8) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value9 = compute(input: 9) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value10 = compute(input: 10) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value11 = compute(input: 11) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value12 = compute(input: 12) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value13 = compute(input: 13) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value14 = compute(input: 14) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value15 = compute(input: 15) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value16 = compute(input: 16) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value17 = compute(input: 17) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value18 = compute(input: 18) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value19 = compute(input: 19) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value20 = compute(input: 20) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value21 = compute(input: 21) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value22 = compute(input: 22) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value23 = compute(input: 23) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value24 = compute(input: 24) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value25 = compute(input: 25) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value26 = compute(input: 26) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value27 = compute(input: 27) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value28 = compute(input: 28) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value29 = compute(input: 29) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value30 = compute(input: 30) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value31 = compute(input: 31) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value32 = compute(input: 32) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value33 = compute(input: 33) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value34 = compute(input: 34) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value35 = compute(input: 35) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value36 = compute(input: 36) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value37 = compute(input: 37) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value38 = compute(input: 38) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value39 = compute(input: 39) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value40 = compute(input: 40) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value41 = compute(input: 41) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value42 = compute(input: 42) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value43 = compute(input: 43) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value44 = compute(input: 44) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value45 = compute(input: 45) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value46 = compute(input: 46) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value47 = compute(input: 47) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value48 = compute(input: 48) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value49 = compute(input: 49) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value50 = compute(input: 50) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value51 = compute(input: 51) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value52 = compute(input: 52) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value53 = compute(input: 53) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value54 = compute(input: 54) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value55 = compute(input: 55) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value56 = compute(input: 56) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value57 = compute(input: 57) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value58 = compute(input: 58) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value59 = compute(input: 59) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value60 = compute(input: 60) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value61 = compute(input: 61) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value62 = compute(input: 62) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value63 = compute(input: 63) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value64 = compute(input: 64) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value65 = compute(input: 65) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value66 = compute(input: 66) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value67 = compute(input: 67) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value68 = compute(input: 68) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value69 = compute(input: 69) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value70 = compute(input: 70) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value71 = compute(input: 71) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value72 = compute(input: 72) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value73 = compute(input: 73) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value74 = compute(input: 74) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value75 = compute(input: 75) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value76 = compute(input: 76) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value77 = compute(input: 77) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value78 = compute(input: 78) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value79 = compute(input: 79) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value80 = compute(input: 80) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value81 = compute(input: 81) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value82 = compute(input: 82) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value83 = compute(input: 83) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value84 = compute(input: 84) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value85 = compute(input: 85) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value86 = compute(input: 86) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value87 = compute(input: 87) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value88 = compute(input: 88) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value89 = compute(input: 89) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value90 = compute(input: 90) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value91 = compute(input: 91) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value92 = compute(input: 92) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value93 = compute(input: 93) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value94 = compute(input: 94) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value95 = compute(input: 95) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value96 = compute(input: 96) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value97 = compute(input: 97) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value98 = compute(input: 98) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value99 = compute(input: 99) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value100 = compute(input: 100) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value101 = compute(input: 101) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value102 = compute(input: 102) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value103 = compute(input: 103) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value104 = compute(input: 104) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value105 = compute(input: 105) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value106 = compute(input: 106) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value107 = compute(input: 107) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value108 = compute(input: 108) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value109 = compute(input: 109) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value110 = compute(input: 110) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value111 = compute(input: 111) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value112 = compute(input: 112) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value113 = compute(input: 113) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value114 = compute(input: 114) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value115 = compute(input: 115) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value116 = compute(input: 116) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value117 = compute(input: 117) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value118 = compute(input: 118) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value119 = compute(input: 119) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
let value120 = compute(input: 120) // a deliberately long line that should soft-wrap inside the printed code block rather than being clipped at the column edge
```

## A tall table

| Row | Name | Value |
|----:|------|-------|
| 1 | item-1 | `v1` |
| 2 | item-2 | `v2` |
| 3 | item-3 | `v3` |
| 4 | item-4 | `v4` |
| 5 | item-5 | `v5` |
| 6 | item-6 | `v6` |
| 7 | item-7 | `v7` |
| 8 | item-8 | `v8` |
| 9 | item-9 | `v9` |
| 10 | item-10 | `v10` |
| 11 | item-11 | `v11` |
| 12 | item-12 | `v12` |
| 13 | item-13 | `v13` |
| 14 | item-14 | `v14` |
| 15 | item-15 | `v15` |
| 16 | item-16 | `v16` |
| 17 | item-17 | `v17` |
| 18 | item-18 | `v18` |
| 19 | item-19 | `v19` |
| 20 | item-20 | `v20` |
| 21 | item-21 | `v21` |
| 22 | item-22 | `v22` |
| 23 | item-23 | `v23` |
| 24 | item-24 | `v24` |
| 25 | item-25 | `v25` |
| 26 | item-26 | `v26` |
| 27 | item-27 | `v27` |
| 28 | item-28 | `v28` |
| 29 | item-29 | `v29` |
| 30 | item-30 | `v30` |
| 31 | item-31 | `v31` |
| 32 | item-32 | `v32` |
| 33 | item-33 | `v33` |
| 34 | item-34 | `v34` |
| 35 | item-35 | `v35` |
| 36 | item-36 | `v36` |
| 37 | item-37 | `v37` |
| 38 | item-38 | `v38` |
| 39 | item-39 | `v39` |
| 40 | item-40 | `v40` |
| 41 | item-41 | `v41` |
| 42 | item-42 | `v42` |
| 43 | item-43 | `v43` |
| 44 | item-44 | `v44` |
| 45 | item-45 | `v45` |
| 46 | item-46 | `v46` |
| 47 | item-47 | `v47` |
| 48 | item-48 | `v48` |
| 49 | item-49 | `v49` |
| 50 | item-50 | `v50` |
| 51 | item-51 | `v51` |
| 52 | item-52 | `v52` |
| 53 | item-53 | `v53` |
| 54 | item-54 | `v54` |
| 55 | item-55 | `v55` |
| 56 | item-56 | `v56` |
| 57 | item-57 | `v57` |
| 58 | item-58 | `v58` |
| 59 | item-59 | `v59` |
| 60 | item-60 | `v60` |
| 61 | item-61 | `v61` |
| 62 | item-62 | `v62` |
| 63 | item-63 | `v63` |
| 64 | item-64 | `v64` |
| 65 | item-65 | `v65` |
| 66 | item-66 | `v66` |
| 67 | item-67 | `v67` |
| 68 | item-68 | `v68` |
| 69 | item-69 | `v69` |
| 70 | item-70 | `v70` |

## An image

![The Seshat icon](../apps/web/src/app/apple-icon.png)

Paragraph after the image.

## Tail

Paragraph 1. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 2. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 3. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 4. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 5. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 6. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 7. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 8. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 9. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 10. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 11. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

Paragraph 12. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

