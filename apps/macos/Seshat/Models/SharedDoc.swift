import Foundation

/// One row of the Shared Documents sheet: a single document (`/d/`) or a
/// folder site (`/s/`, KER-811). `isSite` is set by the loader, not the server.
struct SharedDoc: Decodable, Identifiable, Equatable, Sendable {
    let slug: String
    let title: String
    let createdAt: String?
    let updatedAt: String?
    var isSite = false

    var id: String { "\(apiPath)/\(slug)" }

    var apiPath: String { isSite ? "sites" : "docs" }

    var publicPath: String { "\(isSite ? "s" : "d")/\(slug)" }

    var publicURL: URL? {
        URL(string: "https://seshat.page/\(publicPath)")
    }
}

struct SharedDocsResponse: Decodable, Sendable {
    let documents: [SharedDoc]
}

struct SharedSitesResponse: Decodable, Sendable {
    let sites: [SharedDoc]
}
