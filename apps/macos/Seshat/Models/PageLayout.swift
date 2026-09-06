import CoreGraphics

/// Pure page-break computation for PDF export. Rects are in document
/// coordinates (y grows downward), heights in points.
enum PageLayout {
    enum BlockKind {
        /// Never the last thing on a page: travels with the block below it.
        case heading
        /// Code line, image, table cell: moves whole to the next page when it fits on one.
        case keepTogether
        /// A whole table; when it must span pages its header row is repeated.
        case table
        /// A header-row cell of a table.
        case tableHeader
        /// Paragraph, list item, blockquote: kept whole when it fits on a page, sliced when taller.
        case breakable
    }

    /// Ordered top to bottom; at the same top edge the taller (outer) block comes first.
    struct Block: Hashable, Comparable {
        let kind: BlockKind
        let rect: CGRect
        /// Heading text and level, used for the PDF outline.
        var title: String? = nil
        var level: Int = 0

        static func < (lhs: Block, rhs: Block) -> Bool {
            lhs.rect.minY < rhs.rect.minY
                || (lhs.rect.minY == rhs.rect.minY && lhs.rect.height > rhs.rect.height)
        }
    }

    struct Page: Equatable {
        /// Document y-offset where this page's content starts.
        let start: CGFloat
        /// A table header row (document rect) to draw again above the content.
        var repeatedHeader: CGRect? = nil
    }

    /// How much of the block after a heading has to fit with it.
    static let headingLookahead: CGFloat = 48

    /// Splits the document into pages. The first page always starts at 0.
    static func pages(contentHeight: CGFloat, pageHeight: CGFloat, blocks: [Block]) -> [Page] {
        guard pageHeight > 0 else { return [Page(start: 0)] }
        let sorted = blocks.sorted()
        let tables = sorted.filter { $0.kind == .table }
        let headerCells = sorted.filter { $0.kind == .tableHeader }

        // Everything that fits on a page is kept whole; only oversize blocks are sliced at the edge.
        // ponytail: a paragraph taller than a page still slices through a text line; measure lines if it shows up.
        var keeps: [(rect: CGRect, nested: Bool)] = sorted.compactMap { block in
            guard block.rect.height <= pageHeight else { return nil }
            switch block.kind {
            case .heading: return nil
            case .keepTogether, .table, .tableHeader: return (block.rect, false)
            case .breakable: return (block.rect, true)
            }
        }
        // A heading (through any directly chained headings) plus a few lines of what follows.
        for (i, block) in sorted.enumerated() where block.kind == .heading {
            var j = i + 1
            while j < sorted.count, sorted[j].kind == .heading { j += 1 }
            var bottom = block.rect.maxY
            if j < sorted.count {
                let next = sorted[j].rect
                bottom = min(next.maxY, next.minY + headingLookahead)
            }
            let rect = CGRect(x: 0, y: block.rect.minY, width: 1, height: bottom - block.rect.minY)
            keeps.append((rect, false))
        }

        var pages = [Page(start: 0)]
        var pageStart: CGFloat = 0
        var carried: CGFloat = 0
        while contentHeight - pageStart > pageHeight - carried + 0.5 {
            let limit = pageStart + pageHeight - carried
            let crossing = keeps.filter {
                $0.rect.minY < limit && $0.rect.maxY > limit && $0.rect.minY > pageStart + 0.5
            }
            // Among nested breakables (list item > paragraph) the innermost crossing one decides,
            // so a long list is not pushed to the next page wholesale.
            let candidates = crossing.filter { keep in
                !keep.nested || !crossing.contains { other in
                    other.nested && other.rect != keep.rect
                        && other.rect.minY >= keep.rect.minY && other.rect.maxY <= keep.rect.maxY
                }
            }
            var cut = candidates.map(\.rect.minY).min() ?? limit

            var repeatedHeader: CGRect?
            if let table = tables.first(where: { $0.rect.minY < cut && $0.rect.maxY > cut }),
               let header = headerRect(of: table, cells: headerCells) {
                if cut <= header.maxY + 0.5, table.rect.minY > pageStart + 0.5 {
                    // Never strand a header row alone at the bottom of a page.
                    cut = table.rect.minY
                } else if header.maxY <= cut {
                    repeatedHeader = header
                }
            }

            pages.append(Page(start: cut, repeatedHeader: repeatedHeader))
            pageStart = cut
            carried = repeatedHeader?.height ?? 0
        }
        return pages
    }

    private static func headerRect(of table: Block, cells: [Block]) -> CGRect? {
        cells
            .filter { $0.rect.minY >= table.rect.minY - 0.5 && $0.rect.maxY <= table.rect.maxY + 0.5 }
            .map(\.rect)
            .reduce(nil) { union, rect in union.map { $0.union(rect) } ?? rect }
    }
}
