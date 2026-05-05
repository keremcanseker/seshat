import AppKit

@MainActor
final class SeshatAppDelegate: NSObject, NSApplicationDelegate {
    let router = AppRouter()

    func application(_ application: NSApplication, open urls: [URL]) {
        seshatLog("AppDelegate.application(_:open:) — \(urls.count) url(s): \(urls.map(\.absoluteString))")
        router.handle(urls: urls)
    }
}
