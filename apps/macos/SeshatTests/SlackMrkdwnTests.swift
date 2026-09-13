import XCTest
@testable import Seshat

final class SlackMrkdwnTests: XCTestCase {
    func testConvertsStructureSlackCanPaste() {
        let markdown = """
        # Title

        Some **bold**, *soft* and `code`, a [link](https://x.y) and ~~gone~~.

        - one
        - two
            - nested **b**
                1. deep
        - three

        > quoted

        ```swift
        let x = 1
        ```

        | Name | Qty |
        |------|-----|
        | Ink | 2 |
        | Papyrus | 10 |

        ---

        End.
        """

        let expected = """
        *Title*

        Some *bold*, _soft_ and `code`, a link (https://x.y) and ~gone~.

        • one
        • two
            • nested *b*
                1. deep
        • three

        > quoted

        ```
        let x = 1
        ```

        ```
        Name    | Qty
        --------|----
        Ink     | 2
        Papyrus | 10
        ```

        End.
        """

        XCTAssertEqual(SlackMrkdwn.render(markdown), expected)
    }
}
