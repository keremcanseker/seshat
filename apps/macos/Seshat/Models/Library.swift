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
    static let inboxFolderName = "Inbox"

    let rootURL: URL
    private(set) var folders: [LibraryFolder] = []
    private(set) var lastError: LibraryError?
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

    func clearLastError() {
        lastError = nil
    }

    @discardableResult
    func createFolder(named rawName: String) -> URL? {
        lastError = nil
        let trimmed = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        let baseName: String
        if trimmed.isEmpty {
            baseName = "Untitled"
        } else {
            guard let validated = Self.validatedFolderName(trimmed) else {
                lastError = .invalidName
                return nil
            }
            baseName = validated
        }

        let folderURL = uniqueDirectoryURL(baseName: baseName)
        let manager = FileManager.default
        do {
            try manager.createDirectory(at: folderURL, withIntermediateDirectories: false)
            seshatLog("Library.createFolder — \(folderURL.lastPathComponent)")
            refresh()
            return folderURL
        } catch {
            seshatLog("Library.createFolder — failed: \(error)")
            if let cocoaError = error as? CocoaError, cocoaError.code == CocoaError.Code.fileWriteFileExists {
                lastError = .alreadyExists
            } else {
                lastError = .writeFailed
            }
            return nil
        }
    }

    @discardableResult
    func createFile(named rawName: String, in folderURL: URL) -> URL? {
        lastError = nil
        let folder = folderURL.standardizedFileURL
        guard isTopLevelWorkspaceFolder(folder) else {
            lastError = .notInLibrary
            return nil
        }

        let trimmed = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        let baseName: String
        if trimmed.isEmpty {
            baseName = "Untitled"
        } else {
            guard let validated = Self.validatedFileBaseName(trimmed) else {
                lastError = .invalidName
                return nil
            }
            baseName = validated
        }

        let fileURL = uniqueFileURL(baseName: baseName, ext: "md", in: folder)
        do {
            try "".write(to: fileURL, atomically: true, encoding: .utf8)
            seshatLog("Library.createFile — \(fileURL.lastPathComponent) in \(folder.lastPathComponent)")
            refresh()
            return fileURL
        } catch {
            seshatLog("Library.createFile — failed: \(error)")
            lastError = .writeFailed
            return nil
        }
    }

    @discardableResult
    func renameItem(at itemURL: URL, to newBaseName: String) -> URL? {
        lastError = nil
        let source = itemURL.standardizedFileURL
        guard isUnderLibraryRoot(source) else {
            lastError = .notInLibrary
            return nil
        }

        let manager = FileManager.default
        var isDirectory: ObjCBool = false
        guard manager.fileExists(atPath: source.path, isDirectory: &isDirectory) else {
            lastError = .notFound
            return nil
        }

        let destinationName: String
        if isDirectory.boolValue {
            guard let folderName = Self.validatedFolderName(newBaseName) else {
                lastError = .invalidName
                return nil
            }
            destinationName = folderName
        } else {
            guard let fileBase = Self.validatedFileBaseName(newBaseName) else {
                lastError = .invalidName
                return nil
            }
            let ext = source.pathExtension
            destinationName = ext.isEmpty ? fileBase : "\(fileBase).\(ext)"
        }

        let parent = source.deletingLastPathComponent()
        let destination = parent.appendingPathComponent(destinationName).standardizedFileURL
        if destination == source {
            return source
        }
        if manager.fileExists(atPath: destination.path) {
            lastError = .alreadyExists
            return nil
        }

        do {
            try manager.moveItem(at: source, to: destination)
            seshatLog("Library.renameItem — \(source.lastPathComponent) → \(destination.lastPathComponent)")
            refresh()
            return destination
        } catch {
            seshatLog("Library.renameItem — failed: \(error)")
            lastError = .writeFailed
            return nil
        }
    }

    func importFiles(_ urls: [URL], into folderURL: URL? = nil) {
        lastError = nil
        let manager = FileManager.default
        let inbox = rootURL.appendingPathComponent(Self.inboxFolderName, isDirectory: true)
        let target = folderURL ?? inbox
        try? manager.createDirectory(at: target, withIntermediateDirectories: true)

        var hadFailure = false
        for src in urls {
            let resolved = src.seshatNormalized
            guard Self.markdownExtensions.contains(resolved.pathExtension.lowercased()) else {
                seshatLog("Library.importFiles — skipped non-markdown \(resolved.lastPathComponent)")
                continue
            }
            let dst = target.appendingPathComponent(resolved.lastPathComponent).seshatNormalized
            if dst.seshatMatches(resolved) { continue }

            do {
                if manager.fileExists(atPath: dst.path) {
                    try manager.removeItem(at: dst)
                }
                try manager.copyItem(at: resolved, to: dst)
                seshatLog("Library.importFiles — \(resolved.lastPathComponent) → \(target.lastPathComponent)")
            } catch {
                seshatLog("Library.importFiles — copy failed for \(resolved.path): \(error)")
                hadFailure = true
            }
        }
        if hadFailure {
            lastError = .writeFailed
        }
        refresh()
    }

    func file(at url: URL) -> LibraryFile? {
        let target = url.seshatNormalized
        for folder in folders {
            if let match = folder.files.first(where: { $0.url.seshatMatches(target) }) {
                return match
            }
        }
        return nil
    }

    func folder(containing fileURL: URL) -> LibraryFolder? {
        let parent = fileURL.seshatNormalized.deletingLastPathComponent()
        return folders.first { $0.url.seshatMatches(parent) }
    }

    func isLibraryMarkdownFile(_ url: URL) -> Bool {
        let item = url.standardizedFileURL
        guard isUnderLibraryRoot(item) else { return false }
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: item.path, isDirectory: &isDirectory),
              !isDirectory.boolValue else { return false }
        return Self.markdownExtensions.contains(item.pathExtension.lowercased())
    }

    @discardableResult
    func moveFile(at fileURL: URL, toFolder folderURL: URL) -> URL? {
        lastError = nil
        let source = fileURL.standardizedFileURL
        let destinationFolder = folderURL.standardizedFileURL

        guard isUnderLibraryRoot(source), isTopLevelWorkspaceFolder(destinationFolder) else {
            lastError = .notInLibrary
            return nil
        }
        guard Self.markdownExtensions.contains(source.pathExtension.lowercased()) else {
            lastError = .notFound
            return nil
        }
        if source.deletingLastPathComponent() == destinationFolder {
            lastError = .sameLocation
            return nil
        }

        let manager = FileManager.default
        guard manager.fileExists(atPath: source.path) else {
            lastError = .notFound
            return nil
        }

        let destination = destinationFolder
            .appendingPathComponent(source.lastPathComponent)
            .standardizedFileURL
        if manager.fileExists(atPath: destination.path) {
            lastError = .alreadyExists
            return nil
        }

        do {
            try manager.moveItem(at: source, to: destination)
            seshatLog("Library.moveFile — \(source.lastPathComponent) → \(destinationFolder.lastPathComponent)")
            refresh()
            return destination
        } catch {
            seshatLog("Library.moveFile — failed: \(error)")
            lastError = .writeFailed
            return nil
        }
    }

    @discardableResult
    func deleteItem(at itemURL: URL) -> Bool {
        lastError = nil
        let target = itemURL.standardizedFileURL
        guard isUnderLibraryRoot(target) else {
            lastError = .notInLibrary
            return false
        }

        let manager = FileManager.default
        var isDirectory: ObjCBool = false
        guard manager.fileExists(atPath: target.path, isDirectory: &isDirectory) else {
            lastError = .notFound
            return false
        }

        if isDirectory.boolValue {
            guard isTopLevelWorkspaceFolder(target) else {
                lastError = .notInLibrary
                return false
            }
            let files = scanFiles(in: target, folderName: target.lastPathComponent)
            guard files.isEmpty else {
                lastError = .folderNotEmpty
                return false
            }
        }

        do {
            try manager.trashItem(at: target, resultingItemURL: nil)
            seshatLog("Library.deleteItem — trashed \(target.lastPathComponent)")
            refresh()
            return true
        } catch {
            seshatLog("Library.deleteItem — failed: \(error)")
            lastError = .writeFailed
            return false
        }
    }

    func inboxURL() -> URL {
        rootURL.appendingPathComponent(Self.inboxFolderName, isDirectory: true)
    }

    private func ensureRootExists() {
        let manager = FileManager.default
        guard !manager.fileExists(atPath: rootURL.path) else { return }
        try? manager.createDirectory(at: rootURL, withIntermediateDirectories: true)
        let inbox = inboxURL()
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
            .sorted { lhs, rhs in
                sortFolder(lhs, before: rhs)
            }

        return subfolders.map { folderURL in
            let folderName = folderURL.lastPathComponent
            let files = scanFiles(in: folderURL, folderName: folderName)
            return LibraryFolder(url: folderURL, name: folderName, files: files)
        }
    }

    private func sortFolder(_ lhs: URL, before rhs: URL) -> Bool {
        let lName = lhs.lastPathComponent
        let rName = rhs.lastPathComponent
        if lName == Self.inboxFolderName { return true }
        if rName == Self.inboxFolderName { return false }
        return lName.localizedStandardCompare(rName) == .orderedAscending
    }

    private func scanFiles(in folder: URL, folderName: String) -> [LibraryFile] {
        let manager = FileManager.default
        guard let contents = try? manager.contentsOfDirectory(
            at: folder,
            includingPropertiesForKeys: [.isRegularFileKey, .nameKey, .contentModificationDateKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }

        return contents
            .filter { Self.markdownExtensions.contains($0.pathExtension.lowercased()) }
            .sorted { lhs, rhs in
                let lDate = lhs.modificationDate
                let rDate = rhs.modificationDate
                switch (lDate, rDate) {
                case (let l?, let r?): return l > r
                case (.some, .none): return true
                case (.none, .some): return false
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

    private func isUnderLibraryRoot(_ url: URL) -> Bool {
        url.seshatHasPathPrefix(of: rootURL)
    }

    private func isTopLevelWorkspaceFolder(_ url: URL) -> Bool {
        let folder = url.seshatNormalized
        guard folder.deletingLastPathComponent().seshatMatches(rootURL) else {
            return false
        }
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }

    private func uniqueDirectoryURL(baseName: String) -> URL {
        let manager = FileManager.default
        var candidate = rootURL.appendingPathComponent(baseName, isDirectory: true)
        guard manager.fileExists(atPath: candidate.path) else { return candidate }

        var index = 2
        while manager.fileExists(atPath: candidate.path) {
            candidate = rootURL.appendingPathComponent("\(baseName) \(index)", isDirectory: true)
            index += 1
        }
        return candidate
    }

    private func uniqueFileURL(baseName: String, ext: String, in folder: URL) -> URL {
        let manager = FileManager.default
        var candidate = folder.appendingPathComponent("\(baseName).\(ext)")
        guard manager.fileExists(atPath: candidate.path) else { return candidate }

        var index = 2
        while manager.fileExists(atPath: candidate.path) {
            candidate = folder.appendingPathComponent("\(baseName) \(index).\(ext)")
            index += 1
        }
        return candidate
    }

    static func validatedFolderName(_ raw: String) -> String? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !containsInvalidPathCharacters(trimmed) else { return nil }
        return trimmed
    }

    static func validatedFileBaseName(_ raw: String) -> String? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !containsInvalidPathCharacters(trimmed) else { return nil }
        return trimmed
    }

    private static func containsInvalidPathCharacters(_ name: String) -> Bool {
        name.contains("/") || name.contains(":")
    }
}
