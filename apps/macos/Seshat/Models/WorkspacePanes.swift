import Foundation

/// The workspace's side-by-side panes, left to right, each with its own tabs (VS Code's editor
/// groups), plus the focused one that the sidebar, the menus and the toolbar act on. There is
/// always at least one pane; any other pane closes with its last tab. Persists to UserDefaults
/// on every change: window restoration is off, so this is the only memory of tabs across launches.
@Observable
@MainActor
final class WorkspacePanes {
    static let panesKey = "SeshatWorkspacePanes"
    static let focusedKey = "SeshatWorkspaceFocusedPane"
    /// Three 720pt columns already need a very wide window; past that nothing is readable.
    static let maxPanes = 3
    private static let reopenLimit = 20

    private(set) var panes: [WorkspaceTabs]
    private(set) var focused: WorkspaceTabs
    private var closed: [(url: URL, index: Int, pane: WorkspaceTabs.ID)] = []

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let stored = defaults.array(forKey: Self.panesKey) as? [[String: Any]] ?? []
        let restored = stored
            .map { WorkspaceTabs(paths: $0["tabs"] as? [String] ?? [], active: $0["active"] as? String) }
            .filter { !$0.isEmpty }
        let panes = restored.isEmpty ? [WorkspaceTabs()] : restored
        let index = defaults.integer(forKey: Self.focusedKey)
        self.panes = panes
        focused = panes.indices.contains(index) ? panes[index] : panes[0]
        for pane in panes { pane.owner = self }
        seshatLog("WorkspacePanes.init — restored \(panes.count) pane(s), \(panes.map(\.tabs.count)) tab(s)")
    }

    var canSplit: Bool { panes.count < Self.maxPanes && focused.active != nil }
    var canReopen: Bool { !closed.isEmpty }

    func isFocused(_ pane: WorkspaceTabs) -> Bool { pane === focused }

    func pane(id: WorkspaceTabs.ID) -> WorkspaceTabs? {
        panes.first { $0.id == id }
    }

    func focus(_ pane: WorkspaceTabs) {
        guard pane !== focused, panes.contains(where: { $0 === pane }) else { return }
        focused = pane
        save()
    }

    // MARK: Splitting

    /// ⌘\: the focused document also opens in a new pane on the right (VS Code's Split
    /// Editor), so one long file can be read in two places at once.
    func split() {
        guard canSplit, let url = focused.active else { return }
        let pane = addPane(after: focused)
        focused = pane
        pane.open(url)
    }

    /// ⌥-click and "Open to the Side": the pane right of `source`, made if there is none. At
    /// the pane limit the rightmost pane's side is its left neighbour.
    func openToSide(_ url: URL, of source: WorkspaceTabs? = nil) {
        let source = source ?? focused
        guard let index = panes.firstIndex(where: { $0 === source }) else { return }
        let target: WorkspaceTabs
        if panes.indices.contains(index + 1) {
            target = panes[index + 1]
        } else if panes.count < Self.maxPanes {
            target = addPane(after: source)
        } else {
            target = panes[index - 1]
        }
        focused = target
        target.open(url)
    }

    /// A tab dropped on another pane's tab or page. Its old pane closes if that was its last tab.
    func move(_ url: URL, from source: WorkspaceTabs, to destination: WorkspaceTabs, at index: Int) {
        guard source !== destination else { return }
        focused = destination
        destination.insert(url, at: index)
        source.detach(url)
    }

    /// A tab dropped on the right edge of a page: into a new pane beside it.
    func moveToSide(_ url: URL, from source: WorkspaceTabs, of pane: WorkspaceTabs) {
        guard panes.count < Self.maxPanes, panes.contains(where: { $0 === pane }) else { return }
        move(url, from: source, to: addPane(after: pane), at: 0)
    }

    // MARK: Reopening and disk changes

    /// Most recently closed first, back in its pane at its former index; into the focused
    /// pane when its own has closed since.
    func reopenLast() {
        guard let last = closed.popLast() else { return }
        let pane = self.pane(id: last.pane) ?? focused
        focused = pane
        pane.insert(last.url, at: last.index)
    }

    func remap(from oldURL: URL, to newURL: URL) {
        for pane in panes { pane.remap(from: oldURL, to: newURL) }
        closed = closed.map { ($0.url.seshatRemapped(from: oldURL, to: newURL) ?? $0.url, $0.index, $0.pane) }
    }

    func closeDeleted(_ url: URL) {
        for pane in panes { pane.closeDeleted(url) }
    }

    func refreshMissing() {
        for pane in panes { pane.refreshMissing() }
    }

    // MARK: Pane callbacks

    func paneDidClose(_ url: URL, at index: Int, in pane: WorkspaceTabs) {
        closed.append((url, index, pane.id))
        if closed.count > Self.reopenLimit {
            closed.removeFirst(closed.count - Self.reopenLimit)
        }
    }

    /// An emptied pane closes unless it is the last one; focus falls to its left neighbour.
    func paneDidChange(_ pane: WorkspaceTabs) {
        if pane.isEmpty, panes.count > 1, let index = panes.firstIndex(where: { $0 === pane }) {
            panes.remove(at: index)
            if focused === pane { focused = panes[max(index - 1, 0)] }
            seshatLog("WorkspacePanes — closed pane \(index), \(panes.count) left")
        }
        save()
    }

    // MARK: Private

    private func addPane(after pane: WorkspaceTabs) -> WorkspaceTabs {
        let added = WorkspaceTabs()
        added.owner = self
        let index = panes.firstIndex { $0 === pane } ?? panes.count - 1
        panes.insert(added, at: index + 1)
        seshatLog("WorkspacePanes — opened pane \(index + 1), \(panes.count) now")
        return added
    }

    private func save() {
        let stored: [[String: Any]] = panes.map { ["tabs": $0.tabs.map(\.path), "active": $0.active?.path ?? ""] }
        defaults.set(stored, forKey: Self.panesKey)
        defaults.set(panes.firstIndex { $0 === focused } ?? 0, forKey: Self.focusedKey)
    }
}
