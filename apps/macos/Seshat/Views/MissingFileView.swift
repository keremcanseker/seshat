import SwiftUI

/// Shown in the reader while an open tab's file is gone from disk.
struct MissingFileView: View {
    let url: URL

    var body: some View {
        ContentUnavailableView {
            Label("File not found", systemImage: "questionmark.folder")
        } description: {
            Text(url.path)
        }
    }
}
