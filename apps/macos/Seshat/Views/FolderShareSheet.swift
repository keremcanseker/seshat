import AppKit
import SwiftUI

/// Sidebar's "Share as Site…": publishes a workspace folder through
/// `SitePublisher` (the same path as `seshat share <dir>`) and shows the link.
/// A 402 swaps the sheet for the Premium prompt.
struct FolderShareSheet: View {
    let folder: LibraryFolder
    @Environment(AuthStore.self) private var authStore
    @Environment(\.dismiss) private var dismiss

    @State private var phase: Phase = .publishing

    private enum Phase {
        case publishing
        case published(url: URL, wasUpdate: Bool)
        case premium(PremiumSheet.Prompt)
        case failed(String)

        var isPublishing: Bool {
            if case .publishing = self { true } else { false }
        }
    }

    var body: some View {
        Group {
            if case .premium(let prompt) = phase {
                PremiumSheet(prompt: prompt)
            } else {
                content
                    .padding(22)
                    .frame(width: 380)
                    .background(Color.seshatPaper)
            }
        }
        .task { await publish() }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Share “\(folder.name)” as a site")
                .font(.system(size: 17, weight: .semibold, design: .serif))
                .foregroundStyle(Color.seshatHeading)
            switch phase {
            case .publishing:
                HStack(spacing: 10) {
                    ProgressView().controlSize(.small)
                    Text("Publishing every markdown file in the folder…")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.seshatMuted)
                }
            case .published(let url, let wasUpdate):
                Text(wasUpdate ? "Site updated and link copied." : "Site published and link copied.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.seshatMuted)
                Text(url.absoluteString)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(Color.seshatBodyText)
                    .textSelection(.enabled)
                    .lineLimit(1)
                    .truncationMode(.middle)
            case .failed(let message):
                Text(message)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.seshatMuted)
                    .fixedSize(horizontal: false, vertical: true)
            case .premium:
                EmptyView()
            }
            HStack {
                Spacer()
                if case .published(let url, _) = phase {
                    Button("Open") { NSWorkspace.shared.open(url) }
                    Button("Done") { dismiss() }
                        .keyboardShortcut(.defaultAction)
                } else {
                    Button(phase.isPublishing ? "Cancel" : "Close") { dismiss() }
                        .keyboardShortcut(.cancelAction)
                }
            }
            .padding(.top, 8)
        }
    }

    private func publish() async {
        do {
            let (response, wasUpdate) = try await SitePublisher.publish(folderURL: folder.url, api: authStore.api)
            guard let url = URL(string: response.url) else { throw APIError.invalidResponse }
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(response.url, forType: .string)
            phase = .published(url: url, wasUpdate: wasUpdate)
            await authStore.refreshMe()
        } catch APIError.unauthorized {
            phase = .failed("Session expired. Please sign in again.")
        } catch APIError.paymentRequired(_, let upgradeURL, _) {
            phase = .premium(.init(code: "folder_site", upgradeURL: upgradeURL))
            await authStore.refreshMe()
        } catch {
            phase = .failed(error.localizedDescription)
        }
    }
}
