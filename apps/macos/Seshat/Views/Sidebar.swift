import SwiftUI

struct Sidebar: View {
    let folders: [LibraryFolder]
    @Binding var selection: URL?

    var body: some View {
        if folders.isEmpty {
            EmptySidebar()
        } else {
            List(selection: $selection) {
                ForEach(folders) { folder in
                    Section(folder.name.uppercased()) {
                        ForEach(folder.files) { file in
                            Label(file.name, systemImage: "scroll")
                                .tag(file.url)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        }
    }
}

private struct EmptySidebar: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "books.vertical")
                .font(.system(size: 28, weight: .light))
                .foregroundStyle(.secondary)
            Text("Library is empty")
                .font(.system(size: 13, weight: .medium))
            Text("Drop `.md` files into folders inside `~/Seshat/`, or use `seshat global <file.md>` from the terminal.")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
