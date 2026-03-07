import Foundation
import FirebaseFirestore
import Combine

/// Service handles creating, reading, and managing user trips in Firestore
actor TripService {
    static let shared = TripService()
    
    private let db = Firestore.firestore()
    private let collectionName = "trips"
    
    private init() {}
    
    /// Create or update a trip in Firestore
    func saveTrip(_ trip: Trip) async throws {
        let encodedData = try Firestore.Encoder().encode(trip)
        try await db.collection(collectionName).document(trip.id).setData(encodedData, merge: true)
    }
    
    /// Delete a trip by ID
    func deleteTrip(tripId: String) async throws {
        try await db.collection(collectionName).document(tripId).delete()
    }
    
    /// Fetch all trips for a specific user ID
    func fetchTrips(userId: String) async throws -> [Trip] {
        let snapshot = try await db.collection(collectionName)
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
            
        return snapshot.documents.compactMap { document in
            try? document.data(as: Trip.self)
        }
    }
}
