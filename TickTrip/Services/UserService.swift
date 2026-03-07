import Foundation
import FirebaseFirestore
import FirebaseAuth

/// Service for managing User profiles in Firestore
actor UserService {
    static let shared = UserService()
    
    private let db = Firestore.firestore()
    private let usersCollection = "users"
    
    private init() {}
    
    /// Create or update a user document
    func saveUser(_ user: User) async {
        do {
            let encodedData = try Firestore.Encoder().encode(user)
            try await db.collection(usersCollection).document(user.id).setData(encodedData, merge: true)
        } catch {
            print("Error saving user profile to Firestore: \(error.localizedDescription)")
        }
    }
    
    /// Fetch user data by ID
    func fetchUser(userId: String) async -> User? {
        do {
            let document = try await db.collection(usersCollection).document(userId).getDocument()
            guard document.exists else { return nil }
            return try document.data(as: User.self)
        } catch {
            print("Error fetching user profile from Firestore: \(error.localizedDescription)")
            return nil
        }
    }
}
