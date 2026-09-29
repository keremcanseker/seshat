import SwiftUI
import UniformTypeIdentifiers

/// A tab or file dragged over a page lands in that pane, or over the page's right third in a
/// new pane beside it (VS Code's split on drop). A `DropDelegate` rather than `dropDestination`
/// because the highlighted zone has to follow the pointer during the drag.
struct PaneDropDelegate: DropDelegate {
    enum Zone { case here, side }

    @Binding var zone: Zone?
    let width: CGFloat
    let canSplit: Bool
    let onDropTab: @MainActor (WorkspaceTabDrag, Zone) -> Void
    /// Unfiltered; the receiver keeps the markdown files.
    let onDropFile: @MainActor (URL, Zone) -> Void

    func validateDrop(info: DropInfo) -> Bool {
        info.hasItemsConforming(to: [.seshatTab, .fileURL])
    }

    func dropEntered(info: DropInfo) {
        zone = zone(at: info.location)
    }

    /// Only a drag that entered moves the zone: AppKit reports the pointer once more after
    /// `performDrop`, which would otherwise put the highlight back with no drag left to clear it.
    func dropUpdated(info: DropInfo) -> DropProposal? {
        if zone != nil { zone = zone(at: info.location) }
        return DropProposal(operation: info.hasItemsConforming(to: [.seshatTab]) ? .move : .copy)
    }

    func dropExited(info: DropInfo) {
        zone = nil
    }

    func performDrop(info: DropInfo) -> Bool {
        let target = zone ?? .here
        zone = nil
        seshatLog("PaneDropDelegate.performDrop — \(target)")
        if let provider = info.itemProviders(for: [.seshatTab]).first {
            let onDropTab = onDropTab
            _ = provider.loadTransferable(type: WorkspaceTabDrag.self) { result in
                guard let drag = try? result.get() else { return }
                Task { @MainActor in onDropTab(drag, target) }
            }
            return true
        }
        let providers = info.itemProviders(for: [.fileURL])
        let onDropFile = onDropFile
        for provider in providers {
            _ = provider.loadTransferable(type: URL.self) { result in
                guard let url = try? result.get() else { return }
                Task { @MainActor in onDropFile(url, target) }
            }
        }
        return !providers.isEmpty
    }

    private func zone(at location: CGPoint) -> Zone {
        canSplit && location.x > width * 2 / 3 ? .side : .here
    }
}
