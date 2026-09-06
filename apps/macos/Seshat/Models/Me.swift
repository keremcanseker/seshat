import Foundation

/// GET /me: the server's view of the signed-in account. The app never decides
/// entitlements itself; it only reads `features` and `usage` from here.
struct Me: Codable, Sendable, Equatable {
    struct Usage: Codable, Sendable, Equatable {
        let activeLinks: Int
        /// nil means unlimited.
        let limit: Int?
    }

    let plan: String
    let planStatus: String?
    let features: [String]
    let usage: Usage

    var isFree: Bool { plan == "free" }

    func has(_ feature: String) -> Bool { features.contains(feature) }
}
