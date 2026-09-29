import SwiftUI

struct WorkspaceRoot: View {
    let library: Library
    let panes: WorkspacePanes
    @State private var reloadTick: Int = 0
    @State private var columns: NavigationSplitViewVisibility = .all
    @State private var collapsedFolders: Set<URL> = []
    @State private var revealTick: Int = 0

    @Environment(AppRouter.self) private var router
    @Environment(ReadState.self) private var readState

    /// Sidebar highlight == the focused pane's active tab. A row click opens a new tab there,
    /// ⌘-click swaps the document in the current tab, ⌥-click opens it in the pane beside
    /// (VS Code's open to the side). Arrow keys browse through one reused preview tab, so
    /// walking the list never piles up tabs. `List` writes nil on empty-area clicks; ignored,
    /// tabs close explicitly.
    private var selection: Binding<URL?> {
        Binding(
            get: { panes.focused.active },
            set: { url in
                guard let url else { return }
                let flags = NSEvent.modifierFlags
                if flags.contains(.option) {
                    panes.openToSide(url)
                } else if flags.contains(.command) {
                    panes.focused.replaceActive(with: url)
                } else {
                    panes.focused.open(url, asPreview: NSApp.currentEvent?.type == .keyDown)
                }
            }
        )
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columns) {
            Sidebar(
                library: library,
                selection: selection,
                collapsedFolders: $collapsedFolders,
                revealTick: revealTick,
                onOpenPermanently: { panes.focused.open($0) },
                onOpenToSide: { panes.openToSide($0) },
                onOpenInCurrentTab: { panes.focused.replaceActive(with: $0) },
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
                    ToolbarItemGroup(placement: .automatic) { sidebarToggle; WorkspaceTabNavButtons(tabs: panes.focused) }
                        .sharedBackgroundVisibility(.hidden)
                } else {
                    ToolbarItemGroup(placement: .automatic) { sidebarToggle; WorkspaceTabNavButtons(tabs: panes.focused) }
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 260, max: 360)
        } detail: {
            HStack(spacing: 6) {
                ForEach(panes.panes) { pane in
                    WorkspacePane(
                        pane: pane,
                        panes: panes,
                        reloadTick: reloadTick,
                        onRevealInSidebar: revealInSidebar,
                        onOpenFiles: { openFiles($0, in: pane, toSide: $1) }
                    )
                }
            }
            // View-scoped shortcuts, the ⌘F pattern; keeps nine ⌘-number items out of the menus.
            .background {
                ForEach(1...9, id: \.self) { number in
                    Button("") { panes.focused.activate(number: number) }
                        .keyboardShortcut(KeyEquivalent(Character(String(number))), modifiers: .command)
                }
                Button("") { panes.focused.activateNext() }
                    .keyboardShortcut(.tab, modifiers: .control)
                Button("") { panes.focused.activatePrevious() }
                    .keyboardShortcut(.tab, modifiers: [.control, .shift])
            }
            .padding([.leading, .bottom, .trailing], 6)   // the toolbar's own inset is the top gap
            .background(Color.seshatSidebarBg)
        }
        .navigationSplitViewStyle(.balanced)
        // The sidebar column is a translucent material, and it reaches up into the
        // titlebar: in full screen that patch reads as glass next to the flat toolbar.
        // One opaque colour across the whole toolbar removes the seam.
        .toolbarBackground(Color.seshatSidebarBg, for: .windowToolbar)
        .focusedSceneValue(\.workspacePanes, panes)
        .onChange(of: router.workspaceRefreshTick) { _, _ in
            refresh()
        }
        .onChange(of: library.folders) { _, _ in
            panes.refreshMissing()
        }
    }

    private var sidebarToggle: some View {
        Button(action: toggleSidebar) {
            Label("Toggle Sidebar", systemImage: "sidebar.left")
        }
        .keyboardShortcut("s", modifiers: [.command, .control])
        .help("Toggle Sidebar (⌃⌘S)")
    }

    private func toggleSidebar() {
        withAnimation(.easeInOut(duration: 0.22)) {
            columns = columns == .detailOnly ? .all : .detailOnly
        }
    }

    private func refresh() {
        library.refresh()
        reloadTick &+= 1
    }

    private func revealInSidebar(_ url: URL) {
        panes.focused.activate(url)
        if let folder = library.folder(containing: url) {
            collapsedFolders.remove(folder.url)
        }
        withAnimation(.easeInOut(duration: 0.22)) {
            columns = .all
        }
        revealTick &+= 1
    }

    private func revealLibrary() {
        NSWorkspace.shared.open(library.rootURL)
    }

    /// Files dropped on a pane open as permanent tabs, there or in the pane beside it. Files
    /// from outside the library are copied into its Inbox first, the same as `seshat open`.
    private func openFiles(_ urls: [URL], in pane: WorkspaceTabs, toSide: Bool) {
        let files = urls.filter { Library.markdownExtensions.contains($0.pathExtension.lowercased()) }
        guard !files.isEmpty else { return }
        for file in files {
            let url = InboxImporter.ensureInLibrary(file, libraryRoot: library.rootURL)
            if toSide {
                panes.openToSide(url, of: pane)
            } else {
                panes.focus(pane)
                pane.open(url)
            }
        }
        library.refresh()
    }

    private func handleFileURLChange(from oldURL: URL, to newURL: URL) {
        router.remapReaderFileURL(from: oldURL, to: newURL)
        readState.remap(from: oldURL, to: newURL)
        panes.remap(from: oldURL, to: newURL)
    }

    private func handleItemDeleted(_ url: URL) {
        router.closeReaders(for: url)
        readState.forget(url)
        panes.closeDeleted(url)
    }
}
