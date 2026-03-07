import Foundation

struct Country: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let code: String
    let flagEmoji: String
    let continent: String
    let heroImageName: String
    var cityIds: [String]
    let sortOrder: Int
    let popularityScore: Int
    var completionPercentage: Double
    var visitedCitiesCount: Int
    var totalCities: Int
    var isTrending: Bool
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Country {
    static let samples: [Country] = [
        Country(id: "it", name: "Italy", code: "IT", flagEmoji: "🇮🇹", continent: "Europe",
                heroImageName: "italy_hero", cityIds: ["rome", "florence", "venice", "milan", "naples"],
                sortOrder: 1, popularityScore: 98, completionPercentage: 0.15, visitedCitiesCount: 2,
                totalCities: 5, isTrending: true),
        Country(id: "fr", name: "France", code: "FR", flagEmoji: "🇫🇷", continent: "Europe",
                heroImageName: "france_hero", cityIds: ["paris", "nice", "lyon", "marseille"],
                sortOrder: 2, popularityScore: 96, completionPercentage: 0.08, visitedCitiesCount: 1,
                totalCities: 4, isTrending: false),
        Country(id: "es", name: "Spain", code: "ES", flagEmoji: "🇪🇸", continent: "Europe",
                heroImageName: "spain_hero", cityIds: ["barcelona", "madrid", "seville", "valencia"],
                sortOrder: 3, popularityScore: 94, completionPercentage: 0.0, visitedCitiesCount: 0,
                totalCities: 4, isTrending: true),
        Country(id: "de", name: "Germany", code: "DE", flagEmoji: "🇩🇪", continent: "Europe",
                heroImageName: "germany_hero", cityIds: ["berlin", "munich", "hamburg"],
                sortOrder: 4, popularityScore: 88, completionPercentage: 0.0, visitedCitiesCount: 0,
                totalCities: 3, isTrending: false),
        Country(id: "gb", name: "United Kingdom", code: "GB", flagEmoji: "🇬🇧", continent: "Europe",
                heroImageName: "uk_hero", cityIds: ["london", "edinburgh", "oxford"],
                sortOrder: 5, popularityScore: 92, completionPercentage: 0.0, visitedCitiesCount: 0,
                totalCities: 3, isTrending: false),
        Country(id: "nl", name: "Netherlands", code: "NL", flagEmoji: "🇳🇱", continent: "Europe",
                heroImageName: "netherlands_hero", cityIds: ["amsterdam", "rotterdam"],
                sortOrder: 6, popularityScore: 82, completionPercentage: 0.0, visitedCitiesCount: 0,
                totalCities: 2, isTrending: false),
        Country(id: "gr", name: "Greece", code: "GR", flagEmoji: "🇬🇷", continent: "Europe",
                heroImageName: "greece_hero", cityIds: ["athens", "santorini", "thessaloniki"],
                sortOrder: 7, popularityScore: 90, completionPercentage: 0.0, visitedCitiesCount: 0,
                totalCities: 3, isTrending: true),
        Country(id: "pt", name: "Portugal", code: "PT", flagEmoji: "🇵🇹", continent: "Europe",
                heroImageName: "portugal_hero", cityIds: ["lisbon", "porto"],
                sortOrder: 8, popularityScore: 86, completionPercentage: 0.0, visitedCitiesCount: 0,
                totalCities: 2, isTrending: false),
        Country(id: "at", name: "Austria", code: "AT", flagEmoji: "🇦🇹", continent: "Europe",
                heroImageName: "austria_hero", cityIds: ["vienna", "salzburg"],
                sortOrder: 9, popularityScore: 80, completionPercentage: 0.0, visitedCitiesCount: 0,
                totalCities: 2, isTrending: false),
        Country(id: "cz", name: "Czech Republic", code: "CZ", flagEmoji: "🇨🇿", continent: "Europe",
                heroImageName: "czech_hero", cityIds: ["prague"],
                sortOrder: 10, popularityScore: 78, completionPercentage: 0.0, visitedCitiesCount: 0,
                totalCities: 1, isTrending: false),
        Country(id: "tr", name: "Turkey", code: "TR", flagEmoji: "🇹🇷", continent: "Europe",
                heroImageName: "turkey_hero", cityIds: ["istanbul", "cappadocia", "antalya"],
                sortOrder: 11, popularityScore: 91, completionPercentage: 0.0, visitedCitiesCount: 0,
                totalCities: 3, isTrending: true),
        Country(id: "jp", name: "Japan", code: "JP", flagEmoji: "🇯🇵", continent: "Asia",
                heroImageName: "japan_hero", cityIds: ["tokyo", "kyoto", "osaka"],
                sortOrder: 12, popularityScore: 95, completionPercentage: 0.0, visitedCitiesCount: 0,
                totalCities: 3, isTrending: true),
    ]
}
