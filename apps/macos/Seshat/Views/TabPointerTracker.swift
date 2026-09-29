import AppKit
import SwiftUI

/// Hover and middle-click for a tab. SwiftUI has no middle-button gesture, so an AppKit
/// tracking area does both (hover too, since it is there anyway). `hitTest` only
/// claims middle-button events; left clicks and tooltips still reach the SwiftUI view beneath.
struct TabPointerTracker: NSViewRepresentable {
    let onHover: (Bool) -> Void
    let onMiddleClick: () -> Void

    func makeNSView(context: Context) -> TrackerView {
        let view = TrackerView()
        view.onHover = onHover
        view.onMiddleClick = onMiddleClick
        return view
    }

    func updateNSView(_ nsView: TrackerView, context: Context) {
        nsView.onHover = onHover
        nsView.onMiddleClick = onMiddleClick
    }

    final class TrackerView: NSView {
        var onHover: (Bool) -> Void = { _ in }
        var onMiddleClick: () -> Void = {}
        private var tracking: NSTrackingArea?

        override func updateTrackingAreas() {
            super.updateTrackingAreas()
            if let tracking { removeTrackingArea(tracking) }
            let area = NSTrackingArea(
                rect: .zero,
                options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
                owner: self
            )
            addTrackingArea(area)
            tracking = area
        }

        override func mouseEntered(with event: NSEvent) { onHover(true) }
        override func mouseExited(with event: NSEvent) { onHover(false) }

        override func hitTest(_ point: NSPoint) -> NSView? {
            guard let event = NSApp.currentEvent, event.buttonNumber == 2 else { return nil }
            switch event.type {
            case .otherMouseDown, .otherMouseUp, .otherMouseDragged:
                return super.hitTest(point)
            default:
                return nil
            }
        }

        override func otherMouseDown(with event: NSEvent) {}

        override func otherMouseUp(with event: NSEvent) {
            guard event.buttonNumber == 2, bounds.contains(convert(event.locationInWindow, from: nil)) else { return }
            onMiddleClick()
        }
    }
}
