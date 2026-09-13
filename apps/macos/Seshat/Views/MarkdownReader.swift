import AppKit
import MarkdownUI
import PDFKit
import SwiftUI

struct MarkdownReader: View {
    let fileURL: URL
    var reloadTick: Int = 0
    var onRevealInSidebar: (URL) -> Void = { _ in }

    @State private var parsed: ParsedMarkdown = .empty
    @State private var rawContent: String = ""
    @State private var loadError: Error?
    @State private var showOutline: Bool = true
    @State private var available: CGSize = .zero
    @State private var scrolledSectionId: String?
    @State private var isSharing: Bool = false
    @State private var isExporting: Bool = false
    @State private var toast: ShareToast?
    @State private var showSearch: Bool = false
    @State private var searchQuery: String = ""
    @State private var searchMatches: [String] = []
    @State private var currentMatch: Int = 0
    @FocusState private var searchFocused: Bool
    @State private var showSharedDocs: Bool = false
    @State private var premiumPrompt: PremiumSheet.Prompt?
    @State private var showSignIn: Bool = false
    @AppStorage("seshatAppearance") private var appearance: AppearanceMode = .light
    @Environment(AuthStore.self) private var authStore
    @Environment(ReadState.self) private var readState
    @Environment(WorkspaceTabs.self) private var tabs: WorkspaceTabs?   // nil outside the workspace
    @Environment(AppRouter.self) private var router

    private static let outlineMinWidth: CGFloat = 1080

    var body: some View {
        reader
        .navigationTitle("")
        .toolbar {
            // macOS 26 wraps toolbar items in glass pills; Seshat's chrome stays flat.
            if #available(macOS 26, *) {
                if let tabs {
                    ToolbarItem(placement: .navigation) { tabStrip(tabs) }
                        .sharedBackgroundVisibility(.hidden)
                }
                ToolbarItemGroup(placement: .primaryAction) { actions }
                    .sharedBackgroundVisibility(.hidden)
            } else {
                if let tabs {
                    ToolbarItem(placement: .navigation) { tabStrip(tabs) }
                }
                ToolbarItemGroup(placement: .primaryAction) { actions }
            }
        }
        .focusedSceneValue(\.exportPDF, exportAction)
        .focusedSceneValue(\.printDocument, printAction)
        .focusedSceneValue(\.copyDocument, copyAction)
        .task(id: ReaderLoadKey(url: fileURL, tick: reloadTick)) {
            await load()
        }
    }

    private func tabStrip(_ tabs: WorkspaceTabs) -> some View {
        WorkspaceTabStrip(
            tabs: tabs,
            availableWidth: available.width,
            onRevealInSidebar: onRevealInSidebar,
            onDropFiles: { router.handle(urls: $0) }   // same path as `seshat open`: Inbox copy, permanent tab
        )
    }

    private var reader: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 28) {
                if tabs?.isMissing(fileURL) == true {
                    MissingFileView(url: fileURL)
                } else if let loadError {
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
        .sheet(isPresented: $showSharedDocs) {
            SharedDocsView()
        }
        .sheet(item: $premiumPrompt) { prompt in
            PremiumSheet(prompt: prompt)
        }
        .sheet(isPresented: $showSignIn, onDismiss: shareAfterSignIn) {
            SignInView()
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

    @ViewBuilder
    private var actions: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.22)) { showOutline.toggle() }
        } label: {
            Label("Outline", systemImage: "list.bullet.indent")
                .foregroundStyle(outlineVisible ? Color.seshatAccent : Color.secondary)
        }
        .disabled(parsed.outline.isEmpty || available.width < Self.outlineMinWidth)
        .help(outlineToggleHelp)

        Button {
            withAnimation(.easeInOut(duration: 0.22)) { appearance = appearance.toggled }
        } label: {
            Label(appearance.nextLabel, systemImage: appearance.nextSymbol)
        }
        .help(appearance.nextLabel)

        Button(action: startExport) {
            if isExporting {
                ProgressView()
                    .controlSize(.small)
                    .progressViewStyle(.circular)
            } else {
                Label("Export as PDF", systemImage: "printer")
            }
        }
        .disabled(!canExport)
        .help("Export as PDF (⌘⇧E)")

        Button(action: shareTapped) {
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

        UserMenu(
            onShowSharedDocs: { showSharedDocs = true },
            onSignIn: { showSignIn = true }
        )
    }

    /// Share is always visible; a signed-out user gets the sign-in sheet and the
    /// share continues on its own once the account arrives.
    private func shareTapped() {
        if authStore.isAuthenticated {
            Task { await share() }
        } else {
            showSignIn = true
        }
    }

    private var canExport: Bool {
        !isExporting && loadError == nil && !rawContent.isEmpty
    }

    /// nil while nothing can be exported, which disables the File menu item.
    private var exportAction: (@MainActor () -> Void)? {
        canExport ? startExport : nil
    }

    private func startExport() {
        Task { await exportPDF() }
    }

    private var printAction: (@MainActor () -> Void)? {
        canExport ? startPrint : nil
    }

    private func startPrint() {
        Task { await printDocument() }
    }

    private var copyAction: (@MainActor (DocumentCopier.Format) -> Void)? {
        canExport ? copyDocument : nil
    }

    private func copyDocument(as format: DocumentCopier.Format) {
        Task {
            // Same reasoning as share(): copy what is saved on disk, not a stale render.
            await load()
            guard loadError == nil, !rawContent.isEmpty else {
                present(toast: .init(kind: .failure, message: "Couldn't read the file before copying."))
                return
            }
            DocumentCopier.copy(rawContent, as: format)
            present(toast: .init(
                kind: .success,
                message: format == .slack ? "Copied as a Slack message" : "Copied as rich text"
            ))
        }
    }

    private var outlineVisible: Bool {
        showOutline
            && !parsed.outline.isEmpty
            && available.width >= Self.outlineMinWidth
    }

    private var outlineToggleHelp: String {
        if parsed.outline.isEmpty { return "No headings to show" }
        if available.width < Self.outlineMinWidth { return "Window too narrow for outline" }
        return showOutline ? "Hide outline" : "Show outline"
    }

    @ViewBuilder
    private func sectionView(_ section: MarkdownSection) -> some View {
        SearchableSection(
            content: section.content,
            baseURL: fileURL.deletingLastPathComponent(),
            query: isSearching ? trimmedQuery : "",
            isCurrent: section.id == currentMatchSectionId
        )
        .id(section.id)
    }

    private var trimmedQuery: String {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isSearching: Bool { showSearch && !searchMatches.isEmpty }

    private var currentMatchSectionId: String? {
        searchMatches.indices.contains(currentMatch) ? searchMatches[currentMatch] : nil
    }

    private func load() async {
        do {
            let raw = try String(contentsOf: fileURL, encoding: .utf8)
            rawContent = raw
            parsed = MarkdownParser.parse(raw)
            loadError = nil
            // Opening a file is reading it; no need to scroll to the end.
            readState.markRead(fileURL)
        } catch {
            rawContent = ""
            loadError = error
        }
    }

    /// The sheet closes itself on sign-in; "Not now" leaves the user signed out.
    private func shareAfterSignIn() {
        guard authStore.isAuthenticated else { return }
        Task { await share() }
    }

    private func share() async {
        guard !isSharing else { return }
        // The file may have changed on disk since it was rendered (external editor);
        // the FSEvents watcher only refreshes the sidebar. Re-read so we publish
        // what's actually saved, and the reader catches up in the same step.
        await load()
        guard loadError == nil else {
            present(toast: .init(kind: .failure, message: "Couldn't read the file before sharing."))
            return
        }
        let content = rawContent
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else {
            present(toast: .init(kind: .failure, message: "Nothing to share, the file is empty."))
            return
        }
        isSharing = true
        defer { isSharing = false }
        do {
            let (response, wasUpdate) = try await SharePublisher.publish(
                fileURL: fileURL, content: content, api: authStore.api
            )
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(response.url, forType: .string)
            present(toast: .init(
                kind: .success,
                message: "\(wasUpdate ? "Link updated" : "Link copied") · \(response.url)",
                openURL: URL(string: response.url)
            ))
            await authStore.refreshMe()
        } catch APIError.unauthorized {
            present(toast: .init(kind: .failure, message: "Session expired. Please sign in again."))
        } catch APIError.paymentRequired(let code, let upgradeURL, _) {
            premiumPrompt = .init(code: code, upgradeURL: upgradeURL)
            await authStore.refreshMe()
        } catch {
            present(toast: .init(kind: .failure, message: error.localizedDescription))
        }
    }

    private func exportPDF() async {
        guard !isExporting else { return }
        let title = fileURL.deletingPathExtension().lastPathComponent
        // Same reasoning as share(): export what is saved on disk, not a stale render.
        await load()
        guard loadError == nil else {
            present(toast: .init(kind: .failure, message: "Couldn't read the file before exporting."))
            return
        }
        guard !rawContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            present(toast: .init(kind: .failure, message: "Nothing to export, the file is empty."))
            return
        }
        guard let choice = PDFSavePanel.run(suggestedName: "\(title).pdf") else { return }
        isExporting = true
        defer { isExporting = false }
        do {
            try await PDFExporter.export(
                parsed,
                baseURL: fileURL.deletingLastPathComponent(),
                to: choice.url,
                landscape: choice.landscape
            )
            present(toast: .init(
                kind: .success,
                message: "Exported · \(choice.url.lastPathComponent)",
                openURL: choice.url
            ))
        } catch {
            present(toast: .init(kind: .failure, message: error.localizedDescription))
        }
    }

    /// Print goes through the same PDF pipeline, so paper matches the export exactly.
    private func printDocument() async {
        guard !isExporting else { return }
        await load()
        guard loadError == nil else {
            present(toast: .init(kind: .failure, message: "Couldn't read the file before printing."))
            return
        }
        guard !rawContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            present(toast: .init(kind: .failure, message: "Nothing to print, the file is empty."))
            return
        }
        isExporting = true
        defer { isExporting = false }
        let temporary = FileManager.default.temporaryDirectory.appending(path: "\(UUID().uuidString).pdf")
        defer { try? FileManager.default.removeItem(at: temporary) }
        do {
            try await PDFExporter.export(
                parsed,
                baseURL: fileURL.deletingLastPathComponent(),
                to: temporary,
                landscape: false
            )
            guard let operation = PDFDocument(url: temporary)?
                .printOperation(for: .shared, scalingMode: .pageScaleNone, autoRotate: true)
            else { throw PDFExporter.Failure.renderFailed }
            operation.run()
        } catch {
            present(toast: .init(kind: .failure, message: error.localizedDescription))
        }
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

/// Renders a section with MarkdownUI normally. While a search is active it instead
/// renders an AttributedString (built from the markdown) so individual matched
/// words can be highlighted — MarkdownUI can't style text by content. Headings,
/// bold/italic/inline-code and links survive; code blocks, tables and list markers
/// flatten for the duration of the search.
private struct SearchableSection: View {
    let content: String
    let baseURL: URL    // resolves relative image paths against the file's folder
    let query: String   // trimmed; empty == not searching
    let isCurrent: Bool

    var body: some View {
        if query.isEmpty {
            Markdown(content, baseURL: baseURL)
                .markdownTheme(.seshat)
                .textSelection(.enabled)
        } else {
            Text(highlighted())
                .textSelection(.enabled)
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func highlighted() -> AttributedString {
        let parsed = (try? AttributedString(
            markdown: content,
            options: .init(
                allowsExtendedAttributes: true,
                interpretedSyntax: .full,
                failurePolicy: .returnPartiallyParsedIfPossible
            )
        )) ?? AttributedString(content)

        // Rebuild block-by-block, inserting paragraph breaks (the markdown
        // initializer encodes blocks as presentation intents, not newlines) and
        // sizing headings.
        var result = AttributedString()
        var lastBlock: Int?
        for run in parsed.runs {
            let intent = run.presentationIntent
            let blockID = intent?.components.first?.identity
            if let lastBlock, blockID != lastBlock {
                result += AttributedString("\n\n")
            }
            var slice = AttributedString(parsed[run.range])
            applyBlockStyle(to: &slice, intent: intent)
            result += slice
            lastBlock = blockID ?? lastBlock
        }

        applyHighlight(to: &result)
        return result
    }

    private func applyBlockStyle(to slice: inout AttributedString, intent: PresentationIntent?) {
        slice.foregroundColor = Color.seshatBodyText
        guard let intent else {
            slice.font = .system(size: 16)
            return
        }
        var headerSize: CGFloat?
        var isCode = false
        for component in intent.components {
            switch component.kind {
            case .header(let level):
                headerSize = [1: 30, 2: 23, 3: 19].first { $0.key == level }?.value ?? 17
            case .codeBlock:
                isCode = true
            default:
                break
            }
        }
        if let headerSize {
            slice.font = .system(size: headerSize, weight: .semibold, design: .serif)
            slice.foregroundColor = Color.seshatHeading
        } else if isCode {
            slice.font = .system(size: 14, design: .monospaced)
        } else {
            slice.font = .system(size: 16)
        }
    }

    private func applyHighlight(to attr: inout AttributedString) {
        let plain = String(attr.characters)
        let color = isCurrent ? Color.seshatAccent.opacity(0.6) : Color.seshatAccentSoft
        var searchRange = plain.startIndex..<plain.endIndex
        while let match = plain.range(
            of: query,
            options: [.caseInsensitive, .diacriticInsensitive],
            range: searchRange
        ) {
            let lo = plain.distance(from: plain.startIndex, to: match.lowerBound)
            let hi = plain.distance(from: plain.startIndex, to: match.upperBound)
            let chars = attr.characters
            let aLo = chars.index(chars.startIndex, offsetBy: lo)
            let aHi = chars.index(chars.startIndex, offsetBy: hi)
            attr[aLo..<aHi].backgroundColor = color
            if match.upperBound == match.lowerBound { break }
            searchRange = match.upperBound..<plain.endIndex
        }
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
    let onSignIn: () -> Void
    @Environment(AuthStore.self) private var authStore

    var body: some View {
        Menu {
            if let user = authStore.currentUser {
                Text(user.name ?? user.email)
                    .font(.system(size: 12, weight: .medium))
                Text(user.email)
                    .font(.system(size: 11))
                Divider()
                Button("My Shared Documents…", action: onShowSharedDocs)
                Divider()
                Button("Sign Out", role: .destructive, action: authStore.signOut)
            } else {
                Button("Sign In…", action: onSignIn)
            }
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
