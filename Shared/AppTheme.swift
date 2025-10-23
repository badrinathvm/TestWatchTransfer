//
//  AppTheme.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/21/25.
//

import Combine
import SwiftUI

// MARK: - Theme Protocol

protocol ThemeProtocol {
    // Primary Colors
    var primary: Color { get }
    var primaryLight: Color { get }
    var primaryDark: Color { get }

    // Accent & Interactive Colors
    var accent: Color { get }
    var accentLight: Color { get }

    // Semantic Colors
    var success: Color { get }
    var warning: Color { get }
    var error: Color { get }
    var info: Color { get }

    // Background Colors (system colors that adapt to dark mode)
    var backgroundPrimary: Color { get }
    var backgroundSecondary: Color { get }
    var surface: Color { get }

    // Text Colors
    var textPrimary: Color { get }
    var textSecondary: Color { get }

    // Spacing System
    var spacingXS: CGFloat { get }   // 4pt
    var spacingS: CGFloat { get }    // 8pt
    var spacingM: CGFloat { get }    // 12pt
    var spacingL: CGFloat { get }    // 16pt
    var spacingXL: CGFloat { get }   // 20pt
    var spacingXXL: CGFloat { get }  // 24pt

    // Corner Radius
    var radiusS: CGFloat { get }     // 8pt
    var radiusM: CGFloat { get }     // 12pt
    var radiusL: CGFloat { get }     // 16pt
    var radiusXL: CGFloat { get }    // 20pt
    var radiusCircle: CGFloat { get } // 50% (for pills)

    // Typography - Font Sizes
    var fontSizeCaption: CGFloat { get }      // 12pt
    var fontSizeFootnote: CGFloat { get }     // 13pt
    var fontSizeBody: CGFloat { get }         // 15-17pt
    var fontSizeTitle: CGFloat { get }        // 20pt
    var fontSizeHeading: CGFloat { get }      // 28pt
    var fontSizeLargeTitle: CGFloat { get }   // 34pt

    // Icon Sizes
    var iconSizeSmall: CGFloat { get }        // 16pt
    var iconSizeMedium: CGFloat { get }       // 20pt
    var iconSizeLarge: CGFloat { get }        // 28pt
    var iconSizeXLarge: CGFloat { get }       // 40pt
}

// MARK: - Pickleball Theme (Orange)

struct PickleballTheme: ThemeProtocol {
    // Primary Colors
    var primary: Color { .orange }
    var primaryLight: Color { Color.orange.opacity(0.15) }
    var primaryDark: Color { Color(red: 0.9, green: 0.4, blue: 0.0) }

    // Accent & Interactive Colors
    var accent: Color { .orange }
    var accentLight: Color { Color.orange.opacity(0.1) }

    // Semantic Colors
    var success: Color { .green }
    var warning: Color { Color.yellow }
    var error: Color { .red }
    var info: Color { .blue }

    // Background Colors (system colors for dark mode support)
    var backgroundPrimary: Color {
        #if os(iOS)
        return Color(UIColor.systemGroupedBackground)
        #else
        return Color.black
        #endif
    }

    var backgroundSecondary: Color {
        #if os(iOS)
        return Color(UIColor.secondarySystemGroupedBackground)
        #else
        return Color(red: 0.11, green: 0.11, blue: 0.12) // Dark gray for watchOS
        #endif
    }

    var surface: Color {
        #if os(iOS)
        return Color(UIColor.secondarySystemGroupedBackground)
        #else
        return Color(red: 0.11, green: 0.11, blue: 0.12) // Dark gray for watchOS
        #endif
    }

    // Text Colors
    var textPrimary: Color { .primary }
    var textSecondary: Color { .secondary }

    // Spacing System
    var spacingXS: CGFloat { 4 }
    var spacingS: CGFloat { 8 }
    var spacingM: CGFloat { 12 }
    var spacingL: CGFloat { 16 }
    var spacingXL: CGFloat { 20 }
    var spacingXXL: CGFloat { 24 }

    // Corner Radius
    var radiusS: CGFloat { 8 }
    var radiusM: CGFloat { 12 }
    var radiusL: CGFloat { 16 }
    var radiusXL: CGFloat { 20 }
    var radiusCircle: CGFloat { 1000 }

    // Typography
    var fontSizeCaption: CGFloat { 12 }
    var fontSizeFootnote: CGFloat { 13 }
    var fontSizeBody: CGFloat { 15 }
    var fontSizeTitle: CGFloat { 18 }
    var fontSizeHeading: CGFloat { 28 }
    var fontSizeLargeTitle: CGFloat { 34 }

    // Icon Sizes
    var iconSizeSmall: CGFloat { 16 }
    var iconSizeMedium: CGFloat { 20 }
    var iconSizeLarge: CGFloat { 28 }
    var iconSizeXLarge: CGFloat { 40 }
}

// MARK: - Blue Theme (Alternative)

struct BlueTheme: ThemeProtocol {
    // Primary Colors
    var primary: Color { .blue }
    var primaryLight: Color { Color.blue.opacity(0.15) }
    var primaryDark: Color { Color(red: 0.0, green: 0.3, blue: 0.7) }

    // Accent & Interactive Colors
    var accent: Color { .blue }
    var accentLight: Color { Color.blue.opacity(0.1) }

    // Semantic Colors
    var success: Color { .green }
    var warning: Color { Color.orange }
    var error: Color { .red }
    var info: Color { .cyan }

    // Background Colors
    var backgroundPrimary: Color {
        #if os(iOS)
        return Color(UIColor.systemGroupedBackground)
        #else
        return Color.black
        #endif
    }

    var backgroundSecondary: Color {
        #if os(iOS)
        return Color(UIColor.secondarySystemGroupedBackground)
        #else
        return Color(red: 0.11, green: 0.11, blue: 0.12) // Dark gray for watchOS
        #endif
    }

    var surface: Color {
        #if os(iOS)
        return Color(UIColor.secondarySystemGroupedBackground)
        #else
        return Color(red: 0.11, green: 0.11, blue: 0.12) // Dark gray for watchOS
        #endif
    }

    // Text Colors
    var textPrimary: Color { .primary }
    var textSecondary: Color { .secondary }

    // Spacing System (same as Pickleball theme)
    var spacingXS: CGFloat { 4 }
    var spacingS: CGFloat { 8 }
    var spacingM: CGFloat { 12 }
    var spacingL: CGFloat { 16 }
    var spacingXL: CGFloat { 20 }
    var spacingXXL: CGFloat { 24 }

    // Corner Radius
    var radiusS: CGFloat { 8 }
    var radiusM: CGFloat { 12 }
    var radiusL: CGFloat { 16 }
    var radiusXL: CGFloat { 20 }
    var radiusCircle: CGFloat { 1000 }

    // Typography
    var fontSizeCaption: CGFloat { 12 }
    var fontSizeFootnote: CGFloat { 13 }
    var fontSizeBody: CGFloat { 15 }
    var fontSizeTitle: CGFloat { 18 }
    var fontSizeHeading: CGFloat { 28 }
    var fontSizeLargeTitle: CGFloat { 34 }

    // Icon Sizes
    var iconSizeSmall: CGFloat { 16 }
    var iconSizeMedium: CGFloat { 20 }
    var iconSizeLarge: CGFloat { 28 }
    var iconSizeXLarge: CGFloat { 40 }
}


struct OpticYellowTheme: ThemeProtocol {
    // Primary Colors - Adaptive yellow (darker in light mode, bright in dark mode)
    var primary: Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                // Bright optic yellow for dark mode
                return UIColor(red: 0.97, green: 1.0, blue: 0.0, alpha: 1.0) // #F7FF00
            default:
                // Darker golden yellow for light mode (better contrast)
                return UIColor(red: 0.3, green: 0.7, blue: 0.2, alpha: 1.0) // Parrot Green
            }
        })
        #else
        // watchOS - use bright yellow
        return Color(red: 0.97, green: 1.0, blue: 0.0)
        #endif
    }

    var primaryLight: Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.97, green: 1.0, blue: 0.0, alpha: 0.15)
            default:
                return UIColor(red: 0.3, green: 0.7, blue: 0.2, alpha: 0.15)
            }
        })
        #else
        return Color(red: 0.97, green: 1.0, blue: 0.0).opacity(0.15)
        #endif
    }

    var primaryDark: Color {
        // Even darker yellow for pressed states
        Color(red: 0.7, green: 0.6, blue: 0.0)
    }

    // Accent & Interactive Colors - Adaptive
    var accent: Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.97, green: 1.0, blue: 0.0, alpha: 1.0) // Bright yellow
            default:
                return UIColor(red: 0.3, green: 0.7, blue: 0.2, alpha: 1.0) // Golden yellow
            }
        })
        #else
        return Color(red: 0.97, green: 1.0, blue: 0.0)
        #endif
    }

    var accentLight: Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.97, green: 1.0, blue: 0.0, alpha: 0.1)
            default:
                return UIColor(red: 0.3, green: 0.7, blue: 0.2, alpha: 0.1)
            }
        })
        #else
        return Color(red: 0.97, green: 1.0, blue: 0.0).opacity(0.1)
        #endif
    }

    // Semantic Colors
    var success: Color { .green }
    var warning: Color { Color.orange }
    var error: Color { .red }
    var info: Color { .cyan }

    // Background Colors
    var backgroundPrimary: Color {
        #if os(iOS)
        return Color(UIColor.systemGroupedBackground)
        #else
        return Color.black
        #endif
    }

    var backgroundSecondary: Color {
        #if os(iOS)
        return Color(UIColor.secondarySystemGroupedBackground)
        #else
        return Color(red: 0.11, green: 0.11, blue: 0.12) // Dark gray for watchOS
        #endif
    }

    var surface: Color {
        #if os(iOS)
        return Color(UIColor.secondarySystemGroupedBackground)
        #else
        return Color(red: 0.11, green: 0.11, blue: 0.12) // Dark gray for watchOS
        #endif
    }

    // Text Colors
    var textPrimary: Color { .primary }
    var textSecondary: Color { .secondary }

    // Spacing System (same as Pickleball theme)
    var spacingXS: CGFloat { 4 }
    var spacingS: CGFloat { 8 }
    var spacingM: CGFloat { 12 }
    var spacingL: CGFloat { 16 }
    var spacingXL: CGFloat { 20 }
    var spacingXXL: CGFloat { 24 }

    // Corner Radius
    var radiusS: CGFloat { 8 }
    var radiusM: CGFloat { 12 }
    var radiusL: CGFloat { 16 }
    var radiusXL: CGFloat { 20 }
    var radiusCircle: CGFloat { 1000 }

    // Typography
    var fontSizeCaption: CGFloat { 12 }
    var fontSizeFootnote: CGFloat { 13 }
    var fontSizeBody: CGFloat { 15 }
    var fontSizeTitle: CGFloat { 18 }
    var fontSizeHeading: CGFloat { 28 }
    var fontSizeLargeTitle: CGFloat { 34 }

    // Icon Sizes
    var iconSizeSmall: CGFloat { 16 }
    var iconSizeMedium: CGFloat { 20 }
    var iconSizeLarge: CGFloat { 28 }
    var iconSizeXLarge: CGFloat { 40 }
}

// MARK: - Theme Manager (Observable)

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var selectedTheme: String {
        didSet {
            UserDefaults.standard.set(selectedTheme, forKey: "selectedTheme")
        }
    }

    var currentTheme: ThemeProtocol {
        AppTheme.theme(for: selectedTheme)
    }

    private init() {
        self.selectedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? "blue"
    }
}

// MARK: - App Theme Manager

struct AppTheme {
    // Current active theme - reads from UserDefaults
    static var current: ThemeProtocol {
        let selectedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? "blue"
        return theme(for: selectedTheme)
    }

    // Get theme by key
    static func theme(for key: String) -> ThemeProtocol {
        switch key {
        case "pickleball":
            return PickleballTheme()
        case "opticYellow":
            return OpticYellowTheme()
        case "blue":
            return BlueTheme()
        default:
            return BlueTheme()
        }
    }

    // Convenience accessors (shorthand)
    static var colors: ThemeProtocol { current }
    static var spacing: ThemeProtocol { current }
    static var radius: ThemeProtocol { current }
    static var typography: ThemeProtocol { current }
}

// MARK: - Convenience Extensions

extension View {
    /// Apply primary theme color to foreground
    func themeForeground() -> some View {
        self.foregroundStyle(AppTheme.current.primary)
    }

    /// Apply primary theme tint
    func themeTint() -> some View {
        self.tint(AppTheme.current.accent)
    }

    /// Apply standard corner radius
    func themeCornerRadius(_ style: CornerRadiusStyle = .medium) -> some View {
        let radius: CGFloat = switch style {
        case .small: AppTheme.current.radiusS
        case .medium: AppTheme.current.radiusM
        case .large: AppTheme.current.radiusL
        case .extraLarge: AppTheme.current.radiusXL
        case .circle: AppTheme.current.radiusCircle
        }
        return self.cornerRadius(radius)
    }
}

enum CornerRadiusStyle {
    case small, medium, large, extraLarge, circle
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let rgbValue = UInt32(hex, radix: 16)
        let r = Double((rgbValue! & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue! & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue! & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
