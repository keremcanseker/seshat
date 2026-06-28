import SwiftUI

@main
struct SeshatApp: App {
    @NSApplicationDelegateAdaptor(SeshatAppDelegate.self) private var appDelegate

    init() {
        seshatLog("SeshatApp.init")
    }

    var body: some Scene {
        WorkspaceScene()
            .environment(appDelegate.router)
            .environment(appDelegate.authStore)
            .environment(appDelegate.updateChecker)
            .environment(appDelegate.updaterController)
            .environment(appDelegate.readState)
            .commands {
                SeshatCommands(
                    router: appDelegate.router,
                    updaterController: appDelegate.updaterController
                )
            }
        ReaderScene()
            .environment(appDelegate.router)
            .environment(appDelegate.authStore)
            .environment(appDelegate.updateChecker)
            .environment(appDelegate.updaterController)
            .environment(appDelegate.readState)
    }
}
