import AppKit
import MarkdownUI
import SwiftUI

struct MarkdownReader: View {
    let fileURL: URL
    var reloadTick: Int = 0

    @State private var parsed: ParsedMarkdown = .empty
    @State private var rawContent: String = ""
    @State private var loadError: Error?
    @State private var showOutline: Bool = true
    @State private var available: CGSize = .zero
    @State private var scrolledSectionId: String?
    @State private var isSharing: Bool = false
    @State private var toast: ShareToast?
    @State private var showSearch: Bool = false
    @State private var searchQuery: String = ""
    @State private var searchMatches: [String] = []
    @State private var currentMatch: Int = 0
    @FocusState private var searchFocused: Bool
    @State private var isEditing: Bool = false
    @State private var editingSectionId: String?
    @State private var sectionDrafts: [String: String] = [:]
    @State private var activeDraft: String = ""
    @FocusState private var editorFocused: Bool
    @State private var loadedModificationDate: Date?
    @State private var showConflictAlert: Bool = false
    @State private var conflictRemoteContent: String = ""
    @State private var showSharedDocs: Bool = false
    @AppStorage("seshatAppearance") private var appearance: AppearanceMode = .light
    @Environment(AuthStore.self) private var authStore

    private static let outlineMinWidth: CGFloat = 1080

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 28) {
                if let loadError {
                    ReaderErrorView(error: loadError)
                } else {
                    ForEach(parsed.sections) { section in
                        sectionView(section)
                    }
                }
            }
            .scrollTargetLayout()
            .padding(.horizontal, 32)
            .padding(.vertical, 64)
            .frame(maxWidth: Seshat.contentWidth, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .scrollPosition(id: $scrolledSectionId, anchor: .top)
        .background(Color.seshatPaper)
        .background {
            GeometryReader { geo in
                Color.clear
                    .onChange(of: geo.size, initial: true) { _, newSize in
                        available = newSize
                    }
            }
        }
        .overlay(alignment: .topTrailing) {
            if outlineVisible {
                MarkdownOutline(
                    entries: parsed.outline,
                    activeId: scrolledSectionId
                ) { entry in
                    withAnimation(.easeOut(duration: 0.28)) {
                        scrolledSectionId = entry.id
                    }
                }
                .frame(maxHeight: max(available.height - 48, 200))
                .padding(.top, 24)
                .padding(.trailing, 24)
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .overlay(alignment: .top) {
            if let toast {
                ShareToastView(toast: toast)
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .overlay(alignment: .topTrailing) {
            if showSearch {
                ReaderSearchBar(
                    query: $searchQuery,
                    matchCount: searchMatches.count,
                    currentIndex: currentMatch,
                    focus: $searchFocused,
                    onNext: { advanceMatch(by: 1) },
                    onPrevious: { advanceMatch(by: -1) },
                    onClose: closeSearch
                )
                .padding(.top, 16)
                .padding(.trailing, 16)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background {
            Button("", action: toggleSearch)
                .keyboardShortcut("f", modifiers: .command)
                .hidden()
        }
        .onChange(of: searchQuery) { _, _ in recomputeMatches() }
        .onChange(of: parsed) { _, _ in recomputeMatches() }
        .onExitCommand {
            if showSearch { closeSearch() }
        }
        .alert("This file changed on disk", isPresented: $showConflictAlert) {
            Button("Keep My Version", role: .destructive) { overwriteConflict() }
            Button("Reload from Disk") { reloadFromDisk() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("“\(fileURL.lastPathComponent)” was modified by another app since you opened it. Keeping your version overwrites those changes.")
        }
        .sheet(isPresented: $showSharedDocs) {
            SharedDocsView()
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                HStack(spacing: 6) {
                    Image(systemName: "folder")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(Color.seshatFaint)
                    Text(breadcrumb)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(Color.seshatFaint)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .textSelection(.enabled)
                }
                .help(fileURL.path)
            }
            ToolbarItem(placement: .primaryAction) {
                Toggle(isOn: $showOutline.animation(.easeInOut(duration: 0.22))) {
                    Label("Outline", systemImage: "list.bullet.indent")
                }
                .toggleStyle(.button)
                .disabled(parsed.outline.isEmpty || available.width < Self.outlineMinWidth)
                .help(outlineToggleHelp)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        appearance = appearance.toggled
                    }
                } label: {
                    Image(systemName: appearance.nextSymbol)
                        .symbolRenderingMode(.hierarchical)
                }
                .help(appearance.nextLabel)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { toggleEdit() }
                } label: {
                    Label(isEditing ? "Done" : "Edit", systemImage: isEditing ? "checkmark.circle" : "square.and.pencil")
                }
                .toggleStyle(.button)
                .keyboardShortcut("e", modifiers: .command)
                .disabled(loadError != nil)
                .help(isEditing ? "Finish editing (⌘E)" : "Edit this document (⌘E)")
            }
            if isEditing || isDirty {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        Task { await save() }
                    } label: {
                        Label("Save", systemImage: "tray.and.arrow.down")
                    }
                    .keyboardShortcut("s", modifiers: .command)
                    .disabled(!isDirty && editingSectionId == nil)
                    .help("Save (⌘S)")
                }
            }
            if authStore.isAuthenticated {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { Task { await share() } }) {
                        if isSharing {
                            ProgressView()
                                .controlSize(.small)
                                .progressViewStyle(.circular)
                        } else {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                    .disabled(isSharing || loadError != nil || rawContent.isEmpty)
                    .help("Publish to seshat.page and copy the link")
                }
                ToolbarItem(placement: .primaryAction) {
                    UserMenu(onShowSharedDocs: { showSharedDocs = true })
                }
            }
        }
        .task(id: ReaderLoadKey(url: fileURL, tick: reloadTick)) {
            await load()
        }
        .onChange(of: toast) { _, newValue in
            guard newValue != nil else { return }
            Task {
                try? await Task.sleep(for: .seconds(3.5))
                withAnimation(.easeInOut(duration: 0.25)) {
                    if toast == newValue { toast = nil }
                }
            }
        }
    }

    private var outlineVisible: Bool {
        showOutline
            && !parsed.outline.isEmpty
            && available.width >= Self.outlineMinWidth
    }

    private var breadcrumb: String {
        let path = fileURL.path
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        if path.hasPrefix(home + "/") {
            return "~\(path.dropFirst(home.count))"
        }
        return path
    }

    private var outlineToggleHelp: String {
        if parsed.outline.isEmpty { return "No headings to show" }
        if available.width < Self.outlineMinWidth { return "Window too narrow for outline" }
        return showOutline ? "Hide outline" : "Show outline"
    }

    @ViewBuilder
    private func sectionView(_ section: MarkdownSection) -> some View {
        let content = sectionDrafts[section.id] ?? section.content
        if isEditing, editingSectionId == section.id {
            TextField("", text: $activeDraft, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 16))
                .foregroundStyle(Color.seshatBodyText)
                .lineSpacing(6)
                .focused($editorFocused)
                .id(section.id)
        } else if isEditing {
            // No .textSelection here — it captures the click at the AppKit level
            // and the tap-to-edit never fires.
            EditableBlock(content: content) { beginEditing(section) }
                .id(section.id)
        } else {
            Markdown(content)
                .markdownTheme(.seshat)
                .textSelection(.enabled)
                .id(section.id)
        }
    }

    private func toggleEdit() {
        if isEditing {
            commitActiveEdit()
            isEditing = false
        } else {
            isEditing = true
        }
    }

    private func beginEditing(_ section: MarkdownSection) {
        commitActiveEdit()
        editingSectionId = section.id
        activeDraft = sectionDrafts[section.id] ?? section.content
        editorFocused = true
    }

    private func commitActiveEdit() {
        guard let id = editingSectionId else { return }
        let original = parsed.sections.first { $0.id == id }?.content ?? ""
        if activeDraft == original {
            sectionDrafts.removeValue(forKey: id)
        } else {
            sectionDrafts[id] = activeDraft
        }
        editingSectionId = nil
    }

    private var isDirty: Bool { !sectionDrafts.isEmpty }

    private func reconstructedContent() -> String {
        parsed.sections.map { sectionDrafts[$0.id] ?? $0.content }.joined(separator: "\n")
    }

    private func save() async {
        commitActiveEdit()
        guard isDirty else { return }
        let newContent = reconstructedContent()
        do {
            let outcome = try DocumentWriter.write(
                newContent,
                to: fileURL,
                expecting: loadedModificationDate
            )
            switch outcome {
            case .wrote(let date):
                applySaved(content: newContent, modificationDate: date)
                present(toast: .init(kind: .success, message: "Saved"))
            case .externalChange(let remote):
                conflictRemoteContent = remote
                showConflictAlert = true
            }
        } catch {
            present(toast: .init(kind: .failure, message: "Couldn't save — \(error.localizedDescription)"))
        }
    }

    private func applySaved(content: String, modificationDate: Date?) {
        rawContent = content
        parsed = MarkdownParser.parse(content)
        sectionDrafts = [:]
        editingSectionId = nil
        loadedModificationDate = modificationDate
    }

    private func overwriteConflict() {
        let newContent = reconstructedContent()
        do {
            try DocumentWriter.write(newContent, to: fileURL, expecting: nil)
            applySaved(content: newContent, modificationDate: DocumentWriter.modificationDate(of: fileURL))
            present(toast: .init(kind: .success, message: "Saved (overwrote external changes)"))
        } catch {
            present(toast: .init(kind: .failure, message: "Couldn't save — \(error.localizedDescription)"))
        }
    }

    private func reloadFromDisk() {
        applySaved(content: conflictRemoteContent, modificationDate: DocumentWriter.modificationDate(of: fileURL))
        present(toast: .init(kind: .success, message: "Reloaded from disk"))
    }

    private func load() async {
        do {
            let raw = try String(contentsOf: fileURL, encoding: .utf8)
            rawContent = raw
            parsed = MarkdownParser.parse(raw)
            loadError = nil
            loadedModificationDate = DocumentWriter.modificationDate(of: fileURL)
            sectionDrafts = [:]
            editingSectionId = nil
            isEditing = false
        } catch {
            rawContent = ""
            loadError = error
        }
    }

    private func share() async {
        guard !isSharing else { return }
        let title = fileURL.deletingPathExtension().lastPathComponent
        let content = isDirty ? reconstructedContent() : rawContent
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else {
            present(toast: .init(kind: .failure, message: "Nothing to share — file is empty."))
            return
        }
        isSharing = true
        defer { isSharing = false }
        do {
            let (response, wasUpdate) = try await publish(title: title, content: content)
            ShareStore.setSlug(response.slug, for: fileURL)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(response.url, forType: .string)
            present(toast: .init(
                kind: .success,
                message: "\(wasUpdate ? "Link updated" : "Link copied") · \(response.url)",
                openURL: URL(string: response.url)
            ))
        } catch APIError.unauthorized {
            present(toast: .init(kind: .failure, message: "Session expired — please sign in again."))
        } catch {
            present(toast: .init(kind: .failure, message: error.localizedDescription))
        }
    }

    /// Updates the existing document if this file was shared before (PUT), else
    /// creates a new one (POST). Falls back to POST if the remembered doc is gone.
    private func publish(title: String, content: String) async throws -> (CreateDocResponse, Bool) {
        let body = CreateDocBody(title: title, content: content)
        if let slug = ShareStore.slug(for: fileURL) {
            do {
                let response: CreateDocResponse = try await authStore.api.put("docs/\(slug)", body: body)
                return (response, true)
            } catch APIError.server(let status, _) where status == 404 {
                ShareStore.removeSlug(for: fileURL)
            }
        }
        let response: CreateDocResponse = try await authStore.api.post("docs", body: body)
        return (response, false)
    }

    private func present(toast next: ShareToast) {
        withAnimation(.easeInOut(duration: 0.25)) {
            toast = next
        }
    }

    private func toggleSearch() {
        if showSearch {
            closeSearch()
        } else {
            withAnimation(.easeOut(duration: 0.18)) { showSearch = true }
            searchFocused = true
        }
    }

    private func closeSearch() {
        withAnimation(.easeOut(duration: 0.18)) { showSearch = false }
        searchQuery = ""
        searchMatches = []
        currentMatch = 0
        searchFocused = false
    }

    private func recomputeMatches() {
        let needle = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard showSearch, needle.count >= 1 else {
            searchMatches = []
            currentMatch = 0
            return
        }
        var matches: [String] = []
        for section in parsed.sections {
            let occurrences = section.content.ranges(
                of: needle,
                options: [.caseInsensitive, .diacriticInsensitive]
            ).count
            matches.append(contentsOf: Array(repeating: section.id, count: occurrences))
        }
        searchMatches = matches
        currentMatch = 0
        scrollToCurrentMatch()
    }

    private func advanceMatch(by delta: Int) {
        guard !searchMatches.isEmpty else { return }
        let count = searchMatches.count
        currentMatch = ((currentMatch + delta) % count + count) % count
        scrollToCurrentMatch()
    }

    private func scrollToCurrentMatch() {
        guard searchMatches.indices.contains(currentMatch) else { return }
        let id = searchMatches[currentMatch]
        withAnimation(.easeOut(duration: 0.28)) {
            scrolledSectionId = id
        }
    }
}

private extension String {
    func ranges(
        of substring: String,
        options: String.CompareOptions
    ) -> [Range<String.Index>] {
        var result: [Range<String.Index>] = []
        var start = startIndex
        while let range = range(of: substring, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound > range.lowerBound ? range.upperBound : index(after: range.lowerBound)
            if start >= endIndex { break }
        }
        return result
    }
}

private struct ReaderLoadKey: Hashable {
    let url: URL
    let tick: Int
}

/// A rendered section that, in edit mode, is a click target. Renders with the
/// normal theme (no text selection, so the click reaches us) and shows only a text
/// cursor on hover — no block highlight, so editing feels direct rather than
/// block-based. Tapping swaps it for the source editor in place.
private struct EditableBlock: View {
    let content: String
    let onTap: () -> Void

    var body: some View {
        Markdown(content)
            .markdownTheme(.seshat)
            .contentShape(Rectangle())
            .onContinuousHover { phase in
                switch phase {
                case .active: NSCursor.iBeam.set()
                case .ended: NSCursor.arrow.set()
                }
            }
            .onTapGesture(perform: onTap)
    }
}

private struct ReaderErrorView: View {
    let error: Error

    var body: some View {
        ContentUnavailableView {
            Label("Couldn't read file", systemImage: "exclamationmark.triangle")
        } description: {
            Text(error.localizedDescription)
        }
    }
}

private struct UserMenu: View {
    let onShowSharedDocs: () -> Void
    @Environment(AuthStore.self) private var authStore

    var body: some View {
        Menu {
            if let user = authStore.currentUser {
                Text(user.name ?? user.email)
                    .font(.system(size: 12, weight: .medium))
                Text(user.email)
                    .font(.system(size: 11))
                Divider()
            }
            Button("My Shared Documents…", action: onShowSharedDocs)
            Divider()
            Button("Sign Out", role: .destructive, action: authStore.signOut)
        } label: {
            Image(systemName: "person.crop.circle")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 14))
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .fixedSize()
        .help(authStore.currentUser?.email ?? "Account")
    }
}

private struct ShareToast: Identifiable, Equatable {
    let id = UUID()
    let kind: Kind
    let message: String
    var openURL: URL? = nil

    enum Kind { case success, failure }
}

private struct ShareToastView: View {
    let toast: ShareToast

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: toast.kind == .success ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundStyle(toast.kind == .success ? Color.seshatAccent : Color.red.opacity(0.85))
            Text(toast.message)
                .font(.system(size: 13))
                .foregroundStyle(Color.seshatBodyText)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            if let url = toast.openURL {
                Button("Open") { NSWorkspace.shared.open(url) }
                    .buttonStyle(.borderless)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.seshatAccent)
                    .help("Open in browser")
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.seshatPaper)
                .shadow(color: .black.opacity(0.18), radius: 14, y: 6)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.seshatRule, lineWidth: 0.5)
        }
        .frame(maxWidth: 520)
    }
}
