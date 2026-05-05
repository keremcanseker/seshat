import Foundation

enum MarkdownParser {
    static func parse(_ source: String) -> ParsedMarkdown {
        let lines = source.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)

        struct DetectedHeading {
            let lineIndex: Int
            let level: Int
            let title: String
        }

        var headings: [DetectedHeading] = []
        var inFence = false
        var fenceMarker = ""

        for (index, raw) in lines.enumerated() {
            let trimmed = raw.trimmingCharacters(in: .whitespaces)

            if inFence {
                if trimmed.hasPrefix(fenceMarker) { inFence = false }
                continue
            }

            if trimmed.hasPrefix("```") || trimmed.hasPrefix("~~~") {
                fenceMarker = trimmed.hasPrefix("```") ? "```" : "~~~"
                inFence = true
                continue
            }

            guard let parsed = parseATXHeading(trimmed) else { continue }
            headings.append(DetectedHeading(lineIndex: index, level: parsed.level, title: parsed.title))
        }

        guard !headings.isEmpty else {
            return ParsedMarkdown(
                sections: [MarkdownSection(id: "document", level: 0, title: nil, content: source)],
                outline: []
            )
        }

        var sections: [MarkdownSection] = []
        var usedIDs: Set<String> = []

        if let first = headings.first, first.lineIndex > 0 {
            let preamble = lines[0..<first.lineIndex].joined(separator: "\n")
            if !preamble.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                sections.append(MarkdownSection(id: "preamble", level: 0, title: nil, content: preamble))
            }
        }

        for (idx, heading) in headings.enumerated() {
            let endLine = (idx + 1 < headings.count) ? headings[idx + 1].lineIndex : lines.count
            let chunk = lines[heading.lineIndex..<endLine].joined(separator: "\n")
            let id = uniqueSlug(for: heading.title, used: &usedIDs)
            sections.append(MarkdownSection(id: id, level: heading.level, title: heading.title, content: chunk))
        }

        let outline = sections.compactMap { section -> OutlineEntry? in
            guard let title = section.title else { return nil }
            return OutlineEntry(id: section.id, level: section.level, title: title)
        }

        return ParsedMarkdown(sections: sections, outline: outline)
    }

    private static func parseATXHeading(_ line: String) -> (level: Int, title: String)? {
        guard line.hasPrefix("#") else { return nil }
        var level = 0
        var iterator = line.makeIterator()
        while let char = iterator.next(), char == "#" {
            level += 1
            if level > 6 { return nil }
        }
        guard level >= 1, level <= 6 else { return nil }
        let remainder = line.dropFirst(level)
        guard let firstChar = remainder.first, firstChar == " " || firstChar == "\t" else { return nil }
        var title = remainder.drop { $0 == " " || $0 == "\t" }
        while let last = title.last, last == "#" || last == " " || last == "\t" {
            title.removeLast()
        }
        let trimmed = String(title).trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }
        return (level, trimmed)
    }

    private static func uniqueSlug(for title: String, used: inout Set<String>) -> String {
        let base = slugify(title)
        let prefix = base.isEmpty ? "section" : base
        var candidate = prefix
        var counter = 2
        while used.contains(candidate) {
            candidate = "\(prefix)-\(counter)"
            counter += 1
        }
        used.insert(candidate)
        return candidate
    }

    private static func slugify(_ text: String) -> String {
        let allowed = Set("abcdefghijklmnopqrstuvwxyz0123456789")
        var result = ""
        var lastWasDash = false
        for char in text.lowercased() {
            if allowed.contains(char) {
                result.append(char)
                lastWasDash = false
            } else if !lastWasDash && !result.isEmpty {
                result.append("-")
                lastWasDash = true
            }
        }
        if result.hasSuffix("-") { result.removeLast() }
        return result
    }
}
