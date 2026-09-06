import XCTest
@testable import Seshat

final class SeshatURLTests: XCTestCase {
    func testExportURLCarriesSourceOutputAndOrientation() throws {
        let url = try XCTUnwrap(URL(string: "seshat://export?path=/tmp/a%20b.md&out=/tmp/out.pdf&landscape=1"))
        XCTAssertEqual(
            SeshatURL.action(for: url),
            .exportPDF(
                source: URL(fileURLWithPath: "/tmp/a b.md").standardizedFileURL,
                output: URL(fileURLWithPath: "/tmp/out.pdf").standardizedFileURL,
                landscape: true
            )
        )
    }

    func testExportURLWithoutOutputIsRejected() throws {
        let url = try XCTUnwrap(URL(string: "seshat://export?path=/tmp/a.md"))
        XCTAssertNil(SeshatURL.action(for: url))
    }
}
