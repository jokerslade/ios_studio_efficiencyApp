import SwiftUI

extension Color {
    // Custom Colors
    static let primaryBlue = Color(hex: "3B82F6") // Blue for buttons
    static let playPauseGreen = Color(hex: "10B981") // Green for play/pause
    static let orangeAccent = Color(hex: "FB923C") // Orange for Regenerate button
    
    // In Progress Gradient
    static let inProgressStart = Color(hex: "0284C7")
    static let inProgressEnd = Color(hex: "06B6D4")
    
    // Background gradient for the whole app
    static let bgTop = Color(hex: "D9E2FF")
    static let bgBottom = Color(hex: "F3E8FF")
    
    // UI Elements
    static let cardBackground = Color.white.opacity(0.85)
    static let textPrimary = Color.black.opacity(0.9)
    static let textSecondary = Color.gray
}

// Hex color initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
