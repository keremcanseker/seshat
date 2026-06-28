import SwiftUI

struct SidebarFileRow: View {
    let file: LibraryFile

    @Environment(ReadState.self) private var readState

    private var isUnread: Bool { !readState.isRead(file.url) }

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.seshatAccent)
                .frame(width: 6, height: 6)
                .opacity(isUnread ? 1 : 0)
            Image(systemName: "doc.text")
                .font(.system(size: 12))
                .foregroundStyle(Color.seshatFaint)
            Text(file.name)
                .font(.system(size: 13, weight: isUnread ? .semibold : .regular))
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: 4)
            if let date = file.modifiedAt {
                Text(date, format: .relative(presentation: .numeric, unitsStyle: .narrow))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Color.seshatFaint)
            }
        }
    }
}
