import SwiftUI

struct OutlineEntryRow: View {
    let entry: OutlineEntry
    let indent: CGFloat
    let onSelect: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 0) {
                Text(entry.title)
                    .font(.system(size: 11, weight: entry.level == 1 ? .medium : .regular))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer(minLength: 0)
            }
            .padding(.leading, indent + 6)
            .padding(.trailing, 6)
            .padding(.vertical, 3)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.12)) {
                isHovered = hovering
            }
        }
    }

    private var textColor: Color {
        if isHovered { return .seshatHeading }
        return entry.level == 1 ? .seshatBodyText.opacity(0.7) : .seshatMuted.opacity(0.85)
    }
}
