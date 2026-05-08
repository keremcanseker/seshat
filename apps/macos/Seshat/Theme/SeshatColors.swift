import AppKit
import SwiftUI

extension Color {
    static let seshatPaper = Color(
        light: (252/255, 250/255, 247/255),
        dark:  ( 26/255,  22/255,  20/255)
    )

    static let seshatBgSubtle = Color(
        light: (246/255, 242/255, 236/255),
        dark:  ( 34/255,  30/255,  27/255)
    )

    static let seshatSidebarBg = Color(
        light: (244/255, 239/255, 231/255),
        dark:  ( 31/255,  26/255,  23/255)
    )

    static let seshatBodyText = Color(
        light: ( 42/255,  37/255,  34/255),
        dark:  (232/255, 226/255, 216/255)
    )

    static let seshatHeading = Color(
        light: ( 42/255,  37/255,  34/255),
        dark:  (232/255, 226/255, 216/255)
    )

    static let seshatMuted = Color(
        light: (107/255,  95/255,  80/255),
        dark:  (154/255, 143/255, 128/255)
    )

    static let seshatFaint = Color(
        light: (154/255, 143/255, 128/255),
        dark:  (106/255,  95/255,  80/255)
    )

    static let seshatRule = Color(
        light: (236/255, 230/255, 221/255),
        dark:  ( 44/255,  39/255,  35/255)
    )

    static let seshatRuleStrong = Color(
        light: (217/255, 208/255, 194/255),
        dark:  ( 58/255,  51/255,  45/255)
    )

    static let seshatLink = Color(
        light: ( 30/255,  70/255,  95/255),
        dark:  (130/255, 180/255, 210/255)
    )

    static let seshatAccent = Color(
        light: (194/255, 140/255,  69/255),
        dark:  (194/255, 140/255,  69/255)
    )

    static let seshatAccentSoft = Color(
        light: (212/255, 177/255, 134/255),
        dark:  (170/255, 140/255, 100/255)
    )
}

private extension Color {
    init(
        light: (Double, Double, Double),
        dark: (Double, Double, Double)
    ) {
        self.init(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
            let rgb = isDark ? dark : light
            return NSColor(srgbRed: rgb.0, green: rgb.1, blue: rgb.2, alpha: 1)
        })
    }
}
