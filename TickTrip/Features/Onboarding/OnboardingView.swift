import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    @State private var selectedRegions: Set<String> = []
    @State private var selectedTravelStyle: User.TravelStyle?
    @State private var showPreferences = false
    
    private let pages: [(icon: String, titleKey: String, subtitleKey: String, descKey: String)] = [
        ("🌍", "onboarding_title_1", "onboarding_subtitle_1", "onboarding_desc_1"),
        ("✅", "onboarding_title_2", "onboarding_subtitle_2", "onboarding_desc_2"),
        ("🏆", "onboarding_title_3", "onboarding_subtitle_3", "onboarding_desc_3"),
        ("💬", "onboarding_title_4", "onboarding_subtitle_4", "onboarding_desc_4"),
        ("🦊", "onboarding_title_5", "onboarding_subtitle_5", "onboarding_desc_5"),
    ]
    
    var body: some View {
        ZStack {
            TTColors.backgroundPrimary.ignoresSafeArea()
            
            if showPreferences {
                preferencesView
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                onboardingPages
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            }
        }
    }
    
    // MARK: - Onboarding Pages
    private var onboardingPages: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button("skip".localized) {
                    withAnimation(.spring(response: 0.4)) {
                        showPreferences = true
                    }
                }
                .font(TTTypography.labelLarge)
                .foregroundStyle(TTColors.textTertiary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(
                        icon: pages[index].icon,
                        title: pages[index].titleKey.localized,
                        subtitle: pages[index].subtitleKey.localized,
                        description: pages[index].descKey.localized,
                        pageIndex: index
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack(spacing: 24) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentPage ? TTColors.foxOrange : TTColors.textTertiary.opacity(0.3))
                            .frame(width: i == currentPage ? 10 : 8, height: i == currentPage ? 10 : 8)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                
                GradientButton(
                    title: currentPage == pages.count - 1 ? "get_started".localized : "next".localized,
                    icon: currentPage == pages.count - 1 ? "arrow.right" : "chevron.right"
                ) {
                    withAnimation(.spring(response: 0.4)) {
                        if currentPage < pages.count - 1 {
                            currentPage += 1
                        } else {
                            showPreferences = true
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Preferences
    private var preferencesView: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text("🦊")
                        .font(.system(size: 50))
                    
                    Text("personalize_journey".localized)
                        .font(TTTypography.displaySmall)
                        .foregroundStyle(TTColors.textPrimary)
                    
                    Text("personalize_subtitle".localized)
                        .font(TTTypography.bodyMedium)
                        .foregroundStyle(TTColors.textSecondary)
                }
                .padding(.top, 20)
                
                // Regions
                VStack(alignment: .leading, spacing: 12) {
                    Text("favorite_regions".localized)
                        .font(TTTypography.headlineSmall)
                        .foregroundStyle(TTColors.textPrimary)
                    
                    let regionKeys = ["region_europe", "region_asia", "region_north_america", "region_south_america", "region_africa", "region_oceania"]
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(regionKeys, id: \.self) { key in
                            let region = key.localized
                            Button(action: {
                                if selectedRegions.contains(region) {
                                    selectedRegions.remove(region)
                                } else {
                                    selectedRegions.insert(region)
                                }
                                HapticManager.shared.selection()
                            }) {
                                Text(region)
                                    .font(TTTypography.titleSmall)
                                    .foregroundStyle(selectedRegions.contains(region) ? .white : TTColors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        selectedRegions.contains(region) ?
                                        AnyShapeStyle(TTColors.primaryGradient) :
                                        AnyShapeStyle(TTColors.backgroundSecondary)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                    }
                }
                
                // Travel style
                VStack(alignment: .leading, spacing: 12) {
                    Text("travel_style".localized)
                        .font(TTTypography.headlineSmall)
                        .foregroundStyle(TTColors.textPrimary)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(User.TravelStyle.allCases, id: \.self) { style in
                            Button(action: {
                                selectedTravelStyle = style
                                HapticManager.shared.selection()
                            }) {
                                VStack(spacing: 6) {
                                    Text(styleEmoji(style))
                                        .font(.system(size: 28))
                                    Text(style.rawValue)
                                        .font(TTTypography.captionLarge)
                                        .foregroundStyle(selectedTravelStyle == style ? .white : TTColors.textPrimary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    selectedTravelStyle == style ?
                                    AnyShapeStyle(TTColors.tealGradient) :
                                    AnyShapeStyle(TTColors.backgroundSecondary)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                    }
                }
                
                GradientButton(title: "start_exploring".localized, icon: "globe.americas.fill") {
                    withAnimation(.spring(response: 0.4)) {
                        appState.completeOnboarding()
                    }
                }
                .padding(.top, 8)
                
                Button("skip_for_now".localized) {
                    appState.completeOnboarding()
                }
                .font(TTTypography.labelLarge)
                .foregroundStyle(TTColors.textTertiary)
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func styleEmoji(_ style: User.TravelStyle) -> String {
        switch style {
        case .explorer: return "🧭"
        case .cultural: return "🎭"
        case .foodie: return "🍕"
        case .adventurer: return "🧗"
        case .relaxer: return "🏖️"
        case .photographer: return "📸"
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    let pageIndex: Int
    
    @State private var animateIn = false
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 10)
            
            ZStack {
                Circle()
                    .fill(TTColors.foxOrange.opacity(0.08))
                    .frame(width: 140, height: 140)
                    .scaleEffect(animateIn ? 1.0 : 0.5)
                
                Text(icon)
                    .font(.system(size: 70))
                    .offset(y: animateIn ? 0 : 20)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(TTTypography.displaySmall)
                    .foregroundStyle(TTColors.textPrimary)
                    .opacity(animateIn ? 1 : 0)
                
                Text(subtitle)
                    .font(TTTypography.titleSmall)
                    .foregroundStyle(TTColors.foxOrange)
                    .opacity(animateIn ? 1 : 0)
                
                Text(description)
                    .font(TTTypography.bodyMedium)
                    .foregroundStyle(TTColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .opacity(animateIn ? 1 : 0)
            }
            
            Spacer(minLength: 10)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateIn = true
            }
        }
        .onDisappear {
            animateIn = false
        }
    }
}
