import AppKit
import SwiftUI

extension Color {
    static let seshatPaper = Color(
        light: (252/255, 250/255, 247/255),
        dark:  ( 24/255,  23/255,  21/255)
    )

    static let seshatBodyText = Color(
        light: ( 42/255,  37/255,  34/255),
        dark:  (224/255, 219/255, 209/255)
    )

    static let seshatHeading = Color(
        light: ( 22/255,  19/255,  17/255),
        dark:  (245/255, 240/255, 230/255)
    )

    static let seshatMuted = Color(
        light: (115/255, 105/255,  92/255),
        dark:  (160/255, 152/255, 138/255)
    )

    static let seshatLink = Color(
        light: ( 30/255,  70/255,  95/255),
        dark:  (130/255, 180/255, 210/255)
    )

    static let seshatRule = Color(
        light: (224/255, 215/255, 200/255),
        dark:  ( 64/255,  60/255,  54/255)
    )

    static let seshatBlockquoteRule = Color(
        light: (200/255, 175/255, 130/255),
        dark:  (140/255, 115/255,  72/255)
    )

    static let seshatCodeBg = Color(
        light: (244/255, 239/255, 230/255),
        dark:  ( 36/255,  34/255,  31/255)
    )

    static let seshatCodeText = Color(
        light: ( 60/255,  52/255,  46/255),
        dark:  (220/255, 214/255, 200/255)
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
