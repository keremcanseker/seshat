import Foundation

struct ParsedMarkdown: Equatable, Sendable {
    let sections: [MarkdownSection]
    let outline: [OutlineEntry]

    static let empty = ParsedMarkdown(sections: [], outline: [])
}
