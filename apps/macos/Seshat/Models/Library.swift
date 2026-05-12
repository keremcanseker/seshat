import Foundation

private extension URL {
    var modificationDate: Date? {
        (try? resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate
    }
}

@Observable
@MainActor
final class Library {
    static let markdownExtensions: Set<String> = ["md", "markdown", "mdown", "mkdn"]

    let rootURL: URL
    private(set) var folders: [LibraryFolder] = []
    private var watcher: LibraryWatcher?

    init(rootURL: URL = Library.defaultRootURL) {
        self.rootURL = rootURL
        ensureRootExists()
        refresh()
        startWatching()
    }

    private func startWatching() {
        watcher = LibraryWatcher { [weak self] in
            MainActor.assumeIsolated {
                self?.refresh()
            }
        }
        watcher?.start(rootURL: rootURL)
    }

    static var defaultRootURL: URL {
        FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Seshat", isDirectory: true)
    }

    func refresh() {
        folders = scan()
    }

    func importFiles(_ urls: [URL], into folderURL: URL? = nil) {
        let manager = FileManager.default
        let inbox = rootURL.appendingPathComponent("Inbox", isDirectory: true)
        let target = folderURL ?? inbox
        try? manager.createDirectory(at: target, withIntermediateDirectories: true)

        for src in urls {
            let resolved = src.standardizedFileURL
            guard Library.markdownExtensions.contains(resolved.pathExtension.lowercased()) else {
                seshatLog("Library.importFiles — skipped non-markdown \(resolved.lastPathComponent)")
                continue
            }
            let dst = target.appendingPathComponent(resolved.lastPathComponent).standardizedFileURL
            if dst.path == resolved.path { continue }

            do {
                if manager.fileExists(atPath: dst.path) {
                    try manager.removeItem(at: dst)
                }
                try manager.copyItem(at: resolved, to: dst)
                seshatLog("Library.importFiles — \(resolved.lastPathComponent) → \(target.lastPathComponent)")
            } catch {
                seshatLog("Library.importFiles — copy failed for \(resolved.path): \(error)")
            }
        }
        refresh()
    }

    func file(at url: URL) -> LibraryFile? {
        for folder in folders {
            if let match = folder.files.first(where: { $0.url == url }) {
                return match
            }
        }
        return nil
    }

    private func ensureRootExists() {
        let manager = FileManager.default
        guard !manager.fileExists(atPath: rootURL.path) else { return }
        try? manager.createDirectory(at: rootURL, withIntermediateDirectories: true)
        let inbox = rootURL.appendingPathComponent("Inbox", isDirectory: true)
        try? manager.createDirectory(at: inbox, withIntermediateDirectories: true)
    }

    private func scan() -> [LibraryFolder] {
        let manager = FileManager.default
        guard let entries = try? manager.contentsOfDirectory(
            at: rootURL,
            includingPropertiesForKeys: [.isDirectoryKey, .nameKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }

        let subfolders = entries
            .filter { (try? $0.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true }
            .sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }

        return subfolders.compactMap { folderURL in
            let folderName = folderURL.lastPathComponent
            let files = scanFiles(in: folderURL, folderName: folderName)
            guard !files.isEmpty else { return nil }
            return LibraryFolder(url: folderURL, name: folderName, files: files)
        }
    }

    private func scanFiles(in folder: URL, folderName: String) -> [LibraryFile] {
        let manager = FileManager.default
        guard let contents = try? manager.contentsOfDirectory(
            at: folder,
            includingPropertiesForKeys: [.isRegularFileKey, .nameKey, .contentModificationDateKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }

        return contents
            .filter { Library.markdownExtensions.contains($0.pathExtension.lowercased()) }
            .sorted { lhs, rhs in
                let lDate = lhs.modificationDate
                let rDate = rhs.modificationDate
                switch (lDate, rDate) {
                case (let l?, let r?): return l > r
                case (.some, .none):   return true
                case (.none, .some):   return false
                case (.none, .none):
                    return lhs.lastPathComponent.localizedStandardCompare(rhs.lastPathComponent) == .orderedAscending
                }
            }
            .map { url in
                LibraryFile(
                    url: url,
                    name: url.deletingPathExtension().lastPathComponent,
                    folderName: folderName,
                    modifiedAt: url.modificationDate
                )
            }
    }
}
