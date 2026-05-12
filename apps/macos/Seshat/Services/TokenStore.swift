import Foundation
import Security

enum TokenStore {
    private static let directoryName = "Seshat"
    private static let fileName = "auth.json"
    private static let legacyKeychainService = "com.keremcan.seshat"
    private static let legacyKeychainAccount = "auth-token"

    private struct Stored: Codable {
        let token: String
    }

    static func loadToken() -> String? {
        purgeLegacyKeychainItem()
        guard let data = try? Data(contentsOf: fileURL()),
              let stored = try? JSONDecoder().decode(Stored.self, from: data)
        else { return nil }
        return stored.token
    }

    static func save(token: String) throws {
        let url = fileURL()
        let dir = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(
            at: dir,
            withIntermediateDirectories: true,
            attributes: [.posixPermissions: 0o700]
        )
        let data = try JSONEncoder().encode(Stored(token: token))
        try data.write(to: url, options: [.atomic])
        try FileManager.default.setAttributes(
            [.posixPermissions: 0o600],
            ofItemAtPath: url.path
        )
    }

    static func deleteToken() {
        try? FileManager.default.removeItem(at: fileURL())
    }

    private static func fileURL() -> URL {
        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first ?? URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("Library/Application Support")
        return appSupport
            .appendingPathComponent(directoryName, isDirectory: true)
            .appendingPathComponent(fileName)
    }

    // SecItemDelete on a metadata-only query (service + account) does not
    // decrypt the secret, so it does not fire the Keychain ACL prompt.
    // No-op if the item doesn't exist.
    private static func purgeLegacyKeychainItem() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: legacyKeychainService,
            kSecAttrAccount as String: legacyKeychainAccount
        ]
        SecItemDelete(query as CFDictionary)
    }
}
