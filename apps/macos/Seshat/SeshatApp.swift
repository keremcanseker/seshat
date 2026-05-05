import SwiftUI

@main
struct SeshatApp: App {
    @NSApplicationDelegateAdaptor(SeshatAppDelegate.self) private var appDelegate

    init() {
        seshatLog("SeshatApp.init")
    }

    var body: some Scene {
        WelcomeScene()
            .environment(appDelegate.router)
        WorkspaceScene()
            .environment(appDelegate.router)
        ReaderScene()
            .environment(appDelegate.router)
    }
}
