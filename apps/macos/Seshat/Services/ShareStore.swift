import Foundation

/// Remembers which server slug a local file was published to, so re-sharing the
/// same file updates the existing document (PUT) instead of minting a new link
/// (POST) — one file, one stable URL. Keyed by the file's path.
enum ShareStore {
    private static let key = "SeshatSharedSlugs"

    static func slug(for url: URL) -> String? {
        map()[url.standardizedFileURL.path]
    }

    static func setSlug(_ slug: String, for url: URL) {
        var current = map()
        current[url.standardizedFileURL.path] = slug
        save(current)
    }

    static func removeSlug(for url: URL) {
        var current = map()
        current.removeValue(forKey: url.standardizedFileURL.path)
        save(current)
    }

    private static func map() -> [String: String] {
        UserDefaults.standard.dictionary(forKey: key) as? [String: String] ?? [:]
    }

    private static func save(_ value: [String: String]) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
