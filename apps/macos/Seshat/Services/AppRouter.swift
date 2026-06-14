import AppKit
import SwiftUI

@Observable
@MainActor
final class AppRouter {
    var workspaceTarget: URL?
    private(set) var workspaceRefreshTick: Int = 0
    let authStore: AuthStore

    private var openWindow: OpenWindowAction?
    private var pending: [URL] = []
    private var readerWindows: [ObjectIdentifier: ReaderEntry] = [:]
    private var workspaceWindow: WeakWindow?

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
        let key = ObjectIdentifier(window)
        readerWindows[key] = ReaderEntry(window: WeakWindow(window), fileURL: fileURL)
        seshatLog("AppRouter.registerReader — fileURL=\(fileURL?.lastPathComponent ?? "nil") windowID=\(key.hashValue)")
        reconcileWindows()
    }

    func unregisterReader(window: NSWindow) {
        readerWindows.removeValue(forKey: ObjectIdentifier(window))
    }

    func registerWorkspace(window: NSWindow) {
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
        case .signInCallback:
            break
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
