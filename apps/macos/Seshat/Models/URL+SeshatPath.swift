import Foundation

extension URL {
    var seshatNormalized: URL {
        standardizedFileURL
    }

    func seshatMatches(_ other: URL) -> Bool {
        seshatNormalized == other.seshatNormalized
    }

    func seshatHasPathPrefix(of ancestor: URL) -> Bool {
        let rootComponents = ancestor.seshatNormalized.pathComponents
        let itemComponents = seshatNormalized.pathComponents
        guard itemComponents.count >= rootComponents.count else { return false }
        return Array(itemComponents.prefix(rootComponents.count)) == rootComponents
    }

    /// Where this URL lives after `old` became `new`: the file itself, or anything under a
    /// moved folder. nil when the move does not touch it.
    func seshatRemapped(from old: URL, to new: URL) -> URL? {
        if seshatMatches(old) { return new.seshatNormalized }
        guard seshatHasPathPrefix(of: old) else { return nil }
        let relative = seshatNormalized.pathComponents.dropFirst(old.seshatNormalized.pathComponents.count)
        return relative.reduce(new.seshatNormalized) { $0.appendingPathComponent($1) }.seshatNormalized
    }
}
