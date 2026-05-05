import Foundation

struct MarkdownSection: Identifiable, Equatable, Sendable {
    let id: String
    let level: Int
    let title: String?
    let content: String
}
