import SwiftUI

struct FolderSection<Files: View>: View {
    let folder: LibraryFolder
    let isImportDestination: Bool
    let onSelectAsDestination: () -> Void
    let onDrop: ([URL]) -> Void
    let onImportHere: () -> Void
    let onRenameFolder: () -> Void
    let onDeleteFolder: () -> Void
    @ViewBuilder let files: () -> Files

    @State private var hovering = false

    var body: some View {
        Section {
            files()
        } header: {
            HStack(spacing: 4) {
                if isImportDestination {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(Color.seshatAccent)
                }
                Text(folder.name.uppercased())
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .tracking(1.2)
            }
            .foregroundStyle(hovering || isImportDestination ? Color.seshatAccent : Color.seshatFaint)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(headerBackground)
            )
            .animation(.easeOut(duration: 0.12), value: hovering)
            .animation(.easeOut(duration: 0.12), value: isImportDestination)
            .onTapGesture(count: 1, perform: onSelectAsDestination)
            .contextMenu {
                Button("Import Here…", systemImage: "doc.badge.plus") {
                    onImportHere()
                }
                Button("Rename Folder…", systemImage: "pencil") {
                    onRenameFolder()
                }
                Divider()
                Button("Delete Folder", systemImage: "trash", role: .destructive) {
                    onDeleteFolder()
                }
            }
        }
        .dropDestination(for: URL.self) { urls, _ in
            onDrop(urls)
            return true
        } isTargeted: { isTargeted in
            hovering = isTargeted
        }
    }

    private var headerBackground: Color {
        if hovering {
            return Color.seshatAccentSoft.opacity(0.22)
        }
        if isImportDestination {
            return Color.seshatAccentSoft.opacity(0.14)
        }
        return .clear
    }
}
