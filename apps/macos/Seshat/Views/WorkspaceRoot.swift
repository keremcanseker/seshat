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
        VStack(spacing: 18) {
            SeshatMark(lineWidth: 1.6, color: .seshatFaint)
                .frame(width: 56, height: 56)
            VStack(spacing: 8) {
                Text("No document selected")
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .foregroundStyle(Color.seshatMuted)
                Text("Pick a file from the sidebar — or use `seshat open <file.md>` from the terminal.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.seshatFaint)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 340)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.seshatPaper)
    }
}
