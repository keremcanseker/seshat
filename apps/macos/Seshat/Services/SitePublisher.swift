import Foundation

/// Publishes a folder of markdown files as one site (KER-811, Premium). Every
/// call sends the whole folder; the server replaces the page set, so removed
/// files vanish and new ones appear. Slug memory rides `ShareStore`, keyed by
/// the folder path, exactly like single files.
enum SitePublisher {
    private static let markdownExtensions: Set<String> = ["md", "markdown"]

    @MainActor
    static func publish(folderURL: URL, api: APIClient) async throws -> (CreateSiteResponse, Bool) {
        let pages = try collectPages(in: folderURL)
        guard !pages.isEmpty else {
            throw CocoaError(.fileReadCorruptFile, userInfo: [
                NSLocalizedDescriptionKey: "Nothing to share, the folder has no markdown files.",
            ])
        }
        let body = CreateSiteBody(title: folderURL.lastPathComponent, pages: pages)
        if let slug = ShareStore.slug(for: folderURL) {
            do {
                let response: CreateSiteResponse = try await api.put("sites/\(slug)", body: body)
                ShareStore.setSlug(response.slug, for: folderURL)
                return (response, true)
            } catch APIError.server(let status, _) where status == 404 {
                ShareStore.removeSlug(for: folderURL)
            }
        }
        let response: CreateSiteResponse = try await api.post("sites", body: body)
        ShareStore.setSlug(response.slug, for: folderURL)
        return (response, false)
    }

    /// Every non-hidden, non-empty markdown file under the folder, as
    /// folder-relative paths without the extension ("guides/setup").
    static func collectPages(in folderURL: URL) throws -> [SitePage] {
        let root = folderURL.standardizedFileURL
        guard let enumerator = FileManager.default.enumerator(
            at: root,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else {
            throw CocoaError(.fileReadNoSuchFile)
        }
        var pages: [SitePage] = []
        for case let url as URL in enumerator {
            guard markdownExtensions.contains(url.pathExtension.lowercased()),
                  try url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile == true
            else { continue }
            let content = try String(contentsOf: url, encoding: .utf8)
            guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
            let relative = url.standardizedFileURL.path
                .dropFirst(root.path.count + 1)
            let path = String(relative).replacing(/\.(md|markdown)$/.ignoresCase(), with: "")
            pages.append(SitePage(
                path: path,
                title: url.deletingPathExtension().lastPathComponent,
                content: content
            ))
        }
        return pages.sorted { $0.path < $1.path }
    }
}
