import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct SeshatCommands: Commands {
    let router: AppRouter
    let updaterController: UpdaterController

    var body: some Commands {
        CommandGroup(after: .appInfo) {
            Button("Check for Updates…") {
                updaterController.checkForUpdates()
            }

            Button("Install Terminal Command…") {
                CLIInstaller.reinstallFromMenu()
            }
        }

        CommandGroup(replacing: .newItem) {
            Button("Open…") {
                openFile()
            }
            .keyboardShortcut("o", modifiers: [.command])

            Button("Open Workspace") {
                if let url = URL(string: "seshat://global") {
                    router.handle(urls: [url])
                }
            }
            .keyboardShortcut("o", modifiers: [.command, .shift])
        }

        CommandGroup(after: .toolbar) {
            Button("Refresh Library") {
                router.requestWorkspaceRefresh()
            }
            .keyboardShortcut("r", modifiers: .command)
        }

        CommandGroup(after: .help) {
            Button("Reveal Library Folder") {
                NSWorkspace.shared.open(Library.defaultRootURL)
            }
        }
    }

    @MainActor
    private func openFile() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = ["md", "markdown", "mdown", "mkdn"]
            .compactMap { UTType(filenameExtension: $0) }
        guard panel.runModal() == .OK, let url = panel.url else { return }
        router.handle(urls: [url])
    }
}
