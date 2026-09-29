import AppKit
import SwiftUI

/// Reports every mouse-down inside its frame without taking the click, so a pane is focused
/// the moment it is touched. SwiftUI tap gestures never see clicks on selectable text, so a
/// local event monitor watches instead; `hitTest` stays nil and the event goes on untouched.
struct MouseDownObserver: NSViewRepresentable {
    let onMouseDown: () -> Void

    func makeNSView(context: Context) -> ObserverView {
        let view = ObserverView()
        view.onMouseDown = onMouseDown
        return view
    }

    func updateNSView(_ nsView: ObserverView, context: Context) {
        nsView.onMouseDown = onMouseDown
    }

    final class ObserverView: NSView {
        var onMouseDown: () -> Void = {}
        private var monitor: Any?

        override func hitTest(_ point: NSPoint) -> NSView? { nil }

        /// Removed from the window when SwiftUI drops the view, which ends the monitor with it.
        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            if let monitor { NSEvent.removeMonitor(monitor) }
            monitor = nil
            guard window != nil else { return }
            monitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { [weak self] event in
                MainActor.assumeIsolated {
                    guard let self, event.window === self.window,
                          self.bounds.contains(self.convert(event.locationInWindow, from: nil)) else { return }
                    self.onMouseDown()
                }
                return event
            }
        }
    }
}
