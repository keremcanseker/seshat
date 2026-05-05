import AppKit
import SwiftUI

@Observable
@MainActor
final class AppRouter {
    var workspaceTarget: URL?
    private(set) var workspaceExplicitlyRequested = false

    private var openWindow: OpenWindowAction?
    private var dismissWindow: DismissWindowAction?
    private var pending: [URL] = []
    private var readerWindows: [ObjectIdentifier: ReaderEntry] = [:]

    func bind(openWindow: OpenWindowAction, dismissWindow: DismissWindowAction) {
        guard self.openWindow == nil else { return }
        self.openWindow = openWindow
        self.dismissWindow = dismissWindow
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
                dismissWelcome()
                return
            }
            seshatLog("AppRouter.handle — openWindow(value:) \(fileURL.lastPathComponent)")
            openWindow(value: fileURL)
            dismissWelcome()
        case .openWorkspace(let fileURL):
            workspaceTarget = fileURL
            workspaceExplicitlyRequested = true
            seshatLog("AppRouter.handle — openWindow(id: workspace)")
            openWindow(id: "workspace")
            dismissWelcome()
        }
    }

    private func dismissWelcome() {
        guard let dismissWindow else { return }
        seshatLog("AppRouter.dismissWelcome — dismissing")
        dismissWindow(id: WelcomeScene.id)
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
