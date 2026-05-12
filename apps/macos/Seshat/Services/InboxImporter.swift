import Foundation

enum InboxImporter {
    @MainActor
    static func ensureInLibrary(_ fileURL: URL, libraryRoot: URL) -> URL {
        let manager = FileManager.default
        let source = fileURL.standardizedFileURL
        let rootPath = libraryRoot.standardizedFileURL.path

        if source.path == rootPath || source.path.hasPrefix(rootPath + "/") {
            return source
        }

        let inbox = libraryRoot.appendingPathComponent("Inbox", isDirectory: true)
        try? manager.createDirectory(at: inbox, withIntermediateDirectories: true)

        let destination = inbox
            .appendingPathComponent(source.lastPathComponent)
            .standardizedFileURL

        do {
            if manager.fileExists(atPath: destination.path) {
                try manager.removeItem(at: destination)
            }
            try manager.copyItem(at: source, to: destination)
            seshatLog("InboxImporter — copied \(source.lastPathComponent) into Inbox")
            return destination
        } catch {
            seshatLog("InboxImporter — copy failed for \(source.path): \(error)")
            return source
        }
    }
}
