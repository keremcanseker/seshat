import SwiftUI

struct OutlineEntryRow: View {
    let entry: OutlineEntry
    let depth: Int
    let isActive: Bool
    let onSelect: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(isActive ? Color.seshatAccent : Color.clear)
                    .frame(width: 1.5)
                Text(entry.title)
                    .font(.system(size: 12, weight: depth == 0 ? .medium : .regular))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.leading, indent)
                    .padding(.vertical, 2)
                Spacer(minLength: 0)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.12)) {
                isHovered = hovering
            }
        }
    }

    private var indent: CGFloat {
        switch depth {
        case 0: 12.5
        case 1: 22
        default: 32
        }
    }

    private var textColor: Color {
        if isActive { return .seshatAccent }
        if isHovered { return .seshatBodyText }
        switch depth {
        case 0: return .seshatBodyText
        case 1: return .seshatMuted
        default: return .seshatFaint
        }
    }
}
