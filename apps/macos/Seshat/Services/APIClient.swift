import Foundation

enum APIError: LocalizedError {
    case invalidResponse
    case unauthorized
    /// 402 from the server: `code` is quota_exceeded, read_only_over_quota or feature_required.
    case paymentRequired(code: String, upgradeURL: URL?, message: String)
    case server(status: Int, message: String)
    case transport(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server returned an unexpected response."
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .paymentRequired(_, _, let message), .server(_, let message):
            return message
        case .transport(let error):
            return error.localizedDescription
        }
    }
}

@MainActor
final class APIClient {
    let baseURL: URL
    weak var authStore: AuthStore?

    init(baseURL: URL = URL(string: "https://api.seshat.page")!) {
        self.baseURL = baseURL
    }

    func get<Response: Decodable>(_ path: String, requiresAuth: Bool = true) async throws -> Response {
        try await send(path: path, method: "GET", body: Optional<EmptyBody>.none, requiresAuth: requiresAuth)
    }

    func post<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body,
        requiresAuth: Bool = true
    ) async throws -> Response {
        try await send(path: path, method: "POST", body: body, requiresAuth: requiresAuth)
    }

    func put<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body,
        requiresAuth: Bool = true
    ) async throws -> Response {
        try await send(path: path, method: "PUT", body: body, requiresAuth: requiresAuth)
    }

    func delete<Response: Decodable>(_ path: String, requiresAuth: Bool = true) async throws -> Response {
        try await send(path: path, method: "DELETE", body: Optional<EmptyBody>.none, requiresAuth: requiresAuth)
    }

    func fetchMe() async throws -> Me {
        try await get("me")
    }

    private func send<Body: Encodable, Response: Decodable>(
        path: String,
        method: String,
        body: Body?,
        requiresAuth: Bool
    ) async throws -> Response {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if requiresAuth, let token = authStore?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try Self.encoder.encode(body)
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.transport(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if http.statusCode == 401 {
            authStore?.handleUnauthorized()
            throw APIError.unauthorized
        }

        let errorBody = Self.errorBody(from: data)

        if http.statusCode == 402, let code = errorBody?.code {
            throw APIError.paymentRequired(
                code: code,
                upgradeURL: errorBody?.upgradeUrl.flatMap(URL.init(string:)),
                message: errorBody?.error ?? "This needs Seshat Premium."
            )
        }

        guard (200..<300).contains(http.statusCode) else {
            throw APIError.server(
                status: http.statusCode,
                message: errorBody?.error ?? "Request failed (\(http.statusCode))"
            )
        }

        if Response.self == EmptyResponse.self {
            return EmptyResponse() as! Response
        }

        do {
            return try Self.decoder.decode(Response.self, from: data)
        } catch {
            throw APIError.invalidResponse
        }
    }

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    /// Server errors are `{ error }`; 402s add `code` and `upgradeUrl`.
    private struct ErrorBody: Decodable {
        let error: String?
        let code: String?
        let upgradeUrl: String?
    }

    private static func errorBody(from data: Data) -> ErrorBody? {
        try? JSONDecoder().decode(ErrorBody.self, from: data)
    }
}

private struct EmptyBody: Encodable {}

struct EmptyResponse: Decodable {}

struct CreateDocBody: Encodable {
    let title: String
    let content: String
    /// Premium custom address (KER-808). Omitted from the JSON when nil.
    var slug: String? = nil
}

struct CreateDocResponse: Decodable {
    let slug: String
    let title: String
    let url: String
}

struct SitePage: Encodable, Equatable {
    let path: String
    let title: String
    let content: String
}

struct CreateSiteBody: Encodable {
    let title: String
    let pages: [SitePage]
}

struct CreateSiteResponse: Decodable {
    let slug: String
    let title: String
    let url: String
}
