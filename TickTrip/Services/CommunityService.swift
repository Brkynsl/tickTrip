import Foundation
import FirebaseFirestore
import Combine

/// Service handles creating and reading community posts (tips) in Firestore
actor CommunityService {
    static let shared = CommunityService()
    
    private let db = Firestore.firestore()
    private let collectionName = "communityPosts"
    
    private init() {}
    
    func savePost(_ post: CommunityPost) async throws {
        let encodedData = try Firestore.Encoder().encode(post)
        try await db.collection(collectionName).document(post.id).setData(encodedData, merge: true)
    }
    
    /// Seed sample data into Firestore if the collection is empty
    func seedSampleDataIfNeeded() async throws {
        let snapshot = try await db.collection(collectionName).limit(to: 1).getDocuments()
        if snapshot.documents.isEmpty {
            for post in CommunityPost.samples {
                try await savePost(post)
            }
        }
    }
    
    func fetchPosts(limit: Int = 50) async throws -> [CommunityPost] {
        // First ensure we have data seeded
        try? await seedSampleDataIfNeeded()
        
        let snapshot = try await db.collection(collectionName)
            .order(by: "createdAt", descending: true)
            .limit(to: limit)
            .getDocuments()
            
        let posts = snapshot.documents.compactMap { document in
            try? document.data(as: CommunityPost.self)
        }
        
        return posts
    }
    
    func likePost(postId: String, userId: String, isLiked: Bool) async throws {
        let docRef = db.collection(collectionName).document(postId)
        let updateData: [String: Any] = [
            "likesCount": isLiked ? FieldValue.increment(Int64(1)) : FieldValue.increment(Int64(-1))
        ]
        
        try await docRef.updateData(updateData)
    }
    
    func deletePost(postId: String) async throws {
        try await db.collection(collectionName).document(postId).delete()
    }
}
