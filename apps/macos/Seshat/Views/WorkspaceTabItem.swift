import SwiftUI

/// One tab pill in the toolbar at the width the strip hands it. A title that does not fit
/// fades out at the trailing edge; the ⨯ sits in that fade on hover or keyboard focus and
/// is always in the accessibility tree.
struct WorkspaceTabItem: View {
    let url: URL
    let width: Double
    let tabs: WorkspaceTabs
    let onRevealInSidebar: (URL) -> Void

    @State private var hovering = false
    @State private var dropTargeted = false
    @FocusState private var closeFocused: Bool

    private var isActive: Bool { tabs.isActive(url) }
    private var title: String { tabs.title(for: url) }

    var body: some View {
        Button(action: activate) {
            Text(title)
                .font(.system(size: 12.5, weight: isActive ? .medium : .regular))
                .italic(tabs.isPreview(url))   // VS Code's cue for "the next click replaces me"
                .foregroundStyle(titleColor)
                .lineLimit(1)
                .fixedSize()
                .padding(.leading, 10)
                .frame(width: width, height: 24, alignment: .leading)
                .clipped()
                .mask { titleFade }
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isActive ? .isSelected : [])
        .background(pillColor, in: .rect(cornerRadius: 6))
        .overlay {
            if isActive {
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.seshatRuleStrong, lineWidth: 0.5)
            }
        }
        .overlay(alignment: .trailing) {
            Button("Close \(title)", systemImage: "xmark", action: close)
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(Color.seshatMuted)
                .frame(width: 16, height: 16)
                .contentShape(.rect)
                .opacity(hovering || closeFocused ? 1 : 0)
                .focused($closeFocused)
                .help("Close tab")
                .padding(.trailing, 4)
        }
        .overlay(alignment: .leading) {
            if dropTargeted {
                Color.seshatAccent.frame(width: 2, height: 16)
            }
        }
        .overlay {
            TabPointerTracker(onHover: { hovering = $0 }, onMiddleClick: close)
        }
        .animation(.easeOut(duration: 0.12), value: hovering)
        .simultaneousGesture(TapGesture(count: 2).onEnded { tabs.pin(url) })
        .help(url.path)
        .draggable(WorkspaceTabDrag(url: url)) {
            FileDragPreview(name: title)
        }
        .dropDestination(for: WorkspaceTabDrag.self) { items, _ in
            guard let dragged = items.first else { return false }
            return reorder(dragged.url)
        } isTargeted: { dropTargeted = $0 }
        .contextMenu {
            Button("Close", action: close)
            Button("Close Others") { tabs.closeOthers(url) }
                .disabled(tabs.tabs.count < 2)
            Button("Close to the Right") { tabs.closeRight(of: url) }
                .disabled(tabs.tabs.last?.seshatMatches(url) == true)
            Button("Close All", action: tabs.closeAll)
            Divider()
            Button("Reveal in Sidebar") { onRevealInSidebar(url) }
            Button("Show in Finder", action: showInFinder)
            Button("Copy Path", action: copyPath)
        }
    }

    /// Opaque, then a fade over the last stretch so an overlong title dissolves instead of
    /// ending in "…". Wider while the ⨯ is showing so the two never overlap.
    private var titleFade: some View {
        HStack(spacing: 0) {
            Color.black
            LinearGradient(colors: [.black, .clear], startPoint: .leading, endPoint: .trailing)
                .frame(width: 18)
            Color.clear
                .frame(width: hovering || closeFocused ? 18 : 6)
        }
    }

    /// Inactive tabs are plain text on the chrome; the active one is a small card in the
    /// same paper and hairline as the page below, so tab and page read as one sheet.
    private var pillColor: Color {
        if isActive { return .seshatPaper }
        return hovering ? Color.seshatRuleStrong.opacity(0.35) : .clear
    }

    private var titleColor: Color {
        if tabs.isMissing(url) { return .seshatFaint }
        return isActive || hovering ? .seshatBodyText : .seshatMuted
    }

    private func activate() {
        tabs.activate(url)
    }

    private func close() {
        tabs.close(url)
    }

    private func reorder(_ dragged: URL) -> Bool {
        guard let from = tabs.tabs.firstIndex(where: { $0.seshatMatches(dragged) }),
              let to = tabs.tabs.firstIndex(where: { $0.seshatMatches(url) }),
              from != to else { return false }
        tabs.move(from: from, to: to)
        return true
    }

    private func showInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }

    private func copyPath() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(url.path, forType: .string)
    }
}
