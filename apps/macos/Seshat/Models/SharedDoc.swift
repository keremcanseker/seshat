import Foundation

struct SharedDoc: Decodable, Identifiable, Equatable, Sendable {
    let slug: String
    let title: String
    let createdAt: String?
    let updatedAt: String?

    var id: String { slug }

    var publicURL: URL? {
        URL(string: "https://seshat.page/d/\(slug)")
    }
}

struct SharedDocsResponse: Decodable, Sendable {
    let documents: [SharedDoc]
}
