import XCTest
@testable import Seshat

final class SitePublisherTests: XCTestCase {
    func testCollectsMarkdownFilesAsRelativePathsWithoutExtension() throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("seshat-site-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: root) }
        let files = [
            "README.md": "# Hello",
            "guides/setup.MD": "# Setup",
            "guides/notes.txt": "not markdown",
            "empty.md": "  \n",
            ".hidden/secret.md": "# Hidden",
        ]
        for (path, content) in files {
            let url = root.appendingPathComponent(path)
            try FileManager.default.createDirectory(
                at: url.deletingLastPathComponent(), withIntermediateDirectories: true
            )
            try content.write(to: url, atomically: true, encoding: .utf8)
        }

        let pages = try SitePublisher.collectPages(in: root)

        XCTAssertEqual(pages.map(\.path), ["README", "guides/setup"])
        XCTAssertEqual(pages.map(\.title), ["README", "setup"])
        XCTAssertEqual(pages.first?.content, "# Hello")
    }
}
