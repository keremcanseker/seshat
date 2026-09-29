import Foundation

/// One pane's open documents in strip order, plus its active one: a VS Code editor group.
/// `WorkspacePanes` owns the panes, persists them and keeps one reopen stack for all of them.
/// `active` is nil exactly when `tabs` is empty.
@Observable
@MainActor
final class WorkspaceTabs: Identifiable {
    /// Past this the leftmost inactive tab makes room.
    static let maxTabs = 10

    let id = UUID()
    private(set) var tabs: [URL] = []
    private(set) var active: URL?
    private(set) var missing: Set<URL> = []
    /// The one tab a sidebar click reuses (VS Code's italic preview). Not persisted: after a
    /// relaunch every restored tab is permanent.
    private(set) var preview: URL?
    /// Hears about every close (for ⌘⇧T) and every change (to persist, and to drop an emptied pane).
    @ObservationIgnored weak var owner: WorkspacePanes?

    /// Restores stored paths, skipping duplicates and files that no longer exist.
    init(paths: [String] = [], active activePath: String? = nil) {
        var restored: [URL] = []
        for path in paths {
            let url = URL(fileURLWithPath: path).seshatNormalized
            guard !restored.contains(where: { $0.seshatMatches(url) }) else { continue }
            guard FileManager.default.fileExists(atPath: url.path) else {
                seshatLog("WorkspaceTabs.init — dropped missing \(url.path)")
                continue
            }
            restored.append(url)
        }
        tabs = restored
        let wanted = activePath.map { URL(fileURLWithPath: $0).seshatNormalized }
        active = wanted.flatMap { wanted in restored.first { $0.seshatMatches(wanted) } } ?? restored.first
    }

    var isEmpty: Bool { tabs.isEmpty }
    var canGoPrevious: Bool { (activeIndex ?? 0) > 0 }
    var canGoNext: Bool { activeIndex.map { $0 < tabs.count - 1 } ?? false }

    func isActive(_ url: URL) -> Bool { active?.seshatMatches(url) == true }
    func isMissing(_ url: URL) -> Bool { missing.contains(url.seshatNormalized) }
    func isPreview(_ url: URL) -> Bool { preview?.seshatMatches(url) == true }

    func index(of url: URL) -> Int? {
        tabs.firstIndex { $0.seshatMatches(url) }
    }

    /// "folder › name" while another tab in this pane shares the name.
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
            makeRoom()
            tabs.append(target)
            active = target
            if asPreview { preview = target }
            noteMissing(target)
            seshatLog("WorkspaceTabs.open — \(target.lastPathComponent) (\(tabs.count) open)")
        }
        commit()
    }

    /// ⌘-click: the active tab shows `url` instead of opening another. The document it held
    /// goes on the reopen stack like a closed tab. An already open file is just activated.
    func replaceActive(with url: URL) {
        let target = url.seshatNormalized
        guard let active, let index = index(of: active), self.index(of: target) == nil else {
            open(target)
            return
        }
        owner?.paneDidClose(active, at: index, in: self)
        tabs[index] = target
        missing.remove(active)
        if isPreview(active) { preview = nil }
        self.active = target
        noteMissing(target)
        seshatLog("WorkspaceTabs.replaceActive — \(active.lastPathComponent) → \(target.lastPathComponent)")
        commit()
    }

    /// Puts `url` at `index` (clamped) as a permanent, active tab: a reopened tab, or one
    /// dragged in from another pane. An already open tab is just activated where it is.
    func insert(_ url: URL, at index: Int) {
        let target = url.seshatNormalized
        if let existing = self.index(of: target) {
            activate(index: existing)
            return
        }
        makeRoom()
        tabs.insert(target, at: min(index, tabs.count))
        active = target
        noteMissing(target)
        seshatLog("WorkspaceTabs.insert — \(target.lastPathComponent) at \(index)")
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
        remove(url, reopenable: true)
    }

    /// Leaves without a reopen entry: the tab moved to another pane.
    func detach(_ url: URL) {
        remove(url, reopenable: false)
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
        guard !oldURL.seshatMatches(newURL) else { return }
        var result: [URL] = []
        var changed = false
        for url in tabs {
            let target = url.seshatRemapped(from: oldURL, to: newURL) ?? url
            if target != url { changed = true }
            if result.contains(where: { $0.seshatMatches(target) }) {
                changed = true
                continue
            }
            result.append(target)
        }
        guard changed else { return }
        tabs = result
        if let active, let target = active.seshatRemapped(from: oldURL, to: newURL) {
            self.active = target
        }
        if let preview, let target = preview.seshatRemapped(from: oldURL, to: newURL) {
            self.preview = target
        }
        refreshMissing()
        seshatLog("WorkspaceTabs.remap — \(oldURL.lastPathComponent) → \(newURL.lastPathComponent)")
        commit()
    }

    func refreshMissing() {
        missing = Set(tabs.filter { !FileManager.default.fileExists(atPath: $0.path) })
    }

    // MARK: Private

    private var activeIndex: Int? { active.flatMap(index(of:)) }

    private func remove(_ url: URL, reopenable: Bool) {
        guard let index = index(of: url) else { return }
        let removed = tabs.remove(at: index)
        missing.remove(removed)
        if isPreview(removed) { preview = nil }
        if reopenable { owner?.paneDidClose(removed, at: index, in: self) }
        if active?.seshatMatches(removed) == true {
            active = tabs.indices.contains(index) ? tabs[index] : tabs.last
        }
        seshatLog("WorkspaceTabs.\(reopenable ? "close" : "detach") — \(removed.lastPathComponent) (\(tabs.count) open)")
        commit()
    }

    private func makeRoom() {
        if tabs.count >= Self.maxTabs, let evicted = tabs.first(where: { !isActive($0) }) {
            close(evicted)
        }
    }

    private func noteMissing(_ url: URL) {
        if !FileManager.default.fileExists(atPath: url.path) {
            missing.insert(url)
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
        owner?.paneDidChange(self)
    }
}
