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

// MARK: - App colour palette
extension Color {
    /// Warm amber — primary brand colour
    static let appPrimary      = Color(hex: "#E8892B")
    /// Lighter amber
    static let appSecondary    = Color(hex: "#F4A853")
    /// Deep amber-brown
    static let appTertiary     = Color(hex: "#9B5523")
    /// Warm cream page background
    static let appBackground   = Color(hex: "#FFF8EF")
    /// Very dark brown text
    static let appTextPrimary  = Color(hex: "#3D1F08")
    /// Medium warm-brown secondary text
    static let appTextSecondary = Color(hex: "#96705A")
    /// Light peach border / track
    static let appBorder       = Color(hex: "#F0D9C3")
    /// Very light peach tag background
    static let appTagBackground = Color(hex: "#FFF1E0")
}
