import PDFKit
import XCTest
@testable import Seshat

@MainActor
final class PDFExporterTests: XCTestCase {
    private var fixture: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()  // SeshatTests
            .deletingLastPathComponent()  // macos
            .deletingLastPathComponent()  // apps
            .deletingLastPathComponent()  // repo root
            .appendingPathComponent("samples/export.md")
    }

    func testFixtureExportsEveryBlockAsVectorText() async throws {
        let markdown = try String(contentsOf: fixture, encoding: .utf8)
        let output = FileManager.default.temporaryDirectory
            .appendingPathComponent("seshat-export-test-\(UUID().uuidString).pdf")
        defer { try? FileManager.default.removeItem(at: output) }

        try await PDFExporter.export(
            MarkdownParser.parse(markdown),
            baseURL: fixture.deletingLastPathComponent(),
            to: output,
            landscape: false
        )

        let document = try XCTUnwrap(PDFDocument(url: output))
        let text = try XCTUnwrap(document.string)
        XCTAssertGreaterThan(document.pageCount, 5)
        XCTAssertTrue(text.contains("Seshat PDF Export Fixture"), "first heading missing")
        XCTAssertTrue(text.contains("value120"), "long code block was truncated")
        XCTAssertTrue(text.contains("item-70"), "tall table was truncated")
        XCTAssertTrue(text.contains("Paragraph 12."), "last section missing")
        let bytes = try XCTUnwrap(FileManager.default.attributesOfItem(atPath: output.path)[.size] as? Int)
        XCTAssertLessThan(bytes, 2_000_000, "output looks rasterised")

        for index in 0..<document.pageCount {
            // Newlines collapse so a soft wrap inside the phrase still counts as one line.
            let pageText = (document.page(at: index)?.string ?? "").replacing("\n", with: " ")
            XCTAssertEqual(
                pageText.components(separatedBy: "let value").count,
                pageText.components(separatedBy: "column edge").count,
                "a code line is split across page \(index + 1)"
            )
        }

        let outline = try XCTUnwrap(document.outlineRoot)
        XCTAssertEqual(outline.child(at: 0)?.label, "Seshat PDF Export Fixture")
        XCTAssertEqual(outline.child(at: 0)?.child(at: 0)?.label, "Body paragraphs and inline styles")
        XCTAssertEqual(outline.child(at: 1)?.label, "Chained headings")
        let tail = try XCTUnwrap(outline.child(at: 1)?.child(at: 4))
        XCTAssertEqual(tail.label, "Tail")
        let tailPageText = try XCTUnwrap(tail.destination?.page?.string)
        XCTAssertTrue(tailPageText.contains("Paragraph 1."), "Tail bookmark points at the wrong page")
    }

    func testExistingFileIsReplacedAtomically() async throws {
        let output = FileManager.default.temporaryDirectory
            .appendingPathComponent("seshat-export-replace-\(UUID().uuidString).pdf")
        defer { try? FileManager.default.removeItem(at: output) }
        try Data("not a pdf".utf8).write(to: output)

        try await PDFExporter.export(MarkdownParser.parse("# One\n\nline"), baseURL: output, to: output, landscape: true)

        XCTAssertEqual(PDFDocument(url: output)?.pageCount, 1)
    }
}
