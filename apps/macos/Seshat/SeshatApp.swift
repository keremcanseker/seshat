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
        ReaderScene()
            .environment(appDelegate.router)
            .environment(appDelegate.authStore)
    }
}
