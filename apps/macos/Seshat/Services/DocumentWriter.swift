import Foundation

/// Atomic, conflict-aware markdown writes. Lives outside `Library` so reader
/// windows (which may hold files anywhere on disk, not just `~/Seshat/`) can save
/// too. `Library.write(...)` delegates here after its library-root check.
enum DocumentWriter {
    static func modificationDate(of url: URL) -> Date? {
        (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate
    }

    /// Writes `content` to `url` atomically. If `expectedModification` is provided
    /// and the file on disk has a newer modification date, the write is refused and
    /// the current on-disk content is returned so the caller can resolve the conflict.
    @discardableResult
    static func write(
        _ content: String,
        to url: URL,
        expecting expectedModification: Date?
    ) throws -> WriteOutcome {
        if let expectedModification, let current = modificationDate(of: url),
           current > expectedModification {
            let remote = (try? String(contentsOf: url, encoding: .utf8)) ?? ""
            return .externalChange(remoteContent: remote)
        }
        try content.write(to: url, atomically: true, encoding: .utf8)
        return .wrote(modificationDate: modificationDate(of: url))
    }
}
