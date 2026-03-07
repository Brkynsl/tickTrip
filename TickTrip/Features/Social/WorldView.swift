import SwiftUI

struct WorldView: View {
    @ObservedObject var viewModel: SocialViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // World hero
                    worldHero
                    
                    // Section picker
                    sectionPicker
                    
                    // Content
                    switch viewModel.selectedSection {
                    case .trending:
                        trendingSection
                    case .activity:
                        activitySection
                    case .leaderboard:
                        leaderboardSection
                    }
                }
                .padding(.bottom, 30)
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Image(systemName: "globe.americas.fill")
                            .foregroundStyle(TTColors.foxOrange)
                        Text("world_tab".localized)
                            .font(TTTypography.headlineLarge)
                            .foregroundStyle(TTColors.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - World Hero
    private var worldHero: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(TTColors.tealGradient)
                .frame(height: 160)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("explore_the_world".localized)
                        .font(TTTypography.displaySmall)
                        .foregroundStyle(.white)
                    
                    Text("world_subtitle".localized)
                        .font(TTTypography.bodySmall)
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text("🌍")
                    .font(.system(size: 60))
            }
            .padding(20)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Section Picker
    private var sectionPicker: some View {
        HStack(spacing: 0) {
            ForEach(SocialViewModel.SocialSection.allCases, id: \.self) { section in
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.selectedSection = section
                    }
                    HapticManager.shared.selection()
                }) {
                    Text(section.rawValue)
                        .font(TTTypography.labelLarge)
                        .foregroundStyle(viewModel.selectedSection == section ? .white : TTColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            viewModel.selectedSection == section ?
                            AnyShapeStyle(TTColors.primaryGradient) : AnyShapeStyle(Color.clear)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
        .background(TTColors.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 16)
    }
    
    // MARK: - Trending
    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "trending_destinations".localized)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.trendingCountries) { country in
                        VStack(spacing: 10) {
                            Text(country.flagEmoji)
                                .font(.system(size: 44))
                                .padding(16)
                                .background(
                                    Circle().fill(TTColors.backgroundSecondary)
                                )
                            
                            Text(country.name)
                                .font(TTTypography.labelMedium)
                                .foregroundStyle(TTColors.textPrimary)
                            
                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 10))
                                Text("hot_badge".localized)
                                    .font(TTTypography.captionSmall)
                            }
                            .foregroundStyle(TTColors.foxOrange)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            // Featured cities
            SectionHeader(title: "popular_cities".localized)
                .padding(.horizontal, 16)
            
            ForEach(["Paris", "Rome", "Barcelona", "Istanbul", "London"], id: \.self) { cityName in
                if let city = City.samples.first(where: { $0.name == cityName }),
                   let country = Country.samples.first(where: { $0.id == city.countryId }) {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(TTColors.tealGradient)
                                .frame(width: 56, height: 56)
                            
                            Text(country.flagEmoji)
                                .font(.system(size: 24))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(city.name)
                                .font(TTTypography.titleMedium)
                                .foregroundStyle(TTColors.textPrimary)
                            
                            Text("must_see_format".localized(city.totalPlaces, country.name))
                                .font(TTTypography.captionLarge)
                                .foregroundStyle(TTColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 2) {
                            Text("\(city.popularityScore)")
                                .font(TTTypography.titleSmall)
                                .foregroundStyle(TTColors.foxOrange)
                            Text("score_label".localized)
                                .font(TTTypography.captionSmall)
                                .foregroundStyle(TTColors.textTertiary)
                        }
                    }
                    .ttCard(padding: 14)
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    // MARK: - Activity
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "recent_completions".localized)
                .padding(.horizontal, 16)
            
            ForEach(viewModel.recentCompletions, id: \.userName) { item in
                HStack(spacing: 14) {
                    Circle()
                        .fill(TTColors.primaryGradient)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text(String(item.userName.prefix(1)))
                                .font(TTTypography.titleMedium)
                                .foregroundStyle(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Text(item.userName)
                                .font(TTTypography.titleSmall)
                                .foregroundStyle(TTColors.textPrimary)
                            
                            Text("checked_label".localized)
                                .font(TTTypography.bodySmall)
                                .foregroundStyle(TTColors.textSecondary)
                        }
                        
                        Text("place_in_city_format".localized(item.placeName, item.cityName))
                            .font(TTTypography.bodySmall)
                            .foregroundStyle(TTColors.foxOrange)
                    }
                    
                    Spacer()
                    
                    Text(item.timeAgo)
                        .font(TTTypography.captionSmall)
                        .foregroundStyle(TTColors.textTertiary)
                }
                .ttCard(padding: 14)
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - Leaderboard
    private var leaderboardSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "top_explorers".localized)
                .padding(.horizontal, 16)
            
            ForEach(viewModel.leaderboard, id: \.rank) { entry in
                HStack(spacing: 14) {
                    // Rank
                    ZStack {
                        Circle()
                            .fill(rankGradient(entry.rank))
                            .frame(width: 40, height: 40)
                        
                        Text("#\(entry.rank)")
                            .font(TTTypography.titleSmall)
                            .foregroundStyle(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.name)
                            .font(TTTypography.titleMedium)
                            .foregroundStyle(TTColors.textPrimary)
                        
                        Text(entry.title)
                            .font(TTTypography.captionLarge)
                            .foregroundStyle(TTColors.foxOrange)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(entry.places)")
                            .font(TTTypography.titleMedium)
                            .foregroundStyle(TTColors.textPrimary)
                        
                        Text("countries_count_format".localized(entry.countries))
                            .font(TTTypography.captionSmall)
                            .foregroundStyle(TTColors.textTertiary)
                    }
                }
                .ttCard(padding: 14)
                .padding(.horizontal, 16)
            }
        }
    }
    
    private func rankGradient(_ rank: Int) -> LinearGradient {
        switch rank {
        case 1: return TTColors.goldGradient
        case 2: return LinearGradient(colors: [Color.gray.opacity(0.7), Color.gray], startPoint: .top, endPoint: .bottom)
        case 3: return LinearGradient(colors: [Color.brown.opacity(0.7), Color.brown], startPoint: .top, endPoint: .bottom)
        default: return TTColors.tealGradient
        }
    }
}
