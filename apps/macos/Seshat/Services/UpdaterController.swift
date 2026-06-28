import Sparkle

/// Wraps Sparkle's standard updater so the app can install updates in place,
/// download, verify the EdDSA signature, swap the bundle, relaunch, instead of
/// making the user re-download and drag a DMG into Applications. Background
/// auto-checks are off (`SUEnableAutomaticChecks` = false in Info.plist); the
/// calm in-app banner from `UpdateChecker` is the only nudge, and acting on it
/// routes here for a user-initiated check that installs the update.
@Observable
@MainActor
final class UpdaterController {
    private let controller: SPUStandardUpdaterController

    init() {
        controller = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
    }

    func checkForUpdates() {
        controller.checkForUpdates(nil)
    }
}
