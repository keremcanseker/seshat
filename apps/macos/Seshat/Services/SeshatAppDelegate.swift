import AppKit

@MainActor
final class SeshatAppDelegate: NSObject, NSApplicationDelegate {
    let authStore: AuthStore
    let router: AppRouter
    let updateChecker = UpdateChecker()
    let updaterController = UpdaterController()
    let readState = ReadState()

    override init() {
        let authStore = AuthStore()
        self.authStore = authStore
        self.router = AppRouter(authStore: authStore)
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        authStore.bootstrap()
        CLIInstaller.runFirstLaunchIfNeeded()
        Task { await updateChecker.check() }
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        seshatLog("AppDelegate.application(_:open:) — \(urls.count) url(s): \(urls.map(\.absoluteString))")
        router.handle(urls: urls)
    }

    func applicationSupportsSecureRestorableState(_ application: NSApplication) -> Bool {
        false
    }
}
