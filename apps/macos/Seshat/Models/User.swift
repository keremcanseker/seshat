import Foundation

struct User: Decodable, Sendable, Equatable, Identifiable {
    let id: String
    let email: String
    let name: String?
    let avatarUrl: String?
    let createdAt: String?
}
