import SwiftUI

/// Toolbar tabs, Linear-style. Every tab has the same width; as tabs come and go they share
/// the room the detail column has left after the toolbar's own actions, browser-like, between
/// `minTabWidth` and `maxTabWidth`. Content-sized on purpose: NSToolbar sizes the item from
/// its ideal width and cannot stretch it, so the strip must already be the right size.
struct WorkspaceTabStrip: View {
    let tabs: WorkspaceTabs
    /// Width of the detail column; the strip keeps `reserved` of it for the toolbar's actions.
    let availableWidth: Double
    let onRevealInSidebar: (URL) -> Void
    /// Files dragged in from the sidebar (or Finder) open as permanent tabs.
    let onDropFiles: ([URL]) -> Void

    @State private var dropTargeted = false

    private static let maxTabWidth = 180.0
    private static let minTabWidth = 72.0
    private static let spacing = 2.0
    /// Trailing actions (~300) plus what NSToolbar keeps for margins and overflow (~150).
    private static let reserved = 480.0

    var body: some View {
        HStack(spacing: Self.spacing) {
            ForEach(tabs.tabs, id: \.self) { url in
                WorkspaceTabItem(url: url, width: tabWidth, tabs: tabs, onRevealInSidebar: onRevealInSidebar)
            }
        }
        .padding(.trailing, 24)   // a little empty strip to drop onto after the last tab
        .frame(height: 28)
        .fixedSize()
        .background(dropTargeted ? Color.seshatAccentSoft.opacity(0.2) : .clear, in: .rect(cornerRadius: 6))
        .dropDestination(for: URL.self) { urls, _ in
            let files = urls.filter { Library.markdownExtensions.contains($0.pathExtension.lowercased()) }
            guard !files.isEmpty else { return false }
            onDropFiles(files)
            return true
        } isTargeted: { dropTargeted = $0 }
        .animation(.easeOut(duration: 0.15), value: tabs.tabs.count)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isTabBar)
        .accessibilityLabel("Tabs")
    }

    private var tabWidth: Double {
        let count = Double(max(tabs.tabs.count, 1))
        let room = availableWidth - Self.reserved - Self.spacing * (count - 1)
        return min(Self.maxTabWidth, max(Self.minTabWidth, room / count))
    }
}
