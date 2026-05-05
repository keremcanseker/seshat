import SwiftUI

struct WorkspaceScene: Scene {
    @State private var library = Library()
    @State private var selection: URL?

    var body: some Scene {
        Window("Workspace", id: "workspace") {
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
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        WorkspaceRoot(library: library, selection: $selection)
            .background(WindowAccessor { window in
                window?.isRestorable = false
            })
            .onChange(of: router.workspaceTarget) { _, target in
                guard let target else { return }
                library.refresh()
                selection = target
                router.workspaceTarget = nil
            }
            .onAppear {
                seshatLog("WorkspaceRootContainer.onAppear — explicit=\(router.workspaceExplicitlyRequested)")
                if !router.workspaceExplicitlyRequested {
                    dismissWindow(id: "workspace")
                }
            }
            .task {
                if let target = router.workspaceTarget {
                    selection = target
                    router.workspaceTarget = nil
                }
            }
    }
}
