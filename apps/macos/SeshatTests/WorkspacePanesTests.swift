import XCTest
@testable import Seshat

@MainActor
final class WorkspacePanesTests: XCTestCase {
    private var root: URL!
    private var defaults: UserDefaults!
    private var suite: String!

    override func setUp() async throws {
        suite = "SeshatTests.WorkspacePanes.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suite)
        root = FileManager.default.temporaryDirectory
            .appendingPathComponent("seshat-panes-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
    }

    override func tearDown() async throws {
        defaults.removePersistentDomain(forName: suite)
        try? FileManager.default.removeItem(at: root)
    }

    // MARK: Helpers

    private func file(_ name: String, in folder: String = "n") throws -> URL {
        let dir = root.appendingPathComponent(folder, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent(name)
        try "# \(name)".write(to: url, atomically: true, encoding: .utf8)
        return url.seshatNormalized
    }

    private func make() -> WorkspacePanes {
        WorkspacePanes(defaults: defaults)
    }

    /// Every pane's tab names, left to right.
    private func layout(_ panes: WorkspacePanes) -> [[String]] {
        panes.panes.map { $0.tabs.map(\.lastPathComponent) }
    }

    private func focusedIndex(_ panes: WorkspacePanes) -> Int? {
        panes.panes.firstIndex { $0 === panes.focused }
    }

    // MARK: Splitting

    func testSplitOpensTheFocusedDocumentInANewPaneOnTheRight() throws {
        let a = try file("a.md"), b = try file("b.md")
        let panes = make()
        panes.focused.open(a); panes.focused.open(b)
        panes.split()
        XCTAssertEqual(layout(panes), [["a.md", "b.md"], ["b.md"]])
        XCTAssertEqual(focusedIndex(panes), 1)

        panes.focus(panes.panes[0])
        panes.split()
        XCTAssertEqual(layout(panes), [["a.md", "b.md"], ["b.md"], ["b.md"]], "a new pane goes right after the focused one")
        XCTAssertEqual(focusedIndex(panes), 1)

        XCTAssertFalse(panes.canSplit)
        panes.split()
        XCTAssertEqual(panes.panes.count, WorkspacePanes.maxPanes)
    }

    func testSplitNeedsADocument() {
        let panes = make()
        XCTAssertFalse(panes.canSplit)
        panes.split()
        XCTAssertEqual(panes.panes.count, 1)
    }

    func testOpenToSideReusesTheRightNeighbourAndAtTheLimitTheLeftOne() throws {
        let a = try file("a.md"), b = try file("b.md"), c = try file("c.md"), d = try file("d.md")
        let panes = make()
        panes.focused.open(a)
        panes.openToSide(b)
        XCTAssertEqual(layout(panes), [["a.md"], ["b.md"]])
        XCTAssertEqual(focusedIndex(panes), 1)

        panes.openToSide(c, of: panes.panes[0])
        XCTAssertEqual(layout(panes), [["a.md"], ["b.md", "c.md"]], "an existing right neighbour takes it")

        panes.openToSide(d)
        panes.openToSide(a)
        XCTAssertEqual(layout(panes), [["a.md"], ["b.md", "c.md", "a.md"], ["d.md"]], "past the limit the rightmost pane's side is its left")
        XCTAssertEqual(focusedIndex(panes), 1)
    }

    // MARK: Opening in the current tab

    func testReplaceActiveSwapsInPlaceAndTheOldDocumentCanBeReopened() throws {
        let a = try file("a.md"), b = try file("b.md"), c = try file("c.md")
        let panes = make()
        let tabs = panes.focused
        tabs.replaceActive(with: a)
        XCTAssertEqual(layout(panes), [["a.md"]], "an empty pane just opens it")

        tabs.open(b); tabs.activate(a)
        tabs.replaceActive(with: c)
        XCTAssertEqual(layout(panes), [["c.md", "b.md"]])
        XCTAssertEqual(tabs.active, c)

        tabs.replaceActive(with: b)
        XCTAssertEqual(layout(panes), [["c.md", "b.md"]], "an open file is only activated")
        XCTAssertEqual(tabs.active, b)

        panes.reopenLast()
        XCTAssertEqual(layout(panes), [["a.md", "c.md", "b.md"]])
    }

    // MARK: Moving between panes

    func testMoveBetweenPanesClosesAnEmptiedSourceWithoutAReopenEntry() throws {
        let a = try file("a.md"), b = try file("b.md"), c = try file("c.md")
        let panes = make()
        panes.focused.open(a); panes.focused.open(b)
        panes.openToSide(c)
        let left = panes.panes[0], right = panes.panes[1]

        panes.move(a, from: left, to: right, at: 0)
        XCTAssertEqual(layout(panes), [["b.md"], ["a.md", "c.md"]])
        XCTAssertEqual(right.active, a)
        XCTAssertTrue(panes.focused === right)

        panes.move(b, from: left, to: right, at: 99)
        XCTAssertEqual(layout(panes), [["a.md", "c.md", "b.md"]], "the emptied pane closes")
        XCTAssertFalse(panes.canReopen, "a move is not a close")
    }

    func testMoveOntoAPaneThatHasTheTabAlreadyJustActivatesIt() throws {
        let a = try file("a.md"), b = try file("b.md")
        let panes = make()
        panes.focused.open(a); panes.focused.open(b)
        panes.openToSide(a)
        let left = panes.panes[0], right = panes.panes[1]
        panes.move(a, from: left, to: right, at: 0)
        XCTAssertEqual(layout(panes), [["b.md"], ["a.md"]])
    }

    func testMoveToSideMakesANewPaneBesideTheTarget() throws {
        let a = try file("a.md"), b = try file("b.md")
        let panes = make()
        panes.focused.open(a); panes.focused.open(b)
        let only = panes.focused
        panes.moveToSide(a, from: only, of: only)
        XCTAssertEqual(layout(panes), [["b.md"], ["a.md"]])
        XCTAssertEqual(focusedIndex(panes), 1)
    }

    // MARK: Closing panes

    func testClosingAPanesLastTabClosesItAndFocusesTheLeftNeighbour() throws {
        let a = try file("a.md"), b = try file("b.md"), c = try file("c.md")
        let panes = make()
        panes.focused.open(a)
        panes.openToSide(b)
        panes.openToSide(c)
        XCTAssertEqual(focusedIndex(panes), 2)

        panes.focused.close(c)
        XCTAssertEqual(layout(panes), [["a.md"], ["b.md"]])
        XCTAssertEqual(focusedIndex(panes), 1)

        panes.focus(panes.panes[0])
        panes.panes[0].closeAll()
        XCTAssertEqual(layout(panes), [["b.md"]])
        XCTAssertEqual(focusedIndex(panes), 0)

        panes.focused.close(b)
        XCTAssertEqual(panes.panes.count, 1, "the last pane stays, empty")
        XCTAssertNil(panes.focused.active)
    }

    // MARK: Reopen

    func testReopenRestoresMostRecentFirstAtFormerIndex() throws {
        let a = try file("a.md"), b = try file("b.md"), c = try file("c.md")
        let panes = make()
        let tabs = panes.focused
        tabs.open(a); tabs.open(b); tabs.open(c)
        tabs.close(b)
        tabs.close(a)
        XCTAssertEqual(layout(panes), [["c.md"]])

        XCTAssertTrue(panes.canReopen)
        panes.reopenLast()
        XCTAssertEqual(layout(panes), [["a.md", "c.md"]])
        XCTAssertEqual(tabs.active, a)

        panes.reopenLast()
        XCTAssertEqual(layout(panes), [["a.md", "b.md", "c.md"]])
        XCTAssertEqual(tabs.active, b)

        XCTAssertFalse(panes.canReopen)
        panes.reopenLast()
        XCTAssertEqual(layout(panes), [["a.md", "b.md", "c.md"]])
    }

    func testReopenIndexIsClampedAndDeletedFileReopensMissing() throws {
        let a = try file("a.md"), b = try file("b.md"), c = try file("c.md")
        let panes = make()
        let tabs = panes.focused
        tabs.open(a); tabs.open(b); tabs.open(c)
        tabs.close(c)
        tabs.close(a)
        tabs.close(b)
        try FileManager.default.removeItem(at: c)

        panes.reopenLast()   // b, index 1 clamped to 0
        XCTAssertEqual(layout(panes), [["b.md"]])
        panes.reopenLast()   // a at 0
        panes.reopenLast()   // c at 2
        XCTAssertEqual(layout(panes), [["a.md", "b.md", "c.md"]])
        XCTAssertTrue(tabs.isMissing(c))
    }

    func testReopenGoesBackToItsPaneOrTheFocusedOneOnceThatClosed() throws {
        let a = try file("a.md"), b = try file("b.md"), c = try file("c.md")
        let panes = make()
        panes.focused.open(a)
        panes.openToSide(b); panes.openToSide(c, of: panes.panes[0])   // [[a], [b, c]]
        panes.panes[1].close(b)
        panes.focus(panes.panes[0])
        panes.reopenLast()
        XCTAssertEqual(layout(panes), [["a.md"], ["b.md", "c.md"]], "back in its own pane")
        XCTAssertEqual(focusedIndex(panes), 1)

        panes.panes[1].closeAll()   // the pane closes with it
        panes.reopenLast()
        XCTAssertEqual(layout(panes), [["b.md", "a.md"]], "its pane is gone, so the focused one takes it")
    }

    // MARK: Disk changes

    func testRemapAndDeleteReachEveryPaneAndTheReopenStack() throws {
        let a = try file("a.md", in: "old"), b = try file("b.md", in: "old"), x = try file("x.md", in: "other")
        let panes = make()
        panes.focused.open(a); panes.focused.open(x)
        panes.openToSide(b)
        panes.panes[0].close(a)

        let oldFolder = root.appendingPathComponent("old", isDirectory: true)
        let newFolder = root.appendingPathComponent("new", isDirectory: true)
        try FileManager.default.moveItem(at: oldFolder, to: newFolder)
        panes.remap(from: oldFolder, to: newFolder)
        XCTAssertEqual(panes.panes[1].active?.deletingLastPathComponent().lastPathComponent, "new")

        panes.focus(panes.panes[0])
        panes.reopenLast()
        XCTAssertEqual(panes.panes[0].active?.deletingLastPathComponent().lastPathComponent, "new")
        XCTAssertFalse(panes.panes[0].isMissing(panes.panes[0].active!))

        panes.closeDeleted(newFolder)
        XCTAssertEqual(layout(panes), [["x.md"]], "the pane holding only deleted files closes")
    }

    // MARK: Persistence

    func testPersistenceRoundTripKeepsPanesActiveTabsAndFocus() throws {
        let a = try file("a.md"), b = try file("b.md"), c = try file("c.md")
        let first = make()
        first.focused.open(a); first.focused.open(b); first.focused.activate(a)
        first.openToSide(c)
        first.focus(first.panes[0])

        let second = make()
        XCTAssertEqual(layout(second), [["a.md", "b.md"], ["c.md"]])
        XCTAssertEqual(second.panes[0].active, a)
        XCTAssertEqual(focusedIndex(second), 0)
    }

    func testLoadDropsPanesWhoseFilesAreGone() throws {
        let a = try file("a.md"), b = try file("b.md")
        let first = make()
        first.focused.open(a)
        first.openToSide(b)
        try FileManager.default.removeItem(at: b)

        let second = make()
        XCTAssertEqual(layout(second), [["a.md"]])
        XCTAssertEqual(focusedIndex(second), 0, "the stored focus pointed past the last pane")
    }

    func testLoadSurvivesCorruptValues() {
        defaults.set("not an array", forKey: WorkspacePanes.panesKey)
        defaults.set("nope", forKey: WorkspacePanes.focusedKey)
        let panes = make()
        XCTAssertEqual(panes.panes.count, 1)
        XCTAssertNil(panes.focused.active)
    }
}
