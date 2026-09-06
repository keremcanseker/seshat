import AppKit
import Foundation

@Observable
@MainActor
final class AuthStore {
    enum Status {
        case unknown
        case signedOut
        case signingIn
        case signedIn
    }

    private(set) var status: Status = .unknown
    private(set) var currentUser: User?
    /// Plan and usage from GET /me. Served from a 30-day UserDefaults cache while offline.
    private(set) var me: Me?
    private(set) var lastError: String?
    let api: APIClient

    private(set) var token: String?

    private struct CachedMe: Codable {
        let me: Me
        let fetchedAt: Date
    }

    private static let meCacheKey = "SeshatMe"
    private static let meCacheMaxAge: TimeInterval = 30 * 24 * 60 * 60

    init(api: APIClient = APIClient()) {
        self.api = api
        self.token = TokenStore.loadToken()
        self.api.authStore = self
        self.status = token == nil ? .signedOut : .unknown
        self.me = token == nil ? nil : Self.loadCachedMe()
    }

    var isAuthenticated: Bool {
        status == .signedIn && currentUser != nil
    }

    func bootstrap() {
        guard token != nil else { return }
        Task { await refreshUser() }
    }

    func signIn() {
        let url = api.baseURL
            .appendingPathComponent("auth")
            .appendingPathComponent("google")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "source", value: "macos")]
        guard let final = components?.url else { return }
        status = .signingIn
        lastError = nil
        seshatLog("AuthStore.signIn — opening \(final.absoluteString)")
        NSWorkspace.shared.open(final)
    }

    func handleCallback(token: String) {
        seshatLog("AuthStore.handleCallback — received token (\(token.count) chars)")
        do {
            try TokenStore.save(token: token)
            self.token = token
            Task { await refreshUser() }
        } catch {
            seshatLog("AuthStore.handleCallback — token save failed: \(error.localizedDescription)")
            lastError = "Couldn't store your session."
            status = .signedOut
        }
    }

    func signOut() {
        seshatLog("AuthStore.signOut")
        TokenStore.deleteToken()
        token = nil
        currentUser = nil
        clearMe()
        status = .signedOut
        lastError = nil
    }

    func handleUnauthorized() {
        seshatLog("AuthStore.handleUnauthorized — clearing token")
        TokenStore.deleteToken()
        token = nil
        currentUser = nil
        clearMe()
        status = .signedOut
    }

    func refreshUser() async {
        guard token != nil else { return }
        do {
            let user: User = try await api.get("auth/me")
            currentUser = user
            status = .signedIn
            lastError = nil
            await refreshMe()
        } catch APIError.unauthorized {
            return
        } catch {
            seshatLog("AuthStore.refreshUser failed: \(error.localizedDescription)")
            lastError = error.localizedDescription
            if currentUser == nil { status = .signedOut }
        }
    }

    /// Re-reads plan and usage. Failures keep the cached value; the server is the
    /// only authority, so a stale counter is better than a guessed one.
    func refreshMe() async {
        guard token != nil else { return }
        do {
            let fresh = try await api.fetchMe()
            me = fresh
            let cached = CachedMe(me: fresh, fetchedAt: .now)
            UserDefaults.standard.set(try? JSONEncoder().encode(cached), forKey: Self.meCacheKey)
        } catch {
            seshatLog("AuthStore.refreshMe failed: \(error.localizedDescription)")
        }
    }

    private func clearMe() {
        me = nil
        UserDefaults.standard.removeObject(forKey: Self.meCacheKey)
    }

    private static func loadCachedMe() -> Me? {
        guard let data = UserDefaults.standard.data(forKey: meCacheKey),
              let cached = try? JSONDecoder().decode(CachedMe.self, from: data),
              Date.now.timeIntervalSince(cached.fetchedAt) < meCacheMaxAge
        else { return nil }
        return cached.me
    }
}
