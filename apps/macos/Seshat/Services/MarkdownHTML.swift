import Foundation

/// Markdown → plain semantic HTML for the rich-text pasteboard (KER-814). MarkdownUI's
/// own `renderHTML` loses table cell tags, so this walks Foundation's parse instead: each
/// run's presentation-intent chain says which containers (lists, quote, table rows) it
/// sits in, and the chain diff between consecutive runs opens and closes the tags.
enum MarkdownHTML {
    static func render(_ markdown: String) -> String {
        guard let parsed = try? AttributedString(
            markdown: markdown,
            options: .init(
                allowsExtendedAttributes: true,
                interpretedSyntax: .full,
                failurePolicy: .returnPartiallyParsedIfPossible
            )
        ) else { return "<pre>\(escape(markdown))</pre>" }

        var html = ""
        var openLeaf: PresentationIntent.IntentType?
        var openContainers: [PresentationIntent.IntentType] = []   // outermost first

        for run in parsed.runs {
            let components = run.presentationIntent?.components ?? []
            guard let leaf = components.first else { continue }
            let containers = Array(components.dropFirst().reversed())

            if leaf.identity != openLeaf?.identity {
                if let openLeaf { html += tags(openLeaf, in: openContainers).close }
                let shared = zip(openContainers, containers).prefix { $0.identity == $1.identity }.count
                for container in openContainers[shared...].reversed() { html += tags(container, in: []).close }
                for container in containers[shared...] { html += tags(container, in: []).open }
                openContainers = containers
                openLeaf = leaf
                html += tags(leaf, in: containers).open
            }
            if case .thematicBreak = leaf.kind { continue }   // its text is a placeholder glyph
            html += inline(String(parsed[run.range].characters), run: run)
        }

        if let openLeaf { html += tags(openLeaf, in: openContainers).close }
        for container in openContainers.reversed() { html += tags(container, in: []).close }
        return html
    }

    private static func tags(
        _ component: PresentationIntent.IntentType, in containers: [PresentationIntent.IntentType]
    ) -> (open: String, close: String) {
        switch component.kind {
        case .paragraph: return ("<p>", "</p>\n")
        case .header(let level): return ("<h\(level)>", "</h\(level)>\n")
        case .codeBlock: return ("<pre><code>", "</code></pre>\n")
        case .thematicBreak: return ("<hr>\n", "")
        case .unorderedList: return ("<ul>\n", "</ul>\n")
        case .orderedList: return ("<ol>\n", "</ol>\n")
        case .listItem: return ("<li>", "</li>\n")
        case .blockQuote: return ("<blockquote>\n", "</blockquote>\n")
        case .table: return ("<table>\n", "</table>\n")
        case .tableHeaderRow, .tableRow: return ("<tr>", "</tr>\n")
        case .tableCell:
            let isHeader = containers.contains { $0.kind == .tableHeaderRow }
            return isHeader ? ("<th>", "</th>") : ("<td>", "</td>")
        @unknown default: return ("", "")
        }
    }

    private static func inline(_ text: String, run: AttributedString.Runs.Run) -> String {
        if let image = run.imageURL {
            return "<img src=\"\(escape(image.absoluteString))\" alt=\"\(escape(text))\">"
        }
        let intent = run.inlinePresentationIntent ?? []
        if intent.contains(.lineBreak) { return "<br>\n" }

        var html = escape(text)
        if intent.contains(.code) { html = "<code>\(html)</code>" }
        if intent.contains(.stronglyEmphasized) { html = "<strong>\(html)</strong>" }
        if intent.contains(.emphasized) { html = "<em>\(html)</em>" }
        if intent.contains(.strikethrough) { html = "<del>\(html)</del>" }
        if let link = run.link { html = "<a href=\"\(escape(link.absoluteString))\">\(html)</a>" }
        return html
    }

    private static func escape(_ text: String) -> String {
        text.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }
}
