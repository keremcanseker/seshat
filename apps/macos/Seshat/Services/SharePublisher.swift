import Foundation

/// Publishes a local file to the share server. Used by the reader's Share
/// button and by `seshat share` (AppRouter), so both paths keep one file → one
/// stable URL (KER-514) through `ShareStore`.
enum SharePublisher {
    /// Updates the existing document if this file was shared before (PUT), else
    /// creates a new one (POST). Falls back to POST if the remembered doc is gone.
    /// `slug` asks the server for a custom address (Premium, KER-808); nil keeps
    /// whatever the document has. Returns the server response and whether it was an update.
    @MainActor
    static func publish(
        fileURL: URL, content: String, slug: String? = nil, api: APIClient
    ) async throws -> (CreateDocResponse, Bool) {
        let title = fileURL.deletingPathExtension().lastPathComponent
        let body = CreateDocBody(title: title, content: content, slug: slug)
        if let slug = ShareStore.slug(for: fileURL) {
            do {
                let response: CreateDocResponse = try await api.put("docs/\(slug)", body: body)
                ShareStore.setSlug(response.slug, for: fileURL)
                return (response, true)
            } catch APIError.server(let status, _) where status == 404 {
                ShareStore.removeSlug(for: fileURL)
            }
        }
        let response: CreateDocResponse = try await api.post("docs", body: body)
        ShareStore.setSlug(response.slug, for: fileURL)
        return (response, false)
    }
}
