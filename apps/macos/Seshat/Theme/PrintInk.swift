import SwiftUI

/// Light values of `SeshatColors` frozen for paper, plus a white page. The PDF
/// must not follow the app's dark mode, so nothing here is appearance-dynamic.
enum PrintInk {
    /// Readable measure in landscape; a no-op in portrait, which is narrower.
    static let proseWidth: CGFloat = 540

    static let paper = Color.white
    static let subtle = Color(red: 246/255, green: 242/255, blue: 236/255)
    static let body = Color(red: 42/255, green: 37/255, blue: 34/255)
    static let muted = Color(red: 107/255, green: 95/255, blue: 80/255)
    static let faint = Color(red: 154/255, green: 143/255, blue: 128/255)
    static let rule = Color(red: 236/255, green: 230/255, blue: 221/255)
    static let ruleStrong = Color(red: 217/255, green: 208/255, blue: 194/255)
    static let link = Color(red: 30/255, green: 70/255, blue: 95/255)
    static let accent = Color(red: 194/255, green: 140/255, blue: 69/255)
}
