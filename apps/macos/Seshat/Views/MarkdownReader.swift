import MarkdownUI
import SwiftUI

struct MarkdownReader: View {
    let fileURL: URL

    @State private var parsed: ParsedMarkdown = .empty
    @State private var loadError: Error?
    @State private var showOutline: Bool = true

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
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
                .padding(.horizontal, 32)
                .padding(.vertical, 64)
                .frame(maxWidth: Seshat.contentWidth, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .background(Color.seshatPaper)
            .overlay(alignment: .topTrailing) {
                if showOutline && !parsed.outline.isEmpty {
                    MarkdownOutline(entries: parsed.outline) { entry in
                        withAnimation(.easeOut(duration: 0.28)) {
                            proxy.scrollTo(entry.id, anchor: .top)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
        }
        .navigationTitle(fileURL.lastPathComponent)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Toggle(isOn: $showOutline.animation(.easeInOut(duration: 0.22))) {
                    Label("Outline", systemImage: "list.bullet.indent")
                }
                .toggleStyle(.button)
                .disabled(parsed.outline.isEmpty)
                .help(showOutline ? "Hide outline" : "Show outline")
            }
        }
        .task(id: fileURL) {
            await load()
        }
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
