import Foundation

struct LibraryFolder: Identifiable, Equatable, Hashable, Sendable {
    let url: URL
    let name: String
    let files: [LibraryFile]

    var id: URL { url }
}
