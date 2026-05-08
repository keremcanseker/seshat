import SwiftUI

struct MarkdownOutline: View {
    let entries: [OutlineEntry]
    let activeId: String?
    let onSelect: (OutlineEntry) -> Void

    private var baseLevel: Int {
        entries.map(\.level).min() ?? 1
    }

    private var resolvedActiveId: String? {
        activeId ?? entries.first?.id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("OUTLINE")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .tracking(1.2)
                .foregroundStyle(Color.seshatFaint)
                .padding(.leading, 14)

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(entries) { entry in
                        OutlineEntryRow(
                            entry: entry,
                            depth: max(0, entry.level - baseLevel),
                            isActive: entry.id == resolvedActiveId,
                            onSelect: { onSelect(entry) }
                        )
                    }
                }
                .background(alignment: .leading) {
                    Rectangle()
                        .fill(Color.seshatRuleStrong)
                        .frame(width: 0.5)
                }
            }
            .scrollIndicators(.never)
        }
        .frame(width: 200, alignment: .leading)
    }
}
