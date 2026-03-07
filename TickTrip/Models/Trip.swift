import Foundation

struct Trip: Identifiable, Codable, Hashable {
    let id: String
    var userId: String
    var name: String
    var countryIds: [String]
    var cityIds: [String]
    var startDate: Date?
    var endDate: Date?
    var status: TripStatus
    var currentCityId: String?
    var visibility: TripVisibility
    var createdAt: Date
    var updatedAt: Date
    var cityProgress: [TripCityProgress]
    
    enum TripStatus: String, Codable, Hashable {
        case planning, active, paused, completed
        
        var displayName: String {
            switch self {
            case .planning: return "Planning"
            case .active: return "Active"
            case .paused: return "Paused"
            case .completed: return "Completed"
            }
        }
        
        var icon: String {
            switch self {
            case .planning: return "pencil.and.list.clipboard"
            case .active: return "airplane"
            case .paused: return "pause.circle"
            case .completed: return "checkmark.seal.fill"
            }
        }
    }
    
    enum TripVisibility: String, Codable, Hashable, CaseIterable {
        case privateTrip = "Private"
        case friendsOnly = "Friends Only"
        case publicTrip = "Public"
        
        var icon: String {
            switch self {
            case .privateTrip: return "lock.fill"
            case .friendsOnly: return "person.2.fill"
            case .publicTrip: return "globe"
            }
        }
    }
    
    var overallProgress: Double {
        guard !cityProgress.isEmpty else { return 0 }
        let total = cityProgress.reduce(0.0) { $0 + $1.completionPercentage }
        return total / Double(cityProgress.count)
    }
    
    var countryFlags: String {
        let countries = Country.samples.filter { countryIds.contains($0.id) }
        return countries.map { $0.flagEmoji }.joined(separator: " ")
    }
    
    static func == (lhs: Trip, rhs: Trip) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct TripCityProgress: Identifiable, Codable, Hashable {
    let id: String
    var tripId: String
    var cityId: String
    var completedPlaceIds: [String]
    var completionPercentage: Double
    var notes: [String]
    var photos: [String]
    var isCompleted: Bool
    
    static func == (lhs: TripCityProgress, rhs: TripCityProgress) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct UserPlaceCompletion: Identifiable, Codable, Hashable {
    let id: String
    var userId: String
    var placeId: String
    var cityId: String
    var countryId: String
    var completedAt: Date
    var attachedNote: String?
    var attachedPhotoURL: String?
    var completionSource: CompletionSource
    
    enum CompletionSource: String, Codable, Hashable {
        case manual, trip, import_data
    }
}

extension Trip {
    static let sample = Trip(
        id: "trip-001",
        userId: "user-001",
        name: "Italian Dream",
        countryIds: ["it"],
        cityIds: ["rome", "florence", "venice"],
        startDate: Date().addingTimeInterval(-86400 * 3),
        endDate: Date().addingTimeInterval(86400 * 7),
        status: .active,
        currentCityId: "rome",
        visibility: .publicTrip,
        createdAt: Date().addingTimeInterval(-86400 * 10),
        updatedAt: Date(),
        cityProgress: [
            TripCityProgress(id: "tcp-001", tripId: "trip-001", cityId: "rome",
                           completedPlaceIds: ["rome-colosseum", "rome-vatican", "rome-trevi", "rome-pantheon"],
                           completionPercentage: 0.27, notes: ["Amazing experience!"], photos: [], isCompleted: false),
            TripCityProgress(id: "tcp-002", tripId: "trip-001", cityId: "florence",
                           completedPlaceIds: ["florence-duomo", "florence-ponte-vecchio"],
                           completionPercentage: 0.17, notes: [], photos: [], isCompleted: false),
            TripCityProgress(id: "tcp-003", tripId: "trip-001", cityId: "venice",
                           completedPlaceIds: [],
                           completionPercentage: 0.0, notes: [], photos: [], isCompleted: false),
        ]
    )
    
    static let sampleEurope = Trip(
        id: "trip-002",
        userId: "user-001",
        name: "Europe Explorer",
        countryIds: ["fr", "es"],
        cityIds: ["paris", "barcelona"],
        startDate: nil,
        endDate: nil,
        status: .planning,
        currentCityId: nil,
        visibility: .privateTrip,
        createdAt: Date().addingTimeInterval(-86400 * 2),
        updatedAt: Date(),
        cityProgress: []
    )
}
