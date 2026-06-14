import SwiftUI

struct ReaderSearchBar: View {
    @Binding var query: String
    let matchCount: Int
    let currentIndex: Int
    var focus: FocusState<Bool>.Binding
    let onNext: () -> Void
    let onPrevious: () -> Void
    let onClose: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12))
                .foregroundStyle(Color.seshatFaint)

            TextField("Find in document", text: $query)
                .textFieldStyle(.plain)
                .font(.system(size: 13))
                .foregroundStyle(Color.seshatBodyText)
                .focused(focus)
                .frame(width: 200)
                .onSubmit(onNext)

            Text(countLabel)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(Color.seshatFaint)
                .frame(minWidth: 56, alignment: .trailing)
                .monospacedDigit()

            Divider().frame(height: 16)

            Button(action: onPrevious) {
                Image(systemName: "chevron.up")
            }
            .buttonStyle(.borderless)
            .disabled(matchCount == 0)
            .help("Previous match (⇧⏎)")

            Button(action: onNext) {
                Image(systemName: "chevron.down")
            }
            .buttonStyle(.borderless)
            .disabled(matchCount == 0)
            .help("Next match (⏎)")

            Button(action: onClose) {
                Image(systemName: "xmark")
            }
            .buttonStyle(.borderless)
            .help("Close (esc)")
        }
        .font(.system(size: 12))
        .foregroundStyle(Color.seshatBodyText)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.seshatPaper)
                .shadow(color: .black.opacity(0.18), radius: 14, y: 6)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.seshatRule, lineWidth: 0.5)
        }
    }

    private var countLabel: String {
        if query.isEmpty { return "" }
        if matchCount == 0 { return "No results" }
        return "\(currentIndex + 1) of \(matchCount)"
    }
}
