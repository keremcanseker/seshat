import SwiftUI

/// A fenced code block for paper, one `Text` per source line so each line reports
/// its own frame and a page break can never fall through the middle of one.
struct PrintCodeBlock: View {
    private let lines: [String]

    init(content: String) {
        lines = content
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { $0.isEmpty ? " " : String($0) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Lines repeat, so identity comes from their position; the content never changes after init.
            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                Text(line)
                    .printBlock(.keepTogether)
            }
        }
        .font(.system(size: 10.5, design: .monospaced))
        .foregroundStyle(PrintInk.body)
        .fixedSize(horizontal: false, vertical: true)
    }
}
