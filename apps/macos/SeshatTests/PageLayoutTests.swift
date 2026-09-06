import XCTest
@testable import Seshat

final class PageLayoutTests: XCTestCase {
    private let page: CGFloat = 700

    private func block(_ kind: PageLayout.BlockKind, _ y: CGFloat, _ height: CGFloat) -> PageLayout.Block {
        PageLayout.Block(kind: kind, rect: CGRect(x: 0, y: y, width: 400, height: height))
    }

    private func starts(_ contentHeight: CGFloat, _ blocks: [PageLayout.Block]) -> [CGFloat] {
        PageLayout.pages(contentHeight: contentHeight, pageHeight: page, blocks: blocks).map(\.start)
    }

    func testShortDocumentIsOnePage() {
        XCTAssertEqual(starts(500, []), [0])
    }

    func testCodeBlockCrossingTheEdgeMovesToNextPage() {
        XCTAssertEqual(starts(900, [block(.breakable, 0, 500), block(.keepTogether, 520, 300)]), [0, 520])
    }

    func testBlockTallerThanPageIsSlicedAtTheEdge() {
        XCTAssertEqual(starts(1600, [block(.keepTogether, 20, 1500)]), [0, 700, 1400])
    }

    func testHeadingTravelsWithFollowingBlock() {
        // Heading ends before the edge, its paragraph starts right after: both move.
        let blocks = [block(.breakable, 0, 640), block(.heading, 660, 24), block(.breakable, 700, 200)]
        XCTAssertEqual(starts(1000, blocks), [0, 660])
    }

    func testChainedHeadingsMoveTogether() {
        let blocks = [
            block(.breakable, 0, 600),
            block(.heading, 620, 30),
            block(.heading, 660, 24),
            block(.breakable, 700, 200),
        ]
        XCTAssertEqual(starts(1000, blocks), [0, 620])
    }

    func testInnermostListItemDecidesForNestedBreakables() {
        // A whole list (300pt) contains items; the item crossing the edge moves, not the list.
        let blocks = [
            block(.breakable, 500, 300),
            block(.breakable, 500, 100),
            block(.breakable, 620, 100),
            block(.breakable, 740, 60),
        ]
        XCTAssertEqual(starts(900, blocks), [0, 620])
    }

    func testParagraphThatFitsOnAPageMovesWhole() {
        XCTAssertEqual(starts(900, [block(.breakable, 300, 500)]), [0, 300])
    }

    func testParagraphTallerThanPageIsSliced() {
        XCTAssertEqual(starts(1000, [block(.breakable, 50, 900)]), [0, 700])
    }

    func testTallTableSplitsBetweenRowsAndRepeatsItsHeader() {
        // Header 20..60, then 40pt rows. Row boundaries drive the cuts; each continuation
        // page carries the header, which shrinks the room left for rows.
        var blocks = [block(.table, 20, 1500), block(.tableHeader, 20, 40)]
        for row in 0..<36 {
            blocks.append(block(.keepTogether, 60 + CGFloat(row) * 40, 40))
        }
        let pages = PageLayout.pages(contentHeight: 1600, pageHeight: page, blocks: blocks)
        let header = CGRect(x: 0, y: 20, width: 400, height: 40)
        XCTAssertEqual(pages, [
            PageLayout.Page(start: 0),
            PageLayout.Page(start: 700, repeatedHeader: header),
            PageLayout.Page(start: 1340, repeatedHeader: header),
        ])
    }

    func testHeaderRowIsNeverStrandedAtThePageBottom() {
        // Only the header fits before the edge: the whole table moves instead.
        let blocks = [
            block(.breakable, 0, 640),
            block(.table, 650, 400),
            block(.tableHeader, 650, 40),
            block(.keepTogether, 690, 40),
            block(.keepTogether, 730, 40),
        ]
        XCTAssertEqual(PageLayout.pages(contentHeight: 1100, pageHeight: page, blocks: blocks), [
            PageLayout.Page(start: 0),
            PageLayout.Page(start: 650),
        ])
    }
}
