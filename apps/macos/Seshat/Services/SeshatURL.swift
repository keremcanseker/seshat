import Foundation

enum SeshatURLAction: Equatable {
    case openReader(URL)
    case openWorkspace(URL?)
    case signInCallback(token: String)
}

enum SeshatURL {
    static let scheme = "seshat"

    static func action(for url: URL) -> SeshatURLAction? {
        if url.isFileURL {
            return .openReader(url.standardizedFileURL)
        }

        guard url.scheme == scheme else { return nil }

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)

        switch url.host {
        case "open":
            let target = components?.queryItems?
                .first(where: { $0.name == "path" })?.value
                .flatMap(fileURL(from:))
            guard let target else { return nil }
            return .openReader(target)
        case "global":
            let target = components?.queryItems?
                .first(where: { $0.name == "path" })?.value
                .flatMap(fileURL(from:))
            return .openWorkspace(target)
        case "auth":
            guard url.path == "/callback",
                  let token = token(fromFragment: components?.fragment)
            else { return nil }
            return .signInCallback(token: token)
        default:
            return nil
        }
    }

    private static func fileURL(from rawPath: String) -> URL? {
        guard !rawPath.isEmpty else { return nil }
        let expanded = (rawPath as NSString).expandingTildeInPath
        return URL(fileURLWithPath: expanded).standardizedFileURL
    }

    private static func token(fromFragment fragment: String?) -> String? {
        guard let fragment, !fragment.isEmpty else { return nil }
        for pair in fragment.split(separator: "&") {
            let kv = pair.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
            guard kv.count == 2, kv[0] == "token" else { continue }
            let raw = String(kv[1])
            return raw.removingPercentEncoding ?? raw
        }
        return nil
    }
}
