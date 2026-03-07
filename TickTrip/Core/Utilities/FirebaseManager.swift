import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

/// Centralized manager for Firebase configuration and shared instances
class FirebaseManager {
    static let shared = FirebaseManager()
    
    // Core references
    let auth = Auth.auth()
    let firestore = Firestore.firestore()
    
    private init() {
        // Initialization happens in AppDelegate/App struct
    }
    
    /// Checks if Firebase is properly configured
    var isConfigured: Bool {
        FirebaseApp.app() != nil
    }
}
