import SwiftUI

struct UpdateBanner: View {
    let info: UpdateInfo
    let onUpdate: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.down.circle.fill")
                .foregroundStyle(Color.seshatAccent)
                .font(.system(size: 14))

            Text("Seshat \(info.version) is available")
                .font(.system(size: 13))
                .foregroundStyle(Color.seshatBodyText)

            Button("Update", action: onUpdate)
            .buttonStyle(.borderless)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color.seshatAccent)

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.seshatFaint)
            }
            .buttonStyle(.borderless)
            .help("Dismiss")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(
            Capsule()
                .fill(Color.seshatPaper)
                .shadow(color: .black.opacity(0.18), radius: 14, y: 6)
        )
        .overlay {
            Capsule()
                .strokeBorder(Color.seshatRule, lineWidth: 0.5)
        }
        .padding(.bottom, 20)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
