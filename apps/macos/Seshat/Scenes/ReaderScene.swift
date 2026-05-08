import SwiftUI

struct ReaderScene: Scene {
    var body: some Scene {
        WindowGroup("Seshat", for: URL.self) { $fileURL in
            ReaderRoot(fileURL: fileURL)
        }
        .windowToolbarStyle(.unified)
        .windowResizability(.contentMinSize)
        .defaultSize(width: 880, height: 720)
    }
}

private struct ReaderRoot: View {
    let fileURL: URL?

    @Environment(\.openWindow) private var openWindow
    @Environment(AppRouter.self) private var router
    @Environment(AuthStore.self) private var authStore
    @AppStorage("seshatAppearance") private var appearance: AppearanceMode = .light

    var body: some View {
        Group {
            if let fileURL {
                MarkdownReader(fileURL: fileURL)
            } else if authStore.isAuthenticated {
                EmptyReaderView()
            } else {
                SignInView()
            }
        }
        .preferredColorScheme(appearance.colorScheme)
        .frame(minWidth: 520, minHeight: 360)
        .background(
            WindowAccessor { window in
                guard let window else { return }
                window.isRestorable = false
                router.registerReader(window: window, fileURL: fileURL)
            }
        )
        .onAppear {
            seshatLog("ReaderRoot.onAppear — fileURL=\(fileURL?.lastPathComponent ?? "nil")")
            router.bind(openWindow: openWindow)
        }
    }
}
