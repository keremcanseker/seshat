import Foundation

struct OutlineEntry: Identifiable, Equatable, Hashable, Sendable {
    let id: String
    let level: Int
    let title: String
}
