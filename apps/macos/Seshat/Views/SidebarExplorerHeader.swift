import SwiftUI

struct SidebarExplorerHeader: View {
    let folders: [LibraryFolder]
    @Binding var importDestination: URL?
    let onNewFolder: () -> Void
    let onImport: () -> Void
    let onRefresh: () -> Void
    let onReveal: () -> Void

    private var selectedFolderName: String {
        guard let url = importDestination,
              let folder = folders.first(where: { $0.url.seshatMatches(url) }) else {
            return "Select folder"
        }
        return folder.name
    }

    var body: some View {
        HStack(spacing: 6) {
            Text("LIBRARY")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.seshatMuted)
                .lineLimit(1)

            if !folders.isEmpty {
                Menu {
                    ForEach(folders) { folder in
                        Button(folder.name) {
                            importDestination = folder.url
                        }
                    }
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 10))
                        Text(selectedFolderName)
                            .font(.system(size: 11, weight: .medium))
                            .lineLimit(1)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 8, weight: .semibold))
                    }
                    .foregroundStyle(Color.seshatBodyText)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.seshatSidebarBg, in: .rect(cornerRadius: 4))
                }
                .menuStyle(.borderlessButton)
                .fixedSize(horizontal: true, vertical: false)
                .help("Import destination folder")
            }

            Spacer(minLength: 0)

            SidebarHeaderIconButton(
                title: "New Folder",
                systemImage: "folder.badge.plus",
                action: onNewFolder
            )
            SidebarHeaderIconButton(
                title: importHelpTitle,
                systemImage: "doc.badge.plus",
                action: onImport
            )
            .disabled(folders.isEmpty)
            SidebarHeaderIconButton(
                title: "Refresh",
                systemImage: "arrow.clockwise",
                action: onRefresh
            )
            SidebarHeaderIconButton(
                title: "Reveal in Finder",
                systemImage: "folder",
                action: onReveal
            )
        }
        .padding(.leading, 12)
        .padding(.trailing, 8)
        .padding(.vertical, 7)
        .background(Color.seshatBgSubtle)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.seshatRule.opacity(0.45))
                .frame(height: 1)
        }
    }

    private var importHelpTitle: String {
        guard importDestination != nil, selectedFolderName != "Select folder" else {
            return "Import File (choose a folder first)"
        }
        return "Import into \(selectedFolderName)"
    }
}
