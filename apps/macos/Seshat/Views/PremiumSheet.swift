import AppKit
import SwiftUI

/// Shown when the server answers 402. No purchase flow in the app: "See plans"
/// opens the pricing page in the browser, and the plan flips server-side.
struct PremiumSheet: View {
    struct Prompt: Identifiable {
        let code: String
        let upgradeURL: URL?

        var id: String { code }

        var title: String {
            switch code {
            case "copy_formats": "Copy As needs Seshat Premium"
            case "folder_site": "Sites need Seshat Premium"
            default: "This link needs Seshat Premium"
            }
        }

        var body: String {
            switch code {
            case "read_only_over_quota":
                return "This document is above the free allowance and is read-only until you upgrade."
            case "copy_formats":
                return "Copying as rich text or a Slack message is a Premium feature. Free accounts keep the reader and one share link."
            case "folder_site":
                return "Publishing a folder as a site, with a page tree and search, is a Premium feature. Free accounts keep the reader and one share link."
            default:
                return "Free accounts include one permanent share link. Premium removes the limit."
            }
        }
    }

    let prompt: Prompt
    @Environment(\.dismiss) private var dismiss

    private static let fallbackURL = URL(string: "https://seshat.page/pricing")!

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(prompt.title)
                .font(.system(size: 17, weight: .semibold, design: .serif))
                .foregroundStyle(Color.seshatHeading)
            Text(prompt.body)
                .font(.system(size: 13))
                .foregroundStyle(Color.seshatMuted)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Spacer()
                Button("Not now") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Button("See plans") {
                    NSWorkspace.shared.open(prompt.upgradeURL ?? Self.fallbackURL)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(.top, 8)
        }
        .padding(22)
        .frame(width: 380)
        .background(Color.seshatPaper)
    }
}
