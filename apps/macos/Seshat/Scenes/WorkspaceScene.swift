import SwiftUI

struct WorkspaceScene: Scene {
    static let id = "workspace"

    @State private var library = Library()
    @State private var selection: URL?

    var body: some Scene {
        Window("Seshat", id: Self.id) {
            WorkspaceRootContainer(
                library: library,
                selection: $selection
            )
            .frame(minWidth: 760, minHeight: 480)
        }
        .windowToolbarStyle(.unified)
        .windowResizability(.contentMinSize)
        .defaultSize(width: 1180, height: 800)
    }
}

private struct WorkspaceRootContainer: View {
    let library: Library
    @Binding var selection: URL?

    @Environment(AppRouter.self) private var router
    @Environment(AuthStore.self) private var authStore
    @Environment(UpdateChecker.self) private var updateChecker
    @Environment(UpdaterController.self) private var updaterController
    @Environment(\.openWindow) private var openWindow
    @AppStorage("seshatAppearance") private var appearance: AppearanceMode = .light

    var body: some View {
        Group {
            if authStore.isAuthenticated {
                WorkspaceRoot(library: library, selection: $selection)
            } else {
                SignInView()
            }
        }
        .overlay(alignment: .bottom) {
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
            router.registerWorkspace(window: window)
        })
        .onChange(of: router.workspaceTarget) { _, target in
            guard let target else { return }
            library.refresh()
            selection = target
            router.workspaceTarget = nil
        }
        .onAppear {
            seshatLog("WorkspaceRootContainer.onAppear")
            router.bind(openWindow: openWindow)
        }
        .task {
            if let target = router.workspaceTarget {
                selection = target
                router.workspaceTarget = nil
            }
        }
    }
}
