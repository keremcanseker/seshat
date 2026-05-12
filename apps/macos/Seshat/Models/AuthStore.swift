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
    private(set) var lastError: String?
    let api: APIClient

    private(set) var token: String?

    init(api: APIClient = APIClient()) {
        self.api = api
        self.token = TokenStore.loadToken()
        self.api.authStore = self
        self.status = token == nil ? .signedOut : .unknown
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
        status = .signedOut
        lastError = nil
    }

    func handleUnauthorized() {
        seshatLog("AuthStore.handleUnauthorized — clearing token")
        TokenStore.deleteToken()
        token = nil
        currentUser = nil
        status = .signedOut
    }

    func refreshUser() async {
        guard token != nil else { return }
        do {
            let user: User = try await api.get("auth/me")
            currentUser = user
            status = .signedIn
            lastError = nil
        } catch APIError.unauthorized {
            return
        } catch {
            seshatLog("AuthStore.refreshUser failed: \(error.localizedDescription)")
            lastError = error.localizedDescription
            if currentUser == nil { status = .signedOut }
        }
    }
}
