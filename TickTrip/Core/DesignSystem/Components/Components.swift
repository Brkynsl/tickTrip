import SwiftUI

// MARK: - Animated Progress Bar (Linear)
struct TTProgressBar: View {
    let progress: Double
    var height: CGFloat = 8
    var showLabel: Bool = false
    var gradient: LinearGradient = TTColors.primaryGradient
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            if showLabel {
                Text("\(Int(progress * 100))%")
                    .font(TTTypography.progressFont)
                    .foregroundStyle(TTColors.foxOrange)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(TTColors.backgroundSecondary)
                    
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(gradient)
                        .frame(width: max(0, geo.size.width * animatedProgress))
                }
            }
            .frame(height: height)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Circular Progress
struct TTCircularProgress: View {
    let progress: Double
    var size: CGFloat = 60
    var lineWidth: CGFloat = 6
    var gradient: LinearGradient = TTColors.primaryGradient
    var showLabel: Bool = true
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(TTColors.backgroundSecondary, lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            if showLabel {
                Text("\(Int(progress * 100))%")
                    .font(size > 50 ? TTTypography.progressFont : TTTypography.captionSmall)
                    .fontWeight(.bold)
                    .foregroundStyle(TTColors.textPrimary)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.7).delay(0.3)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Country Card
struct CountryCard: View {
    let country: Country
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Hero Image
            Image(country.heroImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
            HStack(spacing: 12) {
                Text(country.flagEmoji)
                    .font(.system(size: 44))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(country.name)
                            .font(TTTypography.titleLarge)
                            .foregroundStyle(TTColors.textPrimary)
                        
                        if country.isTrending {
                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 9))
                                Text("Trending")
                                    .font(TTTypography.badgeFont)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(TTColors.foxOrange.gradient)
                            .clipShape(Capsule())
                        }
                    }
                    
                    Text("\(country.totalCities) cities • \(country.visitedCitiesCount) visited")
                        .font(TTTypography.captionLarge)
                        .foregroundStyle(TTColors.textSecondary)
                }
                
                Spacer()
                
                TTCircularProgress(
                    progress: country.completionPercentage,
                    size: 48,
                    lineWidth: 5
                )
            }
            
            TTProgressBar(progress: country.completionPercentage, height: 6)
        }
        .ttCard()
    }
}

// MARK: - City Card
struct CityCard: View {
    let city: City
    let completedCount: Int
    let totalCount: Int
    
    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
    
    var body: some View {
        HStack(spacing: 14) {
            // Hero Image
            Image(city.heroImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(city.name)
                    .font(TTTypography.titleMedium)
                    .foregroundStyle(TTColors.textPrimary)
                
                Text("\(completedCount)/\(totalCount) places")
                    .font(TTTypography.captionLarge)
                    .foregroundStyle(TTColors.textSecondary)
                
                TTProgressBar(progress: progress, height: 5)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(TTColors.textTertiary)
        }
        .ttCard()
    }
    
    private var cityGradientColors: [Color] {
        let hue = Double(city.id.hashValue % 360) / 360.0
        return [
            Color(hue: hue, saturation: 0.5, brightness: 0.8),
            Color(hue: hue + 0.05, saturation: 0.6, brightness: 0.6)
        ]
    }
}

// MARK: - Place Card
struct PlaceCard: View {
    let place: Place
    let isCompleted: Bool
    let onToggle: () -> Void
    
    @State private var showCheckAnimation = false
    
    var body: some View {
        HStack(spacing: 14) {
            // Check button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    showCheckAnimation = true
                    onToggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showCheckAnimation = false
                }
            }) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? TTColors.foxOrange : TTColors.backgroundSecondary)
                        .frame(width: 36, height: 36)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .scaleEffect(showCheckAnimation ? 1.3 : 1.0)
                    }
                    
                    Circle()
                        .stroke(isCompleted ? TTColors.foxOrange : TTColors.textTertiary.opacity(0.3), lineWidth: 2)
                        .frame(width: 36, height: 36)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isCompleted ? "Completed: \(place.name)" : "Mark \(place.name) as completed")
            
            Image(place.id)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(place.name)
                        .font(TTTypography.titleSmall)
                        .foregroundStyle(isCompleted ? TTColors.textSecondary : TTColors.textPrimary)
                        .strikethrough(isCompleted, color: TTColors.textTertiary)
                    
                    if place.isPremiumOnly {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(TTColors.premiumGold)
                    }
                }
                
                HStack(spacing: 8) {
                    Label(place.category.rawValue, systemImage: place.category.icon)
                        .font(TTTypography.captionSmall)
                        .foregroundStyle(TTColors.textTertiary)
                    
                    if place.communityTipCount > 0 {
                        Label("\(place.communityTipCount)", systemImage: "bubble.left.fill")
                            .font(TTTypography.captionSmall)
                            .foregroundStyle(TTColors.textTertiary)
                    }
                }
                
                Text(place.description)
                    .font(TTTypography.captionLarge)
                    .foregroundStyle(TTColors.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Popularity rank
            Text("#\(place.popularityRank)")
                .font(TTTypography.labelSmall)
                .foregroundStyle(TTColors.textTertiary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(TTColors.backgroundSecondary)
                .clipShape(Capsule())
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isCompleted ? TTColors.backgroundSecondary.opacity(0.5) : TTColors.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(isCompleted ? TTColors.foxOrange.opacity(0.2) : Color.clear, lineWidth: 1)
        )
        .shadow(color: TTColors.cardShadow, radius: isCompleted ? 2 : 6, x: 0, y: isCompleted ? 1 : 3)
    }
}

// MARK: - Trip Card
struct TripCard: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: trip.status.icon)
                            .font(.system(size: 12))
                            .foregroundStyle(trip.status == .active ? TTColors.success : TTColors.textTertiary)
                        
                        Text(trip.status.displayName)
                            .font(TTTypography.labelMedium)
                            .foregroundStyle(trip.status == .active ? TTColors.success : TTColors.textTertiary)
                    }
                    
                    Text(trip.name)
                        .font(TTTypography.headlineMedium)
                        .foregroundStyle(TTColors.textPrimary)
                }
                
                Spacer()
                
                TTCircularProgress(
                    progress: trip.overallProgress,
                    size: 52,
                    lineWidth: 5,
                    gradient: trip.status == .active ? TTColors.primaryGradient : TTColors.tealGradient
                )
            }
            
            // Country flags
            HStack(spacing: 6) {
                ForEach(trip.countryIds, id: \.self) { countryId in
                    if let country = Country.samples.first(where: { $0.id == countryId }) {
                        Text(country.flagEmoji)
                            .font(.system(size: 24))
                    }
                }
                
                Spacer()
                
                Text("\(trip.cityIds.count) cities")
                    .font(TTTypography.captionLarge)
                    .foregroundStyle(TTColors.textSecondary)
            }
            
            if let startDate = trip.startDate {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                    Text(startDate, style: .date)
                        .font(TTTypography.captionLarge)
                    if let endDate = trip.endDate {
                        Text("→")
                        Text(endDate, style: .date)
                            .font(TTTypography.captionLarge)
                    }
                }
                .foregroundStyle(TTColors.textTertiary)
            }
            
            TTProgressBar(progress: trip.overallProgress, height: 6)
        }
        .ttCard()
    }
}

// MARK: - Achievement Badge
struct AchievementBadge: View {
    let achievement: Achievement
    var size: CGFloat = 70
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ?
                          LinearGradient(colors: [TTColors.foxOrange, TTColors.premiumGold],
                                        startPoint: .topLeading, endPoint: .bottomTrailing) :
                          LinearGradient(colors: [TTColors.backgroundSecondary, TTColors.backgroundSecondary],
                                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: size, height: size)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: size * 0.35))
                    .foregroundStyle(achievement.isUnlocked ? .white : TTColors.textTertiary)
                
                if !achievement.isUnlocked {
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: size, height: size)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: size * 0.2))
                        .foregroundStyle(.white)
                }
            }
            
            Text(achievement.title)
                .font(TTTypography.captionSmall)
                .foregroundStyle(achievement.isUnlocked ? TTColors.textPrimary : TTColors.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: size + 10)
        }
    }
}

// MARK: - Fox Mascot View
struct FoxMascotView: View {
    var message: String
    var size: CGFloat = 80
    var showSpeechBubble: Bool = true
    
    @State private var bounceOffset: CGFloat = 0
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack(spacing: 12) {
            if showSpeechBubble && !message.isEmpty {
                Text(message)
                    .font(TTTypography.foxSpeech)
                    .foregroundStyle(TTColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(TTColors.cardBackground)
                            .shadow(color: TTColors.cardShadow, radius: 8, x: 0, y: 4)
                    )
                    .transition(.scale.combined(with: .opacity))
            }
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [TTColors.foxOrange.opacity(0.15), TTColors.foxOrange.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: size * 1.3, height: size * 1.3)
                
                Text("🦊")
                    .font(.system(size: size * 0.7))
                    .offset(y: bounceOffset)
                    .rotationEffect(.degrees(rotation))
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                bounceOffset = -6
            }
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var foxMessage: String = ""
    var buttonTitle: String?
    var buttonAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            FoxMascotView(
                message: foxMessage.isEmpty ? message : foxMessage,
                size: 90,
                showSpeechBubble: !foxMessage.isEmpty
            )
            
            Text(title)
                .font(TTTypography.headlineMedium)
                .foregroundStyle(TTColors.textPrimary)
            
            if foxMessage.isEmpty {
                Text(message)
                    .font(TTTypography.bodyMedium)
                    .foregroundStyle(TTColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            if let buttonTitle = buttonTitle, let action = buttonAction {
                Button(action: action) {
                    Text(buttonTitle)
                        .font(TTTypography.titleMedium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(TTColors.primaryGradient)
                        .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
            
            Spacer()
        }
    }
}

// MARK: - Gradient Button
struct GradientButton: View {
    let title: String
    let icon: String?
    var gradient: LinearGradient = TTColors.primaryGradient
    var fullWidth: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.buttonTap()
            action()
        }) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(TTTypography.titleMedium)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.vertical, 16)
            .padding(.horizontal, fullWidth ? 0 : 28)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: TTColors.foxOrange.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Premium Lock Badge
struct PremiumBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "crown.fill")
                .font(.system(size: 10))
            Text("PRO")
                .font(TTTypography.badgeFont)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(TTColors.goldGradient)
        .clipShape(Capsule())
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var action: String? = nil
    var onAction: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(TTTypography.headlineSmall)
                .foregroundStyle(TTColors.textPrimary)
            
            Spacer()
            
            if let action = action, let onAction = onAction {
                Button(action: onAction) {
                    Text(action)
                        .font(TTTypography.labelLarge)
                        .foregroundStyle(TTColors.foxOrange)
                }
            }
        }
    }
}

// MARK: - Unsplash Component
/// A smart image view that fetches from Unsplash based on a query, with a shimmer loading state
struct UnsplashImage: View {
    let query: String
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var cornerRadius: CGFloat = 0
    
    @State private var imageURL: URL?
    @State private var isLoading = true
    @State private var hasError = false
    
    var body: some View {
        ZStack {
            if let url = imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        shimmerPlaceholder
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: height)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                            .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                    case .failure:
                        fallbackPlaceholder
                    @unknown default:
                        fallbackPlaceholder
                    }
                }
            } else if isLoading {
                shimmerPlaceholder
            } else {
                fallbackPlaceholder
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .task {
            await loadImage()
        }
    }
    
    private var shimmerPlaceholder: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(TTColors.backgroundSecondary)
            .overlay(
                LinearGradient(
                    colors: [.clear, .white.opacity(0.2), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    private var fallbackPlaceholder: some View {
        ZStack {
            let hue = Double(abs(query.hashValue) % 360) / 360.0
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hue: hue, saturation: 0.5, brightness: 0.8),
                            Color(hue: hue + 0.05, saturation: 0.6, brightness: 0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Image(systemName: "photo.fill")
                .foregroundStyle(.white.opacity(0.8))
                .font(.system(size: min(width ?? 40, height ?? 40) * 0.4))
        }
    }
    
    private func loadImage() async {
        do {
            if let url = try await UnsplashService.shared.fetchImageURL(for: query) {
                await MainActor.run {
                    self.imageURL = url
                    self.isLoading = false
                }
            } else {
                await MainActor.run {
                    self.hasError = true
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.hasError = true
                self.isLoading = false
            }
        }
    }
}
