import AppKit
import UniformTypeIdentifiers

/// The export save dialog: filename plus a single Portrait / Landscape choice,
/// remembered between exports.
@MainActor
enum PDFSavePanel {
    private static let landscapeKey = "seshatExportLandscape"

    static func run(suggestedName: String) -> (url: URL, landscape: Bool)? {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.pdf]
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = suggestedName
        panel.isExtensionHidden = false

        let label = NSTextField(labelWithString: "Orientation:")
        let orientation = NSPopUpButton(frame: .zero, pullsDown: false)
        orientation.addItems(withTitles: ["Portrait", "Landscape"])
        orientation.selectItem(at: UserDefaults.standard.bool(forKey: landscapeKey) ? 1 : 0)
        orientation.setAccessibilityLabel("Orientation")
        let stack = NSStackView(views: [label, orientation])
        stack.orientation = .horizontal
        stack.edgeInsets = NSEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        stack.translatesAutoresizingMaskIntoConstraints = false
        panel.accessoryView = stack

        guard panel.runModal() == .OK, let url = panel.url else { return nil }
        let landscape = orientation.indexOfSelectedItem == 1
        UserDefaults.standard.set(landscape, forKey: landscapeKey)
        return (url, landscape)
    }
}
