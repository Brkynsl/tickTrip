import SwiftUI

struct TTTypography {
    // Display
    static let displayLarge = Font.system(size: 34, weight: .bold, design: .rounded)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)
    static let displaySmall = Font.system(size: 24, weight: .bold, design: .rounded)
    
    // Headlines
    static let headlineLarge = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let headlineMedium = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let headlineSmall = Font.system(size: 18, weight: .semibold, design: .rounded)
    
    // Titles
    static let titleLarge = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let titleMedium = Font.system(size: 16, weight: .medium, design: .rounded)
    static let titleSmall = Font.system(size: 15, weight: .medium, design: .rounded)
    
    // Body
    static let bodyLarge = Font.system(size: 16, weight: .regular, design: .rounded)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .rounded)
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .rounded)
    
    // Labels
    static let labelLarge = Font.system(size: 14, weight: .medium, design: .rounded)
    static let labelMedium = Font.system(size: 12, weight: .medium, design: .rounded)
    static let labelSmall = Font.system(size: 11, weight: .medium, design: .rounded)
    
    // Captions
    static let captionLarge = Font.system(size: 12, weight: .regular, design: .rounded)
    static let captionSmall = Font.system(size: 10, weight: .regular, design: .rounded)
    
    // Special
    static let badgeFont = Font.system(size: 10, weight: .bold, design: .rounded)
    static let progressFont = Font.system(size: 13, weight: .semibold, design: .rounded)
    static let tabFont = Font.system(size: 10, weight: .medium, design: .rounded)
    static let foxSpeech = Font.system(size: 15, weight: .medium, design: .rounded)
}

// View modifiers for consistent text styling
struct TTTextStyle: ViewModifier {
    let font: Font
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
    }
}

extension View {
    func ttTextStyle(_ font: Font, color: Color = TTColors.textPrimary) -> some View {
        modifier(TTTextStyle(font: font, color: color))
    }
}
