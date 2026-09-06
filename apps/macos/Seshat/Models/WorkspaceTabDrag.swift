import CoreTransferable
import UniformTypeIdentifiers

extension UTType {
    static let seshatTab = UTType(exportedAs: "com.keremcan.seshat.tab")
}

/// Not a bare `URL`: the sidebar's `dropDestination(for: URL.self)` would move the file.
struct WorkspaceTabDrag: Codable, Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .seshatTab)
    }
}
