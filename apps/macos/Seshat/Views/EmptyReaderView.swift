import SwiftUI

struct EmptyReaderView: View {
    var body: some View {
        ContentUnavailableView {
            Label("No file open", systemImage: "doc.text")
        } description: {
            Text("Use `seshat open <file.md>` from the terminal to open a markdown file.")
        }
        .background(Color.seshatPaper)
    }
}
