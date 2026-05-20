import SwiftUI

struct SidebarFileRow: View {
    let file: LibraryFile

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "doc.text")
                .font(.system(size: 12))
                .foregroundStyle(Color.seshatFaint)
            Text(file.name)
                .font(.system(size: 13))
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
