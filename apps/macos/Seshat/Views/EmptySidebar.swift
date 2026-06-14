import SwiftUI

struct EmptySidebar: View {
    var body: some View {
        VStack(spacing: 10) {
            Spacer(minLength: 0)
            SeshatMark(lineWidth: 1.4, color: .seshatFaint)
                .frame(width: 28, height: 28)
            Text("No documents yet")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.seshatMuted)
            Text("Create a folder, then drop files onto it, or drag documents between folders in the list.")
                .font(.system(size: 11))
                .foregroundStyle(Color.seshatFaint)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
