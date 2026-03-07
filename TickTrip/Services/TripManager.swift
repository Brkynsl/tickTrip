import SwiftUI
import Combine
import FirebaseAuth

class TripManager: ObservableObject {
    static let shared = TripManager()
    
    @Published var trips: [Trip] = []
    @Published var activeTrip: Trip?
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private init() {
        // Fetch trips initially if user is already logged in
        if Auth.auth().currentUser != nil {
            fetchTrips()
        }
    }
    
    func fetchTrips() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        Task {
            do {
                let fetchedTrips = try await TripService.shared.fetchTrips(userId: userId)
                DispatchQueue.main.async {
                    self.trips = fetchedTrips
                    self.activeTrip = fetchedTrips.first { $0.status == .active } ?? fetchedTrips.first
                    self.isLoading = false
                }
            } catch {
                print("Error loading trips: \(error.localizedDescription)")
                DispatchQueue.main.async { 
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func createTrip(name: String, countryIds: [String], cityIds: [String], startDate: Date?, endDate: Date?, visibility: Trip.TripVisibility) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let newTrip = Trip(
            id: "trip-\(UUID().uuidString.prefix(8))",
            userId: userId,
            name: name,
            countryIds: countryIds,
            cityIds: cityIds,
            startDate: startDate,
            endDate: endDate,
            status: .planning,
            currentCityId: cityIds.first,
            visibility: visibility,
            createdAt: Date(),
            updatedAt: Date(),
            cityProgress: cityIds.map { cityId in
                TripCityProgress(
                    id: "tcp-\(UUID().uuidString.prefix(8))",
                    tripId: "",
                    cityId: cityId,
                    completedPlaceIds: [],
                    completionPercentage: 0,
                    notes: [],
                    photos: [],
                    isCompleted: false
                )
            }
        )
        trips.insert(newTrip, at: 0)
        if activeTrip == nil {
            activeTrip = newTrip
        }
        HapticManager.shared.notification(.success)
        
        // Save to Firebase
        Task {
            try? await TripService.shared.saveTrip(newTrip)
        }
    }
    
    func deleteTrip(_ trip: Trip) {
        trips.removeAll { $0.id == trip.id }
        if activeTrip?.id == trip.id {
            activeTrip = trips.first
        }
        
        // Delete from Firebase
        Task {
            try? await TripService.shared.deleteTrip(tripId: trip.id)
        }
    }
    
    func setActiveTrip(_ trip: Trip) {
        activeTrip = trip
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index].status = .active
            trips[index].updatedAt = Date()
            
            let updatedTrip = trips[index]
            Task { try? await TripService.shared.saveTrip(updatedTrip) }
        }
    }
    
    func addCityToTrip(_ tripId: String, cityId: String) {
        if let index = trips.firstIndex(where: { $0.id == tripId }) {
            if !trips[index].cityIds.contains(cityId) {
                trips[index].cityIds.append(cityId)
                let city = City.samples.first { $0.id == cityId }
                let countryId = city?.countryId ?? ""
                if !countryId.isEmpty && !trips[index].countryIds.contains(countryId) {
                    trips[index].countryIds.append(countryId)
                }
                trips[index].cityProgress.append(
                    TripCityProgress(
                        id: "tcp-\(UUID().uuidString.prefix(8))",
                        tripId: tripId,
                        cityId: cityId,
                        completedPlaceIds: [],
                        completionPercentage: 0,
                        notes: [],
                        photos: [],
                        isCompleted: false
                    )
                )
                trips[index].updatedAt = Date()
                if activeTrip?.id == tripId { activeTrip = trips[index] }
                
                let updatedTrip = trips[index]
                Task { try? await TripService.shared.saveTrip(updatedTrip) }
            }
        }
    }
    
    func removeCityFromTrip(_ tripId: String, cityId: String) {
        if let index = trips.firstIndex(where: { $0.id == tripId }) {
            trips[index].cityIds.removeAll { $0 == cityId }
            trips[index].cityProgress.removeAll { $0.cityId == cityId }
            trips[index].updatedAt = Date()
            if activeTrip?.id == tripId { activeTrip = trips[index] }
            
            let updatedTrip = trips[index]
            Task { try? await TripService.shared.saveTrip(updatedTrip) }
        }
    }
    
    func deleteTrip(_ tripId: String) {
        isLoading = true
        trips.removeAll { $0.id == tripId }
        if activeTrip?.id == tripId { activeTrip = nil }
        
        Task {
            try? await TripService.shared.deleteTrip(tripId: tripId)
            await MainActor.run { self.isLoading = false }
        }
    }
}
