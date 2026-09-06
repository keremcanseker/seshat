import MarkdownUI
import SwiftUI

extension Theme {
    /// The reader theme scaled for paper: white background, 12pt body, fixed
    /// light palette (the PDF must not follow the app's dark mode).
    ///
    /// Spacing uses plain padding instead of `markdownMargin`: MarkdownUI resolves
    /// margins through `onPreferenceChange` into `@State`, which never settles inside
    /// `ImageRenderer`'s one-shot layout. Every text block also gets a vertical
    /// `fixedSize`, otherwise the renderer truncates long text with an ellipsis.
    @MainActor
    static let seshatPrint = Theme()
        .text {
            FontFamily(.system())
            FontSize(12)
            ForegroundColor(PrintInk.body)
        }
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.875))
            ForegroundColor(PrintInk.body)
            BackgroundColor(PrintInk.subtle)
        }
        .strong {
            FontWeight(.semibold)
        }
        .emphasis {
            FontStyle(.italic)
        }
        .link {
            ForegroundColor(PrintInk.link)
            UnderlineStyle(.single)
        }
        .heading1 { configuration in
            configuration.label
                .markdownTextStyle {
                    FontFamily(.system(.serif))
                    FontWeight(.bold)
                    FontSize(26)
                    ForegroundColor(PrintInk.body)
                }
                .frame(maxWidth: PrintInk.proseWidth, alignment: .leading)
                .printBlock(.heading, title: configuration.content.renderPlainText(), level: 1)
                .padding(.top, 16)
                .padding(.bottom, 2)
        }
        .heading2 { configuration in
            configuration.label
                .markdownTextStyle {
                    FontFamily(.system(.serif))
                    FontWeight(.bold)
                    FontSize(20)
                    ForegroundColor(PrintInk.body)
                }
                .frame(maxWidth: PrintInk.proseWidth, alignment: .leading)
                .printBlock(.heading, title: configuration.content.renderPlainText(), level: 2)
                .padding(.top, 18)
                .padding(.bottom, 2)
        }
        .heading3 { configuration in
            configuration.label
                .markdownTextStyle {
                    FontFamily(.system(.serif))
                    FontWeight(.semibold)
                    FontSize(16)
                    ForegroundColor(PrintInk.body)
                }
                .frame(maxWidth: PrintInk.proseWidth, alignment: .leading)
                .printBlock(.heading, title: configuration.content.renderPlainText(), level: 3)
                .padding(.top, 14)
        }
        .heading4 { configuration in
            configuration.label
                .markdownTextStyle {
                    FontWeight(.semibold)
                    FontSize(13.5)
                    ForegroundColor(PrintInk.body)
                }
                .frame(maxWidth: PrintInk.proseWidth, alignment: .leading)
                .printBlock(.heading, title: configuration.content.renderPlainText(), level: 4)
                .padding(.top, 10)
        }
        .heading5 { configuration in
            configuration.label
                .markdownTextStyle {
                    FontWeight(.semibold)
                    FontSize(12)
                    ForegroundColor(PrintInk.body)
                }
                .frame(maxWidth: PrintInk.proseWidth, alignment: .leading)
                .printBlock(.heading, title: configuration.content.renderPlainText(), level: 5)
                .padding(.top, 8)
        }
        .heading6 { configuration in
            configuration.label
                .markdownTextStyle {
                    FontWeight(.semibold)
                    FontSize(11)
                    FontCapsVariant(.lowercaseSmallCaps)
                    ForegroundColor(PrintInk.muted)
                }
                .frame(maxWidth: PrintInk.proseWidth, alignment: .leading)
                .printBlock(.heading, title: configuration.content.renderPlainText(), level: 6)
                .padding(.top, 6)
        }
        .paragraph { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.4))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: PrintInk.proseWidth, alignment: .leading)
                .printBlock(.breakable)
                .padding(.bottom, 4)
        }
        .blockquote { configuration in
            HStack(spacing: 0) {
                Rectangle()
                    .fill(PrintInk.accent)
                    .frame(width: 2)
                configuration.label
                    .padding(.leading, 16)
                    .padding(.vertical, 3)
                    .markdownTextStyle {
                        FontFamily(.system(.serif))
                        FontStyle(.italic)
                        FontSize(14)
                        ForegroundColor(PrintInk.body)
                    }
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: PrintInk.proseWidth, alignment: .leading)
            .printBlock(.breakable)
            .padding(.vertical, 8)
        }
        .codeBlock { configuration in
            PrintCodeBlock(content: configuration.content)
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(PrintInk.subtle)
                .clipShape(.rect(cornerRadius: 4))
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(PrintInk.rule, lineWidth: 0.5)
                }
                .printBlock(.keepTogether)
                .padding(.vertical, 6)
        }
        .image { configuration in
            configuration.label
                .printBlock(.keepTogether)
        }
        .listItem { configuration in
            configuration.label
                .frame(maxWidth: PrintInk.proseWidth, alignment: .leading)
                .printBlock(.breakable)
        }
        .bulletedListMarker { configuration in
            Group {
                switch configuration.listLevel {
                case 1:
                    SeshatStar()
                        .fill(PrintInk.accent)
                        .frame(width: 6, height: 6)
                case 2:
                    SeshatStar()
                        .stroke(PrintInk.muted, lineWidth: 0.8)
                        .frame(width: 6, height: 6)
                default:
                    Circle()
                        .fill(PrintInk.faint)
                        .frame(width: 3, height: 3)
                }
            }
            .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
            .padding(.trailing, 6)
        }
        .numberedListMarker { configuration in
            Text("\(configuration.itemNumber).")
                .monospacedDigit()
                .foregroundStyle(PrintInk.muted)
                .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
        }
        .taskListMarker { configuration in
            RoundedRectangle(cornerRadius: 2)
                .fill(configuration.isCompleted ? PrintInk.accent : Color.clear)
                .overlay {
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(
                            configuration.isCompleted ? PrintInk.accent : PrintInk.ruleStrong,
                            lineWidth: 1
                        )
                }
                .overlay {
                    if configuration.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 7, weight: .bold))
                            .foregroundStyle(PrintInk.paper)
                    }
                }
                .frame(width: 10, height: 10)
                .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
                .padding(.trailing, 6)
        }
        .table { configuration in
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .markdownTableBorderStyle(
                    .init(.horizontalBorders, color: PrintInk.ruleStrong, width: 0.5)
                )
                .markdownTableBackgroundStyle(
                    .alternatingRows(
                        Color.clear,
                        PrintInk.subtle.opacity(0.5),
                        header: Color.clear
                    )
                )
                .printBlock(.table)
                .padding(.vertical, 8)
        }
        .tableCell { configuration in
            configuration.label
                .markdownTextStyle {
                    FontSize(11)
                    if configuration.row == 0 {
                        FontWeight(.semibold)
                        ForegroundColor(PrintInk.body)
                    } else {
                        ForegroundColor(PrintInk.muted)
                    }
                    BackgroundColor(nil)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .printBlock(configuration.row == 0 ? .tableHeader : .keepTogether)
        }
        .thematicBreak {
            Rectangle()
                .fill(PrintInk.ruleStrong)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .padding(.vertical, 16)
        }
}
