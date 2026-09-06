import Foundation

/// The workspace's open documents in strip order, plus the active one. Persists to
/// UserDefaults on every mutation, like `ReadState`; window restoration is off, so this
/// is the only memory of tabs across launches. `active` is nil exactly when `tabs` is empty.
@Observable
@MainActor
final class WorkspaceTabs {
    static let tabsKey = "SeshatWorkspaceTabs"
    static let activeKey = "SeshatWorkspaceActiveTab"
    /// Past this the leftmost inactive tab makes room, so the strip never has to scroll.
    static let maxTabs = 10
    private static let reopenLimit = 20

    private(set) var tabs: [URL] = []
    private(set) var active: URL?
    private(set) var missing: Set<URL> = []
    /// The one tab a sidebar click reuses (VS Code's italic preview). Not persisted: after a
    /// relaunch every restored tab is permanent.
    private(set) var preview: URL?
    private var closed: [(url: URL, index: Int)] = []

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let stored = defaults.array(forKey: Self.tabsKey) as? [String] ?? []
        var restored: [URL] = []
        for path in stored {
            let url = URL(fileURLWithPath: path).seshatNormalized
            guard !restored.contains(where: { $0.seshatMatches(url) }) else { continue }
            guard FileManager.default.fileExists(atPath: url.path) else {
                seshatLog("WorkspaceTabs.init — dropped missing \(url.path)")
                continue
            }
            restored.append(url)
        }
        tabs = restored
        let storedActive = defaults.string(forKey: Self.activeKey)
            .map { URL(fileURLWithPath: $0).seshatNormalized }
        active = storedActive.flatMap { wanted in restored.first { $0.seshatMatches(wanted) } } ?? restored.first
        seshatLog("WorkspaceTabs.init — restored \(restored.count) tab(s), active=\(active?.lastPathComponent ?? "nil")")
    }

    var isEmpty: Bool { tabs.isEmpty }
    var canGoPrevious: Bool { (activeIndex ?? 0) > 0 }
    var canGoNext: Bool { activeIndex.map { $0 < tabs.count - 1 } ?? false }
    var canReopen: Bool { !closed.isEmpty }

    func isActive(_ url: URL) -> Bool { active?.seshatMatches(url) == true }
    func isMissing(_ url: URL) -> Bool { missing.contains(url.seshatNormalized) }
    func isPreview(_ url: URL) -> Bool { preview?.seshatMatches(url) == true }

    /// "folder › name" while another open tab shares the name.
    func title(for url: URL) -> String {
        let name = url.deletingPathExtension().lastPathComponent
        let shared = tabs.contains {
            !$0.seshatMatches(url) && $0.deletingPathExtension().lastPathComponent == name
        }
        return shared ? "\(url.deletingLastPathComponent().lastPathComponent) › \(name)" : name
    }

    // MARK: Opening and activating

    /// A preview open reuses the current preview tab in place; a permanent open appends (and
    /// pins the tab if it was the preview). Opening an already open file just activates it.
    func open(_ url: URL, asPreview: Bool = false) {
        let target = url.seshatNormalized
        if let existing = tabs.first(where: { $0.seshatMatches(target) }) {
            active = existing
            if !asPreview { pin(existing) }
        } else if asPreview, let preview, let index = index(of: preview) {
            tabs[index] = target
            missing.remove(preview)
            self.preview = target
            active = target
            noteMissing(target)
            seshatLog("WorkspaceTabs.open — preview \(target.lastPathComponent)")
        } else {
            if tabs.count >= Self.maxTabs, let evicted = tabs.first(where: { !isActive($0) }) {
                close(evicted)
            }
            tabs.append(target)
            active = target
            if asPreview { preview = target }
            noteMissing(target)
            seshatLog("WorkspaceTabs.open — \(target.lastPathComponent) (\(tabs.count) open)")
        }
        commit()
    }

    /// Makes the preview tab permanent (double-click, reorder, explicit open).
    func pin(_ url: URL) {
        guard isPreview(url) else { return }
        preview = nil
    }

    func activate(_ url: URL) {
        guard let index = index(of: url) else { return }
        activate(index: index)
    }

    func activate(index: Int) {
        guard tabs.indices.contains(index) else { return }
        active = tabs[index]
        commit()
    }

    /// ⌘1…⌘8 pick the nth tab, ⌘9 the last one.
    func activate(number: Int) {
        activate(index: number == 9 ? tabs.count - 1 : number - 1)
    }

    func activateNext() {
        if let index = activeIndex { activate(index: index + 1) }
    }

    func activatePrevious() {
        if let index = activeIndex { activate(index: index - 1) }
    }

    // MARK: Closing

    /// Closing the active tab activates its right neighbour, or the left one at the end.
    func close(_ url: URL) {
        guard let index = index(of: url) else { return }
        let removed = tabs.remove(at: index)
        missing.remove(removed)
        if isPreview(removed) { preview = nil }
        pushClosed(removed, at: index)
        if active?.seshatMatches(removed) == true {
            active = tabs.indices.contains(index) ? tabs[index] : tabs.last
        }
        seshatLog("WorkspaceTabs.close — \(removed.lastPathComponent) (\(tabs.count) open)")
        commit()
    }

    func closeOthers(_ url: URL) {
        guard index(of: url) != nil else { return }
        for other in tabs where !other.seshatMatches(url) {
            close(other)
        }
    }

    func closeRight(of url: URL) {
        guard let index = index(of: url) else { return }
        for other in tabs[(index + 1)...].reversed() {
            close(other)
        }
    }

    func closeAll() {
        for url in tabs.reversed() {
            close(url)
        }
    }

    /// A deleted file closes its tab; a deleted folder closes every tab under it.
    func closeDeleted(_ url: URL) {
        let gone = url.seshatNormalized
        for tab in tabs.reversed() where tab.seshatMatches(gone) || tab.seshatHasPathPrefix(of: gone) {
            close(tab)
        }
    }

    /// Most recently closed first, back at its former index clamped to the current count.
    func reopenLast() {
        guard let last = closed.popLast() else { return }
        if let existing = index(of: last.url) {
            activate(index: existing)
            return
        }
        let index = min(last.index, tabs.count)
        tabs.insert(last.url, at: index)
        active = last.url
        noteMissing(last.url)
        seshatLog("WorkspaceTabs.reopenLast — \(last.url.lastPathComponent) at \(index)")
        commit()
    }

    // MARK: Reordering and disk changes

    func move(from source: Int, to destination: Int) {
        guard tabs.indices.contains(source), tabs.indices.contains(destination), source != destination else { return }
        let url = tabs.remove(at: source)
        tabs.insert(url, at: destination)
        pin(url)
        commit()
    }

    /// A file remaps its own tab; a folder remaps every tab under it. Two tabs landing on
    /// the same URL merge into one.
    func remap(from oldURL: URL, to newURL: URL) {
        let old = oldURL.seshatNormalized
        let new = newURL.seshatNormalized
        guard !old.seshatMatches(new) else { return }

        func mapped(_ url: URL) -> URL? {
            if url.seshatMatches(old) { return new }
            guard url.seshatHasPathPrefix(of: old) else { return nil }
            let relative = url.pathComponents.dropFirst(old.pathComponents.count)
            return relative.reduce(new) { $0.appendingPathComponent($1) }.seshatNormalized
        }

        var result: [URL] = []
        var changed = false
        for url in tabs {
            let target = mapped(url) ?? url
            if target != url { changed = true }
            if result.contains(where: { $0.seshatMatches(target) }) {
                changed = true
                continue
            }
            result.append(target)
        }
        guard changed else { return }
        tabs = result
        if let active, let target = mapped(active) {
            self.active = target
        }
        if let preview, let target = mapped(preview) {
            self.preview = target
        }
        closed = closed.map { (mapped($0.url) ?? $0.url, $0.index) }
        refreshMissing()
        seshatLog("WorkspaceTabs.remap — \(old.lastPathComponent) → \(new.lastPathComponent)")
        commit()
    }

    func refreshMissing() {
        missing = Set(tabs.filter { !FileManager.default.fileExists(atPath: $0.path) })
    }

    // MARK: Private

    private var activeIndex: Int? { active.flatMap(index(of:)) }

    private func index(of url: URL) -> Int? {
        tabs.firstIndex { $0.seshatMatches(url) }
    }

    private func noteMissing(_ url: URL) {
        if !FileManager.default.fileExists(atPath: url.path) {
            missing.insert(url)
        }
    }

    private func pushClosed(_ url: URL, at index: Int) {
        closed.append((url, index))
        if closed.count > Self.reopenLimit {
            closed.removeFirst(closed.count - Self.reopenLimit)
        }
    }

    private func commit() {
        if let active, index(of: active) == nil {
            assertionFailure("WorkspaceTabs: active tab is not open")
            self.active = tabs.first
        }
        if active == nil, let first = tabs.first {
            assertionFailure("WorkspaceTabs: tabs open but none active")
            active = first
        }
        defaults.set(tabs.map(\.path), forKey: Self.tabsKey)
        defaults.set(active?.path, forKey: Self.activeKey)
    }
}
