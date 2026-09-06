import SwiftUI

/// Linear-sized row: 26pt tall, 13pt name, unread dot in the gutter. The
/// modified date only surfaces on hover so the list reads as names alone.
struct SidebarFileRow: View {
    let file: LibraryFile

    @Environment(ReadState.self) private var readState
    @State private var hovering = false

    private var isUnread: Bool { !readState.isRead(file.url) }

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.seshatAccent)
                .frame(width: 5, height: 5)
                .opacity(isUnread ? 1 : 0)
            Text(file.name)
                .font(.system(size: 13, weight: isUnread ? .semibold : .regular))
                .foregroundStyle(Color.seshatBodyText)   // stays put when the row is selected
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: 4)
            if hovering, let date = file.modifiedAt {
                Text(date, format: .relative(presentation: .numeric, unitsStyle: .narrow))
                    .font(.system(size: 10.5, design: .monospaced))
                    .foregroundStyle(Color.seshatFaint)
                    .transition(.opacity)
            }
        }
        .frame(height: 26)
        .contentShape(.rect)
        .onHover { hovering = $0 }
        .animation(.easeOut(duration: 0.12), value: hovering)
    }
}
