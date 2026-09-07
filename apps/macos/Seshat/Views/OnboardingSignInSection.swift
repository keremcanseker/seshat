import SwiftUI

/// The optional sign-in step of onboarding. Reads like the other sections and
/// changes its button to the signed-in account once the browser round-trip lands.
struct OnboardingSignInSection: View {
    @Environment(AuthStore.self) private var authStore

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Share by link")
                .font(.system(size: 16, weight: .semibold, design: .serif))
                .foregroundStyle(Color.seshatHeading)
            Text("Sign in with Google to publish any file as a page at **seshat.page**. One permanent link is free. Reading never needs an account.")
                .font(.system(size: 13.5))
                .foregroundStyle(Color.seshatBodyText)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            if let user = authStore.currentUser {
                Label("Signed in as \(user.email)", systemImage: "checkmark.circle.fill")
                    .font(.system(size: 12.5, weight: .medium))
                    .foregroundStyle(Color.seshatAccent)
                    .padding(.top, 4)
            } else {
                Button(
                    authStore.status == .signingIn ? "Waiting for browser…" : "Sign in with Google",
                    action: authStore.signIn
                )
                .buttonStyle(OnboardingSecondaryButton())
                .disabled(authStore.status == .signingIn)
                .padding(.top, 4)
            }
            if let error = authStore.lastError {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.red.opacity(0.85))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
