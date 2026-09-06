import MarkdownUI
import SwiftUI

/// Loads images synchronously for the print layout: `ImageRenderer` does not
/// wait for MarkdownUI's async default provider, which would leave every image
/// as an empty gap.
struct PrintImageProvider: ImageProvider {
    let baseURL: URL
    /// Remote images fetched before rendering, keyed by their absolute URL.
    let remoteImages: [URL: Data]

    func makeImage(url: URL?) -> some View {
        if let image = load(url) {
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Color.clear.frame(height: 0)
        }
    }

    private func load(_ url: URL?) -> NSImage? {
        guard let url else { return nil }
        if url.scheme == nil {
            return NSImage(contentsOf: baseURL.appending(path: url.path))
        }
        if url.isFileURL {
            return NSImage(contentsOf: url)
        }
        return remoteImages[url].flatMap(NSImage.init(data:))
    }
}
