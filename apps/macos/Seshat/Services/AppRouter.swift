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
    }

    func unregisterReader(window: NSWindow) {
        readerWindows.removeValue(forKey: ObjectIdentifier(window))
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
            if let existing = liveReaderWindow(for: fileURL) {
                seshatLog("AppRouter.handle — focus existing reader \(fileURL.lastPathComponent)")
                existing.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
                return
            }
            seshatLog("AppRouter.handle — openWindow(value:) \(fileURL.lastPathComponent)")
            openWindow(value: fileURL)
        case .openWorkspace(let fileURL):
            if let fileURL {
                workspaceTarget = InboxImporter.ensureInLibrary(fileURL, libraryRoot: Library.defaultRootURL)
            } else {
                workspaceTarget = nil
            }
            seshatLog("AppRouter.handle — openWindow(id: workspace) target=\(workspaceTarget?.lastPathComponent ?? "nil")")
            openWindow(id: WorkspaceScene.id)
        case .signInCallback:
            break
        }
    }

    private func liveReaderWindow(for url: URL) -> NSWindow? {
        let target = url.seshatNormalized
        for entry in readerWindows.values {
            guard let fileURL = entry.fileURL, fileURL.seshatMatches(target),
                  let window = entry.window.window else { continue }
            return window
        }
        return nil
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
