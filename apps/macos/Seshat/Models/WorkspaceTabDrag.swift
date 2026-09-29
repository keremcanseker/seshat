import CoreTransferable
import UniformTypeIdentifiers

extension UTType {
    static let seshatTab = UTType(exportedAs: "com.keremcan.seshat.tab")
}

/// Not a bare `URL`: the sidebar's `dropDestination(for: URL.self)` would move the file.
struct WorkspaceTabDrag: Codable, Transferable {
    let url: URL
    /// The pane it is dragged out of, so a drop on another pane moves it rather than copies it.
    let pane: UUID

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .seshatTab)
    }
}
