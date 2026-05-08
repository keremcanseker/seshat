import SwiftUI

enum AppearanceMode: String, CaseIterable {
    case light
    case dark

    var colorScheme: ColorScheme {
        switch self {
        case .light: .light
        case .dark: .dark
        }
    }

    var toggled: AppearanceMode {
        switch self {
        case .light: .dark
        case .dark: .light
        }
    }

    var nextSymbol: String {
        switch self {
        case .light: "moon"
        case .dark: "sun.max"
        }
    }

    var nextLabel: String {
        switch self {
        case .light: "Switch to dark theme"
        case .dark: "Switch to light theme"
        }
    }
}
