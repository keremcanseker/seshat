import MarkdownUI
import SwiftUI

extension Theme {
    @MainActor
    static let seshat = Theme()
        .text {
            FontFamily(.system())
            FontSize(16)
            ForegroundColor(.seshatBodyText)
        }
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.88))
            ForegroundColor(.seshatCodeText)
            BackgroundColor(.seshatCodeBg)
        }
        .strong {
            FontWeight(.semibold)
        }
        .emphasis {
            FontStyle(.italic)
        }
        .link {
            ForegroundColor(.seshatLink)
            UnderlineStyle(.single)
        }
        .heading1 { configuration in
            configuration.label
                .markdownMargin(top: 32, bottom: 18)
                .markdownTextStyle {
                    FontFamily(.system(.serif))
                    FontWeight(.bold)
                    FontSize(36)
                    ForegroundColor(.seshatHeading)
                }
                .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
        }
        .heading2 { configuration in
            configuration.label
                .markdownMargin(top: 32, bottom: 14)
                .markdownTextStyle {
                    FontFamily(.system(.serif))
                    FontWeight(.bold)
                    FontSize(26)
                    ForegroundColor(.seshatHeading)
                }
                .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
        }
        .heading3 { configuration in
            configuration.label
                .markdownMargin(top: 26, bottom: 10)
                .markdownTextStyle {
                    FontFamily(.system(.serif))
                    FontWeight(.semibold)
                    FontSize(20)
                    ForegroundColor(.seshatHeading)
                }
                .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
        }
        .heading4 { configuration in
            configuration.label
                .markdownMargin(top: 22, bottom: 8)
                .markdownTextStyle {
                    FontFamily(.system())
                    FontWeight(.semibold)
                    FontSize(17)
                    ForegroundColor(.seshatHeading)
                }
                .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
        }
        .heading5 { configuration in
            configuration.label
                .markdownMargin(top: 20, bottom: 6)
                .markdownTextStyle {
                    FontFamily(.system())
                    FontWeight(.semibold)
                    FontSize(15)
                    ForegroundColor(.seshatHeading)
                }
                .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
        }
        .heading6 { configuration in
            configuration.label
                .markdownMargin(top: 18, bottom: 6)
                .markdownTextStyle {
                    FontFamily(.system())
                    FontWeight(.semibold)
                    FontSize(13)
                    FontCapsVariant(.lowercaseSmallCaps)
                    ForegroundColor(.seshatMuted)
                }
                .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
        }
        .paragraph { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.4))
                .markdownMargin(top: 0, bottom: 16)
                .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
        }
        .blockquote { configuration in
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.seshatBlockquoteRule)
                    .frame(width: 3)
                configuration.label
                    .padding(.leading, 16)
                    .padding(.vertical, 2)
                    .markdownTextStyle {
                        FontStyle(.italic)
                        ForegroundColor(.seshatMuted)
                    }
            }
            .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
            .markdownMargin(top: 16, bottom: 16)
        }
        .codeBlock { configuration in
            ScrollView(.horizontal, showsIndicators: false) {
                configuration.label
                    .padding(20)
                    .markdownTextStyle {
                        FontFamilyVariant(.monospaced)
                        FontSize(13.5)
                        ForegroundColor(.seshatCodeText)
                        BackgroundColor(nil)
                    }
            }
            .background(Color.seshatCodeBg)
            .clipShape(.rect(cornerRadius: 8))
            .markdownMargin(top: 16, bottom: 16)
        }
        .listItem { configuration in
            configuration.label
                .markdownMargin(top: .em(0.25))
                .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
        }
        .bulletedListMarker { configuration in
            BulletMarker(level: configuration.listLevel)
        }
        .numberedListMarker { configuration in
            Text("\(configuration.itemNumber).")
                .monospacedDigit()
                .foregroundStyle(Color.seshatMuted)
                .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
        }
        .taskListMarker { configuration in
            TaskMarker(isCompleted: configuration.isCompleted)
        }
        .table { configuration in
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .markdownTableBorderStyle(
                    .init(.horizontalBorders, color: .seshatRule, width: 0.5)
                )
                .markdownTableBackgroundStyle(
                    .alternatingRows(
                        Color.clear,
                        Color.seshatCodeBg.opacity(0.35),
                        header: Color.clear
                    )
                )
                .markdownMargin(top: 16, bottom: 16)
        }
        .tableCell { configuration in
            configuration.label
                .markdownTextStyle {
                    FontSize(15)
                    if configuration.row == 0 {
                        FontWeight(.semibold)
                        ForegroundColor(.seshatHeading)
                    }
                    BackgroundColor(nil)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
        }
        .thematicBreak {
            Rectangle()
                .fill(Color.seshatRule)
                .frame(maxWidth: 280, maxHeight: 1)
                .padding(.vertical, 24)
        }
}

enum Seshat {
    static let proseWidth: CGFloat = 720
    static let contentWidth: CGFloat = 920
}

private struct BulletMarker: View {
    let level: Int

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size, weight: .regular))
            .foregroundStyle(color)
            .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
    }

    private var symbol: String {
        switch level {
        case 1: "diamond.fill"
        case 2: "diamond"
        default: "circle.fill"
        }
    }

    private var size: CGFloat {
        level >= 3 ? 5 : 8
    }

    private var color: Color {
        level == 1 ? .seshatBlockquoteRule : .seshatMuted
    }
}

private struct TaskMarker: View {
    let isCompleted: Bool

    var body: some View {
        Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
            .font(.system(size: 14, weight: .regular))
            .foregroundStyle(isCompleted ? Color.seshatBlockquoteRule : Color.seshatMuted)
            .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
    }
}
