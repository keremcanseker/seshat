import SwiftUI

struct WelcomeScene: Scene {
    static let id = "welcome"

    var body: some Scene {
        Window("Seshat", id: Self.id) {
            WelcomeRoot()
        }
        .windowToolbarStyle(.unified)
        .windowResizability(.contentMinSize)
        .defaultSize(width: 880, height: 720)
    }
}

private struct WelcomeRoot: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(AppRouter.self) private var router

    var body: some View {
        EmptyReaderView()
            .frame(minWidth: 520, minHeight: 360)
            .background(WindowAccessor { window in
                window?.isRestorable = false
            })
            .onAppear {
                seshatLog("WelcomeRoot.onAppear")
                router.bind(openWindow: openWindow, dismissWindow: dismissWindow)
            }
    }
}

struct EmptyReaderView: View {
    var body: some View {
        ContentUnavailableView {
            Label("No file open", systemImage: "doc.text")
        } description: {
            Text("Use `seshat open <file.md>` from the terminal to open a markdown file.")
        }
        .background(Color.seshatPaper)
    }
}
