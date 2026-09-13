import AppKit
import SwiftUI

/// In-app companion to the web dashboard (KER-516): lists everything the signed-in
/// user has published with `seshat share`, with open / copy-link / delete.
struct SharedDocsView: View {
    @Environment(AuthStore.self) private var authStore
    @Environment(\.dismiss) private var dismiss

    @State private var docs: [SharedDoc] = []
    @State private var loadState: LoadState = .loading
    @State private var deleting: Set<String> = []

    private enum LoadState: Equatable {
        case loading
        case loaded
        case failed(String)
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            content
        }
        .frame(width: 480, height: 460)
        .background(Color.seshatPaper)
        .task { await load() }
    }

    private var header: some View {
        HStack {
            Text("Shared Documents")
                .font(.system(size: 15, weight: .semibold, design: .serif))
                .foregroundStyle(Color.seshatHeading)
            Spacer()
            Button("Done") { dismiss() }
                .keyboardShortcut(.defaultAction)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }

    @ViewBuilder
    private var content: some View {
        switch loadState {
        case .loading:
            centered { ProgressView().controlSize(.small) }
        case .failed(let message):
            centered {
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(Color.seshatFaint)
                    Text(message)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.seshatMuted)
                        .multilineTextAlignment(.center)
                    Button("Try Again") { Task { await load() } }
                }
            }
        case .loaded where docs.isEmpty:
            centered {
                VStack(spacing: 8) {
                    Text("Nothing shared yet")
                        .font(.system(size: 14, weight: .medium, design: .serif))
                        .foregroundStyle(Color.seshatMuted)
                    Text("Open a document and hit Share to publish a link.")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.seshatFaint)
                }
            }
        case .loaded:
            List(docs) { doc in
                SharedDocRow(
                    doc: doc,
                    isDeleting: deleting.contains(doc.id),
                    onOpen: { if let url = doc.publicURL { NSWorkspace.shared.open(url) } },
                    onCopy: { copy(doc) },
                    onDelete: { Task { await delete(doc) } }
                )
            }
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
        }
    }

    private func centered<V: View>(@ViewBuilder _ view: () -> V) -> some View {
        view()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func load() async {
        loadState = .loading
        do {
            async let documents: SharedDocsResponse = authStore.api.get("docs/me")
            async let sites: SharedSitesResponse = authStore.api.get("sites/me")
            var rows = try await documents.documents
            rows += try await sites.sites.map { site in
                var site = site
                site.isSite = true
                return site
            }
            docs = rows.sorted { ($0.createdAt ?? "") > ($1.createdAt ?? "") }
            loadState = .loaded
        } catch {
            loadState = .failed(error.localizedDescription)
        }
    }

    private func copy(_ doc: SharedDoc) {
        guard let url = doc.publicURL else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(url.absoluteString, forType: .string)
    }

    private func delete(_ doc: SharedDoc) async {
        deleting.insert(doc.id)
        defer { deleting.remove(doc.id) }
        do {
            let _: EmptyResponse = try await authStore.api.delete("\(doc.apiPath)/\(doc.slug)")
            docs.removeAll { $0.id == doc.id }
        } catch {
            loadState = .failed(error.localizedDescription)
        }
    }
}

private struct SharedDocRow: View {
    let doc: SharedDoc
    let isDeleting: Bool
    let onOpen: () -> Void
    let onCopy: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(doc.title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.seshatBodyText)
                    .lineLimit(1)
                Text("seshat.page/\(doc.publicPath)")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Color.seshatFaint)
                    .lineLimit(1)
            }
            Spacer(minLength: 8)
            if isDeleting {
                ProgressView().controlSize(.small)
            } else {
                Button(action: onOpen) { Image(systemName: "arrow.up.right.square") }
                    .buttonStyle(.borderless)
                    .help("Open in browser")
                Button(action: onCopy) { Image(systemName: "link") }
                    .buttonStyle(.borderless)
                    .help("Copy link")
                Button(action: onDelete) { Image(systemName: "trash") }
                    .buttonStyle(.borderless)
                    .foregroundStyle(Color.red.opacity(0.8))
                    .help("Delete")
            }
        }
        .padding(.vertical, 4)
    }
}
