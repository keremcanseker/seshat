import AppKit
import SwiftUI

/// `NavigationSplitView` on macOS 26 wraps the sidebar in its own titlebar background and a
/// blurred backdrop that run behind the toolbar, so the strip above the sidebar shows as a
/// paler rounded patch next to the flat toolbar. Hiding those two views lets the window's own
/// toolbar background (see `toolbarBackground` in WorkspaceRoot) run edge to edge.
///
/// SwiftUI builds the split view with a plain `NSSplitView`, not an `NSSplitViewController`,
/// so `allowsFullHeightLayout` is not available and the views are found by class name.
/// ponytail: private view names, macOS 26.5. If a release renames them the patch just comes back.
@MainActor
enum SidebarChrome {
    private static let hiddenViews: Set<String> = ["NSTitlebarBackgroundView", "NSBlurryAlleywayView"]

    static func flattenTitlebar(in window: NSWindow) {
        window.backgroundColor = NSColor(Color.seshatSidebarBg)   // the inset gutter around the sidebar
        window.titlebarSeparatorStyle = .none                     // the page card draws its own top edge
        apply(to: window)
        for name in [NSWindow.didEnterFullScreenNotification, NSWindow.didExitFullScreenNotification] {
            NotificationCenter.default.addObserver(forName: name, object: window, queue: .main) { note in
                guard let window = note.object as? NSWindow else { return }
                MainActor.assumeIsolated { apply(to: window) }
            }
        }
    }

    private static func apply(to window: NSWindow) {
        guard let content = window.contentView else { return }
        let wrappers = descendants(of: content).filter { className($0) == "_NSSplitViewItemViewWrapper" }
        // The detail wrapper spans the window; the sidebar's is the narrow one.
        guard let sidebar = wrappers.min(by: { $0.frame.width < $1.frame.width }), wrappers.count > 1 else { return }
        for view in sidebar.subviews where hiddenViews.contains(className(view)) {
            view.isHidden = true
        }
        // The sidebar's trailing edge is a 12pt shadow strip, not a divider line.
        for view in sidebar.superview?.subviews ?? [] where className(view) == "_NSSplitViewShadowView" {
            view.isHidden = true
        }
        // macOS 26 floats the sidebar as a rounded glass card 8pt inside its column. Linear's
        // chrome is one flat surface: the 8pt constraints (leading, bottom, width) go to zero,
        // the hosting view moves out of the glass and follows the glass's frame, and the glass
        // itself is hidden. Hidden views still lay out, so collapse animations keep working.
        guard #available(macOS 26, *) else { return }
        for case let glass as NSGlassEffectView in sidebar.subviews where !glass.isHidden {
            for constraint in sidebar.constraints
            where (constraint.firstItem === glass || constraint.secondItem === glass) && abs(constraint.constant) == 8 {
                constraint.constant = 0
            }
            guard let hosting = descendants(of: glass).first(where: { className($0).hasPrefix("NSHostingView") }) else { continue }
            hosting.removeFromSuperview()
            sidebar.addSubview(hosting)
            hosting.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hosting.topAnchor.constraint(equalTo: glass.topAnchor),
                hosting.bottomAnchor.constraint(equalTo: glass.bottomAnchor),
                hosting.leadingAnchor.constraint(equalTo: glass.leadingAnchor),
                hosting.trailingAnchor.constraint(equalTo: glass.trailingAnchor),
            ])
            glass.isHidden = true
        }
    }

    private static func descendants(of view: NSView) -> [NSView] {
        view.subviews.flatMap { [$0] + descendants(of: $0) }
    }

    private static func className(_ view: NSView) -> String {
        String(describing: type(of: view))
    }
}
