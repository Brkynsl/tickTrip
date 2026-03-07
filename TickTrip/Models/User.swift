import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: String
    var displayName: String
    var username: String
    var email: String
    var authProvider: AuthProvider
    var profilePhotoURL: String?
    var bio: String?
    var currentTitle: String
    var titlesUnlocked: [String]
    var selectedTheme: String
    var isPremium: Bool
    var subscriptionStatus: SubscriptionStatus
    var visibilitySettings: VisibilitySettings
    var notificationSettings: NotificationSettings
    var favoriteRegions: [String]
    var travelStyle: TravelStyle
    var totalPlacesCompleted: Int
    var totalCitiesVisited: Int
    var totalCountriesVisited: Int
    var totalTipsShared: Int
    var currentStreak: Int
    var travelLevel: Int
    var createdAt: Date
    var updatedAt: Date
    
    enum AuthProvider: String, Codable, Hashable {
        case apple, google, email
    }
    
    enum SubscriptionStatus: String, Codable, Hashable {
        case free, monthly, yearly, lifetime, expired
    }
    
    struct VisibilitySettings: Codable, Hashable {
        var profilePublic: Bool
        var tripsPublic: Bool
        var progressPublic: Bool
    }
    
    struct NotificationSettings: Codable, Hashable {
        var pushEnabled: Bool
        var reminderEnabled: Bool
        var socialEnabled: Bool
        var tipsEnabled: Bool
    }
    
    enum TravelStyle: String, Codable, Hashable, CaseIterable {
        case explorer = "Explorer"
        case cultural = "Culture Seeker"
        case foodie = "Foodie"
        case adventurer = "Adventurer"
        case relaxer = "Relaxer"
        case photographer = "Photographer"
    }
}

extension User {
    static let sample = User(
        id: "user-001",
        displayName: "Alex Explorer",
        username: "alexexplorer",
        email: "alex@example.com",
        authProvider: .email,
        profilePhotoURL: nil,
        bio: "Avid traveler and photography enthusiast. Love exploring hidden gems!",
        currentTitle: "Europe Explorer",
        titlesUnlocked: ["Rome Explorer", "Italy Traveler", "Europe Explorer"],
        selectedTheme: "default",
        isPremium: false,
        subscriptionStatus: .free,
        visibilitySettings: VisibilitySettings(profilePublic: true, tripsPublic: true, progressPublic: true),
        notificationSettings: NotificationSettings(pushEnabled: true, reminderEnabled: true, socialEnabled: true, tipsEnabled: true),
        favoriteRegions: ["Europe", "Asia"],
        travelStyle: .explorer,
        totalPlacesCompleted: 28,
        totalCitiesVisited: 5,
        totalCountriesVisited: 3,
        totalTipsShared: 12,
        currentStreak: 7,
        travelLevel: 8,
        createdAt: Date().addingTimeInterval(-86400 * 90),
        updatedAt: Date()
    )
}
