import SwiftUI

struct WorkspaceRoot: View {
    let library: Library
    @Binding var selection: URL?

    var body: some View {
        NavigationSplitView {
            Sidebar(folders: library.folders, selection: $selection)
                .navigationSplitViewColumnWidth(min: 200, ideal: 240, max: 320)
        } detail: {
            if let selection {
                MarkdownReader(fileURL: selection)
            } else {
                EmptyDetail()
            }
        }
        .navigationSplitViewStyle(.balanced)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("Refresh", systemImage: "arrow.clockwise", action: library.refresh)
                    .help("Re-scan ~/Seshat/")
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Reveal Library", systemImage: "folder", action: revealLibrary)
                    .help("Open ~/Seshat/ in Finder")
            }
        }
    }

    private func revealLibrary() {
        NSWorkspace.shared.open(library.rootURL)
    }
}

private struct EmptyDetail: View {
    var body: some View {
        ContentUnavailableView {
            Label("No document", systemImage: "doc.text")
        } description: {
            Text("Select a file from the sidebar.")
        }
        .background(Color.seshatPaper)
    }
}
