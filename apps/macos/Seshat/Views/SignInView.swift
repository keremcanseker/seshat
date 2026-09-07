import SwiftUI

/// Sheet shown when a signed-out reader taps Share. Publishing needs an
/// identity; reading never does, so this is the only place the app asks.
/// Dismisses itself once the browser round-trip signs the user in.
struct SignInView: View {
    @Environment(AuthStore.self) private var authStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            SeshatMark(lineWidth: 1.5, color: .seshatAccent)
                .frame(width: 48, height: 48)
            VStack(spacing: 8) {
                Text("Sign in to share")
                    .font(.system(size: 22, weight: .semibold, design: .serif))
                    .foregroundStyle(Color.seshatHeading)
                Text("Publishing a link at seshat.page needs an account. One permanent link is free.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.seshatMuted)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Button(action: authStore.signIn) {
                HStack(spacing: 10) {
                    if authStore.status == .signingIn {
                        ProgressView()
                            .controlSize(.small)
                            .progressViewStyle(.circular)
                    } else {
                        Image(systemName: "globe")
                            .font(.system(size: 13, weight: .medium))
                    }
                    Text(authStore.status == .signingIn ? "Waiting for browser…" : "Sign in with Google")
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .frame(minWidth: 240)
            }
            .buttonStyle(SignInButtonStyle())
            .disabled(authStore.status == .signingIn)

            if let error = authStore.lastError {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.red.opacity(0.85))
                    .multilineTextAlignment(.center)
            }

            Button("Not now") { dismiss() }
                .buttonStyle(.borderless)
                .font(.system(size: 12))
                .foregroundStyle(Color.seshatFaint)
                .keyboardShortcut(.cancelAction)
        }
        .padding(36)
        .frame(width: 420)
        .background(Color.seshatPaper)
        .onChange(of: authStore.isAuthenticated) { _, signedIn in
            if signedIn { dismiss() }
        }
    }
}

private struct SignInButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.seshatPaper)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.seshatBodyText)
                    .opacity(configuration.isPressed ? 0.85 : 1)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.seshatBodyText.opacity(0.4), lineWidth: 0.5)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
