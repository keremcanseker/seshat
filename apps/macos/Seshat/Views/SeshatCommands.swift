import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct SeshatCommands: Commands {
    let router: AppRouter
    let updaterController: UpdaterController

    @FocusedValue(\.exportPDF) private var exportPDF
    @FocusedValue(\.printDocument) private var printDocument
    @FocusedValue(\.copyDocument) private var copyDocument
    @FocusedValue(\.workspacePanes) private var panes

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

            Divider()

            Button("Export as PDF…", action: exportFocusedDocument)
                .keyboardShortcut("e", modifiers: [.command, .shift])
                .disabled(exportPDF == nil)
        }

        CommandGroup(after: .pasteboard) {
            Menu("Copy As") {
                Button("Rich Text") { copyDocument?(.richText) }
                    .keyboardShortcut("c", modifiers: [.command, .option])
                Button("Slack Message") { copyDocument?(.slack) }
            }
            .disabled(copyDocument == nil)
        }

        CommandGroup(replacing: .printItem) {
            Button("Print…", action: printFocusedDocument)
                .keyboardShortcut("p", modifiers: .command)
                .disabled(printDocument == nil)
        }

        CommandGroup(after: .toolbar) {
            Button("Toggle Dark Theme", action: toggleAppearance)
                .keyboardShortcut("d", modifiers: [.command, .option])

            Button("Refresh Library") {
                router.requestWorkspaceRefresh()
            }
            .keyboardShortcut("r", modifiers: .command)

            Divider()

            Button("Previous Tab") {
                panes?.focused.activatePrevious()
            }
            .keyboardShortcut("[", modifiers: [.command, .shift])
            .disabled(panes?.focused.canGoPrevious != true)

            Button("Next Tab") {
                panes?.focused.activateNext()
            }
            .keyboardShortcut("]", modifiers: [.command, .shift])
            .disabled(panes?.focused.canGoNext != true)

            // ⌘W itself is caught by the workspace window (WorkspaceRootContainer), ahead of
            // the system Close item, which stays for closing the window when no tab is open.
            Button("Reopen Closed Tab") {
                panes?.reopenLast()
            }
            .keyboardShortcut("t", modifiers: [.command, .shift])
            .disabled(panes?.canReopen != true)

            Button("Split Right") {
                panes?.split()
            }
            .keyboardShortcut("\\", modifiers: .command)
            .disabled(panes?.canSplit != true)
        }

        CommandGroup(after: .help) {
            Button("Reveal Library Folder") {
                NSWorkspace.shared.open(Library.defaultRootURL)
            }
        }
    }

    private func exportFocusedDocument() {
        exportPDF?()
    }

    private func printFocusedDocument() {
        printDocument?()
    }

    /// Writes the same key every `@AppStorage("seshatAppearance")` observes.
    private func toggleAppearance() {
        let defaults = UserDefaults.standard
        let current = AppearanceMode(rawValue: defaults.string(forKey: "seshatAppearance") ?? "") ?? .light
        defaults.set(current.toggled.rawValue, forKey: "seshatAppearance")
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
