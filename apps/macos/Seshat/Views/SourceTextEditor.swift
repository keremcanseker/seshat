import AppKit
import SwiftUI

/// A plain, auto-growing NSTextView wrapped for SwiftUI. Used as the in-place
/// markdown source editor — native text input so focus and typing are reliable
/// (SwiftUI's TextField(axis:.vertical) dropped focus when the tap that opened it
/// was consumed by a gesture). Grows to fit content inside the reader's ScrollView.
struct SourceTextEditor: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> GrowingTextView {
        let view = GrowingTextView()
        view.delegate = context.coordinator
        view.isRichText = false
        view.allowsUndo = true
        view.font = .systemFont(ofSize: 16)
        view.textColor = NSColor(Color.seshatBodyText)
        view.insertionPointColor = NSColor(Color.seshatAccent)
        view.drawsBackground = false
        view.textContainerInset = NSSize(width: 0, height: 2)
        view.isVerticallyResizable = false
        view.isHorizontallyResizable = false
        view.textContainer?.widthTracksTextView = true
        view.textContainer?.lineFragmentPadding = 0
        view.string = text
        view.setContentHuggingPriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        DispatchQueue.main.async { [weak view] in
            guard let view else { return }
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ view: GrowingTextView, context: Context) {
        if view.string != text {
            view.string = text
            view.invalidateIntrinsicContentSize()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textDidChange(_ notification: Notification) {
            guard let view = notification.object as? NSTextView else { return }
            text = view.string
        }
    }

    final class GrowingTextView: NSTextView {
        override var intrinsicContentSize: NSSize {
            guard let layoutManager, let textContainer else {
                return super.intrinsicContentSize
            }
            layoutManager.ensureLayout(for: textContainer)
            let used = layoutManager.usedRect(for: textContainer)
            return NSSize(
                width: NSView.noIntrinsicMetric,
                height: ceil(used.height + textContainerInset.height * 2)
            )
        }

        override func didChangeText() {
            super.didChangeText()
            invalidateIntrinsicContentSize()
        }

        override func layout() {
            super.layout()
            invalidateIntrinsicContentSize()
        }
    }
}
