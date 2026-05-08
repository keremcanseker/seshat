import MarkdownUI
import SwiftUI

struct MarkdownReader: View {
    let fileURL: URL

    @State private var parsed: ParsedMarkdown = .empty
    @State private var loadError: Error?
    @State private var showOutline: Bool = true
    @State private var available: CGSize = .zero
    @State private var scrolledSectionId: String?
    @AppStorage("seshatAppearance") private var appearance: AppearanceMode = .light

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
        }
        .task(id: fileURL) {
            await load()
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
            parsed = MarkdownParser.parse(raw)
            loadError = nil
        } catch {
            loadError = error
        }
    }
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
