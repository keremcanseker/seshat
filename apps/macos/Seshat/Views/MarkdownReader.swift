import AppKit
import MarkdownUI
import SwiftUI

struct MarkdownReader: View {
    let fileURL: URL
    var reloadTick: Int = 0

    @State private var parsed: ParsedMarkdown = .empty
    @State private var rawContent: String = ""
    @State private var loadError: Error?
    @State private var showOutline: Bool = true
    @State private var available: CGSize = .zero
    @State private var scrolledSectionId: String?
    @State private var isSharing: Bool = false
    @State private var toast: ShareToast?
    @AppStorage("seshatAppearance") private var appearance: AppearanceMode = .light
    @Environment(AuthStore.self) private var authStore

    private static let outlineMinWidth: CGFloat = 1080

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 28) {
                if let loadError {
                    ReaderErrorView(error: loadError)
                } else {
                    ForEach(parsed.sections) { section in
                        Markdown(section.content)
                            .markdownTheme(.seshat)
                            .textSelection(.enabled)
                            .id(section.id)
                    }
                }
            }
            .scrollTargetLayout()
            .padding(.horizontal, 32)
            .padding(.vertical, 64)
            .frame(maxWidth: Seshat.contentWidth, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .scrollPosition(id: $scrolledSectionId, anchor: .top)
        .background(Color.seshatPaper)
        .background {
            GeometryReader { geo in
                Color.clear
                    .onChange(of: geo.size, initial: true) { _, newSize in
                        available = newSize
                    }
            }
        }
        .overlay(alignment: .topTrailing) {
            if outlineVisible {
                MarkdownOutline(
                    entries: parsed.outline,
                    activeId: scrolledSectionId
                ) { entry in
                    withAnimation(.easeOut(duration: 0.28)) {
                        scrolledSectionId = entry.id
                    }
                }
                .frame(maxHeight: max(available.height - 48, 200))
                .padding(.top, 24)
                .padding(.trailing, 24)
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .overlay(alignment: .top) {
            if let toast {
                ShareToastView(toast: toast)
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                HStack(spacing: 6) {
                    Image(systemName: "folder")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(Color.seshatFaint)
                    Text(breadcrumb)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(Color.seshatFaint)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .textSelection(.enabled)
                }
                .help(fileURL.path)
            }
            ToolbarItem(placement: .primaryAction) {
                Toggle(isOn: $showOutline.animation(.easeInOut(duration: 0.22))) {
                    Label("Outline", systemImage: "list.bullet.indent")
                }
                .toggleStyle(.button)
                .disabled(parsed.outline.isEmpty || available.width < Self.outlineMinWidth)
                .help(outlineToggleHelp)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        appearance = appearance.toggled
                    }
                } label: {
                    Image(systemName: appearance.nextSymbol)
                        .symbolRenderingMode(.hierarchical)
                }
                .help(appearance.nextLabel)
            }
            if authStore.isAuthenticated {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { Task { await share() } }) {
                        if isSharing {
                            ProgressView()
                                .controlSize(.small)
                                .progressViewStyle(.circular)
                        } else {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                    .disabled(isSharing || loadError != nil || rawContent.isEmpty)
                    .help("Publish to seshat.page and copy the link")
                }
                ToolbarItem(placement: .primaryAction) {
                    UserMenu()
                }
            }
        }
        .task(id: ReaderLoadKey(url: fileURL, tick: reloadTick)) {
            await load()
        }
        .onChange(of: toast) { _, newValue in
            guard newValue != nil else { return }
            Task {
                try? await Task.sleep(for: .seconds(3.5))
                withAnimation(.easeInOut(duration: 0.25)) {
                    if toast == newValue { toast = nil }
                }
            }
        }
    }

    private var outlineVisible: Bool {
        showOutline
            && !parsed.outline.isEmpty
            && available.width >= Self.outlineMinWidth
    }

    private var breadcrumb: String {
        let path = fileURL.path
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        if path.hasPrefix(home + "/") {
            return "~\(path.dropFirst(home.count))"
        }
        return path
    }

    private var outlineToggleHelp: String {
        if parsed.outline.isEmpty { return "No headings to show" }
        if available.width < Self.outlineMinWidth { return "Window too narrow for outline" }
        return showOutline ? "Hide outline" : "Show outline"
    }

    private func load() async {
        do {
            let raw = try String(contentsOf: fileURL, encoding: .utf8)
            rawContent = raw
            parsed = MarkdownParser.parse(raw)
            loadError = nil
        } catch {
            rawContent = ""
            loadError = error
        }
    }

    private func share() async {
        guard !isSharing else { return }
        let title = fileURL.deletingPathExtension().lastPathComponent
        let trimmedContent = rawContent.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else {
            present(toast: .init(kind: .failure, message: "Nothing to share — file is empty."))
            return
        }
        isSharing = true
        defer { isSharing = false }
        do {
            let response: CreateDocResponse = try await authStore.api.post(
                "docs",
                body: CreateDocBody(title: title, content: rawContent)
            )
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(response.url, forType: .string)
            present(toast: .init(
                kind: .success,
                message: "Link copied · \(response.url)",
                openURL: URL(string: response.url)
            ))
        } catch APIError.unauthorized {
            present(toast: .init(kind: .failure, message: "Session expired — please sign in again."))
        } catch {
            present(toast: .init(kind: .failure, message: error.localizedDescription))
        }
    }

    private func present(toast next: ShareToast) {
        withAnimation(.easeInOut(duration: 0.25)) {
            toast = next
        }
    }
}

private struct ReaderLoadKey: Hashable {
    let url: URL
    let tick: Int
}

private struct ReaderErrorView: View {
    let error: Error

    var body: some View {
        ContentUnavailableView {
            Label("Couldn't read file", systemImage: "exclamationmark.triangle")
        } description: {
            Text(error.localizedDescription)
        }
    }
}

private struct UserMenu: View {
    @Environment(AuthStore.self) private var authStore

    var body: some View {
        Menu {
            if let user = authStore.currentUser {
                Text(user.name ?? user.email)
                    .font(.system(size: 12, weight: .medium))
                Text(user.email)
                    .font(.system(size: 11))
                Divider()
            }
            Button("Sign Out", role: .destructive, action: authStore.signOut)
        } label: {
            Image(systemName: "person.crop.circle")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 14))
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .fixedSize()
        .help(authStore.currentUser?.email ?? "Account")
    }
}

private struct ShareToast: Identifiable, Equatable {
    let id = UUID()
    let kind: Kind
    let message: String
    var openURL: URL? = nil

    enum Kind { case success, failure }
}

private struct ShareToastView: View {
    let toast: ShareToast

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: toast.kind == .success ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundStyle(toast.kind == .success ? Color.seshatAccent : Color.red.opacity(0.85))
            Text(toast.message)
                .font(.system(size: 13))
                .foregroundStyle(Color.seshatBodyText)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            if let url = toast.openURL {
                Button("Open") { NSWorkspace.shared.open(url) }
                    .buttonStyle(.borderless)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.seshatAccent)
                    .help("Open in browser")
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.seshatPaper)
                .shadow(color: .black.opacity(0.18), radius: 14, y: 6)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.seshatRule, lineWidth: 0.5)
        }
        .frame(maxWidth: 520)
    }
}
