import SwiftUI

struct MarkdownOutline: View {
    let entries: [OutlineEntry]
    let onSelect: (OutlineEntry) -> Void

    private var baseLevel: Int {
        entries.map(\.level).min() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            ForEach(entries) { entry in
                OutlineEntryRow(
                    entry: entry,
                    indent: CGFloat(entry.level - baseLevel) * 10
                ) {
                    onSelect(entry)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .frame(width: 200, alignment: .leading)
    }
}
