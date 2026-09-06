import Foundation

struct UpdateInfo: Equatable {
    let version: String
    let downloadURL: URL
    var notes: String? = nil
}

/// Polls our own server (`/version`) on launch and surfaces a newer build so
/// users don't have to manually re-download. Self-hosted rather than GitHub
/// Releases because the repo is private — the server points at the current DMG.
@Observable
@MainActor
final class UpdateChecker {
    private static let versionURL = URL(string: "https://api.seshat.page/version")!

    private(set) var available: UpdateInfo?

    private let currentVersion: String

    init(currentVersion: String = UpdateChecker.bundleVersion) {
        self.currentVersion = currentVersion
    }

    static var bundleVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    }

    func check() async {
        do {
            var request = URLRequest(url: Self.versionURL)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.timeoutInterval = 10
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                return
            }
            let info = try JSONDecoder().decode(VersionResponse.self, from: data)

            let latest = Self.normalize(info.version)
            guard Self.isVersion(latest, newerThan: Self.normalize(currentVersion)) else { return }
            guard let downloadURL = URL(string: info.url) else { return }

            available = UpdateInfo(version: latest, downloadURL: downloadURL, notes: info.notes)
            seshatLog("UpdateChecker — update available: \(latest) (current \(currentVersion))")
        } catch {
            seshatLog("UpdateChecker — check failed: \(error.localizedDescription)")
        }
    }

    /// Snooze only: the card comes back on the next launch while the update is pending.
    func dismiss() {
        available = nil
    }

    private static func normalize(_ version: String) -> String {
        version.hasPrefix("v") ? String(version.dropFirst()) : version
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

private struct VersionResponse: Decodable {
    let version: String
    let url: String
    let notes: String?
}
