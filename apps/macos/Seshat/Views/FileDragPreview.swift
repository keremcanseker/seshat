import SwiftUI

struct FileDragPreview: View {
    let name: String

    var body: some View {
        Label(name, systemImage: "doc.text")
            .font(.system(size: 12))
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 6))
    }
}
