import Foundation

struct LibraryFile: Identifiable, Equatable, Hashable, Sendable {
    let url: URL
    let name: String
    let folderName: String

    var id: URL { url }
}
