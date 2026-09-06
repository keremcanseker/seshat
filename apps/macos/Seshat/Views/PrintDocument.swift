import MarkdownUI
import SwiftUI

/// The whole document laid out at print width, never lazily. Blocks report their
/// frames into `sink` during layout, which is the only moment `ImageRenderer`
/// gives us: it renders once and runs no callbacks afterwards.
struct PrintDocument: View {
    /// Collects block frames; layout may visit a block more than once, so repeats are dropped.
    final class Sink {
        private(set) var blocks: [PageLayout.Block] = []
        private var seen: Set<PageLayout.Block> = []

        func record(_ block: PageLayout.Block) {
            if seen.insert(block).inserted {
                blocks.append(block)
            }
        }
    }

    static let coordinateSpace = "seshat.print"

    let sections: [MarkdownSection]
    let width: CGFloat
    let baseURL: URL
    let remoteImages: [URL: Data]
    let sink: Sink

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(sections) { section in
                Markdown(section.content, baseURL: baseURL)
                    .markdownTheme(.seshatPrint)
                    .markdownImageProvider(PrintImageProvider(baseURL: baseURL, remoteImages: remoteImages))
            }
        }
        .frame(width: width, alignment: .leading)
        .coordinateSpace(.named(Self.coordinateSpace))
        .background(Color.white)
        .environment(\.printSink, sink)
    }
}
