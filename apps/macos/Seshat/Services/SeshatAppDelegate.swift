import AppKit

@MainActor
final class SeshatAppDelegate: NSObject, NSApplicationDelegate {
    let router = AppRouter()

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let outputPath = exportIconsArgument(in: CommandLine.arguments) {
            exportIcons(to: outputPath)
        }
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        seshatLog("AppDelegate.application(_:open:) — \(urls.count) url(s): \(urls.map(\.absoluteString))")
        router.handle(urls: urls)
    }

    private func exportIconsArgument(in arguments: [String]) -> String? {
        guard let index = arguments.firstIndex(of: "--export-icons") else { return nil }
        let next = index + 1
        return next < arguments.count ? arguments[next] : nil
    }

    private func exportIcons(to path: String) {
        let url = URL(filePath: (path as NSString).expandingTildeInPath)
        do {
            try IconExporter.exportAll(to: url)
            seshatLog("IconExporter: done. Exiting.")
            exit(0)
        } catch {
            seshatLog("IconExporter failed: \(error.localizedDescription)")
            exit(1)
        }
    }
}
