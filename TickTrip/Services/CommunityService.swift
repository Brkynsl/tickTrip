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
    
    func fetchPosts(limit: Int = 50) async throws -> [CommunityPost] {
        let snapshot = try await db.collection(collectionName)
            .order(by: "date", descending: true)
            .limit(to: limit)
            .getDocuments()
            
        return snapshot.documents.compactMap { document in
            try? document.data(as: CommunityPost.self)
        }
    }
    
    func likePost(postId: String, userId: String, isLiked: Bool) async throws {
        let docRef = db.collection(collectionName).document(postId)
        let updateData: [String: Any] = [
            "likes": isLiked ? FieldValue.increment(Int64(1)) : FieldValue.increment(Int64(-1))
        ]
        
        try await docRef.updateData(updateData)
    }
}
