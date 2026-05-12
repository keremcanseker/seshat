import AppKit
import Foundation

@MainActor
enum CLIInstaller {
    private static let symlinkPath = "/usr/local/bin/seshat"
    private static let promptedKey = "seshatCLIPrompted"

    static func runFirstLaunchIfNeeded() {
        guard let bundled = bundledCLIPath() else { return }
        if isCorrectlyInstalled(bundledPath: bundled) { return }
        if UserDefaults.standard.bool(forKey: promptedKey) { return }

        DispatchQueue.main.async {
            promptAndInstall(bundledPath: bundled)
        }
    }

    static func reinstallFromMenu() {
        guard let bundled = bundledCLIPath() else {
            showAlert(
                title: "CLI not bundled",
                body: "Seshat couldn't locate its bundled command-line tool.",
                style: .warning
            )
            return
        }
        promptAndInstall(bundledPath: bundled, forceEvenIfPrompted: true)
    }

    private static func bundledCLIPath() -> String? {
        Bundle.main.url(forResource: "seshat", withExtension: nil)?.path
    }

    private static func isCorrectlyInstalled(bundledPath: String) -> Bool {
        guard let resolved = try? FileManager.default.destinationOfSymbolicLink(atPath: symlinkPath) else {
            return false
        }
        return resolved == bundledPath && FileManager.default.isExecutableFile(atPath: resolved)
    }

    private static func promptAndInstall(bundledPath: String, forceEvenIfPrompted: Bool = false) {
        let alert = NSAlert()
        alert.messageText = "Install the seshat command?"
        alert.informativeText = """
        Adds a `seshat` command to your terminal so you can open markdown files from anywhere.

        You'll be asked for your password to install at /usr/local/bin/seshat.
        """
        alert.addButton(withTitle: "Install")
        alert.addButton(withTitle: "Not Now")
        alert.alertStyle = .informational

        let response = alert.runModal()
        UserDefaults.standard.set(true, forKey: promptedKey)
        guard response == .alertFirstButtonReturn else { return }

        switch performAdminInstall(source: bundledPath, target: symlinkPath) {
        case .success:
            showAlert(
                title: "seshat is ready",
                body: "Open a new terminal window and try `seshat help`.",
                style: .informational
            )
        case .failure(.userCancelled):
            return
        case .failure(.unsafePath):
            showAlert(
                title: "Install failed",
                body: "The Seshat application path contains characters that block automatic install. You can install manually: copy the bundled CLI from Seshat.app/Contents/Resources/seshat to a directory in your PATH.",
                style: .warning
            )
        case .failure(.scriptFailed(let message)):
            showAlert(
                title: "Install failed",
                body: message,
                style: .warning
            )
        }
    }

    private enum AdminInstallError: Error {
        case userCancelled
        case unsafePath
        case scriptFailed(String)
    }

    private static func performAdminInstall(source: String, target: String) -> Result<Void, AdminInstallError> {
        let dir = (target as NSString).deletingLastPathComponent
        let dangerous = CharacterSet(charactersIn: "\\\"\n\r")
        for component in [source, target, dir] {
            if component.rangeOfCharacter(from: dangerous) != nil {
                return .failure(.unsafePath)
            }
        }

        let script = """
        do shell script "mkdir -p " & quoted form of "\(dir)" & " && ln -sf " & quoted form of "\(source)" & " " & quoted form of "\(target)" with administrator privileges
        """

        var error: NSDictionary?
        _ = NSAppleScript(source: script)?.executeAndReturnError(&error)

        if let error {
            if (error[NSAppleScript.errorNumber] as? Int) == -128 {
                return .failure(.userCancelled)
            }
            let message = error[NSAppleScript.errorMessage] as? String ?? "Unknown error"
            return .failure(.scriptFailed(message))
        }
        return .success(())
    }

    private static func showAlert(title: String, body: String, style: NSAlert.Style) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = body
        alert.alertStyle = style
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
