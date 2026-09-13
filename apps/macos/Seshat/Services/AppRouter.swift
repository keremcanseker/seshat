import AppKit
import SwiftUI

@Observable
@MainActor
final class AppRouter {
    var workspaceTarget: URL?
    private(set) var workspaceRefreshTick: Int = 0
    let authStore: AuthStore

    // Pure window bookkeeping — must NOT be observation-tracked, or mutating it
    // from WindowAccessor's update callback would re-trigger a SwiftUI graph
    // update and spin into an infinite render loop (app hang).
    @ObservationIgnored private var openWindow: OpenWindowAction?
    @ObservationIgnored private var pending: [URL] = []
    @ObservationIgnored private var readerWindows: [ObjectIdentifier: ReaderEntry] = [:]
    @ObservationIgnored private var workspaceWindow: WeakWindow?

    init(authStore: AuthStore) {
        self.authStore = authStore
    }

    func bind(openWindow: OpenWindowAction) {
        guard self.openWindow == nil else { return }
        self.openWindow = openWindow
        let queued = pending
        pending.removeAll()
        seshatLog("AppRouter.bind — flushing \(queued.count) queued URL(s)")
        for url in queued { handle(url: url) }
    }

    func handle(urls: [URL]) {
        seshatLog("AppRouter.handle(urls:) count=\(urls.count) bound=\(openWindow != nil)")
        for url in urls { handle(url: url) }
    }

    func registerReader(window: NSWindow, fileURL: URL?) {
        // Called on every SwiftUI update via WindowAccessor — no-op unless the
        // window/file actually changed, so we never churn or close in a loop.
        let key = ObjectIdentifier(window)
        if let existing = readerWindows[key], existing.window.window === window,
           existing.fileURL == fileURL {
            return
        }
        readerWindows[key] = ReaderEntry(window: WeakWindow(window), fileURL: fileURL)
        seshatLog("AppRouter.registerReader — fileURL=\(fileURL?.lastPathComponent ?? "nil")")
        reconcileWindows()
    }

    func unregisterReader(window: NSWindow) {
        readerWindows.removeValue(forKey: ObjectIdentifier(window))
    }

    func registerWorkspace(window: NSWindow) {
        guard workspaceWindow?.window !== window else { return }
        workspaceWindow = WeakWindow(window)
        seshatLog("AppRouter.registerWorkspace")
        reconcileWindows()
    }

    /// The workspace ("global") window is the one and only document window.
    /// Once it exists, no standalone reader window survives beside it — opening a
    /// markdown file shows it inside the workspace, never in a second window.
    private func reconcileWindows() {
        guard workspaceWindow?.window != nil else { return }
        for (key, entry) in readerWindows {
            entry.window.window?.close()
            readerWindows.removeValue(forKey: key)
        }
    }

    func requestWorkspaceRefresh() {
        workspaceRefreshTick &+= 1
        seshatLog("AppRouter.requestWorkspaceRefresh — tick=\(workspaceRefreshTick)")
    }

    func remapReaderFileURL(from oldURL: URL, to newURL: URL) {
        let old = oldURL.seshatNormalized
        let new = newURL.seshatNormalized
        guard !old.seshatMatches(new) else { return }
        for (key, entry) in readerWindows {
            guard let fileURL = entry.fileURL, fileURL.seshatMatches(old),
                  let window = entry.window.window else { continue }
            readerWindows[key] = ReaderEntry(window: WeakWindow(window), fileURL: new)
            seshatLog("AppRouter.remapReaderFileURL — \(old.lastPathComponent) → \(new.lastPathComponent)")
        }
    }

    func closeReaders(for fileURL: URL) {
        let target = fileURL.seshatNormalized
        for (key, entry) in readerWindows {
            guard let url = entry.fileURL, url.seshatMatches(target),
                  let window = entry.window.window else { continue }
            window.close()
            readerWindows.removeValue(forKey: key)
            seshatLog("AppRouter.closeReaders — closed window for \(target.lastPathComponent)")
        }
    }

    private func handle(url: URL) {
        guard let action = SeshatURL.action(for: url) else { return }
        if case .signInCallback(let token) = action {
            authStore.handleCallback(token: token)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        if case .exportPDF(let source, let output, let landscape) = action {
            Task { await exportHeadless(source: source, to: output, landscape: landscape) }
            return
        }
        if case .share(let source, let output, let slug) = action {
            Task { await shareHeadless(source: source, to: output, slug: slug) }
            return
        }
        guard let openWindow else {
            pending.append(url)
            seshatLog("AppRouter.handle — not bound; queued: \(url)")
            return
        }
        switch action {
        case .openReader(let fileURL):
            NSDocumentController.shared.noteNewRecentDocumentURL(fileURL)
            // Always show files inside the single workspace window — never a
            // separate per-file reader window (KER-504.1 / "new things" #1).
            openInWorkspace(fileURL, openWindow: openWindow)
        case .openWorkspace(let fileURL):
            openInWorkspace(fileURL, openWindow: openWindow)
        case .signInCallback, .exportPDF, .share:
            break
        }
    }

    /// The `seshat share` path. Same contract as export: the URL lands in `output`,
    /// a failure in `<output>.error`.
    private func shareHeadless(source: URL, to output: URL, slug: String?) async {
        let errorFile = output.appendingPathExtension("error")
        do {
            guard authStore.isAuthenticated else {
                throw CocoaError(.userCancelled, userInfo: [
                    NSLocalizedDescriptionKey: "Not signed in. Open Seshat and sign in first.",
                ])
            }
            let url: String
            if source.hasDirectoryPath || (try? source.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true {
                // A folder becomes a site (KER-811); the server gates it on Premium.
                url = try await SitePublisher.publish(folderURL: source, api: authStore.api).0.url
            } else {
                let markdown = try String(contentsOf: source, encoding: .utf8)
                guard !markdown.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    throw CocoaError(.fileReadCorruptFile, userInfo: [
                        NSLocalizedDescriptionKey: "Nothing to share, the file is empty.",
                    ])
                }
                url = try await SharePublisher.publish(
                    fileURL: source, content: markdown, slug: slug, api: authStore.api
                ).0.url
            }
            try Data(url.utf8).write(to: output, options: .atomic)
            await authStore.refreshMe()
            seshatLog("AppRouter.shareHeadless — \(url)")
        } catch APIError.paymentRequired(_, let upgradeURL, let message) {
            let note = upgradeURL.map { "\(message) Upgrade at \($0.absoluteString)" } ?? message
            seshatLog("AppRouter.shareHeadless — premium required")
            try? Data(note.utf8).write(to: errorFile)
        } catch {
            seshatLog("AppRouter.shareHeadless — failed: \(error.localizedDescription)")
            try? Data(error.localizedDescription.utf8).write(to: errorFile)
        }
    }

    /// The `seshat export` path. The CLI cannot read our stderr, so a failure is
    /// left next to the requested output as `<name>.pdf.error` for it to relay.
    private func exportHeadless(source: URL, to output: URL, landscape: Bool) async {
        let errorFile = output.appendingPathExtension("error")
        do {
            let markdown = try String(contentsOf: source, encoding: .utf8)
            guard !markdown.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw CocoaError(.fileReadCorruptFile, userInfo: [
                    NSLocalizedDescriptionKey: "Nothing to export, the file is empty.",
                ])
            }
            try await PDFExporter.export(
                MarkdownParser.parse(markdown),
                baseURL: source.deletingLastPathComponent(),
                to: output,
                landscape: landscape
            )
            seshatLog("AppRouter.exportHeadless — wrote \(output.path)")
        } catch {
            seshatLog("AppRouter.exportHeadless — failed: \(error.localizedDescription)")
            try? Data(error.localizedDescription.utf8).write(to: errorFile)
        }
    }

    private func openInWorkspace(_ fileURL: URL?, openWindow: OpenWindowAction) {
        if let fileURL {
            workspaceTarget = InboxImporter.ensureInLibrary(fileURL, libraryRoot: Library.defaultRootURL)
        } else {
            workspaceTarget = nil
        }
        seshatLog("AppRouter.openInWorkspace — target=\(workspaceTarget?.lastPathComponent ?? "nil")")
        openWindow(id: WorkspaceScene.id)
        NSApp.activate(ignoringOtherApps: true)
    }
}

private struct ReaderEntry {
    let window: WeakWindow
    let fileURL: URL?
}

private struct WeakWindow {
    weak var window: NSWindow?
    init(_ window: NSWindow) { self.window = window }
}
