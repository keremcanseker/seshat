import SwiftUI

/// One quiet row: the destination folder as a dropdown on the left, a single
/// "+" menu on the right. Everything that used to be its own icon lives in that menu.
struct SidebarExplorerHeader: View {
    let folders: [LibraryFolder]
    @Binding var importDestination: URL?
    let onNewFile: () -> Void
    let onNewFolder: () -> Void
    let onImport: () -> Void
    let onRefresh: () -> Void
    let onReveal: () -> Void

    private var selectedFolderName: String {
        guard let url = importDestination,
              let folder = folders.first(where: { $0.url.seshatMatches(url) }) else {
            return "Library"
        }
        return folder.name
    }

    var body: some View {
        HStack(spacing: 6) {
            Menu {
                ForEach(folders) { folder in
                    Button(folder.name) {
                        importDestination = folder.url
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selectedFolderName)
                        .font(.system(size: 12, weight: .medium))
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundStyle(Color.seshatFaint)
                }
                .foregroundStyle(Color.seshatBodyText)
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .fixedSize(horizontal: true, vertical: false)
            .disabled(folders.isEmpty)
            .help("Destination folder for new and imported files")

            Spacer(minLength: 0)

            Menu {
                Button("New File…", systemImage: "doc.badge.plus", action: onNewFile)
                Button("New Folder", systemImage: "folder.badge.plus", action: onNewFolder)
                Button("Import File…", systemImage: "square.and.arrow.down", action: onImport)
                    .disabled(folders.isEmpty)
                Divider()
                Button("Refresh", systemImage: "arrow.clockwise", action: onRefresh)
                Button("Reveal in Finder", systemImage: "folder", action: onReveal)
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.seshatFaint)
                    .frame(width: 22, height: 22)
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .fixedSize()
            .help("Add")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}
