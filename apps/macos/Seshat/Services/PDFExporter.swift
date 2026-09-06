import PDFKit
import SwiftUI

/// Renders a parsed document to a paginated, vector PDF with the print theme.
@MainActor
enum PDFExporter {
    enum Failure: LocalizedError {
        case renderFailed

        var errorDescription: String? {
            "Couldn't render the document as PDF."
        }
    }

    /// 2 cm on every side.
    static let margin: CGFloat = 56.7

    /// Writes the PDF atomically: a failed render never leaves a partial file at `destination`.
    static func export(_ parsed: ParsedMarkdown, baseURL: URL, to destination: URL, landscape: Bool) async throws {
        let margin = Self.margin  // the nested draw helper below is nonisolated
        let paper = NSPrintInfo.shared.paperSize
        let page = landscape
            ? CGSize(width: max(paper.width, paper.height), height: min(paper.width, paper.height))
            : CGSize(width: min(paper.width, paper.height), height: max(paper.width, paper.height))
        let contentWidth = page.width - 2 * margin
        let contentHeight = page.height - 2 * margin

        let remoteImages = await fetchRemoteImages(in: parsed)
        let sink = PrintDocument.Sink()
        let renderer = ImageRenderer(content: PrintDocument(
            sections: parsed.sections,
            width: contentWidth,
            baseURL: baseURL,
            remoteImages: remoteImages,
            sink: sink
        ))
        renderer.proposedSize = ProposedViewSize(width: contentWidth, height: nil)

        let temporary = FileManager.default.temporaryDirectory
            .appending(path: UUID().uuidString)
            .appendingPathExtension("pdf")
        var pages: [PageLayout.Page] = []
        renderer.render { size, draw in
            var mediaBox = CGRect(origin: .zero, size: page)
            let metadata: [CFString: Any] = [
                kCGPDFContextTitle: destination.deletingPathExtension().lastPathComponent,
                kCGPDFContextCreator: "Seshat",
            ]
            guard let pdf = CGContext(temporary as CFURL, mediaBox: &mediaBox, metadata as CFDictionary) else { return }
            pages = PageLayout.pages(contentHeight: size.height, pageHeight: contentHeight, blocks: sink.blocks)

            /// Draws document rows `from..<from + height` so that row `from` lands `offset` below the top margin.
            func drawSlice(from: CGFloat, height: CGFloat, offset: CGFloat) {
                pdf.saveGState()
                // Inset by half a point: a text line that merely touches the clip edge would
                // otherwise stay in the page's content stream, invisible but selectable.
                let top = page.height - margin - offset
                pdf.clip(to: CGRect(x: margin, y: top - height, width: contentWidth, height: height)
                    .insetBy(dx: 0, dy: 0.5))
                pdf.translateBy(x: margin, y: top - size.height + from)
                draw(pdf)
                pdf.restoreGState()
            }

            for (index, current) in pages.enumerated() {
                let next = index + 1 < pages.count ? pages[index + 1].start : size.height
                pdf.beginPDFPage(nil)
                var offset: CGFloat = 0
                if let header = current.repeatedHeader {
                    drawSlice(from: header.minY, height: header.height, offset: 0)
                    offset = header.height
                }
                let visible = min(contentHeight - offset, next - current.start)
                drawSlice(from: current.start, height: visible, offset: offset)
                pdf.endPDFPage()
            }
            pdf.closePDF()
        }
        guard !pages.isEmpty else {
            try? FileManager.default.removeItem(at: temporary)
            throw Failure.renderFailed
        }
        addOutline(to: temporary, blocks: sink.blocks, pages: pages, pageHeight: page.height)

        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destination.path) {
            _ = try fileManager.replaceItemAt(destination, withItemAt: temporary)
        } else {
            try fileManager.moveItem(at: temporary, to: destination)
        }
    }

    /// Bookmarks (the PDF sidebar outline) from the measured headings, nested by level.
    private static func addOutline(to url: URL, blocks: [PageLayout.Block], pages: [PageLayout.Page], pageHeight: CGFloat) {
        guard let document = PDFDocument(url: url) else { return }
        let root = PDFOutline()
        var parents: [(level: Int, node: PDFOutline)] = [(0, root)]
        let headings = blocks
            .filter { $0.kind == .heading && !($0.title ?? "").isEmpty }
            .sorted()
        for heading in headings {
            let pageIndex = pages.lastIndex { $0.start <= heading.rect.minY + 0.5 } ?? 0
            guard let page = document.page(at: pageIndex) else { continue }
            let localY = heading.rect.minY - pages[pageIndex].start
            let node = PDFOutline()
            node.label = heading.title
            node.destination = PDFDestination(page: page, at: CGPoint(x: 0, y: pageHeight - margin - localY + 8))
            while parents.count > 1, parents[parents.count - 1].level >= heading.level {
                parents.removeLast()
            }
            let parent = parents[parents.count - 1].node
            parent.insertChild(node, at: parent.numberOfChildren)
            parents.append((heading.level, node))
        }
        guard root.numberOfChildren > 0 else { return }
        document.outlineRoot = root
        document.write(to: url)
    }

    /// Downloads every `![](http…)` image up front with a short timeout, so the
    /// synchronous render has them and an unreachable host costs seconds, not a hang.
    private static func fetchRemoteImages(in parsed: ParsedMarkdown) async -> [URL: Data] {
        let pattern = /!\[[^\]]*\]\((https?:\/\/[^\s)]+)/
        var urls = Set<URL>()
        for section in parsed.sections {
            for match in section.content.matches(of: pattern) {
                if let url = URL(string: String(match.1)) { urls.insert(url) }
            }
        }
        guard !urls.isEmpty else { return [:] }

        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 10
        let session = URLSession(configuration: configuration)
        var images: [URL: Data] = [:]
        await withTaskGroup(of: (URL, Data?).self) { group in
            for url in urls {
                group.addTask { (url, try? await session.data(from: url).0) }
            }
            for await (url, data) in group {
                if let data { images[url] = data }
            }
        }
        return images
    }
}
