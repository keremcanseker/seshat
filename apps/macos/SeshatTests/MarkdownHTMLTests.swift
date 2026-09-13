import XCTest
@testable import Seshat

final class MarkdownHTMLTests: XCTestCase {
    func testKeepsTablesNestedListsAndFences() {
        let markdown = """
        ## Title

        Some **bold** & a [link](https://x.y).

        - one
            - nested
        - two

        ```swift
        let x = 1 < 2
        ```

        | Name | Qty |
        |------|-----|
        | Ink | 2 |
        """

        let expected = """
        <h2>Title</h2>
        <p>Some <strong>bold</strong> &amp; a <a href="https://x.y">link</a>.</p>
        <ul>
        <li><p>one</p>
        <ul>
        <li><p>nested</p>
        </li>
        </ul>
        </li>
        <li><p>two</p>
        </li>
        </ul>
        <pre><code>let x = 1 &lt; 2
        </code></pre>
        <table>
        <tr><th>Name</th><th>Qty</th></tr>
        <tr><td>Ink</td><td>2</td></tr>
        </table>

        """

        XCTAssertEqual(MarkdownHTML.render(markdown), expected)
    }
}
