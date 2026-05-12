import SwiftUI

struct Sidebar: View {
    let library: Library
    @Binding var selection: URL?

    @State private var inboxHover = false

    var body: some View {
        Group {
            if library.folders.isEmpty {
                EmptySidebar()
            } else {
                List(selection: $selection) {
                    ForEach(library.folders) { folder in
                        FolderSection(folder: folder) { urls in
                            library.importFiles(urls, into: folder.url)
                        }
                    }
                }
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
            }
        }
        .background(
            Color.seshatSidebarBg
                .overlay(inboxHover ? Color.seshatAccentSoft.opacity(0.18) : Color.clear)
        )
        .dropDestination(for: URL.self) { urls, _ in
            library.importFiles(urls, into: nil)
            return true
        } isTargeted: { hovering in
            inboxHover = hovering
        }
    }
}

private struct FolderSection: View {
    let folder: LibraryFolder
    let onDrop: ([URL]) -> Void

    @State private var hovering = false

    var body: some View {
        Section {
            ForEach(folder.files) { file in
                FileRow(file: file)
                    .tag(file.url)
            }
        } header: {
            Text(folder.name.uppercased())
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .tracking(1.2)
                .foregroundStyle(hovering ? Color.seshatAccent : Color.seshatFaint)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(hovering ? Color.seshatAccentSoft.opacity(0.22) : Color.clear)
                )
                .animation(.easeOut(duration: 0.12), value: hovering)
        }
        .dropDestination(for: URL.self) { urls, _ in
            onDrop(urls)
            return true
        } isTargeted: { isTargeted in
            hovering = isTargeted
        }
    }
}

private struct FileRow: View {
    let file: LibraryFile

    var body: some View {
        HStack(spacing: 8) {
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

private struct EmptySidebar: View {
    var body: some View {
        VStack(spacing: 12) {
            SeshatMark(lineWidth: 1.4, color: .seshatFaint)
                .frame(width: 32, height: 32)
            Text("Library is empty")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.seshatMuted)
            Text("Drop `.md` files here, or use `seshat global <file.md>` from the terminal.")
                .font(.system(size: 11))
                .foregroundStyle(Color.seshatFaint)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
