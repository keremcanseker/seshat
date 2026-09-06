import SwiftUI

/// Linear-sized row: 26pt tall, 13pt name, tight leading gutter.
struct SidebarFileRow: View {
    let file: LibraryFile

    @Environment(ReadState.self) private var readState

    private var isUnread: Bool { !readState.isRead(file.url) }

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.seshatAccent)
                .frame(width: 5, height: 5)
                .opacity(isUnread ? 1 : 0)
            Image(systemName: "doc.text")
                .font(.system(size: 11))
                .foregroundStyle(Color.seshatFaint)
            Text(file.name)
                .font(.system(size: 13, weight: isUnread ? .semibold : .regular))
                .foregroundStyle(Color.seshatBodyText)   // stays put when the row is selected
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: 4)
            if let date = file.modifiedAt {
                Text(date, format: .relative(presentation: .numeric, unitsStyle: .narrow))
                    .font(.system(size: 10.5, design: .monospaced))
                    .foregroundStyle(Color.seshatFaint)
            }
        }
        .frame(height: 26)
    }
}
