import SwiftUI

// MARK: - View Extensions
extension View {
    func ttCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(TTColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: TTColors.cardShadow, radius: 8, x: 0, y: 4)
    }
    
    func ttCardNoPadding() -> some View {
        self
            .background(TTColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: TTColors.cardShadow, radius: 8, x: 0, y: 4)
    }
    
    func ttHeroOverlay() -> some View {
        self.overlay(
            LinearGradient(
                colors: [Color.black.opacity(0.0), Color.black.opacity(0.55)],
                startPoint: .center,
                endPoint: .bottom
            )
        )
    }
    
    func ttSectionHeader() -> some View {
        self
            .font(TTTypography.headlineSmall)
            .foregroundStyle(TTColors.textPrimary)
    }
    
    func shimmer(isActive: Bool = true) -> some View {
        self.modifier(ShimmerModifier(isActive: isActive))
    }
}

// MARK: - Shimmer Loading Effect
struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay(
                    GeometryReader { geo in
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.0),
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geo.size.width * 0.5)
                        .offset(x: -geo.size.width * 0.5 + phase * geo.size.width * 1.5)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onAppear {
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
        } else {
            content
        }
    }
}

// MARK: - Skeleton View
struct SkeletonView: View {
    var width: CGFloat? = nil
    var height: CGFloat = 16
    var cornerRadius: CGFloat = 8
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(TTColors.backgroundSecondary)
            .frame(width: width, height: height)
            .shimmer()
    }
}
