import SwiftUI

struct Sidebar: View {
    let folders: [LibraryFolder]
    @Binding var selection: URL?

    var body: some View {
        Group {
            if folders.isEmpty {
                EmptySidebar()
            } else {
                List(selection: $selection) {
                    ForEach(folders) { folder in
                        Section {
                            ForEach(folder.files) { file in
                                FileRow(file: file)
                                    .tag(file.url)
                            }
                        } header: {
                            Text(folder.name.uppercased())
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .tracking(1.2)
                                .foregroundStyle(Color.seshatFaint)
                        }
                    }
                }
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
            }
        }
        .background(Color.seshatSidebarBg)
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
            Text("Drop `.md` files into folders inside `~/Seshat/`, or use `seshat global <file.md>` from the terminal.")
                .font(.system(size: 11))
                .foregroundStyle(Color.seshatFaint)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
