import SwiftUI
import Combine
import FirebaseAuth

class ExploreViewModel: ObservableObject {
    @Published var countries: [Country] = Country.samples
    @Published var searchText: String = ""
    @Published var selectedContinent: String? = nil
    @Published var sortOption: SortOption = .popularity
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showAddFeedback = false
    
    let progressManager = ProgressManager.shared
    let tripManager = TripManager.shared
    
    enum SortOption: String, CaseIterable {
        case popularity = "Popular"
        case alphabetical = "A-Z"
        case completion = "Progress"
    }
    
    var filteredCountries: [Country] {
        var result = countries
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let continent = selectedContinent {
            result = result.filter { $0.continent == continent }
        }
        
        switch sortOption {
        case .popularity: result.sort { $0.popularityScore > $1.popularityScore }
        case .alphabetical: result.sort { $0.name < $1.name }
        case .completion: result.sort { $0.completionPercentage > $1.completionPercentage }
        }
        
        return result
    }
    
    var continents: [String] {
        Array(Set(countries.map { $0.continent })).sorted()
    }
    
    func cities(for country: Country) -> [City] {
        City.samples.filter { $0.countryId == country.id }
    }
    
    func places(for city: City) -> [Place] {
        Place.places(for: city.id)
    }
    
    func updateCountryProgress(_ countryId: String) {
        if let index = countries.firstIndex(where: { $0.id == countryId }) {
            let completed = progressManager.completedCountForCountry(countryId)
            let total = progressManager.totalPlacesForCountry(countryId)
            countries[index].completionPercentage = total > 0 ? Double(completed) / Double(total) : 0
        }
    }
    
    func addCityToActiveTrip(_ cityId: String) {
        guard let activeTrip = tripManager.activeTrip else {
            errorMessage = "no_active_trip_error".localized
            return
        }
        
        tripManager.addCityToTrip(activeTrip.id, cityId: cityId)
        showAddFeedback = true
        HapticManager.shared.notification(.success)
        
        // Auto-hide feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showAddFeedback = false
        }
    }
}

class MyTripViewModel: ObservableObject {
    var tripManager = TripManager.shared
    @Published var showCreateTrip = false
    @Published var newTripName = ""
    @Published var selectedCountries: Set<String> = []
    @Published var selectedCities: Set<String> = []
    
    var trips: [Trip] { tripManager.trips }
    var activeTrip: Trip? { tripManager.activeTrip }
    
    /// Sync trip cityProgress with ProgressManager data
    func syncProgressWithTrips() {
        let progressManager = ProgressManager.shared
        for i in 0..<tripManager.trips.count {
            for j in 0..<tripManager.trips[i].cityProgress.count {
                let cityId = tripManager.trips[i].cityProgress[j].cityId
                let cityPlaces = Place.places(for: cityId)
                let completedForCity = cityPlaces.filter { progressManager.completedPlaces.contains($0.id) }.map { $0.id }
                
                tripManager.trips[i].cityProgress[j].completedPlaceIds = completedForCity
                tripManager.trips[i].cityProgress[j].completionPercentage =
                    cityPlaces.isEmpty ? 0 : Double(completedForCity.count) / Double(cityPlaces.count)
                tripManager.trips[i].cityProgress[j].isCompleted =
                    !cityPlaces.isEmpty && completedForCity.count == cityPlaces.count
            }
        }
        // Update activeTrip reference
        if let activeId = tripManager.activeTrip?.id,
           let updated = tripManager.trips.first(where: { $0.id == activeId }) {
            tripManager.activeTrip = updated
        }
    }
}

class SocialViewModel: ObservableObject {
    @Published var trendingCountries: [Country] = Array(Country.samples.filter { $0.isTrending })
    @Published var recentCompletions: [(userName: String, placeName: String, cityName: String, timeAgo: String)] = [
        ("Sofia M.", "Colosseum", "Rome", "2h ago"),
        ("James K.", "Eiffel Tower", "Paris", "4h ago"),
        ("Ahmet Y.", "Hagia Sophia", "Istanbul", "6h ago"),
        ("Anna S.", "Sagrada Família", "Barcelona", "8h ago"),
        ("Claire D.", "Tower of London", "London", "12h ago"),
    ]
    @Published var leaderboard: [(rank: Int, name: String, title: String, places: Int, countries: Int)] = [
        (1, "WorldRunner", "World Nomad", 234, 18),
        (2, "Sofia M.", "Europe Ambassador", 189, 12),
        (3, "TravelMax", "City Collector", 156, 9),
        (4, "James K.", "Italy Ambassador", 134, 7),
        (5, "WanderLena", "Europe Explorer", 112, 6),
    ]
    @Published var selectedSection: SocialSection = .trending
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    enum SocialSection: String, CaseIterable {
        case trending = "Trending"
        case activity = "Activity"
        case leaderboard = "Leaderboard"
    }
}

class CommunityViewModel: ObservableObject {
    @Published var posts: [CommunityPost] = []
    @Published var selectedCountry: Country?
    @Published var selectedCity: City?
    @Published var sortBy: SortOption = .newest
    @Published var filterType: CommunityPost.PostType?
    @Published var showCreateTip = false
    @Published var newTipContent = ""
    @Published var newTipType: CommunityPost.PostType = .tip
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    enum SortOption: String, CaseIterable {
        case popular = "Most Useful"
        case newest = "Newest"
        case trending = "Trending"
    }
    
    var filteredPosts: [CommunityPost] {
        var result = posts
        
        if let city = selectedCity {
            result = result.filter { $0.cityId == city.id }
        } else if let country = selectedCountry {
            result = result.filter { $0.countryId == country.id }
        }
        
        if let type = filterType {
            result = result.filter { $0.type == type }
        }
        
        switch sortBy {
        case .popular: result.sort { $0.likesCount > $1.likesCount }
        case .newest: result.sort { $0.createdAt > $1.createdAt }
        case .trending: result.sort { $0.likesCount + $0.savesCount > $1.likesCount + $1.savesCount }
        }
        
        return result
    }
    
    func fetchPosts() {
        isLoading = true
        Task {
            do {
                let fetchedPosts = try await CommunityService.shared.fetchPosts()
                await MainActor.run {
                    self.posts = fetchedPosts
                    self.isLoading = false
                    self.errorMessage = nil
                }
            } catch {
                print("Error fetching community posts: \(error.localizedDescription)")
                await MainActor.run {
                    // Load sample data as fallback
                    if self.posts.isEmpty {
                        self.posts = CommunityPost.samples
                    }
                    self.isLoading = false
                    self.errorMessage = nil // Don't show error if we have fallback data
                }
            }
        }
    }
    
    func toggleLike(_ postId: String) {
        guard let index = posts.firstIndex(where: { $0.id == postId }), 
              let userId = Auth.auth().currentUser?.uid else { return }
              
        posts[index].isLiked.toggle()
        posts[index].likesCount += posts[index].isLiked ? 1 : -1
        HapticManager.shared.impact(.light)
        
        let isLikedNow = posts[index].isLiked
        Task {
            try? await CommunityService.shared.likePost(postId: postId, userId: userId, isLiked: isLikedNow)
        }
    }
    
    func toggleSave(_ postId: String) {
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].isSaved.toggle()
            posts[index].savesCount += posts[index].isSaved ? 1 : -1
            HapticManager.shared.selection()
        }
    }
    
    func createTip(cityId: String, placeId: String?) {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let newPost = CommunityPost(
            id: UUID().uuidString,
            userId: currentUser.uid, 
            userName: currentUser.displayName ?? "Traveler", 
            userTitle: "novice_explorer".localized,
            countryId: City.samples.first(where: { $0.id == cityId })?.countryId ?? "",
            cityId: cityId, placeId: placeId, placeName: nil,
            content: newTipContent, type: newTipType,
            likesCount: 0, savesCount: 0, reportsCount: 0,
            createdAt: Date(), updatedAt: Date(),
            moderationStatus: .approved, isLiked: false, isSaved: false
        )
        
        posts.insert(newPost, at: 0)
        newTipContent = ""
        HapticManager.shared.notification(.success)
        
        Task {
            try? await CommunityService.shared.savePost(newPost)
        }
    }
}

class ProfileViewModel: ObservableObject {
    @Published var user: User = User.sample
    @Published var achievements: [Achievement] = Achievement.samples
    @Published var titles: [TitleRule] = TitleRule.samples
    @Published var subscriptionManager = SubscriptionManager()
    @Published var showSettings = false
    @Published var showAchievements = false
    @Published var showPaywall = false
    @Published var showEditProfile = false
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // Use shared ProgressManager for real stats
    private var progressManager = ProgressManager.shared
    
    init() {
        if let currentUser = Auth.auth().currentUser {
            user.id = currentUser.uid
            user.email = currentUser.email ?? ""
            user.displayName = currentUser.displayName ?? "Traveler"
        }
    }
    
    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }
    
    var lockedAchievements: [Achievement] {
        achievements.filter { !$0.isUnlocked }
    }
    
    var worldProgress: Double {
        let total = Country.samples.count
        let visited = progressManager.completedCountries.count
        return total > 0 ? Double(visited) / Double(total) : 0
    }
    
    var europeProgress: Double {
        let europeTotal = Country.samples.filter { $0.continent == "Europe" }.count
        let europeVisited = Country.samples.filter { 
            $0.continent == "Europe" && progressManager.completedCountries.contains($0.id) 
        }.count
        return europeTotal > 0 ? Double(europeVisited) / Double(europeTotal) : 0
    }
    
    var asiaProgress: Double { 
        let asiaTotal = Country.samples.filter { $0.continent == "Asia" }.count
        let asiaVisited = Country.samples.filter { 
            $0.continent == "Asia" && progressManager.completedCountries.contains($0.id) 
        }.count
        return asiaTotal > 0 ? Double(asiaVisited) / Double(asiaTotal) : 0
     }
    
    /// Real stats from ProgressManager
    var totalPlaces: Int { progressManager.completedPlaces.count }
    var totalCities: Int { progressManager.completedCities.count }
    var totalCountries: Int { progressManager.completedCountries.count }
    
    func updateProfile(displayName: String, username: String, bio: String) {
        isLoading = true
        var updatedUser = user
        updatedUser.displayName = displayName
        updatedUser.username = username
        updatedUser.bio = bio
        
        let finalUser = updatedUser
        Task {
            await UserService.shared.saveUser(finalUser)
            await MainActor.run {
                self.user = finalUser
                self.isLoading = false
            }
        }
    }
}
