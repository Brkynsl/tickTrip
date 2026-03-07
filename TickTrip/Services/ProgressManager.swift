import SwiftUI
import Combine
import FirebaseAuth

class ProgressManager: ObservableObject {
    @Published var completedPlaces: Set<String> = []
    @Published var foxMessage: String? = nil
    @Published var showFoxCelebration: Bool = false
    @Published var lastMilestone: String? = nil
    @Published var completedCities: Set<String> = []
    @Published var completedCountries: Set<String> = []
    
    init() {
        if Auth.auth().currentUser != nil {
            fetchUserProgress()
        }
    }
    
    func fetchUserProgress() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Task {
            do {
                if let progress = try await ProgressService.shared.fetchProgress(userId: userId) {
                    DispatchQueue.main.async {
                        self.completedPlaces = Set(progress.visitedPlaceIds)
                        self.completedCities = Set(progress.completedCityIds)
                        self.completedCountries = Set(progress.completedCountryIds)
                    }
                }
            } catch {
                print("Error loading progress: \(error.localizedDescription)")
            }
        }
    }
    
    private let foxMessages = [
        "You're doing amazing! 🦊",
        "Another one checked off! Keep going!",
        "You're becoming a true explorer! 🌍",
        "Don't forget to write a memory note!",
        "The world is waiting for you! 🗺️",
    ]
    
    private let milestoneMessages: [Int: String] = [
        5: "🎉 5 places completed! You're on your way!",
        10: "🌟 10 places! You're getting serious!",
        25: "🏆 25 places! True explorer status!",
        50: "👑 50 places! You're unstoppable!",
        100: "🌍 100 places! World-class traveler!",
    ]
    
    func togglePlace(_ placeId: String, cityId: String, countryId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        if completedPlaces.contains(placeId) {
            completedPlaces.remove(placeId)
            HapticManager.shared.impact(.light)
            Task { try? await ProgressService.shared.togglePlaceCompletion(userId: userId, placeId: placeId, isCompleted: false) }
        } else {
            completedPlaces.insert(placeId)
            HapticManager.shared.checkPlace()
            triggerFoxReaction(placeId: placeId, cityId: cityId)
            Task { try? await ProgressService.shared.togglePlaceCompletion(userId: userId, placeId: placeId, isCompleted: true) }
            
            // Check if city is now completed after checking this place
            checkCityCompletion(cityId: cityId, countryId: countryId, userId: userId)
        }
    }
    
    private func checkCityCompletion(cityId: String, countryId: String, userId: String) {
        let cityPlaces = Place.places(for: cityId)
        guard !cityPlaces.isEmpty else { return }
        
        let allCompleted = cityPlaces.allSatisfy { completedPlaces.contains($0.id) }
        if allCompleted && !completedCities.contains(cityId) {
            completedCities.insert(cityId)
            // City check off can be added to ProgressService if needed
            
            checkCountryCompletion(countryId: countryId, userId: userId)
        }
    }
    
    private func checkCountryCompletion(countryId: String, userId: String) {
        let countryCities = City.samples.filter { $0.countryId == countryId }
        guard !countryCities.isEmpty else { return }
        
        let allCompleted = countryCities.allSatisfy { completedCities.contains($0.id) }
        if allCompleted && !completedCountries.contains(countryId) {
            completedCountries.insert(countryId)
            // Country check off can be added to ProgressService if needed
        }
    }
    
    func isCompleted(_ placeId: String) -> Bool {
        completedPlaces.contains(placeId)
    }
    
    func completedCount(for cityId: String, places: [Place]) -> Int {
        places.filter { $0.cityId == cityId && completedPlaces.contains($0.id) }.count
    }
    
    func completionPercentage(for cityId: String, places: [Place]) -> Double {
        let cityPlaces = places.filter { $0.cityId == cityId }
        guard !cityPlaces.isEmpty else { return 0 }
        let completed = cityPlaces.filter { completedPlaces.contains($0.id) }.count
        return Double(completed) / Double(cityPlaces.count)
    }
    
    func completedCountForCountry(_ countryId: String) -> Int {
        let cities = City.samples.filter { $0.countryId == countryId }
        var count = 0
        for city in cities {
            let places = Place.places(for: city.id)
            count += places.filter { completedPlaces.contains($0.id) }.count
        }
        return count
    }
    
    func totalPlacesForCountry(_ countryId: String) -> Int {
        let cities = City.samples.filter { $0.countryId == countryId }
        var count = 0
        for city in cities {
            let places = Place.places(for: city.id)
            count += places.isEmpty ? city.totalPlaces : places.count
        }
        return count
    }
    
    // MARK: - Fox Reactions
    
    private func triggerFoxReaction(placeId: String, cityId: String) {
        let totalCompleted = completedPlaces.count
        
        // Check milestones
        if let milestone = milestoneMessages[totalCompleted] {
            lastMilestone = milestone
            showFoxCelebration = true
            foxMessage = milestone
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.showFoxCelebration = false
            }
            return
        }
        
        // City completion check
        let cityPlaces = Place.places(for: cityId)
        if !cityPlaces.isEmpty {
            let cityCompleted = cityPlaces.filter { completedPlaces.contains($0.id) }.count
            let remaining = cityPlaces.count - cityCompleted
            
            if remaining == 0 {
                foxMessage = "🎉 You completed \(cityId.capitalized)! Amazing!"
                showFoxCelebration = true
            } else if remaining <= 3 {
                foxMessage = "You're \(remaining) place\(remaining == 1 ? "" : "s") away from completing \(cityId.capitalized)! 🦊"
            } else {
                foxMessage = foxMessages.randomElement()
            }
        } else {
            foxMessage = foxMessages.randomElement()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            withAnimation { self?.foxMessage = nil }
        }
    }
}
