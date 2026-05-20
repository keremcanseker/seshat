import SwiftUI

struct ImportFolderPickerSheet: View {
    let folders: [LibraryFolder]
    @Binding var selection: URL?
    let onImport: (URL) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Import into folder")
                .font(.system(size: 15, weight: .semibold))

            Text("Choose which library folder should receive the imported files.")
                .font(.system(size: 12))
                .foregroundStyle(Color.seshatMuted)

            Picker("Folder", selection: $selection) {
                ForEach(folders) { folder in
                    Text(folder.name).tag(Optional(folder.url))
                }
            }
            .pickerStyle(.radioGroup)
            .labelsHidden()

            HStack {
                Spacer()
                Button("Cancel", role: .cancel, action: onCancel)
                Button("Choose Files…") {
                    if let selection {
                        onImport(selection)
                    }
                }
                .keyboardShortcut(.defaultAction)
                .disabled(selection == nil)
            }
        }
        .padding(20)
        .frame(width: 320)
        .onAppear {
            if selection == nil {
                selection = folders.first?.url
            }
        }
    }
}
