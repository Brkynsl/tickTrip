import Foundation
import FirebaseFirestore
import FirebaseAuth

/// Tracks user activities (place visits) for the global activity feed, trending, and leaderboard
actor ActivityService {
    static let shared = ActivityService()
    
    private let db = Firestore.firestore()
    private let collectionName = "activities"
    private let leaderboardCollection = "leaderboard"
    
    private init() {}
    
    struct Activity: Codable, Identifiable {
        var id: String
        var userId: String
        var userName: String
        var placeId: String
        var placeName: String
        var cityId: String
        var cityName: String
        var countryId: String
        var countryFlag: String
        var timestamp: Date
    }
    
    struct LeaderboardEntry: Codable, Identifiable {
        var id: String // userId
        var userName: String
        var totalPlaces: Int
        var totalCities: Int
        var totalCountries: Int
        var updatedAt: Date
    }
    
    // MARK: - Log Activity
    
    func logActivity(userId: String, userName: String, placeId: String, placeName: String, cityId: String, countryId: String) async throws {
        let cityName = City.samples.first(where: { $0.id == cityId })?.name ?? cityId
        let countryFlag = Country.samples.first(where: { $0.id == countryId })?.flagEmoji ?? "🌍"
        
        let activity = Activity(
            id: UUID().uuidString,
            userId: userId,
            userName: userName,
            placeId: placeId,
            placeName: placeName,
            cityId: cityId,
            cityName: cityName,
            countryId: countryId,
            countryFlag: countryFlag,
            timestamp: Date()
        )
        
        let encodedData = try Firestore.Encoder().encode(activity)
        try await db.collection(collectionName).document(activity.id).setData(encodedData)
        
        // Update leaderboard entry
        try await updateLeaderboard(userId: userId, userName: userName)
    }
    
    // MARK: - Fetch Recent Activities (Global Feed)
    
    func fetchRecentActivities(limit: Int = 20) async throws -> [Activity] {
        let snapshot = try await db.collection(collectionName)
            .order(by: "timestamp", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Activity.self)
        }
    }
    
    // MARK: - Fetch Activities for a Specific User
    
    func fetchUserActivities(userId: String, limit: Int = 50) async throws -> [Activity] {
        let snapshot = try await db.collection(collectionName)
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Activity.self)
        }
    }
    
    // MARK: - Trending Cities (most ticked)
    
    func fetchTrendingCityIds(limit: Int = 10) async throws -> [String] {
        // Get recent activities and count by city
        let snapshot = try await db.collection(collectionName)
            .order(by: "timestamp", descending: true)
            .limit(to: 200)
            .getDocuments()
        
        var cityCounts: [String: Int] = [:]
        for doc in snapshot.documents {
            if let cityId = doc.data()["cityId"] as? String {
                cityCounts[cityId, default: 0] += 1
            }
        }
        
        return cityCounts.sorted { $0.value > $1.value }
            .prefix(limit)
            .map { $0.key }
    }
    
    // MARK: - Leaderboard
    
    private func updateLeaderboard(userId: String, userName: String) async throws {
        // Fetch user's progress to get real counts
        if let progress = try await ProgressService.shared.fetchProgress(userId: userId) {
            let entry = LeaderboardEntry(
                id: userId,
                userName: userName,
                totalPlaces: progress.visitedPlaceIds.count,
                totalCities: progress.completedCityIds.count,
                totalCountries: progress.completedCountryIds.count,
                updatedAt: Date()
            )
            let encodedData = try Firestore.Encoder().encode(entry)
            try await db.collection(leaderboardCollection).document(userId).setData(encodedData, merge: true)
        }
    }
    
    func fetchLeaderboard(limit: Int = 20) async throws -> [LeaderboardEntry] {
        let snapshot = try await db.collection(leaderboardCollection)
            .order(by: "totalPlaces", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: LeaderboardEntry.self)
        }
    }
    
    // MARK: - Fetch User Public Profile
    
    func fetchUserProfile(userId: String) async throws -> LeaderboardEntry? {
        let doc = try await db.collection(leaderboardCollection).document(userId).getDocument()
        return try? doc.data(as: LeaderboardEntry.self)
    }
}
