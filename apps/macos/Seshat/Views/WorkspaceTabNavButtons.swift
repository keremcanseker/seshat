import SwiftUI

/// ‹ › next to the sidebar toggle; tab switching only, no history.
struct WorkspaceTabNavButtons: View {
    let tabs: WorkspaceTabs

    var body: some View {
        HStack(spacing: 0) {
            navButton("Previous Tab", symbol: "chevron.left", enabled: tabs.canGoPrevious, action: tabs.activatePrevious)
            navButton("Next Tab", symbol: "chevron.right", enabled: tabs.canGoNext, action: tabs.activateNext)
        }
    }

    private func navButton(_ title: String, symbol: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(title, systemImage: symbol, action: action)
            .labelStyle(.iconOnly)
            .buttonStyle(.plain)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(enabled ? Color.seshatMuted : Color.seshatFaint.opacity(0.5))
            .frame(width: 22, height: 24)
            .contentShape(.rect)
            .disabled(!enabled)
            .help(title)
    }
}
