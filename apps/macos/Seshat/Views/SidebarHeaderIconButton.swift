import SwiftUI

struct SidebarHeaderIconButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    @State private var hovering = false

    var body: some View {
        Button(title, systemImage: systemImage, action: action)
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(hovering ? Color.seshatBodyText : Color.seshatFaint)
            .frame(width: 26, height: 26)
            .background {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(hovering ? Color.seshatAccentSoft.opacity(0.28) : Color.clear)
            }
            .onHover { hovering = $0 }
            .help(title)
    }
}
