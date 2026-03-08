import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        let settings = FirestoreSettings()
        settings.cacheSettings = PersistentCacheSettings() // Enable offline persistence
        let db = Firestore.firestore()
        db.settings = settings
        
        return true
    }
}

@main
struct TickTripApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var authManager = AuthManager()
    @StateObject private var appState = AppState()
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager)
                .environmentObject(appState)
                .environmentObject(localizationManager)
                .localizable()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @Published var selectedTab: AppTab = .explore
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}

enum AppTab: Int, CaseIterable {
    case explore = 0
    case myTrip = 1
    case world = 2
    case community = 3
    case profile = 4
    
    var title: String {
        switch self {
        case .explore: return "explore_tab".localized
        case .myTrip: return "my_trip_tab".localized
        case .world: return "world_tab".localized
        case .community: return "community_tab".localized
        case .profile: return "profile_tab".localized
        }
    }
    
    var icon: String {
        switch self {
        case .explore: return "safari"
        case .myTrip: return "suitcase.fill"
        case .world: return "globe.americas.fill"
        case .community: return "bubble.left.and.bubble.right.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}
