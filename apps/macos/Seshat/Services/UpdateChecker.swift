import Foundation

struct UpdateInfo: Equatable {
    let version: String
    let releaseURL: URL
    let downloadURL: URL
}

/// Polls the public GitHub Releases API on launch and surfaces a newer build so
/// users don't have to manually re-download. No server dependency — the same
/// releases the `release.yml` workflow publishes are the source of truth.
@Observable
@MainActor
final class UpdateChecker {
    private static let latestReleaseURL = URL(
        string: "https://api.github.com/repos/keremcanseker/seshat/releases/latest"
    )!

    private(set) var available: UpdateInfo?

    private let currentVersion: String
    private var dismissedVersion: String? {
        get { UserDefaults.standard.string(forKey: "SeshatDismissedUpdateVersion") }
        set { UserDefaults.standard.set(newValue, forKey: "SeshatDismissedUpdateVersion") }
    }

    init(currentVersion: String = UpdateChecker.bundleVersion) {
        self.currentVersion = currentVersion
    }

    static var bundleVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    }

    func check() async {
        do {
            var request = URLRequest(url: Self.latestReleaseURL)
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            request.timeoutInterval = 10
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                return
            }
            let release = try JSONDecoder().decode(GitHubRelease.self, from: data)
            guard !release.draft, !release.prerelease else { return }

            let latest = Self.normalize(release.tagName)
            guard Self.isVersion(latest, newerThan: Self.normalize(currentVersion)) else { return }
            guard latest != dismissedVersion else { return }

            guard let releaseURL = URL(string: release.htmlUrl) else { return }
            let asset = release.assets.first { $0.name.lowercased().hasSuffix(".dmg") }
            let downloadURL = asset.flatMap { URL(string: $0.browserDownloadUrl) } ?? releaseURL

            available = UpdateInfo(version: latest, releaseURL: releaseURL, downloadURL: downloadURL)
            seshatLog("UpdateChecker — update available: \(latest) (current \(currentVersion))")
        } catch {
            seshatLog("UpdateChecker — check failed: \(error.localizedDescription)")
        }
    }

    func dismiss() {
        dismissedVersion = available?.version
        available = nil
    }

    private static func normalize(_ tag: String) -> String {
        tag.hasPrefix("v") ? String(tag.dropFirst()) : tag
    }

    /// Numeric, component-wise semver-ish comparison (1.10.0 > 1.9.0).
    static func isVersion(_ lhs: String, newerThan rhs: String) -> Bool {
        let l = lhs.split(separator: ".").map { Int($0) ?? 0 }
        let r = rhs.split(separator: ".").map { Int($0) ?? 0 }
        for i in 0..<max(l.count, r.count) {
            let a = i < l.count ? l[i] : 0
            let b = i < r.count ? r[i] : 0
            if a != b { return a > b }
        }
        return false
    }
}

private struct GitHubRelease: Decodable {
    let tagName: String
    let htmlUrl: String
    let draft: Bool
    let prerelease: Bool
    let assets: [Asset]

    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case htmlUrl = "html_url"
        case draft
        case prerelease
        case assets
    }

    struct Asset: Decodable {
        let name: String
        let browserDownloadUrl: String

        enum CodingKeys: String, CodingKey {
            case name
            case browserDownloadUrl = "browser_download_url"
        }
    }
}
