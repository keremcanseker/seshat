import SwiftUI

/// One pane's tabs, above its page. Every tab has the same width; as tabs come and go they
/// share the pane's width between `minTabWidth` and `maxTabWidth`, browser-like. A strip that
/// still overflows (a narrow split pane) scrolls sideways and keeps the active tab in view.
struct WorkspaceTabStrip: View {
    let tabs: WorkspaceTabs
    /// Only the focused pane's active tab reads as the current document.
    let isFocused: Bool
    let onRevealInSidebar: (URL) -> Void
    let onOpenToSide: (URL) -> Void
    /// A tab dropped on one of these tabs lands before it; true when it was taken.
    let onDropTab: (WorkspaceTabDrag, URL) -> Bool
    /// Files dragged in from the sidebar (or Finder) open as permanent tabs.
    let onDropFiles: ([URL]) -> Void

    @State private var dropTargeted = false
    @State private var width = 0.0

    private static let maxTabWidth = 180.0
    private static let minTabWidth = 72.0
    private static let spacing = 2.0
    /// A little empty strip after the last tab to drop onto.
    private static let trailingRoom = 24.0

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: Self.spacing) {
                    ForEach(tabs.tabs, id: \.self) { url in
                        WorkspaceTabItem(
                            url: url,
                            width: tabWidth,
                            tabs: tabs,
                            isPaneFocused: isFocused,
                            onRevealInSidebar: onRevealInSidebar,
                            onOpenToSide: onOpenToSide,
                            onDropTab: { onDropTab($0, url) }
                        )
                    }
                }
                .padding(.trailing, Self.trailingRoom)
                .frame(height: 28)
            }
            .scrollIndicators(.never)
            .onChange(of: tabs.active) { _, active in
                guard let active else { return }
                withAnimation(.easeOut(duration: 0.15)) { proxy.scrollTo(active) }
            }
        }
        .onGeometryChange(for: Double.self) { $0.size.width } action: { width = $0 }
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
        let room = width - Self.trailingRoom - Self.spacing * (count - 1)
        return min(Self.maxTabWidth, max(Self.minTabWidth, room / count))
    }
}
