import SwiftUI

/// Records one block's frame into the print sink while the print layout runs.
///
/// Reporting happens as a side effect of `body` rather than through preferences:
/// `anchorPreference` replaces what nested blocks reported, and its transforming
/// variant crashes inside SwiftUI when the tree is rendered by `ImageRenderer`.
struct PrintBlockReporter: View {
    let block: PageLayout.Block

    @Environment(\.printSink) private var sink

    var body: some View {
        let _ = sink?.record(block)
        Color.clear
    }
}

extension EnvironmentValues {
    @Entry var printSink: PrintDocument.Sink?
}

extension View {
    /// Reports this block's bounds to the print layout. Apply before any outer
    /// padding so the reported rect excludes the block's own margins.
    func printBlock(_ kind: PageLayout.BlockKind, title: String? = nil, level: Int = 0) -> some View {
        background {
            GeometryReader { geometry in
                PrintBlockReporter(block: PageLayout.Block(
                    kind: kind,
                    rect: geometry.frame(in: .named(PrintDocument.coordinateSpace)),
                    title: title,
                    level: level
                ))
            }
        }
    }
}
