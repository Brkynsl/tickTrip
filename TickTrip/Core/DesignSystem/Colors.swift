import SwiftUI

struct TTColors {
    // Primary brand colors
    static let primary = Color("Primary", bundle: nil)
    static let secondary = Color("Secondary", bundle: nil)
    static let accent = Color("Accent", bundle: nil)
    
    // Fallback computed colors
    static let primaryFallback = Color(hue: 0.05, saturation: 0.75, brightness: 0.95) // Warm coral-orange
    static let secondaryFallback = Color(hue: 0.52, saturation: 0.65, brightness: 0.55) // Deep teal
    static let accentFallback = Color(hue: 0.12, saturation: 0.85, brightness: 0.90) // Gold
    
    // Semantic colors
    static let foxOrange = Color(hue: 0.07, saturation: 0.85, brightness: 0.92)
    static let foxDark = Color(hue: 0.07, saturation: 0.90, brightness: 0.45)
    
    // Adaptive colors for dark mode support
    static var backgroundPrimary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.08, green: 0.08, blue: 0.10, alpha: 1.0)
                : UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1.0)
        })
    }
    
    static var backgroundSecondary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.14, green: 0.14, blue: 0.16, alpha: 1.0)
                : UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        })
    }
    
    static var cardBackground: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.16, green: 0.16, blue: 0.18, alpha: 1.0)
                : UIColor.white
        })
    }
    
    static var cardShadow: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.clear
                : UIColor.black.withAlphaComponent(0.06)
        })
    }
    
    static var textPrimary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
                : UIColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0)
        })
    }
    
    static var textSecondary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.70, green: 0.70, blue: 0.72, alpha: 1.0)
                : UIColor(red: 0.45, green: 0.45, blue: 0.48, alpha: 1.0)
        })
    }
    
    static var textTertiary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.50, green: 0.50, blue: 0.52, alpha: 1.0)
                : UIColor(red: 0.65, green: 0.65, blue: 0.67, alpha: 1.0)
        })
    }
    
    static let success = Color(hue: 0.38, saturation: 0.70, brightness: 0.65)
    static let warning = Color(hue: 0.10, saturation: 0.75, brightness: 0.90)
    static let error = Color(hue: 0.0, saturation: 0.70, brightness: 0.85)
    static let info = Color(hue: 0.58, saturation: 0.55, brightness: 0.75)
    
    // Premium
    static let premiumGold = Color(hue: 0.12, saturation: 0.85, brightness: 0.90)
    static let premiumGradientStart = Color(hue: 0.08, saturation: 0.80, brightness: 0.95)
    static let premiumGradientEnd = Color(hue: 0.04, saturation: 0.75, brightness: 0.85)
    
    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [Color(hue: 0.05, saturation: 0.75, brightness: 0.95),
                 Color(hue: 0.02, saturation: 0.80, brightness: 0.85)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let tealGradient = LinearGradient(
        colors: [Color(hue: 0.50, saturation: 0.55, brightness: 0.65),
                 Color(hue: 0.55, saturation: 0.70, brightness: 0.45)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let goldGradient = LinearGradient(
        colors: [Color(hue: 0.13, saturation: 0.70, brightness: 0.95),
                 Color(hue: 0.08, saturation: 0.85, brightness: 0.85)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let sunsetGradient = LinearGradient(
        colors: [Color(hue: 0.08, saturation: 0.60, brightness: 0.98),
                 Color(hue: 0.04, saturation: 0.45, brightness: 0.95),
                 Color(hue: 0.95, saturation: 0.30, brightness: 0.98)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let heroOverlay = LinearGradient(
        colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Continent colors for charts/maps
    static let continentColors: [String: Color] = [
        "Europe": Color(hue: 0.58, saturation: 0.55, brightness: 0.75),
        "Asia": Color(hue: 0.08, saturation: 0.70, brightness: 0.90),
        "Africa": Color(hue: 0.12, saturation: 0.80, brightness: 0.85),
        "North America": Color(hue: 0.55, saturation: 0.60, brightness: 0.60),
        "South America": Color(hue: 0.38, saturation: 0.65, brightness: 0.65),
        "Oceania": Color(hue: 0.50, saturation: 0.50, brightness: 0.70)
    ]
}

// Color extension for convenience
extension Color {
    static let ttPrimary = TTColors.foxOrange
    static let ttSecondary = TTColors.secondaryFallback
    static let ttAccent = TTColors.accentFallback
    static let ttBackground = TTColors.backgroundPrimary
    static let ttCard = TTColors.cardBackground
    static let ttText = TTColors.textPrimary
    static let ttTextSecondary = TTColors.textSecondary
}
