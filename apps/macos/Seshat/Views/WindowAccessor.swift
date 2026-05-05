import AppKit
import SwiftUI

struct WindowAccessor: NSViewRepresentable {
    let onWindow: @MainActor (NSWindow?) -> Void

    func makeNSView(context: Context) -> Reporter {
        Reporter(onWindow: onWindow)
    }

    func updateNSView(_ view: Reporter, context: Context) {
        view.onWindow = onWindow
        view.report()
    }

    @MainActor
    final class Reporter: NSView {
        var onWindow: @MainActor (NSWindow?) -> Void

        init(onWindow: @escaping @MainActor (NSWindow?) -> Void) {
            self.onWindow = onWindow
            super.init(frame: .zero)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError("not used") }

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            report()
        }

        func report() {
            onWindow(window)
        }
    }
}
