import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct Sidebar: View {
    let library: Library
    @Binding var selection: URL?
    @Binding var collapsedFolders: Set<URL>   // ponytail: in-memory; persist if people keep re-collapsing after launch
    var revealTick: Int = 0                   // bumped to scroll the selected row into view
    /// New file and import open a permanent tab instead of reusing the preview. (A double-click
    /// gesture on rows would swallow `List`'s single-click and arrow-key selection.)
    var onOpenPermanently: (URL) -> Void = { _ in }
    @Environment(ReadState.self) private var readState
    var onRefresh: () -> Void = {}
    var onRevealLibrary: () -> Void = {}
    var onURLRenamed: (URL, URL) -> Void = { _, _ in }
    var onItemMoved: (URL, URL) -> Void = { _, _ in }
    var onItemDeleted: (URL) -> Void = { _ in }

    @State private var importDestinationFolderURL: URL?
    @State private var showImporter = false
    @State private var importTargetFolder: URL?
    @State private var showPickFolderBeforeImport = false
    @State private var showNewFolderAlert = false
    @State private var newFolderName = ""
    @State private var showNewFileAlert = false
    @State private var newFileName = ""
    @State private var newFileTargetFolder: URL?
    @State private var showRenameAlert = false
    @State private var renameDraft = ""
    @State private var renameTarget: SidebarRenameTarget?
    @State private var showErrorAlert = false
    @State private var showDeleteAlert = false
    @State private var deleteTarget: SidebarDeleteTarget?

    var body: some View {
        VStack(spacing: 0) {
            SidebarExplorerHeader(
                folders: library.folders,
                importDestination: $importDestinationFolderURL,
                onNewFile: presentNewFileFromToolbar,
                onNewFolder: presentNewFolder,
                onImport: presentImportFromToolbar,
                onRefresh: onRefresh,
                onReveal: onRevealLibrary
            )

            Group {
                if library.folders.isEmpty {
                    EmptySidebar()
                } else {
                    libraryList
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.seshatSidebarBg)
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: Self.markdownTypes,
            allowsMultipleSelection: true
        ) { result in
            handleImportResult(result)
        }
        .fileDialogMessage(importDialogMessage)
        .fileDialogConfirmationLabel("Import")
        .alert("New Folder", isPresented: $showNewFolderAlert) {
            TextField("Folder name", text: $newFolderName)
            Button("Cancel", role: .cancel) {
                newFolderName = ""
            }
            Button("Create") {
                createFolder()
            }
        } message: {
            Text("Creates a workspace folder in ~/Seshat/.")
        }
        .alert("New File", isPresented: $showNewFileAlert) {
            TextField("File name", text: $newFileName)
            Button("Cancel", role: .cancel) {
                newFileName = ""
                newFileTargetFolder = nil
            }
            Button("Create") {
                createFile()
            }
        } message: {
            if let folder = newFileTargetFolder {
                Text("Creates an empty “.md” note in “\(folder.lastPathComponent)”.")
            } else {
                Text("Creates an empty “.md” note.")
            }
        }
        .alert(renameAlertTitle, isPresented: $showRenameAlert) {
            TextField("Name", text: $renameDraft)
            Button("Cancel", role: .cancel) {
                renameTarget = nil
                renameDraft = ""
            }
            Button("Rename") {
                commitRename()
            }
        }
        .alert(deleteAlertTitle, isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
                deleteTarget = nil
            }
            Button("Move to Trash", role: .destructive) {
                if let deleteTarget {
                    commitDelete(deleteTarget)
                }
            }
        } message: {
            if let deleteTarget {
                Text(deleteAlertMessage(for: deleteTarget))
            }
        }
        .alert("Couldn’t complete action", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {
                library.clearLastError()
            }
        } message: {
            if let error = library.lastError {
                Text(error.localizedDescription)
            }
        }
        .onChange(of: library.lastError) { _, error in
            showErrorAlert = error != nil
        }
        .onChange(of: library.folders) { _, _ in
            syncImportDestination()
        }
        .onChange(of: selection) { _, url in
            syncImportDestination(fromFile: url)
        }
        .onAppear {
            syncImportDestination()
        }
        .sheet(isPresented: $showPickFolderBeforeImport) {
            ImportFolderPickerSheet(
                folders: library.folders,
                selection: $importDestinationFolderURL,
                onImport: { folderURL in
                    importDestinationFolderURL = folderURL
                    showPickFolderBeforeImport = false
                    presentImport(into: folderURL)
                },
                onCancel: {
                    showPickFolderBeforeImport = false
                }
            )
        }
    }

    private var libraryList: some View {
        ScrollViewReader { proxy in
            List(selection: $selection) {
                ForEach(library.folders) { folder in
                    FolderSection(
                        folder: folder,
                        isImportDestination: importDestinationFolderURL?.seshatMatches(folder.url) == true,
                        onSelectAsDestination: { importDestinationFolderURL = folder.url },
                        onDrop: { urls in handleDrop(urls, into: folder) },
                        onNewFileHere: { presentNewFile(into: folder.url) },
                        onImportHere: { presentImport(into: folder.url) },
                        onRenameFolder: { presentRename(folder: folder) },
                        onRevealFolder: { revealInFinder(folder.url) },
                        onDeleteFolder: { presentDelete(folder: folder) },
                        isExpanded: isExpanded(folder)
                    ) {
                        ForEach(folder.files) { file in
                            SidebarFileRow(file: file)
                                .tag(file.url)
                                .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                                .listRowSeparator(.hidden)
                                .listRowBackground(rowBackground(isSelected: selection?.seshatMatches(file.url) == true))
                                .draggable(file.url) {
                                    FileDragPreview(name: file.name)
                                }
                                .contextMenu {
                                    fileContextMenu(file: file, currentFolder: folder)
                                }
                        }
                    }
                }
            }
            .onChange(of: revealTick) { _, _ in
                guard let selection else { return }
                Task { @MainActor in   // next run loop turn, so a just-expanded folder has its rows
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo(selection, anchor: .center)
                    }
                }
            }
        }
        // .sidebar pins rows to the system source-list height (32pt on macOS 26);
        // .plain sizes rows from content, which is how we get Linear's 26pt.
        .listStyle(.plain)
        .listSectionSeparator(.hidden)
        .focusEffectDisabled()   // no focus ring around the list when a row is clicked
        .scrollContentBackground(.hidden)
        .environment(\.defaultMinListRowHeight, 26)
        .dropDestination(for: URL.self) { urls, _ in
            guard let folderURL = importDestinationFolderURL,
                  let folder = library.folders.first(where: { $0.url.seshatMatches(folderURL) }) else {
                return false
            }
            handleDrop(urls, into: folder)
            return true
        }
        .contextMenu {
            Button("New File…", systemImage: "doc.badge.plus") {
                presentNewFileFromToolbar()
            }
            Button("New Folder", systemImage: "folder.badge.plus") {
                presentNewFolder()
            }
            Button("Import File…", systemImage: "square.and.arrow.down") {
                presentImportFromToolbar()
            }
        }
    }

    private func isExpanded(_ folder: LibraryFolder) -> Binding<Bool> {
        Binding(
            get: { !collapsedFolders.contains(folder.url) },
            set: { expanded in
                if expanded {
                    collapsedFolders.remove(folder.url)
                } else {
                    collapsedFolders.insert(folder.url)
                }
            }
        )
    }

    /// The system sidebar highlight is the user's accent colour (blue by default) and
    /// ignores `.tint`. An opaque row background painted over it keeps selection on-theme.
    private func rowBackground(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(isSelected ? Color.seshatAccentSoft.opacity(0.3) : .clear)
            .padding(.horizontal, 6)
            .background(Color.seshatSidebarBg)
    }

    private var deleteAlertTitle: String {
        switch deleteTarget {
        case .file: "Delete File?"
        case .folder: "Delete Folder?"
        case .none: "Delete?"
        }
    }

    private var renameAlertTitle: String {
        switch renameTarget {
        case .file: "Rename File"
        case .folder: "Rename Folder"
        case .none: "Rename"
        }
    }

    private var importDialogMessage: String {
        if let folder = importTargetFolder ?? importDestinationFolderURL {
            return "Choose markdown files to copy into “\(folder.lastPathComponent)”."
        }
        return "Choose markdown files to copy into the selected folder."
    }

    private var resolvedImportDestination: URL? {
        importTargetFolder ?? importDestinationFolderURL
    }

    @ViewBuilder
    private func fileContextMenu(file: LibraryFile, currentFolder: LibraryFolder) -> some View {
        Button("New File…", systemImage: "doc.badge.plus") {
            presentNewFile(into: currentFolder.url)
        }

        Divider()

        if readState.isRead(file.url) {
            Button("Mark as Unread", systemImage: "circle") {
                readState.markUnread(file.url)
            }
        } else {
            Button("Mark as Read", systemImage: "circle.fill") {
                readState.markRead(file.url)
            }
        }

        Button("Rename…", systemImage: "pencil") {
            presentRename(file: file)
        }

        let otherFolders = library.folders.filter { !$0.url.seshatMatches(currentFolder.url) }
        if !otherFolders.isEmpty {
            Menu("Move to Folder", systemImage: "folder") {
                ForEach(otherFolders) { destination in
                    Button(destination.name) {
                        moveFile(file, to: destination)
                    }
                }
            }
        }

        Button("Reveal in Finder", systemImage: "magnifyingglass") {
            revealInFinder(file.url)
        }

        Divider()

        Button("Delete", systemImage: "trash", role: .destructive) {
            presentDelete(file: file)
        }
    }

    private func deleteAlertMessage(for target: SidebarDeleteTarget) -> String {
        switch target {
        case .file(let file):
            "“\(file.name)” will be moved to the Trash."
        case .folder(let folder):
            "The empty folder “\(folder.name)” will be moved to the Trash."
        }
    }

    private static let markdownTypes: [UTType] = ["md", "markdown", "mdown", "mkdn"].compactMap {
        UTType(filenameExtension: $0)
    }

    private func presentNewFolder() {
        library.clearLastError()
        newFolderName = ""
        showNewFolderAlert = true
    }

    private func presentNewFile(into folder: URL) {
        library.clearLastError()
        newFileName = ""
        newFileTargetFolder = folder
        showNewFileAlert = true
    }

    private func presentNewFileFromToolbar() {
        library.clearLastError()
        guard !library.folders.isEmpty else {
            presentNewFolder()
            return
        }
        let target = importDestinationFolderURL ?? library.folders.first?.url
        guard let target else {
            presentNewFolder()
            return
        }
        presentNewFile(into: target)
    }

    private func createFile() {
        let name = newFileName
        let target = newFileTargetFolder
        newFileName = ""
        newFileTargetFolder = nil
        guard let target else { return }
        if let url = library.createFile(named: name, in: target) {
            importDestinationFolderURL = target
            onOpenPermanently(url)
        }
    }

    private func revealInFinder(_ url: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }

    private func presentImportFromToolbar() {
        library.clearLastError()
        guard !library.folders.isEmpty else {
            presentNewFolder()
            return
        }
        if importDestinationFolderURL != nil {
            presentImport(into: importDestinationFolderURL)
        } else {
            showPickFolderBeforeImport = true
        }
    }

    private func presentImport(into folder: URL?) {
        library.clearLastError()
        guard let folder else {
            showPickFolderBeforeImport = true
            return
        }
        importDestinationFolderURL = folder
        importTargetFolder = folder
        showImporter = true
    }

    private func syncImportDestination(fromFile url: URL? = nil) {
        if let url, let folder = library.folder(containing: url) {
            importDestinationFolderURL = folder.url
            return
        }
        if let current = importDestinationFolderURL,
           library.folders.contains(where: { $0.url.seshatMatches(current) }) {
            return
        }
        importDestinationFolderURL = library.folders.first?.url
    }

    private func presentRename(file: LibraryFile) {
        library.clearLastError()
        renameTarget = .file(file.url)
        renameDraft = file.name
        showRenameAlert = true
    }

    private func presentRename(folder: LibraryFolder) {
        library.clearLastError()
        renameTarget = .folder(folder.url)
        renameDraft = folder.name
        showRenameAlert = true
    }

    private func createFolder() {
        let name = newFolderName
        newFolderName = ""
        if let url = library.createFolder(named: name) {
            importDestinationFolderURL = url
        }
    }

    private func presentDelete(file: LibraryFile) {
        library.clearLastError()
        deleteTarget = .file(file)
        showDeleteAlert = true
    }

    private func presentDelete(folder: LibraryFolder) {
        library.clearLastError()
        deleteTarget = .folder(folder)
        showDeleteAlert = true
    }

    private func commitDelete(_ target: SidebarDeleteTarget) {
        let url = target.url
        deleteTarget = nil
        showDeleteAlert = false

        guard library.deleteItem(at: url) else { return }

        if importDestinationFolderURL?.seshatMatches(url) == true {
            syncImportDestination()
        }
        onItemDeleted(url)
    }

    private func moveFile(_ file: LibraryFile, to destination: LibraryFolder) {
        moveDroppedFile(from: file.url, to: destination)
    }

    private func handleDrop(_ urls: [URL], into folder: LibraryFolder) {
        library.clearLastError()
        importDestinationFolderURL = folder.url

        var externalImports: [URL] = []
        for url in urls {
            let resolved = url.seshatNormalized
            if library.isLibraryMarkdownFile(resolved) {
                moveDroppedFile(from: resolved, to: folder)
            } else if Library.markdownExtensions.contains(resolved.pathExtension.lowercased()) {
                externalImports.append(resolved)
            }
        }

        guard !externalImports.isEmpty else { return }
        library.importFiles(externalImports, into: folder.url)
        if let first = externalImports.first {
            let imported = folder.url
                .appendingPathComponent(first.lastPathComponent)
                .seshatNormalized
            if library.file(at: imported) != nil {
                onOpenPermanently(imported)
            }
        }
    }

    private func moveDroppedFile(from source: URL, to folder: LibraryFolder) {
        let oldURL = source.seshatNormalized
        guard let newURL = library.moveFile(at: oldURL, toFolder: folder.url) else {
            if library.lastError != .sameLocation {
                return
            }
            return
        }
        importDestinationFolderURL = folder.url
        onItemMoved(oldURL, newURL)   // owner remaps first, so the re-select below finds the new URL
        if selection?.seshatMatches(oldURL) == true {
            selection = newURL
        }
    }

    private func commitRename() {
        guard let target = renameTarget else { return }
        let oldURL = target.url
        let draft = renameDraft
        renameTarget = nil
        renameDraft = ""

        guard let newURL = library.renameItem(at: oldURL, to: draft) else { return }

        onURLRenamed(oldURL, newURL)
        if selection?.seshatMatches(oldURL) == true {
            selection = newURL
        }
    }

    private func handleImportResult(_ result: Result<[URL], Error>) {
        guard case .success(let urls) = result else { return }
        guard let target = resolvedImportDestination else {
            importTargetFolder = nil
            showPickFolderBeforeImport = true
            return
        }
        importTargetFolder = nil

        var scoped: [URL] = []
        var accessible: [URL] = []
        for url in urls {
            if url.startAccessingSecurityScopedResource() {
                scoped.append(url)
            }
            accessible.append(url)
        }
        library.importFiles(accessible, into: target)
        for url in scoped {
            url.stopAccessingSecurityScopedResource()
        }
        if let first = accessible.first {
            let imported = target
                .appendingPathComponent(first.lastPathComponent)
                .seshatNormalized
            if library.file(at: imported) != nil {
                onOpenPermanently(imported)
            }
        }
    }
}
