import Foundation

enum SeshatURLAction: Equatable {
    case openReader(URL)
    case openWorkspace(URL?)
    case signInCallback(token: String)
    /// `seshat export`: render `source` to `output` without showing a window.
    case exportPDF(source: URL, output: URL, landscape: Bool)
    /// `seshat share`: publish `source` and write the public URL to `output`.
    /// `slug` is `--slug`, a Premium custom address (KER-808).
    case share(source: URL, output: URL, slug: String?)
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
        case "export":
            let items = components?.queryItems ?? []
            guard let source = items.first(where: { $0.name == "path" })?.value.flatMap(fileURL(from:)),
                  let output = items.first(where: { $0.name == "out" })?.value.flatMap(fileURL(from:))
            else { return nil }
            let landscape = items.first(where: { $0.name == "landscape" })?.value == "1"
            return .exportPDF(source: source, output: output, landscape: landscape)
        case "share":
            let items = components?.queryItems ?? []
            guard let source = items.first(where: { $0.name == "path" })?.value.flatMap(fileURL(from:)),
                  let output = items.first(where: { $0.name == "out" })?.value.flatMap(fileURL(from:))
            else { return nil }
            let slug = items.first(where: { $0.name == "slug" })?.value.flatMap { $0.isEmpty ? nil : $0 }
            return .share(source: source, output: output, slug: slug)
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
