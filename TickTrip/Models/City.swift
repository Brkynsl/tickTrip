import Foundation

struct City: Identifiable, Codable, Hashable {
    let id: String
    let countryId: String
    let name: String
    let heroImageName: String
    let latitude: Double
    let longitude: Double
    var totalPlaces: Int
    let popularityScore: Int
    let checklistVersion: Int
    var placeIds: [String]
    var completedPlaces: Int
    var completionPercentage: Double
    
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension City {
    static let samples: [City] = [
        // Italy
        City(id: "rome", countryId: "it", name: "Rome", heroImageName: "rome_hero",
             latitude: 41.9028, longitude: 12.4964, totalPlaces: 15, popularityScore: 98,
             checklistVersion: 1, placeIds: Place.romePlaceIds, completedPlaces: 4, completionPercentage: 0.27),
        City(id: "florence", countryId: "it", name: "Florence", heroImageName: "florence_hero",
             latitude: 43.7696, longitude: 11.2558, totalPlaces: 12, popularityScore: 92,
             checklistVersion: 1, placeIds: Place.florencePlaceIds, completedPlaces: 2, completionPercentage: 0.17),
        City(id: "venice", countryId: "it", name: "Venice", heroImageName: "venice_hero",
             latitude: 45.4408, longitude: 12.3155, totalPlaces: 10, popularityScore: 90,
             checklistVersion: 1, placeIds: Place.venicePlaceIds, completedPlaces: 0, completionPercentage: 0.0),
        City(id: "milan", countryId: "it", name: "Milan", heroImageName: "milan_hero",
             latitude: 45.4642, longitude: 9.1900, totalPlaces: 10, popularityScore: 85,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "naples", countryId: "it", name: "Naples", heroImageName: "naples_hero",
             latitude: 40.8518, longitude: 14.2681, totalPlaces: 10, popularityScore: 82,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        
        // France
        City(id: "paris", countryId: "fr", name: "Paris", heroImageName: "paris_hero",
             latitude: 48.8566, longitude: 2.3522, totalPlaces: 18, popularityScore: 99,
             checklistVersion: 1, placeIds: Place.parisPlaceIds, completedPlaces: 3, completionPercentage: 0.17),
        City(id: "nice", countryId: "fr", name: "Nice", heroImageName: "nice_hero",
             latitude: 43.7102, longitude: 7.2620, totalPlaces: 8, popularityScore: 78,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "lyon", countryId: "fr", name: "Lyon", heroImageName: "lyon_hero",
             latitude: 45.7640, longitude: 4.8357, totalPlaces: 8, popularityScore: 75,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "marseille", countryId: "fr", name: "Marseille", heroImageName: "marseille_hero",
             latitude: 43.2965, longitude: 5.3698, totalPlaces: 8, popularityScore: 74,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        
        // Spain
        City(id: "barcelona", countryId: "es", name: "Barcelona", heroImageName: "barcelona_hero",
             latitude: 41.3874, longitude: 2.1686, totalPlaces: 15, popularityScore: 96,
             checklistVersion: 1, placeIds: Place.barcelonaPlaceIds, completedPlaces: 0, completionPercentage: 0.0),
        City(id: "madrid", countryId: "es", name: "Madrid", heroImageName: "madrid_hero",
             latitude: 40.4168, longitude: -3.7038, totalPlaces: 12, popularityScore: 90,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "seville", countryId: "es", name: "Seville", heroImageName: "seville_hero",
             latitude: 37.3891, longitude: -5.9845, totalPlaces: 10, popularityScore: 84,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "valencia", countryId: "es", name: "Valencia", heroImageName: "valencia_hero",
             latitude: 39.4699, longitude: -0.3763, totalPlaces: 8, popularityScore: 80,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        
        // Germany
        City(id: "berlin", countryId: "de", name: "Berlin", heroImageName: "berlin_hero",
             latitude: 52.5200, longitude: 13.4050, totalPlaces: 12, popularityScore: 90,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "munich", countryId: "de", name: "Munich", heroImageName: "munich_hero",
             latitude: 48.1351, longitude: 11.5820, totalPlaces: 10, popularityScore: 85,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "hamburg", countryId: "de", name: "Hamburg", heroImageName: "hamburg_hero",
             latitude: 53.5511, longitude: 9.9937, totalPlaces: 8, popularityScore: 78,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        
        // UK
        City(id: "london", countryId: "gb", name: "London", heroImageName: "london_hero",
             latitude: 51.5074, longitude: -0.1278, totalPlaces: 18, popularityScore: 98,
             checklistVersion: 1, placeIds: Place.londonPlaceIds, completedPlaces: 0, completionPercentage: 0.0),
        City(id: "edinburgh", countryId: "gb", name: "Edinburgh", heroImageName: "edinburgh_hero",
             latitude: 55.9533, longitude: -3.1883, totalPlaces: 10, popularityScore: 82,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "oxford", countryId: "gb", name: "Oxford", heroImageName: "oxford_hero",
             latitude: 51.7520, longitude: -1.2577, totalPlaces: 8, popularityScore: 75,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        
        // Others
        City(id: "amsterdam", countryId: "nl", name: "Amsterdam", heroImageName: "amsterdam_hero",
             latitude: 52.3676, longitude: 4.9041, totalPlaces: 12, popularityScore: 92,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "rotterdam", countryId: "nl", name: "Rotterdam", heroImageName: "rotterdam_hero",
             latitude: 51.9244, longitude: 4.4777, totalPlaces: 6, popularityScore: 68,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "athens", countryId: "gr", name: "Athens", heroImageName: "athens_hero",
             latitude: 37.9838, longitude: 23.7275, totalPlaces: 12, popularityScore: 88,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "santorini", countryId: "gr", name: "Santorini", heroImageName: "santorini_hero",
             latitude: 36.3932, longitude: 25.4615, totalPlaces: 8, popularityScore: 94,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "lisbon", countryId: "pt", name: "Lisbon", heroImageName: "lisbon_hero",
             latitude: 38.7223, longitude: -9.1393, totalPlaces: 12, popularityScore: 88,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "porto", countryId: "pt", name: "Porto", heroImageName: "porto_hero",
             latitude: 41.1579, longitude: -8.6291, totalPlaces: 8, popularityScore: 82,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "vienna", countryId: "at", name: "Vienna", heroImageName: "vienna_hero",
             latitude: 48.2082, longitude: 16.3738, totalPlaces: 12, popularityScore: 86,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "salzburg", countryId: "at", name: "Salzburg", heroImageName: "salzburg_hero",
             latitude: 47.8095, longitude: 13.0550, totalPlaces: 8, popularityScore: 78,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "prague", countryId: "cz", name: "Prague", heroImageName: "prague_hero",
             latitude: 50.0755, longitude: 14.4378, totalPlaces: 12, popularityScore: 90,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "istanbul", countryId: "tr", name: "Istanbul", heroImageName: "istanbul_hero",
             latitude: 41.0082, longitude: 28.9784, totalPlaces: 15, popularityScore: 95,
             checklistVersion: 1, placeIds: Place.istanbulPlaceIds, completedPlaces: 0, completionPercentage: 0.0),
        City(id: "cappadocia", countryId: "tr", name: "Cappadocia", heroImageName: "cappadocia_hero",
             latitude: 38.6431, longitude: 34.8289, totalPlaces: 8, popularityScore: 88,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "antalya", countryId: "tr", name: "Antalya", heroImageName: "antalya_hero",
             latitude: 36.8969, longitude: 30.7133, totalPlaces: 8, popularityScore: 80,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "tokyo", countryId: "jp", name: "Tokyo", heroImageName: "tokyo_hero",
             latitude: 35.6762, longitude: 139.6503, totalPlaces: 15, popularityScore: 97,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "kyoto", countryId: "jp", name: "Kyoto", heroImageName: "kyoto_hero",
             latitude: 35.0116, longitude: 135.7681, totalPlaces: 12, popularityScore: 94,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
        City(id: "osaka", countryId: "jp", name: "Osaka", heroImageName: "osaka_hero",
             latitude: 34.6937, longitude: 135.5023, totalPlaces: 10, popularityScore: 88,
             checklistVersion: 1, placeIds: [], completedPlaces: 0, completionPercentage: 0.0),
    ]
    
    static func cities(for countryId: String) -> [City] {
        samples.filter { $0.countryId == countryId }
    }
}
