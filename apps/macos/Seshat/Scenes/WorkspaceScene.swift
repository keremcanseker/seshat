import SwiftUI

struct WorkspaceScene: Scene {
    static let id = "workspace"

    @State private var library = Library()
    @State private var tabs = WorkspaceTabs()   // above the auth gate, so sign-out keeps the tabs

    var body: some Scene {
        Window("Seshat", id: Self.id) {
            WorkspaceRootContainer(library: library, tabs: tabs)
                .frame(minWidth: 760, minHeight: 480)
        }
        .windowToolbarStyle(.unifiedCompact)
        .windowResizability(.contentMinSize)
        .defaultSize(width: 1180, height: 800)
    }
}

private struct WorkspaceRootContainer: View {
    let library: Library
    let tabs: WorkspaceTabs

    @Environment(AppRouter.self) private var router
    @Environment(AuthStore.self) private var authStore
    @Environment(UpdateChecker.self) private var updateChecker
    @Environment(UpdaterController.self) private var updaterController
    @Environment(\.openWindow) private var openWindow
    @AppStorage("seshatAppearance") private var appearance: AppearanceMode = .light
    @State private var closeTabMonitor: Any?
    @State private var window: NSWindow?

    var body: some View {
        Group {
            if authStore.isAuthenticated {
                WorkspaceRoot(library: library, tabs: tabs)
            } else {
                SignInView()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if let info = updateChecker.available {
                UpdateBanner(
                    info: info,
                    onUpdate: updaterController.checkForUpdates,
                    onDismiss: updateChecker.dismiss
                )
                .animation(.easeOut(duration: 0.25), value: updateChecker.available)
            }
        }
        .preferredColorScheme(appearance.colorScheme)
        .background(WindowAccessor { window in
            guard let window else { return }
            window.isRestorable = false
            window.tabbingMode = .disallowed   // keeps the system "Show Next Tab" items out of the Window menu
            router.registerWorkspace(window: window)
            self.window = window
        })
        .onChange(of: router.workspaceTarget) { _, target in
            guard let target else { return }
            library.refresh()
            tabs.open(target)
            router.workspaceTarget = nil
        }
        .onAppear {
            seshatLog("WorkspaceRootContainer.onAppear")
            router.bind(openWindow: openWindow)
            installCloseTabShortcut()
        }
        .task {
            if let target = router.workspaceTarget {
                tabs.open(target)
                router.workspaceTarget = nil
            }
        }
    }

    /// ⌘W closes the active tab. SwiftUI offers no placement for the system Close item, so the
    /// key is taken here before menu dispatch; with no tab open it falls through and closes
    /// the window as before. Only while the workspace itself is key and showing tabs: another
    /// window (Sparkle, a reader), a sheet, or the sign-in screen leaves the tab alone.
    private func installCloseTabShortcut() {
        guard closeTabMonitor == nil else { return }
        let tabs = tabs
        let authStore = authStore
        closeTabMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command,
                  event.charactersIgnoringModifiers == "w" else { return event }
            let handled = MainActor.assumeIsolated {
                guard let window, NSApp.keyWindow === window, window.attachedSheet == nil,
                      authStore.isAuthenticated, let active = tabs.active else { return false }
                tabs.close(active)
                return true
            }
            return handled ? nil : event
        }
    }
}
