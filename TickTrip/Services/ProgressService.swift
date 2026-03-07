import Foundation
import FirebaseFirestore
import Combine

/// Track which places users have completed (checked-off) across cities/countries
actor ProgressService {
    static let shared = ProgressService()
    
    private let db = Firestore.firestore()
    private let collectionName = "progress" // "progress/{userId}_places"
    
    private init() {}
    
    struct UserProgress: Codable {
        var id: String // userId
        var visitedPlaceIds: [String]
        var completedCityIds: [String]
        var completedCountryIds: [String]
        var updatedAt: Date
    }
    
    /// Save a place visit for the user
    func togglePlaceCompletion(userId: String, placeId: String, isCompleted: Bool) async throws {
        let docRef = db.collection(collectionName).document(userId)
        
        let updateData: [String: Any] = [
            "visitedPlaceIds": isCompleted ? FieldValue.arrayUnion([placeId]) : FieldValue.arrayRemove([placeId]),
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        try await docRef.setData(updateData, merge: true)
    }
    
    /// Fetch user progress document
    func fetchProgress(userId: String) async throws -> UserProgress? {
        let doc = try await db.collection(collectionName).document(userId).getDocument()
        return try? doc.data(as: UserProgress.self)
    }
}
