import XCTest
@testable import Seshat

@MainActor
final class WorkspaceTabsTests: XCTestCase {
    private var root: URL!

    override func setUp() async throws {
        root = FileManager.default.temporaryDirectory
            .appendingPathComponent("seshat-tabs-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: root)
    }

    // MARK: Helpers

    @discardableResult
    private func file(_ folder: String, _ name: String) throws -> URL {
        let dir = root.appendingPathComponent(folder, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent(name)
        try "# \(name)".write(to: url, atomically: true, encoding: .utf8)
        return url.seshatNormalized
    }

    private func make() -> WorkspaceTabs {
        WorkspaceTabs()
    }

    private func names(_ tabs: WorkspaceTabs) -> [String] {
        tabs.tabs.map(\.lastPathComponent)
    }

    // MARK: Opening

    func testOpenAppendsInOrderAndDedupes() throws {
        let a = try file("notes", "a.md"), b = try file("notes", "b.md"), c = try file("notes", "c.md")
        let tabs = make()
        tabs.open(a); tabs.open(b); tabs.open(c)
        XCTAssertEqual(names(tabs), ["a.md", "b.md", "c.md"])
        XCTAssertEqual(tabs.active, c)

        tabs.open(a)
        XCTAssertEqual(names(tabs), ["a.md", "b.md", "c.md"])
        XCTAssertEqual(tabs.active, a)
    }

    func testOpenNormalisesPathVariants() throws {
        let a = try file("notes", "a.md")
        let tabs = make()
        tabs.open(a)
        tabs.open(URL(fileURLWithPath: a.path + "/../a.md"))
        tabs.open(URL(fileURLWithPath: root.path + "/notes/./a.md"))
        XCTAssertEqual(tabs.tabs.count, 1)
    }

    func testPreviewOpenReusesOneTabUntilPinned() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md"), c = try file("n", "c.md"), d = try file("n", "d.md")
        let tabs = make()
        tabs.open(a)
        tabs.open(b, asPreview: true)
        tabs.open(c, asPreview: true)
        XCTAssertEqual(names(tabs), ["a.md", "c.md"], "the preview tab is replaced in place")
        XCTAssertTrue(tabs.isPreview(c))
        XCTAssertEqual(tabs.active, c)

        tabs.pin(c)
        XCTAssertFalse(tabs.isPreview(c))
        tabs.open(d, asPreview: true)
        XCTAssertEqual(names(tabs), ["a.md", "c.md", "d.md"])
        XCTAssertTrue(tabs.isPreview(d))

        tabs.open(d)
        XCTAssertFalse(tabs.isPreview(d), "an explicit open pins the preview")
        tabs.open(a, asPreview: true)
        XCTAssertEqual(tabs.active, a)
        XCTAssertFalse(tabs.isPreview(a), "an already open permanent tab stays permanent")
    }

    func testPreviewIsClearedByCloseAndPinnedByMove() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md")
        let tabs = make()
        tabs.open(a)
        tabs.open(b, asPreview: true)
        tabs.move(from: 1, to: 0)
        XCTAssertFalse(tabs.isPreview(b))

        tabs.open(a, asPreview: true)
        let c = try file("n", "c.md")
        tabs.open(c, asPreview: true)
        XCTAssertTrue(tabs.isPreview(c))
        tabs.close(c)
        XCTAssertNil(tabs.preview)
    }

    func testOpenBeyondCapEvictsLeftmostInactive() throws {
        let tabs = make()
        let urls = try (0..<WorkspaceTabs.maxTabs).map { try file("n", "t\($0).md") }
        for url in urls { tabs.open(url) }
        tabs.activate(urls[0])
        let extra = try file("n", "extra.md")
        tabs.open(extra)
        XCTAssertEqual(tabs.tabs.count, WorkspaceTabs.maxTabs)
        XCTAssertEqual(tabs.tabs.first, urls[0], "the active tab is never evicted")
        XCTAssertEqual(tabs.tabs[1], urls[2], "the leftmost inactive tab made room")
        XCTAssertEqual(tabs.active, extra)
    }

    func testOpenOfMissingFileIsMarkedMissing() throws {
        let ghost = root.appendingPathComponent("notes/ghost.md")
        let tabs = make()
        tabs.open(ghost)
        XCTAssertTrue(tabs.isMissing(ghost))
        XCTAssertEqual(tabs.active?.seshatMatches(ghost), true)
    }

    // MARK: Closing

    func testCloseActiveInMiddleActivatesRightNeighbour() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md"), c = try file("n", "c.md")
        let tabs = make()
        tabs.open(a); tabs.open(b); tabs.open(c); tabs.activate(b)
        tabs.close(b)
        XCTAssertEqual(names(tabs), ["a.md", "c.md"])
        XCTAssertEqual(tabs.active, c)
    }

    func testCloseActiveLastActivatesLeftNeighbour() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md")
        let tabs = make()
        tabs.open(a); tabs.open(b)
        tabs.close(b)
        XCTAssertEqual(tabs.active, a)
    }

    func testCloseNonActiveKeepsActive() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md"), c = try file("n", "c.md")
        let tabs = make()
        tabs.open(a); tabs.open(b); tabs.open(c); tabs.activate(a)
        tabs.close(c)
        XCTAssertEqual(tabs.active, a)
        XCTAssertEqual(names(tabs), ["a.md", "b.md"])
    }

    func testCloseOnlyTabLeavesNothing() throws {
        let a = try file("n", "a.md")
        let tabs = make()
        tabs.open(a)
        tabs.close(a)
        XCTAssertTrue(tabs.isEmpty)
        XCTAssertNil(tabs.active)
    }

    func testCloseOthersRightAndAll() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md"), c = try file("n", "c.md")
        let tabs = make()
        tabs.open(a); tabs.open(b); tabs.open(c)

        tabs.closeRight(of: b)
        XCTAssertEqual(names(tabs), ["a.md", "b.md"])
        XCTAssertEqual(tabs.active, b)

        tabs.open(c)
        tabs.closeOthers(b)
        XCTAssertEqual(names(tabs), ["b.md"])
        XCTAssertEqual(tabs.active, b)

        tabs.closeAll()
        XCTAssertTrue(tabs.isEmpty)
        XCTAssertNil(tabs.active)
    }

    func testCloseDeletedFolderClosesEveryTabUnderIt() throws {
        let a = try file("old", "a.md"), b = try file("old", "b.md"), other = try file("other", "x.md")
        let tabs = make()
        tabs.open(a); tabs.open(other); tabs.open(b)
        tabs.closeDeleted(root.appendingPathComponent("old", isDirectory: true))
        XCTAssertEqual(names(tabs), ["x.md"])
        XCTAssertEqual(tabs.active, other)

        tabs.closeDeleted(other)
        XCTAssertTrue(tabs.isEmpty)
    }

    // MARK: Navigation

    func testNextPreviousDoNotWrap() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md"), c = try file("n", "c.md")
        let tabs = make()
        tabs.open(a); tabs.open(b); tabs.open(c); tabs.activate(b)

        XCTAssertTrue(tabs.canGoNext); XCTAssertTrue(tabs.canGoPrevious)
        tabs.activateNext()
        XCTAssertEqual(tabs.active, c)
        XCTAssertFalse(tabs.canGoNext)
        tabs.activateNext()
        XCTAssertEqual(tabs.active, c)

        tabs.activatePrevious(); tabs.activatePrevious()
        XCTAssertEqual(tabs.active, a)
        XCTAssertFalse(tabs.canGoPrevious)
        tabs.activatePrevious()
        XCTAssertEqual(tabs.active, a)
    }

    func testActivateByNumberWithNineAsLast() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md"), c = try file("n", "c.md")
        let tabs = make()
        tabs.open(a); tabs.open(b); tabs.open(c)

        tabs.activate(number: 1)
        XCTAssertEqual(tabs.active, a)
        tabs.activate(number: 9)
        XCTAssertEqual(tabs.active, c)
        tabs.activate(number: 2)
        XCTAssertEqual(tabs.active, b)
        tabs.activate(number: 5)
        XCTAssertEqual(tabs.active, b, "a number beyond the count does nothing")
    }

    func testMove() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md"), c = try file("n", "c.md")
        let tabs = make()
        tabs.open(a); tabs.open(b); tabs.open(c)
        tabs.move(from: 0, to: 2)
        XCTAssertEqual(names(tabs), ["b.md", "c.md", "a.md"])
        tabs.move(from: 2, to: 0)
        XCTAssertEqual(names(tabs), ["a.md", "b.md", "c.md"])
        tabs.move(from: 1, to: 1)
        tabs.move(from: 7, to: 0)
        XCTAssertEqual(names(tabs), ["a.md", "b.md", "c.md"])
    }

    // MARK: Remap

    func testRemapFileKeepsPositionAndActive() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md")
        let tabs = make()
        tabs.open(a); tabs.open(b); tabs.activate(a)
        let a2 = try file("n", "a2.md")
        tabs.remap(from: a, to: a2)
        XCTAssertEqual(names(tabs), ["a2.md", "b.md"])
        XCTAssertEqual(tabs.active, a2)
    }

    func testRemapFolderPrefixMovesEveryTabUnderIt() throws {
        let a = try file("old", "a.md"), b = try file("old", "b.md"), other = try file("other", "x.md")
        let tabs = make()
        tabs.open(a); tabs.open(other); tabs.open(b); tabs.activate(b)

        let oldFolder = root.appendingPathComponent("old", isDirectory: true)
        let newFolder = root.appendingPathComponent("new", isDirectory: true)
        try FileManager.default.moveItem(at: oldFolder, to: newFolder)
        tabs.remap(from: oldFolder, to: newFolder)

        XCTAssertEqual(tabs.tabs.map { $0.deletingLastPathComponent().lastPathComponent }, ["new", "other", "new"])
        XCTAssertEqual(tabs.active?.lastPathComponent, "b.md")
        XCTAssertTrue(tabs.missing.isEmpty)
    }

    func testRemapOntoAlreadyOpenURLMerges() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md")
        let tabs = make()
        tabs.open(a); tabs.open(b)
        tabs.remap(from: a, to: b)
        XCTAssertEqual(names(tabs), ["b.md"])
        XCTAssertEqual(tabs.active, b)
    }

    // MARK: Missing files

    func testRefreshMissingTracksDeleteAndPutBack() throws {
        let a = try file("n", "a.md")
        let tabs = make()
        tabs.open(a)
        XCTAssertFalse(tabs.isMissing(a))

        try FileManager.default.removeItem(at: a)
        tabs.refreshMissing()
        XCTAssertTrue(tabs.isMissing(a))
        XCTAssertEqual(tabs.tabs, [a], "the tab stays open")

        try "back".write(to: a, atomically: true, encoding: .utf8)
        tabs.refreshMissing()
        XCTAssertFalse(tabs.isMissing(a))

        try FileManager.default.removeItem(at: a)
        tabs.refreshMissing()
        tabs.close(a)
        XCTAssertTrue(tabs.isEmpty)
        XCTAssertTrue(tabs.missing.isEmpty)
    }

    // MARK: Restoring

    func testRestoreDropsMissingFilesAndDuplicatesAndFallsBackToFirstTab() throws {
        let a = try file("n", "a.md"), b = try file("n", "b.md")
        let gone = root.appendingPathComponent("n/gone.md")
        let tabs = WorkspaceTabs(
            paths: [a.path, gone.path, b.path, a.path, b.path + "/../b.md"],
            active: gone.path
        )
        XCTAssertEqual(names(tabs), ["a.md", "b.md"])
        XCTAssertEqual(tabs.active, a)
        XCTAssertEqual(WorkspaceTabs(paths: [a.path, b.path], active: b.path).active, b)
    }

    // MARK: Titles

    func testDuplicateTitlesShowFolderAndRecoverOnClose() throws {
        let plan1 = try file("notes", "plan.md"), plan2 = try file("drafts", "plan.md"), other = try file("notes", "other.md")
        let tabs = make()
        tabs.open(plan1); tabs.open(plan2); tabs.open(other)
        XCTAssertEqual(tabs.title(for: plan1), "notes › plan")
        XCTAssertEqual(tabs.title(for: plan2), "drafts › plan")
        XCTAssertEqual(tabs.title(for: other), "other")

        tabs.close(plan2)
        XCTAssertEqual(tabs.title(for: plan1), "plan")
    }
}
