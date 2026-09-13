import AppKit

/// Puts a document on the pasteboard in a shape the destination keeps intact (KER-814):
/// Slack mrkdwn as plain text, or HTML + RTF for Google Docs, Mail, Notion and friends.
/// The raw markdown rides along as the plain-text fallback of the rich copy.
enum DocumentCopier {
    enum Format {
        case slack
        case richText
    }

    @MainActor
    static func copy(_ markdown: String, as format: Format) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        switch format {
        case .slack:
            pasteboard.setString(SlackMrkdwn.render(markdown), forType: .string)
        case .richText:
            let html = "<meta charset=\"utf-8\">\n" + MarkdownHTML.render(markdown)
            pasteboard.setString(html, forType: .html)
            pasteboard.setString(markdown, forType: .string)
            if let rtf = rtf(fromHTML: html) {
                pasteboard.setData(rtf, forType: .rtf)
            }
        }
    }

    @MainActor
    private static func rtf(fromHTML html: String) -> Data? {
        guard let data = html.data(using: .utf8),
              let attributed = NSAttributedString(
                html: data,
                options: [.characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
              )
        else { return nil }
        return attributed.rtf(
            from: NSRange(location: 0, length: attributed.length),
            documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf]
        )
    }
}
