import Foundation

struct Achievement: Identifiable, Codable, Hashable {
    let id: String
    let key: String
    let title: String
    let description: String
    let icon: String
    let criteriaType: CriteriaType
    let criteriaValue: Int
    var isUnlocked: Bool
    var unlockedAt: Date?
    
    enum CriteriaType: String, Codable, Hashable {
        case placesCompleted
        case citiesCompleted
        case countriesVisited
        case tipsShared
        case tripsCompleted
        case categoriesExplored
        case streakDays
    }
}

struct TitleRule: Identifiable, Codable, Hashable {
    let id: String
    let key: String
    let titleName: String
    let regionScope: RegionScope
    let regionId: String?
    let unlockCriteria: UnlockCriteria
    
    enum RegionScope: String, Codable, Hashable {
        case city, country, continent, world, special
    }
    
    struct UnlockCriteria: Codable, Hashable {
        let type: String
        let value: Int
    }
}

struct SubscriptionProduct: Identifiable, Codable, Hashable {
    let id: String
    let productIdentifier: String
    let type: ProductType
    let priceDisplay: String
    let duration: String
    let isActive: Bool
    let savings: String?
    let isBestValue: Bool
    
    enum ProductType: String, Codable, Hashable {
        case monthly, yearly, lifetime
    }
}

// MARK: - Sample Data
extension Achievement {
    static let samples: [Achievement] = [
        Achievement(id: "ach-001", key: "first_place", title: "First Step", description: "Complete your first place", icon: "flag.fill", criteriaType: .placesCompleted, criteriaValue: 1, isUnlocked: true, unlockedAt: Date().addingTimeInterval(-86400 * 10)),
        Achievement(id: "ach-002", key: "ten_places", title: "Getting Started", description: "Complete 10 places", icon: "10.circle.fill", criteriaType: .placesCompleted, criteriaValue: 10, isUnlocked: true, unlockedAt: Date().addingTimeInterval(-86400 * 5)),
        Achievement(id: "ach-003", key: "fifty_places", title: "Seasoned Traveler", description: "Complete 50 places", icon: "star.circle.fill", criteriaType: .placesCompleted, criteriaValue: 50, isUnlocked: false, unlockedAt: nil),
        Achievement(id: "ach-004", key: "first_city", title: "City Conqueror", description: "Complete all places in a city", icon: "building.2.crop.circle.fill", criteriaType: .citiesCompleted, criteriaValue: 1, isUnlocked: false, unlockedAt: nil),
        Achievement(id: "ach-005", key: "five_cities", title: "City Collector", description: "Complete 5 cities", icon: "building.2.fill", criteriaType: .citiesCompleted, criteriaValue: 5, isUnlocked: false, unlockedAt: nil),
        Achievement(id: "ach-006", key: "first_country", title: "Border Crosser", description: "Visit your first country", icon: "globe.europe.africa.fill", criteriaType: .countriesVisited, criteriaValue: 1, isUnlocked: true, unlockedAt: Date().addingTimeInterval(-86400 * 8)),
        Achievement(id: "ach-007", key: "three_countries", title: "World Wanderer", description: "Visit 3 countries", icon: "globe.americas.fill", criteriaType: .countriesVisited, criteriaValue: 3, isUnlocked: true, unlockedAt: Date().addingTimeInterval(-86400 * 2)),
        Achievement(id: "ach-008", key: "first_tip", title: "Community Helper", description: "Share your first tip", icon: "bubble.left.and.bubble.right.fill", criteriaType: .tipsShared, criteriaValue: 1, isUnlocked: true, unlockedAt: Date().addingTimeInterval(-86400 * 7)),
        Achievement(id: "ach-009", key: "ten_tips", title: "Local Expert", description: "Share 10 tips", icon: "text.bubble.fill", criteriaType: .tipsShared, criteriaValue: 10, isUnlocked: true, unlockedAt: Date().addingTimeInterval(-86400 * 1)),
        Achievement(id: "ach-010", key: "museum_hunter", title: "Museum Hunter", description: "Visit 10 museums", icon: "building.columns.fill", criteriaType: .categoriesExplored, criteriaValue: 10, isUnlocked: false, unlockedAt: nil),
        Achievement(id: "ach-011", key: "night_explorer", title: "Night Explorer", description: "Complete 5 places after sunset", icon: "moon.stars.fill", criteriaType: .placesCompleted, criteriaValue: 5, isUnlocked: false, unlockedAt: nil),
        Achievement(id: "ach-012", key: "streak_7", title: "Week Warrior", description: "Maintain a 7-day streak", icon: "flame.fill", criteriaType: .streakDays, criteriaValue: 7, isUnlocked: true, unlockedAt: Date()),
    ]
}

extension TitleRule {
    static let samples: [TitleRule] = [
        TitleRule(id: "title-001", key: "rome_explorer", titleName: "Rome Explorer", regionScope: .city, regionId: "rome",
                  unlockCriteria: TitleRule.UnlockCriteria(type: "placesCompleted", value: 10)),
        TitleRule(id: "title-002", key: "italy_traveler", titleName: "Italy Traveler", regionScope: .country, regionId: "it",
                  unlockCriteria: TitleRule.UnlockCriteria(type: "citiesVisited", value: 3)),
        TitleRule(id: "title-003", key: "italy_ambassador", titleName: "Italy Ambassador", regionScope: .country, regionId: "it",
                  unlockCriteria: TitleRule.UnlockCriteria(type: "completionPercentage", value: 75)),
        TitleRule(id: "title-004", key: "europe_explorer", titleName: "Europe Explorer", regionScope: .continent, regionId: "Europe",
                  unlockCriteria: TitleRule.UnlockCriteria(type: "countriesVisited", value: 5)),
        TitleRule(id: "title-005", key: "europe_ambassador", titleName: "Europe Ambassador", regionScope: .continent, regionId: "Europe",
                  unlockCriteria: TitleRule.UnlockCriteria(type: "completionPercentage", value: 50)),
        TitleRule(id: "title-006", key: "world_nomad", titleName: "World Nomad", regionScope: .world, regionId: nil,
                  unlockCriteria: TitleRule.UnlockCriteria(type: "countriesVisited", value: 10)),
        TitleRule(id: "title-007", key: "world_conqueror", titleName: "World Conqueror", regionScope: .world, regionId: nil,
                  unlockCriteria: TitleRule.UnlockCriteria(type: "completionPercentage", value: 80)),
        TitleRule(id: "title-008", key: "hidden_gem_hunter", titleName: "Hidden Gem Hunter", regionScope: .special, regionId: nil,
                  unlockCriteria: TitleRule.UnlockCriteria(type: "hiddenGemsFound", value: 20)),
        TitleRule(id: "title-009", key: "city_collector", titleName: "City Collector", regionScope: .special, regionId: nil,
                  unlockCriteria: TitleRule.UnlockCriteria(type: "citiesCompleted", value: 10)),
    ]
}

extension SubscriptionProduct {
    static let products: [SubscriptionProduct] = [
        SubscriptionProduct(id: "sub-monthly", productIdentifier: "com.ticktrip.pro.monthly",
                           type: .monthly, priceDisplay: "$4.99/mo", duration: "Monthly",
                           isActive: true, savings: nil, isBestValue: false),
        SubscriptionProduct(id: "sub-yearly", productIdentifier: "com.ticktrip.pro.yearly",
                           type: .yearly, priceDisplay: "$29.99/yr", duration: "Yearly",
                           isActive: true, savings: "Save 50%", isBestValue: true),
        SubscriptionProduct(id: "sub-lifetime", productIdentifier: "com.ticktrip.pro.lifetime",
                           type: .lifetime, priceDisplay: "$79.99", duration: "Lifetime",
                           isActive: true, savings: "Pay Once", isBestValue: false),
    ]
}
