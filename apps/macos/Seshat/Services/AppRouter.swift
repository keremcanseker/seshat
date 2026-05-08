import AppKit
import SwiftUI

@Observable
@MainActor
final class AppRouter {
    var workspaceTarget: URL?
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
            if let existing = liveReaderWindow(for: fileURL) {
                seshatLog("AppRouter.handle — focus existing reader \(fileURL.lastPathComponent)")
                existing.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
                return
            }
            seshatLog("AppRouter.handle — openWindow(value:) \(fileURL.lastPathComponent)")
            openWindow(value: fileURL)
        case .openWorkspace(let fileURL):
            workspaceTarget = fileURL
            seshatLog("AppRouter.handle — openWindow(id: workspace)")
            openWindow(id: WorkspaceScene.id)
        case .signInCallback:
            break
        }
    }

    private func liveReaderWindow(for url: URL) -> NSWindow? {
        for entry in readerWindows.values {
            guard entry.fileURL == url, let window = entry.window.window else { continue }
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
