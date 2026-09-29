import SwiftUI

/// One pane: its own tab row over its own page, like a VS Code editor group. A click anywhere
/// in it focuses it, which is what the sidebar, the menus and the toolbar then act on.
struct WorkspacePane: View {
    let pane: WorkspaceTabs
    let panes: WorkspacePanes
    let reloadTick: Int
    let onRevealInSidebar: (URL) -> Void
    /// Dropped files, opened here or (`toSide`) in the pane beside this one.
    let onOpenFiles: (_ urls: [URL], _ toSide: Bool) -> Void

    @State private var dropZone: PaneDropDelegate.Zone?
    @State private var pageWidth: CGFloat = 0

    private var isFocused: Bool { panes.isFocused(pane) }

    var body: some View {
        VStack(spacing: 4) {
            WorkspaceTabStrip(
                tabs: pane,
                isFocused: isFocused,
                onRevealInSidebar: { url in
                    panes.focus(pane)
                    onRevealInSidebar(url)
                },
                onOpenToSide: { panes.openToSide($0, of: pane) },
                onDropTab: dropTab(_:before:),
                onDropFiles: { onOpenFiles($0, false) }
            )
            page
        }
        .background {
            MouseDownObserver { panes.focus(pane) }
        }
    }

    private var page: some View {
        Group {
            if let active = pane.active {
                MarkdownReader(fileURL: active, reloadTick: reloadTick, isFocused: isFocused)
            } else {
                EmptyDetail()
            }
        }
        .environment(pane)
        .overlay { dropHighlight }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { pageWidth = $0 }
        .onDrop(of: [.seshatTab, .fileURL], delegate: PaneDropDelegate(
            zone: $dropZone,
            width: pageWidth,
            canSplit: panes.panes.count < WorkspacePanes.maxPanes,
            onDropTab: dropTab(_:zone:),
            onDropFile: { url, zone in onOpenFiles([url], zone == .side) }
        ))
        // Linear-style inset page: chrome (toolbar + sidebar) is one flat colour, the
        // document sits in a bordered card with a thin gutter. Shadow on the shape, not
        // the scroll view, so scrolling never re-rasterises the page.
        .clipShape(.rect(cornerRadius: 8))
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.seshatPaper)
                .shadow(color: .black.opacity(0.06), radius: 3, y: 1)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.seshatRuleStrong, lineWidth: 0.5)
        }
    }

    /// The whole page for "here", its right half for "in a new pane beside it".
    @ViewBuilder
    private var dropHighlight: some View {
        if let dropZone {
            HStack(spacing: 0) {
                if dropZone == .side { Color.clear }
                Color.seshatAccentSoft.opacity(0.25)
            }
            .allowsHitTesting(false)
        }
    }

    private func dropTab(_ drag: WorkspaceTabDrag, zone: PaneDropDelegate.Zone) {
        guard let source = panes.pane(id: drag.pane) else { return }
        if zone == .side {
            panes.moveToSide(drag.url, from: source, of: pane)
        } else {
            panes.move(drag.url, from: source, to: pane, at: pane.tabs.count)
        }
    }

    /// A tab dropped on one of this pane's tabs lands before it: a reorder from this pane,
    /// a move from another.
    private func dropTab(_ drag: WorkspaceTabDrag, before target: URL) -> Bool {
        guard let source = panes.pane(id: drag.pane), let to = pane.index(of: target) else { return false }
        if source === pane {
            guard let from = pane.index(of: drag.url), from != to else { return false }
            pane.move(from: from, to: to)
        } else {
            panes.move(drag.url, from: source, to: pane, at: to)
        }
        return true
    }
}

private struct EmptyDetail: View {
    var body: some View {
        VStack(spacing: 18) {
            SeshatMark(lineWidth: 1.6, color: .seshatFaint)
                .frame(width: 56, height: 56)
            VStack(spacing: 8) {
                Text("No document selected")
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .foregroundStyle(Color.seshatMuted)
                Text("Pick a file from the sidebar, or use `seshat open <file.md>` from the terminal.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.seshatFaint)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 340)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.seshatPaper)
    }
}
