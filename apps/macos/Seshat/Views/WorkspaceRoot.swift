import SwiftUI

struct WorkspaceRoot: View {
    let library: Library
    let tabs: WorkspaceTabs
    @State private var reloadTick: Int = 0
    @State private var columns: NavigationSplitViewVisibility = .all
    @State private var collapsedFolders: Set<URL> = []
    @State private var revealTick: Int = 0

    @Environment(AppRouter.self) private var router
    @Environment(ReadState.self) private var readState

    /// Sidebar highlight == active tab. A row click opens a preview tab (⌘-click a permanent
    /// one). `List` writes nil on empty-area clicks; ignored, tabs close explicitly.
    private var selection: Binding<URL?> {
        Binding(
            get: { tabs.active },
            set: { url in
                guard let url else { return }
                let permanent = NSEvent.modifierFlags.contains(.command)
                tabs.open(url, asPreview: !permanent)
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
                onOpenPermanently: { tabs.open($0) },
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
                    ToolbarItemGroup(placement: .automatic) { sidebarToggle; WorkspaceTabNavButtons(tabs: tabs) }
                        .sharedBackgroundVisibility(.hidden)
                } else {
                    ToolbarItemGroup(placement: .automatic) { sidebarToggle; WorkspaceTabNavButtons(tabs: tabs) }
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 260, max: 360)
        } detail: {
            Group {
                if let active = tabs.active {
                    MarkdownReader(fileURL: active, reloadTick: reloadTick, onRevealInSidebar: revealInSidebar)
                } else {
                    EmptyDetail()
                }
            }
            .environment(tabs)
            // Dropping a file anywhere on the page opens it as a permanent tab, same path as `seshat open`.
            .dropDestination(for: URL.self) { urls, _ in
                let files = urls.filter { Library.markdownExtensions.contains($0.pathExtension.lowercased()) }
                guard !files.isEmpty else { return false }
                router.handle(urls: files)
                return true
            }
            // View-scoped shortcuts, the ⌘F pattern; keeps nine ⌘-number items out of the menus.
            .background {
                ForEach(1...9, id: \.self) { number in
                    Button("") { tabs.activate(number: number) }
                        .keyboardShortcut(KeyEquivalent(Character(String(number))), modifiers: .command)
                }
                Button("", action: tabs.activateNext)
                    .keyboardShortcut(.tab, modifiers: .control)
                Button("", action: tabs.activatePrevious)
                    .keyboardShortcut(.tab, modifiers: [.control, .shift])
            }
            // Linear-style inset page: chrome (toolbar + sidebar) is one flat colour, the
            // document sits in a bordered card with a thin gutter. Shadow on the shape, not
            // the scroll view, so scrolling never re-rasterises the page.
            .clipShape(.rect(cornerRadius: 8))
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.seshatPaper)
                    .shadow(color: .black.opacity(0.06), radius: 3, y: 1)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.seshatRuleStrong, lineWidth: 0.5)
            }
            .padding([.leading, .bottom, .trailing], 6)   // the toolbar's own inset is the top gap
            .background(Color.seshatSidebarBg)
        }
        .navigationSplitViewStyle(.balanced)
        // The sidebar column is a translucent material, and it reaches up into the
        // titlebar: in full screen that patch reads as glass next to the flat toolbar.
        // One opaque colour across the whole toolbar removes the seam.
        .toolbarBackground(Color.seshatSidebarBg, for: .windowToolbar)
        .focusedSceneValue(\.workspaceTabs, tabs)
        .onChange(of: router.workspaceRefreshTick) { _, _ in
            refresh()
        }
        .onChange(of: library.folders) { _, _ in
            tabs.refreshMissing()
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
        tabs.activate(url)
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

    private func handleFileURLChange(from oldURL: URL, to newURL: URL) {
        router.remapReaderFileURL(from: oldURL, to: newURL)
        readState.remap(from: oldURL, to: newURL)
        tabs.remap(from: oldURL, to: newURL)
    }

    private func handleItemDeleted(_ url: URL) {
        router.closeReaders(for: url)
        readState.forget(url)
        tabs.closeDeleted(url)
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
