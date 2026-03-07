import SwiftUI
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    // Specific app interactions
    func checkPlace() {
        impact(.medium)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.notification(.success)
        }
    }
    
    func achievementUnlocked() {
        notification(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.impact(.heavy)
        }
    }
    
    func tabSwitch() {
        selection()
    }
    
    func buttonTap() {
        impact(.light)
    }
    
    func error() {
        notification(.error)
    }
}
