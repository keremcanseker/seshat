import SwiftUI

struct FolderSection<Files: View>: View {
    let folder: LibraryFolder
    let isImportDestination: Bool
    let onSelectAsDestination: () -> Void
    let onDrop: ([URL]) -> Void
    let onNewFileHere: () -> Void
    let onImportHere: () -> Void
    let onRenameFolder: () -> Void
    let onRevealFolder: () -> Void
    let onDeleteFolder: () -> Void
    @ViewBuilder let files: () -> Files

    @State private var hovering = false
    // ponytail: in-memory only; persist per folder if people keep re-collapsing after launch.
    @State private var isExpanded = true

    var body: some View {
        Section {
            if isExpanded {
                files()
            }
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
                Image(systemName: "chevron.right")
                    .font(.system(size: 7, weight: .semibold))
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    .opacity(hovering || !isExpanded ? 1 : 0.5)
            }
            .foregroundStyle(hovering || isImportDestination ? Color.seshatAccent : Color.seshatFaint)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(headerBackground)
            )
            .contentShape(.rect)
            .animation(.easeOut(duration: 0.12), value: hovering)
            .animation(.easeOut(duration: 0.12), value: isImportDestination)
            .onHover { hovering = $0 }
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.15)) { isExpanded.toggle() }
            }
            .contextMenu {
                Button("New File…", systemImage: "doc.badge.plus") {
                    onNewFileHere()
                }
                Button("Import Here…", systemImage: "square.and.arrow.down") {
                    onImportHere()
                }
                Button("Use for New Files & Imports", systemImage: "arrow.down.circle") {
                    onSelectAsDestination()
                }
                .disabled(isImportDestination)
                Divider()
                Button("Rename Folder…", systemImage: "pencil") {
                    onRenameFolder()
                }
                Button("Reveal in Finder", systemImage: "magnifyingglass") {
                    onRevealFolder()
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
