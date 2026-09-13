import Foundation

/// Markdown → Slack mrkdwn, the syntax Slack's composer renders when text is pasted
/// (KER-814). Slack has no headings or tables: headings become bold lines, tables a
/// monospaced block. Links carry their URL in parentheses because the composer does
/// not read the API-only `<url|text>` form.
enum SlackMrkdwn {
    static func render(_ markdown: String) -> String {
        guard let parsed = try? AttributedString(
            markdown: markdown,
            options: .init(
                allowsExtendedAttributes: true,
                interpretedSyntax: .full,
                failurePolicy: .returnPartiallyParsedIfPossible
            )
        ) else { return markdown }

        var renderedItems = Set<Int>()
        return join(blocks(parsed).compactMap { renderBlock($0, renderedItems: &renderedItems) })
    }

    private struct Block {
        var components: [PresentationIntent.IntentType]
        var text = ""
        var rows: [[String]] = []   // tables only
        var lastRow: Int?
        var lastCell: Int?
    }

    private struct Rendered {
        let text: String
        let isListItem: Bool
    }

    /// Runs → leaf blocks (paragraph, heading, code block, whole table…).
    private static func blocks(_ parsed: AttributedString) -> [Block] {
        var blocks: [Block] = []
        for run in parsed.runs {
            let components = run.presentationIntent?.components ?? []
            let text = String(parsed[run.range].characters)
            guard let leaf = components.first else { continue }

            if case .tableCell = leaf.kind, components.count >= 3 {
                let row = components[1], table = components[2]
                if blocks.last?.components.first?.identity != table.identity {
                    blocks.append(Block(components: Array(components[2...])))
                }
                var block = blocks.removeLast()
                if block.lastRow != row.identity {
                    block.rows.append([])
                    block.lastRow = row.identity
                }
                if block.lastCell != leaf.identity {
                    block.rows[block.rows.count - 1].append("")
                    block.lastCell = leaf.identity
                }
                block.rows[block.rows.count - 1][block.rows[block.rows.count - 1].count - 1] += text
                blocks.append(block)
            } else if blocks.last?.components.first?.identity == leaf.identity {
                blocks[blocks.count - 1].text += inline(text, run: run)
            } else {
                blocks.append(Block(components: components, text: inline(text, run: run)))
            }
        }
        return blocks
    }

    private static func inline(_ text: String, run: AttributedString.Runs.Run) -> String {
        if let image = run.imageURL { return image.absoluteString }   // Slack unfurls bare URLs
        let intent = run.inlinePresentationIntent ?? []
        if intent.contains(.lineBreak) { return "\n" }

        // Markers must touch the text they wrap; whitespace stays outside.
        let leading = text.prefix(while: \.isWhitespace)
        let trailing = text.reversed().prefix(while: \.isWhitespace)
        var core = String(text.dropFirst(leading.count).dropLast(trailing.count))
        guard !core.isEmpty else { return text }

        if intent.contains(.code) {
            core = "`\(core)`"
        } else {
            if intent.contains(.stronglyEmphasized) { core = "*\(core)*" }
            if intent.contains(.emphasized) { core = "_\(core)_" }
            if intent.contains(.strikethrough) { core = "~\(core)~" }
        }
        if let link = run.link?.absoluteString, link != core {
            core += " (\(link))"
        }
        return leading + core + String(trailing.reversed())
    }

    /// `renderedItems` remembers list items that already got their bullet or number, so a
    /// second paragraph inside an item only gets the indent.
    private static func renderBlock(_ block: Block, renderedItems: inout Set<Int>) -> Rendered? {
        guard let leaf = block.components.first else { return nil }
        var text: String
        var listItem = false

        switch leaf.kind {
        case .header:
            text = "*\(block.text)*"
        case .codeBlock:
            let code = block.text.trimmingCharacters(in: .newlines)
            text = "```\n\(code)\n```"
        case .table:
            text = "```\n\(table(block.rows))\n```"
        case .thematicBreak:
            return nil
        default:
            text = block.text
            let items = block.components.indices.filter { isListItem(block.components[$0]) }
            if let item = items.first {
                let indent = String(repeating: "    ", count: items.count - 1)
                text = indent + marker(block.components, itemIndex: item, renderedItems: &renderedItems) + text
                listItem = true
            }
        }

        if block.components.contains(where: { $0.kind == .blockQuote }) {
            text = text.split(separator: "\n", omittingEmptySubsequences: false)
                .map { "> \($0)" }
                .joined(separator: "\n")
        }
        return Rendered(text: text, isListItem: listItem)
    }

    private static func isListItem(_ component: PresentationIntent.IntentType) -> Bool {
        if case .listItem = component.kind { return true }
        return false
    }

    private static func marker(
        _ components: [PresentationIntent.IntentType], itemIndex: Int, renderedItems: inout Set<Int>
    ) -> String {
        let item = components[itemIndex]
        guard case .listItem(let ordinal) = item.kind, renderedItems.insert(item.identity).inserted else { return "  " }
        // The chain reads innermost-first: the item's own list is the next component.
        if components.indices.contains(itemIndex + 1), components[itemIndex + 1].kind == .orderedList {
            return "\(ordinal). "
        }
        return "• "
    }

    private static func table(_ rows: [[String]]) -> String {
        let columns = rows.map(\.count).max() ?? 0
        let widths = (0..<columns).map { column in
            rows.map { $0.count > column ? $0[column].count : 0 }.max() ?? 0
        }
        func line(_ row: [String]) -> String {
            (0..<columns)
                .map { column in
                    let cell = column < row.count ? row[column] : ""
                    // No trailing spaces after the last column.
                    return column == columns - 1 ? cell : cell.padding(toLength: widths[column], withPad: " ", startingAt: 0)
                }
                .joined(separator: " | ")
        }
        var lines = rows.map(line)
        if rows.count > 1 {
            lines.insert(widths.map { String(repeating: "-", count: $0) }.joined(separator: "-|-"), at: 1)
        }
        return lines.joined(separator: "\n")
    }

    /// Tight lists stay on consecutive lines; everything else is a paragraph apart.
    private static func join(_ rendered: [Rendered]) -> String {
        var out = ""
        for (index, block) in rendered.enumerated() {
            if index > 0 {
                out += block.isListItem && rendered[index - 1].isListItem ? "\n" : "\n\n"
            }
            out += block.text
        }
        return out
    }
}
