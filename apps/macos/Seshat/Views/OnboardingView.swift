import AppKit
import SwiftUI

struct OnboardingView: View {
    @AppStorage("SeshatOnboardingCompletedV1") private var completed = false

    var body: some View {
        ZStack {
            Color.seshatPaper.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 36) {
                    header
                    sections
                    Button("Get started") { completed = true }
                        .buttonStyle(OnboardingPrimaryButton())
                        .padding(.top, 8)
                }
                .padding(.horizontal, 56)
                .padding(.vertical, 56)
                .frame(maxWidth: 580)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 14) {
            SeshatMark(lineWidth: 1.5, color: .seshatBodyText)
                .frame(width: 56, height: 56)
            Text("Welcome to Seshat")
                .font(.system(size: 26, weight: .semibold, design: .serif))
                .foregroundStyle(Color.seshatHeading)
            Text("A reading room for your markdown.")
                .font(.system(size: 14))
                .foregroundStyle(Color.seshatMuted)
        }
    }

    private var sections: some View {
        VStack(spacing: 28) {
            OnboardingSection(
                title: "Your library",
                copy: "Seshat reads markdown from **~/Seshat/**. Top-level folders become workspaces in the sidebar; drop new notes into **Inbox** to keep them at hand.",
                actionLabel: "Reveal in Finder",
                action: { NSWorkspace.shared.open(Library.defaultRootURL) }
            )

            OnboardingSection(
                title: "From the terminal",
                copy: "Install the `seshat` command once and any file becomes a reading window: `seshat open <file.md>`, or `seshat global <file.md>` to reveal it in the workspace.",
                actionLabel: "Install seshat command…",
                action: { CLIInstaller.reinstallFromMenu() }
            )

            OnboardingSection(
                title: "VSCode / Cursor",
                copy: "An editor extension adds *Open in Seshat* and *Reveal in Seshat Workspace*. See **apps/vscode/README.md** in the repo for the `.vsix` install.",
                actionLabel: nil,
                action: nil
            )
        }
    }
}

private struct OnboardingSection: View {
    let title: String
    let copy: String
    let actionLabel: String?
    let action: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .serif))
                .foregroundStyle(Color.seshatHeading)
            Text(LocalizedStringKey(copy))
                .font(.system(size: 13.5))
                .foregroundStyle(Color.seshatBodyText)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            if let actionLabel, let action {
                Button(actionLabel, action: action)
                    .buttonStyle(OnboardingSecondaryButton())
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct OnboardingPrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color.seshatPaper)
            .padding(.horizontal, 22)
            .padding(.vertical, 11)
            .frame(minWidth: 200)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.seshatBodyText)
                    .opacity(configuration.isPressed ? 0.85 : 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct OnboardingSecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12.5, weight: .medium))
            .foregroundStyle(Color.seshatBodyText)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.seshatBgSubtle)
                    .opacity(configuration.isPressed ? 0.7 : 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.seshatRuleStrong, lineWidth: 0.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingView()
        .frame(width: 720, height: 760)
}
