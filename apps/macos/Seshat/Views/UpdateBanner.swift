import SwiftUI

/// Bottom-right update card. Deliberately a little insistent: a filled primary
/// button, a teaser line from the release notes, and "Not now" only snoozes
/// until the next launch.
struct UpdateBanner: View {
    let info: UpdateInfo
    let onUpdate: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.seshatAccent)
                Text("Seshat \(info.version) is ready")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.seshatBodyText)
            }

            Text(teaser)
                .font(.system(size: 12))
                .foregroundStyle(Color.seshatMuted)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 10) {
                Button("Update now", action: onUpdate)
                    .buttonStyle(.borderedProminent)
                    .tint(Color.seshatAccent)
                    .controlSize(.small)
                Button("Not now", action: onDismiss)
                    .buttonStyle(.borderless)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.seshatFaint)
                    .help("Remind me on the next launch")
            }
        }
        .padding(14)
        .frame(width: 280, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.seshatBgSubtle)   // one step off the paper so it reads as a card in both themes
                .shadow(color: .black.opacity(0.22), radius: 18, y: 8)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Color.seshatRuleStrong, lineWidth: 0.5)
        }
        .padding(16)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    /// First meaningful line of the release notes, else a generic nudge.
    private var teaser: String {
        let firstLine = info.notes?
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: CharacterSet(charactersIn: "-*# ")) }
            .first { !$0.isEmpty }
        return firstLine ?? "Installs in one step and relaunches automatically."
    }
}
