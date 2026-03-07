import SwiftUI
import FirebaseFirestore

/// Public profile view for any user — shows their progress, visited places, and activity
struct UserProfileView: View {
    let userId: String
    let userName: String
    
    @State private var activities: [ActivityService.Activity] = []
    @State private var profile: ActivityService.LeaderboardEntry?
    @State private var visitedPlaceIds: Set<String> = []
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile header
                profileHeader
                
                // Stats
                statsGrid
                
                // Countries & Progress
                countriesSection
                
                // Recent Activity
                activitySection
            }
            .padding(.bottom, 30)
        }
        .background(TTColors.backgroundPrimary.ignoresSafeArea())
        .navigationTitle(userName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadUserData()
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(TTColors.primaryGradient)
                .frame(width: 80, height: 80)
                .overlay(
                    Text(String(userName.prefix(1)).uppercased())
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                )
            
            Text(userName)
                .font(TTTypography.headlineMedium)
                .foregroundStyle(TTColors.textPrimary)
            
            if let profile = profile {
                Text("🌍 \(profile.totalCountries) ülke • 🏙 \(profile.totalCities) şehir • 📍 \(profile.totalPlaces) yer")
                    .font(TTTypography.captionLarge)
                    .foregroundStyle(TTColors.textSecondary)
            }
        }
        .padding(.top, 16)
    }
    
    // MARK: - Stats Grid
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            statCard(value: "\(profile?.totalPlaces ?? 0)", label: "Yer", icon: "checkmark.circle.fill", color: TTColors.foxOrange)
            statCard(value: "\(profile?.totalCities ?? 0)", label: "Şehir", icon: "building.2.fill", color: TTColors.secondaryFallback)
            statCard(value: "\(profile?.totalCountries ?? 0)", label: "Ülke", icon: "globe.americas.fill", color: TTColors.success)
        }
        .padding(.horizontal, 16)
    }
    
    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            
            Text(value)
                .font(TTTypography.headlineMedium)
                .foregroundStyle(TTColors.textPrimary)
            
            Text(label)
                .font(TTTypography.captionSmall)
                .foregroundStyle(TTColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(TTColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: TTColors.cardShadow, radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Countries Section
    private var countriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Ziyaret Ettiği Ülkeler")
                .padding(.horizontal, 16)
            
            let visitedCountries = Country.samples.filter { country in
                let countryCities = City.samples.filter { $0.countryId == country.id }
                return countryCities.contains { city in
                    Place.places(for: city.id).contains { visitedPlaceIds.contains($0.id) }
                }
            }
            
            if visitedCountries.isEmpty {
                Text("Henüz bir yer ziyaret etmemiş")
                    .font(TTTypography.bodyMedium)
                    .foregroundStyle(TTColors.textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                ForEach(visitedCountries) { country in
                    NavigationLink(destination: userCountryDetail(country: country)) {
                        HStack(spacing: 14) {
                            Text(country.flagEmoji)
                                .font(.system(size: 32))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(country.name)
                                    .font(TTTypography.titleMedium)
                                    .foregroundStyle(TTColors.textPrimary)
                                
                                let countryCities = City.samples.filter { $0.countryId == country.id }
                                let visitedCities = countryCities.filter { city in
                                    Place.places(for: city.id).contains { visitedPlaceIds.contains($0.id) }
                                }
                                Text("\(visitedCities.count)/\(countryCities.count) şehir ziyaret edildi")
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
    
    // MARK: - Country Detail (User's progress)
    private func userCountryDetail(country: Country) -> some View {
        let countryCities = City.samples.filter { $0.countryId == country.id }
        
        return ScrollView {
            VStack(spacing: 12) {
                ForEach(countryCities) { city in
                    let places = Place.places(for: city.id)
                    let completed = places.filter { visitedPlaceIds.contains($0.id) }.count
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(city.name)
                                .font(TTTypography.titleMedium)
                                .foregroundStyle(TTColors.textPrimary)
                            
                            Spacer()
                            
                            Text("\(completed)/\(places.count)")
                                .font(TTTypography.labelMedium)
                                .foregroundStyle(TTColors.foxOrange)
                        }
                        
                        TTProgressBar(progress: places.isEmpty ? 0 : Double(completed) / Double(places.count), height: 5)
                        
                        ForEach(places) { place in
                            HStack(spacing: 10) {
                                Image(systemName: visitedPlaceIds.contains(place.id) ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 18))
                                    .foregroundStyle(visitedPlaceIds.contains(place.id) ? TTColors.foxOrange : TTColors.textTertiary)
                                
                                Text(place.name)
                                    .font(TTTypography.bodyMedium)
                                    .foregroundStyle(visitedPlaceIds.contains(place.id) ? TTColors.textPrimary : TTColors.textTertiary)
                                    .strikethrough(visitedPlaceIds.contains(place.id), color: TTColors.textTertiary)
                                
                                Spacer()
                            }
                        }
                    }
                    .ttCard()
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 8)
        }
        .background(TTColors.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("\(userName) — \(country.name)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Activity Section
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Son Aktiviteler")
                .padding(.horizontal, 16)
            
            if activities.isEmpty && !isLoading {
                Text("Henüz aktivite yok")
                    .font(TTTypography.bodyMedium)
                    .foregroundStyle(TTColors.textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                ForEach(activities.prefix(10)) { activity in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(TTColors.foxOrange)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(activity.placeName)")
                                .font(TTTypography.titleSmall)
                                .foregroundStyle(TTColors.textPrimary)
                            
                            Text("\(activity.countryFlag) \(activity.cityName)")
                                .font(TTTypography.captionLarge)
                                .foregroundStyle(TTColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Text(activity.timestamp, style: .relative)
                            .font(TTTypography.captionSmall)
                            .foregroundStyle(TTColors.textTertiary)
                    }
                    .ttCard(padding: 12)
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    // MARK: - Load Data
    private func loadUserData() async {
        do {
            async let activitiesResult = ActivityService.shared.fetchUserActivities(userId: userId)
            async let profileResult = ActivityService.shared.fetchUserProfile(userId: userId)
            async let progressResult = ProgressService.shared.fetchProgress(userId: userId)
            
            let (acts, prof, prog) = try await (activitiesResult, profileResult, progressResult)
            
            await MainActor.run {
                self.activities = acts
                self.profile = prof
                if let prog = prog {
                    self.visitedPlaceIds = Set(prog.visitedPlaceIds)
                }
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
