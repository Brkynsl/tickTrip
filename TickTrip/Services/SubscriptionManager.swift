import SwiftUI
import Combine

class SubscriptionManager: ObservableObject {
    @Published var isPremium: Bool = false
    @Published var currentSubscription: SubscriptionProduct?
    @Published var products: [SubscriptionProduct] = SubscriptionProduct.products
    @Published var isLoading: Bool = false
    @Published var showPaywall: Bool = false
    @Published var purchaseSuccess: Bool = false
    
    func purchase(_ product: SubscriptionProduct) {
        isLoading = true
        // Simulate StoreKit 2 purchase
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.isPremium = true
            self.currentSubscription = product
            self.purchaseSuccess = true
            self.showPaywall = false
            HapticManager.shared.achievementUnlocked()
        }
    }
    
    func restorePurchases() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isLoading = false
            // In production: verify with App Store
        }
    }
    
    func checkEntitlement() {
        // In production: check StoreKit 2 entitlements
    }
    
    var premiumFeatures: [(icon: String, title: String, description: String)] {
        [
            ("globe.americas.fill", "All Destinations", "Unlock every country and city worldwide"),
            ("suitcase.fill", "Unlimited Trips", "Create as many trips as you want"),
            ("chart.bar.fill", "Advanced Analytics", "Deep insights into your travel progress"),
            ("crown.fill", "Premium Titles", "Unlock exclusive titles and badges"),
            ("map.fill", "Interactive Maps", "Detailed maps with offline support"),
            ("camera.fill", "Unlimited Memories", "Store unlimited photos and notes"),
            ("paintbrush.fill", "Custom Themes", "Personalize your fox mascot and app theme"),
            ("sparkles", "Hidden Gem Lists", "Access curated hidden gem checklists"),
        ]
    }
}
