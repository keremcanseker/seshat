import Foundation

enum SeshatURLAction: Equatable {
    case openReader(URL)
    case openWorkspace(URL?)
}

enum SeshatURL {
    static let scheme = "seshat"

    static func action(for url: URL) -> SeshatURLAction? {
        if url.isFileURL {
            return .openReader(url.standardizedFileURL)
        }

        guard url.scheme == scheme else { return nil }

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let pathQuery = components?.queryItems?.first(where: { $0.name == "path" })?.value
        let target = pathQuery.flatMap(fileURL(from:))

        switch url.host {
        case "open":
            guard let target else { return nil }
            return .openReader(target)
        case "global":
            return .openWorkspace(target)
        default:
            return nil
        }
    }

    private static func fileURL(from rawPath: String) -> URL? {
        guard !rawPath.isEmpty else { return nil }
        let expanded = (rawPath as NSString).expandingTildeInPath
        return URL(fileURLWithPath: expanded).standardizedFileURL
    }
}
