import SwiftUI

struct SignInView: View {
    @Environment(AuthStore.self) private var authStore

    var body: some View {
        ZStack {
            Color.seshatPaper.ignoresSafeArea()
            VStack(spacing: 28) {
                SeshatMark(lineWidth: 1.5, color: .seshatBodyText)
                    .frame(width: 64, height: 64)
                VStack(spacing: 8) {
                    Text("Welcome to Seshat")
                        .font(.system(size: 26, weight: .semibold, design: .serif))
                        .foregroundStyle(Color.seshatHeading)
                    Text("Sign in to share your markdown to the web.")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.seshatMuted)
                        .multilineTextAlignment(.center)
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
                        .frame(maxWidth: 320)
                }

                VStack(spacing: 4) {
                    Text("Reading is always free.")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.seshatFaint)
                    Text("Sharing publishes a public link at seshat.page.")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.seshatFaint)
                }
                .multilineTextAlignment(.center)
                .padding(.top, 4)
            }
            .padding(40)
            .frame(maxWidth: 420)
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
