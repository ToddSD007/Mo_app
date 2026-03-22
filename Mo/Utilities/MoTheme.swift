import SwiftUI

enum MoTheme {
    static let background = Color(hex: 0xF4F0EA)
    static let cardBackground = Color.white.opacity(0.96)
    static let primaryText = Color(hex: 0x4F4844)
    static let secondaryText = Color(hex: 0x948A83)
    static let accent = Color(hex: 0xD6AF59)
    static let accentSoft = Color(hex: 0xEAD39A)
    static let overlay = Color.black.opacity(0.44)
    static let shadow = Color.black.opacity(0.08)

    static func headingFont(size: CGFloat) -> Font {
        .custom("Iowan Old Style", size: size)
    }

    static func bodyFont(size: CGFloat) -> Font {
        .custom("Avenir Next", size: size)
    }
}

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
