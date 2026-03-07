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
            .onAppear {
                viewModel.fetchAll()
            }
            .refreshable {
                viewModel.fetchAll()
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
    
    // MARK: - Trending (Real Data)
    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "trending_destinations".localized)
                .padding(.horizontal, 16)
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else {
                // Trending cities - tap to open checklist
                ForEach(viewModel.trendingCities, id: \.city.id) { item in
                    NavigationLink(destination: CityChecklistView(city: item.city, countryId: item.country.id)) {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(TTColors.tealGradient)
                                    .frame(width: 56, height: 56)
                                
                                Text(item.country.flagEmoji)
                                    .font(.system(size: 24))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(item.city.name)
                                        .font(TTTypography.titleMedium)
                                        .foregroundStyle(TTColors.textPrimary)
                                    
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
                                
                                Text("\(item.city.totalPlaces) konum • \(item.country.name)")
                                    .font(TTTypography.captionLarge)
                                    .foregroundStyle(TTColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundStyle(TTColors.textTertiary)
                        }
                        .ttCard(padding: 14)
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Activity (Real Data)
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "recent_completions".localized)
                .padding(.horizontal, 16)
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else if viewModel.recentActivities.isEmpty {
                EmptyStateView(
                    icon: "person.2",
                    title: "Henüz Aktivite Yok",
                    message: "Checklist'lerden yer işaretlemeye başlayın!",
                    foxMessage: "İlk keşfini yap! 🦊"
                )
                .frame(minHeight: 300)
            } else {
                ForEach(viewModel.recentActivities) { activity in
                    NavigationLink(destination: UserProfileView(userId: activity.userId, userName: activity.userName)) {
                        HStack(spacing: 14) {
                            Circle()
                                .fill(TTColors.primaryGradient)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Text(String(activity.userName.prefix(1)))
                                        .font(TTTypography.titleMedium)
                                        .foregroundStyle(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 4) {
                                    Text(activity.userName)
                                        .font(TTTypography.titleSmall)
                                        .foregroundStyle(TTColors.textPrimary)
                                    
                                    Text("ziyaret etti")
                                        .font(TTTypography.bodySmall)
                                        .foregroundStyle(TTColors.textSecondary)
                                }
                                
                                HStack(spacing: 4) {
                                    Text(activity.countryFlag)
                                    Text("\(activity.placeName), \(activity.cityName)")
                                        .font(TTTypography.bodySmall)
                                        .foregroundStyle(TTColors.foxOrange)
                                }
                            }
                            
                            Spacer()
                            
                            Text(activity.timestamp, style: .relative)
                                .font(TTTypography.captionSmall)
                                .foregroundStyle(TTColors.textTertiary)
                        }
                        .ttCard(padding: 14)
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Leaderboard (Real Data)
    private var leaderboardSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "top_explorers".localized)
                .padding(.horizontal, 16)
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else if viewModel.leaderboard.isEmpty {
                EmptyStateView(
                    icon: "trophy",
                    title: "Liderlik Tablosu Boş",
                    message: "İlk keşfedici siz olun!",
                    foxMessage: "Yer işaretleyerek liderlik tablosunda yerinizi alın! 🏆"
                )
                .frame(minHeight: 300)
            } else {
                ForEach(Array(viewModel.leaderboard.enumerated()), id: \.element.id) { index, entry in
                    let rank = index + 1
                    
                    NavigationLink(destination: UserProfileView(userId: entry.id, userName: entry.userName)) {
                        HStack(spacing: 14) {
                            // Rank
                            ZStack {
                                Circle()
                                    .fill(rankGradient(rank))
                                    .frame(width: 40, height: 40)
                                
                                Text("#\(rank)")
                                    .font(TTTypography.titleSmall)
                                    .foregroundStyle(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.userName)
                                    .font(TTTypography.titleMedium)
                                    .foregroundStyle(TTColors.textPrimary)
                                
                                Text("\(entry.totalCities) şehir • \(entry.totalCountries) ülke")
                                    .font(TTTypography.captionLarge)
                                    .foregroundStyle(TTColors.foxOrange)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(entry.totalPlaces)")
                                    .font(TTTypography.titleMedium)
                                    .foregroundStyle(TTColors.textPrimary)
                                
                                Text("yer")
                                    .font(TTTypography.captionSmall)
                                    .foregroundStyle(TTColors.textTertiary)
                            }
                        }
                        .ttCard(padding: 14)
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(.plain)
                }
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
