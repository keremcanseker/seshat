import SwiftUI

struct WorkspaceScene: Scene {
    static let id = "workspace"

    @State private var library = Library()
    @State private var tabs = WorkspaceTabs()   // owned by the scene, so onboarding and sign-out keep the tabs

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
    @AppStorage("SeshatOnboardingCompletedV1") private var onboardingCompleted = false
    @State private var closeTabMonitor: Any?
    @State private var window: NSWindow?

    var body: some View {
        Group {
            // Reading never needs an account: the only thing between a fresh
            // install and the library is the one-time onboarding, which can be
            // skipped. Sign-in lives in the Share flow (KER-801).
            if onboardingCompleted {
                WorkspaceRoot(library: library, tabs: tabs)
            } else {
                OnboardingView()
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
            // ponytail: one turn later, the split view controller SwiftUI builds exists by then.
            Task { @MainActor in SidebarChrome.flattenTitlebar(in: window) }
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
    /// window (Sparkle, a reader), a sheet, or the onboarding screen leaves the tab alone.
    private func installCloseTabShortcut() {
        guard closeTabMonitor == nil else { return }
        let tabs = tabs
        closeTabMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command,
                  event.charactersIgnoringModifiers == "w" else { return event }
            let handled = MainActor.assumeIsolated {
                guard let window, NSApp.keyWindow === window, window.attachedSheet == nil,
                      onboardingCompleted, let active = tabs.active else { return false }
                tabs.close(active)
                return true
            }
            return handled ? nil : event
        }
    }
}
