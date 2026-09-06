import SwiftUI

struct WorkspaceRoot: View {
    let library: Library
    @Binding var selection: URL?
    @State private var reloadTick: Int = 0
    @State private var columns: NavigationSplitViewVisibility = .all

    @Environment(AppRouter.self) private var router
    @Environment(ReadState.self) private var readState

    var body: some View {
        NavigationSplitView(columnVisibility: $columns) {
            Sidebar(
                library: library,
                selection: $selection,
                onRefresh: refresh,
                onRevealLibrary: revealLibrary,
                onURLRenamed: handleFileURLChange,
                onItemMoved: handleFileURLChange,
                onItemDeleted: handleItemDeleted
            )
            // The system toggle jumps between the sidebar's trailing edge and the
            // detail's leading edge; ours stays put next to the traffic lights, like Linear.
            .toolbar(removing: .sidebarToggle)
            .toolbar {
                if #available(macOS 26, *) {
                    ToolbarItem(placement: .automatic) { sidebarToggle }
                        .sharedBackgroundVisibility(.hidden)
                } else {
                    ToolbarItem(placement: .automatic) { sidebarToggle }
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 260, max: 360)
        } detail: {
            if let selection {
                MarkdownReader(fileURL: selection, reloadTick: reloadTick)
            } else {
                EmptyDetail()
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onChange(of: router.workspaceRefreshTick) { _, _ in
            refresh()
        }
    }

    private var sidebarToggle: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.22)) {
                columns = columns == .detailOnly ? .all : .detailOnly
            }
        } label: {
            Label("Toggle Sidebar", systemImage: "sidebar.left")
        }
        .keyboardShortcut("s", modifiers: [.command, .control])
        .help("Toggle Sidebar (⌃⌘S)")
    }

    private func refresh() {
        library.refresh()
        reloadTick &+= 1
    }

    private func revealLibrary() {
        NSWorkspace.shared.open(library.rootURL)
    }

    private func handleFileURLChange(from oldURL: URL, to newURL: URL) {
        router.remapReaderFileURL(from: oldURL, to: newURL)
        readState.remap(from: oldURL, to: newURL)
        if selection?.seshatMatches(oldURL) == true {
            reloadTick &+= 1
        }
    }

    private func handleItemDeleted(_ url: URL) {
        router.closeReaders(for: url)
        readState.forget(url)
        if selection?.seshatMatches(url) == true {
            selection = nil
        }
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
                Text("Pick a file from the sidebar, or use `seshat open <file.md>` from the terminal.")
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
