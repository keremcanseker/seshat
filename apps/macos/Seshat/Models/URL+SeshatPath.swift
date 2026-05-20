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
}
