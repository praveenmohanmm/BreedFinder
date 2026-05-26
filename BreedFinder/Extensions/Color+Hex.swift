import SwiftUI

// MARK: - Hex colour initialiser
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 200, 200, 200)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - App colour palette  (blue theme)
extension Color {
    /// Vivid royal blue — primary brand colour
    static let appPrimary       = Color(hex: "#1D6EF5")
    /// Lighter cornflower blue
    static let appSecondary     = Color(hex: "#5B9AFF")
    /// Deep navy blue
    static let appTertiary      = Color(hex: "#1249B8")
    /// Very light blue-white page background
    static let appBackground    = Color(hex: "#F0F5FF")
    /// Deep navy text
    static let appTextPrimary   = Color(hex: "#0D1B3E")
    /// Muted blue-grey secondary text
    static let appTextSecondary = Color(hex: "#5B7DA6")
    /// Soft blue border / track
    static let appBorder        = Color(hex: "#B8D4FA")
    /// Pale blue tag background
    static let appTagBackground = Color(hex: "#DDE9FF")
}
