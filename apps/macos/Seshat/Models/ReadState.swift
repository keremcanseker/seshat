import Foundation

/// Tracks which library documents have been read. A file is "read" once it has
/// been opened in the reader; until then it shows an unread marker in the
/// sidebar. State is keyed by the file's standardized path and persisted in
/// UserDefaults, mirroring `ShareStore`'s path-keyed approach but exposed as
/// observable state so the sidebar updates live across windows.
@Observable
@MainActor
final class ReadState {
    private static let key = "SeshatReadPaths"

    private var readPaths: Set<String>

    init() {
        let stored = UserDefaults.standard.array(forKey: Self.key) as? [String] ?? []
        readPaths = Set(stored)
    }

    func isRead(_ url: URL) -> Bool {
        readPaths.contains(Self.key(for: url))
    }

    func markRead(_ url: URL) {
        let path = Self.key(for: url)
        guard !readPaths.contains(path) else { return }
        readPaths.insert(path)
        persist()
    }

    func markUnread(_ url: URL) {
        let path = Self.key(for: url)
        guard readPaths.contains(path) else { return }
        readPaths.remove(path)
        persist()
    }

    func toggle(_ url: URL) {
        if isRead(url) {
            markUnread(url)
        } else {
            markRead(url)
        }
    }

    /// Carries read state across a rename or move so the document keeps its mark.
    func remap(from oldURL: URL, to newURL: URL) {
        let oldKey = Self.key(for: oldURL)
        guard readPaths.contains(oldKey) else { return }
        readPaths.remove(oldKey)
        readPaths.insert(Self.key(for: newURL))
        persist()
    }

    /// Drops read state for a deleted document.
    func forget(_ url: URL) {
        let path = Self.key(for: url)
        guard readPaths.contains(path) else { return }
        readPaths.remove(path)
        persist()
    }

    private func persist() {
        UserDefaults.standard.set(Array(readPaths), forKey: Self.key)
    }

    private static func key(for url: URL) -> String {
        url.standardizedFileURL.path
    }
}
