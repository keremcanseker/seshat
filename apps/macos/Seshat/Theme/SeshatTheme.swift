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
            FontSize(.em(0.875))
            ForegroundColor(.seshatBodyText)
            BackgroundColor(.seshatBgSubtle)
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
                .markdownMargin(top: 32, bottom: 8)
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
                .markdownMargin(top: 40, bottom: 12)
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
                .markdownMargin(top: 32, bottom: 10)
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
                .markdownMargin(top: 0, bottom: 18)
                .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
        }
        .blockquote { configuration in
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.seshatAccent)
                    .frame(width: 2)
                configuration.label
                    .padding(.leading, 22)
                    .padding(.vertical, 4)
                    .markdownTextStyle {
                        FontFamily(.system(.serif))
                        FontStyle(.italic)
                        FontSize(19)
                        ForegroundColor(.seshatBodyText)
                    }
            }
            .frame(maxWidth: Seshat.proseWidth, alignment: .leading)
            .markdownMargin(top: 28, bottom: 28)
        }
        .codeBlock { configuration in
            ScrollView(.horizontal) {
                configuration.label
                    .padding(.vertical, 18)
                    .padding(.horizontal, 22)
                    .markdownTextStyle {
                        FontFamilyVariant(.monospaced)
                        FontSize(14)
                        ForegroundColor(.seshatBodyText)
                        BackgroundColor(nil)
                    }
            }
            .scrollIndicators(.hidden)
            .background(Color.seshatBgSubtle)
            .clipShape(.rect(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.seshatRule, lineWidth: 0.5)
            }
            .markdownMargin(top: 22, bottom: 22)
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
            ScrollView(.horizontal) {
                configuration.label
                    .fixedSize(horizontal: false, vertical: true)
                    .markdownTableBorderStyle(
                        .init(.horizontalBorders, color: .seshatRuleStrong, width: 0.5)
                    )
                    .markdownTableBackgroundStyle(
                        .alternatingRows(
                            Color.clear,
                            Color.seshatBgSubtle.opacity(0.5),
                            header: Color.clear
                        )
                    )
            }
            .markdownMargin(top: 24, bottom: 24)
        }
        .tableCell { configuration in
            configuration.label
                .markdownTextStyle {
                    FontSize(15)
                    if configuration.row == 0 {
                        FontWeight(.semibold)
                        ForegroundColor(.seshatHeading)
                    } else {
                        ForegroundColor(.seshatMuted)
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
                .frame(maxWidth: .infinity, maxHeight: 0.5)
                .padding(.vertical, 32)
        }
}

enum Seshat {
    static let proseWidth: CGFloat = 720
}

private struct BulletMarker: View {
    let level: Int

    var body: some View {
        Group {
            switch level {
            case 1:
                SeshatStar()
                    .fill(Color.seshatAccent)
                    .frame(width: 7, height: 7)
            case 2:
                SeshatStar()
                    .stroke(Color.seshatMuted, lineWidth: 1)
                    .frame(width: 7, height: 7)
            default:
                Circle()
                    .fill(Color.seshatFaint)
                    .frame(width: 4, height: 4)
            }
        }
        .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
        .padding(.trailing, 8)
    }
}

private struct TaskMarker: View {
    let isCompleted: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(isCompleted ? Color.seshatAccent : Color.clear)
            .overlay {
                RoundedRectangle(cornerRadius: 3)
                    .strokeBorder(
                        isCompleted ? Color.seshatAccent : Color.seshatRuleStrong,
                        lineWidth: 1
                    )
            }
            .overlay {
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(Color.seshatPaper)
                }
            }
            .frame(width: 12, height: 12)
            .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
            .padding(.trailing, 8)
    }
}
