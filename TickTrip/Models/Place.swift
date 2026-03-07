import Foundation

struct Place: Identifiable, Codable, Hashable {
    let id: String
    let cityId: String
    let name: String
    let description: String
    let imageSystemName: String
    let latitude: Double
    let longitude: Double
    let category: PlaceCategory
    let popularityRank: Int
    let estimatedVisitTime: String
    let tags: [String]
    let isPremiumOnly: Bool
    var communityTipCount: Int
    var isCompleted: Bool
    var note: String?
    
    enum PlaceCategory: String, Codable, Hashable, CaseIterable {
        case landmark = "Landmark"
        case museum = "Museum"
        case park = "Park"
        case religious = "Religious"
        case square = "Square"
        case neighborhood = "Neighborhood"
        case market = "Market"
        case viewpoint = "Viewpoint"
        case bridge = "Bridge"
        case palace = "Palace"
        case beach = "Beach"
        case food = "Food & Drink"
        case entertainment = "Entertainment"
        case historical = "Historical"
        
        var icon: String {
            switch self {
            case .landmark: return "building.columns"
            case .museum: return "building.2"
            case .park: return "leaf"
            case .religious: return "star.circle"
            case .square: return "square.grid.2x2"
            case .neighborhood: return "house.lodge"
            case .market: return "bag"
            case .viewpoint: return "binoculars"
            case .bridge: return "road.lanes"
            case .palace: return "crown"
            case .beach: return "sun.horizon"
            case .food: return "fork.knife"
            case .entertainment: return "star"
            case .historical: return "clock.arrow.circlepath"
            }
        }
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Place IDs per city
extension Place {
    static let romePlaceIds = ["rome-colosseum", "rome-vatican", "rome-trevi", "rome-pantheon", "rome-forum",
                                "rome-spanish-steps", "rome-piazza-navona", "rome-trastevere", "rome-borghese",
                                "rome-aventine", "rome-campo-de-fiori", "rome-castel-sant-angelo",
                                "rome-piazza-del-popolo", "rome-appian-way", "rome-mouth-of-truth"]
    
    static let florencePlaceIds = ["florence-duomo", "florence-uffizi", "florence-ponte-vecchio",
                                    "florence-accademia", "florence-pitti", "florence-boboli",
                                    "florence-piazzale", "florence-santa-croce", "florence-san-lorenzo",
                                    "florence-signoria", "florence-baptistery", "florence-bardini"]
    
    static let venicePlaceIds = ["venice-san-marco", "venice-rialto", "venice-doges", "venice-grand-canal",
                                  "venice-murano", "venice-burano", "venice-guggenheim", "venice-bridge-sighs",
                                  "venice-san-giorgio", "venice-lido"]
    
    static let parisPlaceIds = ["paris-eiffel", "paris-louvre", "paris-notre-dame", "paris-sacre-coeur",
                                 "paris-arc-triomphe", "paris-champs-elysees", "paris-montmartre",
                                 "paris-musee-orsay", "paris-luxembourg", "paris-seine", "paris-marais",
                                 "paris-tuileries", "paris-versailles", "paris-moulin-rouge",
                                 "paris-saint-germain", "paris-opera", "paris-pantheon", "paris-concorde"]
    
    static let barcelonaPlaceIds = ["bcn-sagrada", "bcn-park-guell", "bcn-las-ramblas", "bcn-casa-batllo",
                                     "bcn-gothic-quarter", "bcn-barceloneta", "bcn-casa-mila",
                                     "bcn-boqueria", "bcn-montjuic", "bcn-tibidabo", "bcn-born",
                                     "bcn-camp-nou", "bcn-ciutadella", "bcn-palau-musica", "bcn-hospital-sant-pau"]
    
    static let londonPlaceIds = ["ldn-tower", "ldn-big-ben", "ldn-buckingham", "ldn-british-museum",
                                  "ldn-tower-bridge", "ldn-eye", "ldn-hyde-park", "ldn-westminster",
                                  "ldn-st-pauls", "ldn-covent-garden", "ldn-camden", "ldn-tate-modern",
                                  "ldn-notting-hill", "ldn-borough-market", "ldn-natural-history",
                                  "ldn-soho", "ldn-greenwich", "ldn-kensington"]
    
    static let istanbulPlaceIds = ["ist-hagia-sophia", "ist-blue-mosque", "ist-grand-bazaar", "ist-topkapi",
                                    "ist-basilica-cistern", "ist-galata-tower", "ist-dolmabahce",
                                    "ist-spice-bazaar", "ist-bosphorus", "ist-suleymaniye",
                                    "ist-maiden-tower", "ist-istiklal", "ist-balat", "ist-kadikoy", "ist-princes-islands"]
}

// MARK: - Sample Places
extension Place {
    static let romeSamples: [Place] = [
        Place(id: "rome-colosseum", cityId: "rome", name: "Colosseum",
              description: "The iconic ancient amphitheatre, the largest ever built, symbol of Rome.",
              imageSystemName: "building.columns.fill", latitude: 41.8902, longitude: 12.4922,
              category: .landmark, popularityRank: 1, estimatedVisitTime: "2-3 hours",
              tags: ["ancient", "iconic", "must-see"], isPremiumOnly: false, communityTipCount: 45, isCompleted: true),
        Place(id: "rome-vatican", cityId: "rome", name: "Vatican Museums & Sistine Chapel",
              description: "One of the world's greatest art collections, including Michelangelo's Sistine Chapel ceiling.",
              imageSystemName: "paintpalette.fill", latitude: 41.9065, longitude: 12.4536,
              category: .museum, popularityRank: 2, estimatedVisitTime: "3-4 hours",
              tags: ["art", "religious", "must-see"], isPremiumOnly: false, communityTipCount: 38, isCompleted: true),
        Place(id: "rome-trevi", cityId: "rome", name: "Trevi Fountain",
              description: "Baroque masterpiece where tossing a coin guarantees your return to Rome.",
              imageSystemName: "drop.fill", latitude: 41.9009, longitude: 12.4833,
              category: .landmark, popularityRank: 3, estimatedVisitTime: "30 min",
              tags: ["fountain", "romantic", "iconic"], isPremiumOnly: false, communityTipCount: 52, isCompleted: true),
        Place(id: "rome-pantheon", cityId: "rome", name: "Pantheon",
              description: "Best preserved ancient Roman building with its remarkable unreinforced concrete dome.",
              imageSystemName: "building.columns", latitude: 41.8986, longitude: 12.4769,
              category: .historical, popularityRank: 4, estimatedVisitTime: "1 hour",
              tags: ["ancient", "architecture", "free"], isPremiumOnly: false, communityTipCount: 28, isCompleted: true),
        Place(id: "rome-forum", cityId: "rome", name: "Roman Forum",
              description: "The heart of ancient Rome, full of ruins of government buildings.",
              imageSystemName: "building.columns.circle", latitude: 41.8925, longitude: 12.4853,
              category: .historical, popularityRank: 5, estimatedVisitTime: "2 hours",
              tags: ["ancient", "ruins", "history"], isPremiumOnly: false, communityTipCount: 22, isCompleted: false),
        Place(id: "rome-spanish-steps", cityId: "rome", name: "Spanish Steps",
              description: "Monumental stairway of 135 steps connecting Piazza di Spagna to the Trinità dei Monti church.",
              imageSystemName: "figure.stairs", latitude: 41.9060, longitude: 12.4828,
              category: .landmark, popularityRank: 6, estimatedVisitTime: "30 min",
              tags: ["shopping", "iconic", "photography"], isPremiumOnly: false, communityTipCount: 18, isCompleted: false),
        Place(id: "rome-piazza-navona", cityId: "rome", name: "Piazza Navona",
              description: "One of Rome's most beautiful squares with Bernini's Fountain of the Four Rivers.",
              imageSystemName: "building.2.fill", latitude: 41.8992, longitude: 12.4730,
              category: .square, popularityRank: 7, estimatedVisitTime: "45 min",
              tags: ["baroque", "fountains", "cafes"], isPremiumOnly: false, communityTipCount: 15, isCompleted: false),
        Place(id: "rome-trastevere", cityId: "rome", name: "Trastevere",
              description: "Charming medieval neighborhood famous for its nightlife and authentic Roman cuisine.",
              imageSystemName: "house.lodge.fill", latitude: 41.8840, longitude: 12.4700,
              category: .neighborhood, popularityRank: 8, estimatedVisitTime: "2-3 hours",
              tags: ["food", "nightlife", "authentic"], isPremiumOnly: false, communityTipCount: 35, isCompleted: false),
        Place(id: "rome-borghese", cityId: "rome", name: "Villa Borghese Gardens",
              description: "Beautiful landscaped gardens with the renowned Borghese Gallery art museum.",
              imageSystemName: "leaf.fill", latitude: 41.9146, longitude: 12.4854,
              category: .park, popularityRank: 9, estimatedVisitTime: "2 hours",
              tags: ["art", "nature", "relaxing"], isPremiumOnly: false, communityTipCount: 12, isCompleted: false),
        Place(id: "rome-aventine", cityId: "rome", name: "Aventine Keyhole",
              description: "Peek through the keyhole of the Knights of Malta priory for a perfectly framed view of St. Peter's.",
              imageSystemName: "eye.fill", latitude: 41.8825, longitude: 12.4797,
              category: .viewpoint, popularityRank: 10, estimatedVisitTime: "30 min",
              tags: ["hidden-gem", "photography", "unique"], isPremiumOnly: false, communityTipCount: 20, isCompleted: false),
        Place(id: "rome-campo-de-fiori", cityId: "rome", name: "Campo de' Fiori",
              description: "Lively market square by day and bustling social hub by night.",
              imageSystemName: "bag.fill", latitude: 41.8957, longitude: 12.4720,
              category: .market, popularityRank: 11, estimatedVisitTime: "1 hour",
              tags: ["market", "food", "nightlife"], isPremiumOnly: false, communityTipCount: 14, isCompleted: false),
        Place(id: "rome-castel-sant-angelo", cityId: "rome", name: "Castel Sant'Angelo",
              description: "Towering cylindrical fortress originally built as Emperor Hadrian's mausoleum.",
              imageSystemName: "building.fill", latitude: 41.9031, longitude: 12.4663,
              category: .historical, popularityRank: 12, estimatedVisitTime: "1.5 hours",
              tags: ["fortress", "views", "history"], isPremiumOnly: false, communityTipCount: 16, isCompleted: false),
        Place(id: "rome-piazza-del-popolo", cityId: "rome", name: "Piazza del Popolo",
              description: "Large urban square with twin churches, an Egyptian obelisk, and stunning terraced views.",
              imageSystemName: "circle.grid.2x2.fill", latitude: 41.9108, longitude: 12.4762,
              category: .square, popularityRank: 13, estimatedVisitTime: "30 min",
              tags: ["photography", "sunset", "obelisk"], isPremiumOnly: false, communityTipCount: 8, isCompleted: false),
        Place(id: "rome-appian-way", cityId: "rome", name: "Appian Way",
              description: "One of the earliest and most important Roman roads, great for a historic walk or bike ride.",
              imageSystemName: "figure.walk", latitude: 41.8561, longitude: 12.5252,
              category: .historical, popularityRank: 14, estimatedVisitTime: "2-3 hours",
              tags: ["ancient", "walking", "cycling"], isPremiumOnly: true, communityTipCount: 10, isCompleted: false),
        Place(id: "rome-mouth-of-truth", cityId: "rome", name: "Mouth of Truth",
              description: "Ancient marble mask that legend says will bite the hand of a liar.",
              imageSystemName: "theatermask.and.paintbrush.fill", latitude: 41.8884, longitude: 12.4818,
              category: .landmark, popularityRank: 15, estimatedVisitTime: "20 min",
              tags: ["legend", "fun", "photography"], isPremiumOnly: false, communityTipCount: 22, isCompleted: false),
    ]
    
    static let parisSamples: [Place] = [
        Place(id: "paris-eiffel", cityId: "paris", name: "Eiffel Tower",
              description: "The most iconic symbol of Paris and one of the most recognizable structures in the world.",
              imageSystemName: "antenna.radiowaves.left.and.right", latitude: 48.8584, longitude: 2.2945,
              category: .landmark, popularityRank: 1, estimatedVisitTime: "2-3 hours",
              tags: ["iconic", "must-see", "views"], isPremiumOnly: false, communityTipCount: 65, isCompleted: true),
        Place(id: "paris-louvre", cityId: "paris", name: "Louvre Museum",
              description: "The world's largest art museum, home to the Mona Lisa.",
              imageSystemName: "paintpalette.fill", latitude: 48.8606, longitude: 2.3376,
              category: .museum, popularityRank: 2, estimatedVisitTime: "3-5 hours",
              tags: ["art", "must-see", "mona-lisa"], isPremiumOnly: false, communityTipCount: 42, isCompleted: true),
        Place(id: "paris-notre-dame", cityId: "paris", name: "Notre-Dame Cathedral",
              description: "Medieval masterpiece of French Gothic architecture on Île de la Cité.",
              imageSystemName: "star.circle.fill", latitude: 48.8530, longitude: 2.3499,
              category: .religious, popularityRank: 3, estimatedVisitTime: "1-2 hours",
              tags: ["gothic", "architecture", "history"], isPremiumOnly: false, communityTipCount: 30, isCompleted: true),
        Place(id: "paris-sacre-coeur", cityId: "paris", name: "Sacré-Cœur",
              description: "White-domed basilica atop Montmartre hill with panoramic city views.",
              imageSystemName: "star.circle", latitude: 48.8867, longitude: 2.3431,
              category: .religious, popularityRank: 4, estimatedVisitTime: "1 hour",
              tags: ["views", "architecture", "free"], isPremiumOnly: false, communityTipCount: 25, isCompleted: false),
        Place(id: "paris-arc-triomphe", cityId: "paris", name: "Arc de Triomphe",
              description: "Iconic triumphal arch honoring those who fought for France.",
              imageSystemName: "building.columns.fill", latitude: 48.8738, longitude: 2.2950,
              category: .landmark, popularityRank: 5, estimatedVisitTime: "1 hour",
              tags: ["views", "iconic", "history"], isPremiumOnly: false, communityTipCount: 20, isCompleted: false),
        Place(id: "paris-champs-elysees", cityId: "paris", name: "Champs-Élysées",
              description: "The most famous avenue in the world, lined with shops, cafés, and theatres.",
              imageSystemName: "cart.fill", latitude: 48.8698, longitude: 2.3070,
              category: .neighborhood, popularityRank: 6, estimatedVisitTime: "1-2 hours",
              tags: ["shopping", "iconic", "walking"], isPremiumOnly: false, communityTipCount: 18, isCompleted: false),
    ]
    
    static let barcelonaSamples: [Place] = [
        Place(id: "bcn-sagrada", cityId: "barcelona", name: "Sagrada Família",
              description: "Gaudí's unfinished masterpiece, one of the most extraordinary churches ever built.",
              imageSystemName: "star.circle.fill", latitude: 41.4036, longitude: 2.1744,
              category: .religious, popularityRank: 1, estimatedVisitTime: "2-3 hours",
              tags: ["gaudi", "must-see", "architecture"], isPremiumOnly: false, communityTipCount: 55, isCompleted: false),
        Place(id: "bcn-park-guell", cityId: "barcelona", name: "Park Güell",
              description: "Gaudí's colorful public park system with stunning city views.",
              imageSystemName: "leaf.fill", latitude: 41.4145, longitude: 2.1527,
              category: .park, popularityRank: 2, estimatedVisitTime: "2 hours",
              tags: ["gaudi", "mosaic", "views"], isPremiumOnly: false, communityTipCount: 40, isCompleted: false),
        Place(id: "bcn-las-ramblas", cityId: "barcelona", name: "Las Ramblas",
              description: "Barcelona's most famous street stretching 1.2 km from Plaça de Catalunya to the waterfront.",
              imageSystemName: "figure.walk", latitude: 41.3809, longitude: 2.1734,
              category: .neighborhood, popularityRank: 3, estimatedVisitTime: "1 hour",
              tags: ["walking", "street-life", "shopping"], isPremiumOnly: false, communityTipCount: 30, isCompleted: false),
        Place(id: "bcn-casa-batllo", cityId: "barcelona", name: "Casa Batlló",
              description: "Gaudí's dragon-inspired masterpiece on Passeig de Gràcia.",
              imageSystemName: "house.fill", latitude: 41.3916, longitude: 2.1650,
              category: .landmark, popularityRank: 4, estimatedVisitTime: "1.5 hours",
              tags: ["gaudi", "architecture", "modernisme"], isPremiumOnly: false, communityTipCount: 28, isCompleted: false),
        Place(id: "bcn-gothic-quarter", cityId: "barcelona", name: "Gothic Quarter",
              description: "Medieval heart of the old city with narrow streets and hidden plazas.",
              imageSystemName: "building.2.fill", latitude: 41.3833, longitude: 2.1761,
              category: .neighborhood, popularityRank: 5, estimatedVisitTime: "2 hours",
              tags: ["medieval", "history", "walking"], isPremiumOnly: false, communityTipCount: 22, isCompleted: false),
    ]
    
    static let londonSamples: [Place] = [
        Place(id: "ldn-tower", cityId: "london", name: "Tower of London",
              description: "Historic castle housing the Crown Jewels with over 900 years of history.",
              imageSystemName: "building.columns.fill", latitude: 51.5081, longitude: -0.0759,
              category: .historical, popularityRank: 1, estimatedVisitTime: "3 hours",
              tags: ["history", "crown-jewels", "must-see"], isPremiumOnly: false, communityTipCount: 40, isCompleted: false),
        Place(id: "ldn-big-ben", cityId: "london", name: "Big Ben & Parliament",
              description: "The iconic clock tower and the Palace of Westminster.",
              imageSystemName: "clock.fill", latitude: 51.5007, longitude: -0.1246,
              category: .landmark, popularityRank: 2, estimatedVisitTime: "1 hour",
              tags: ["iconic", "photography", "architecture"], isPremiumOnly: false, communityTipCount: 35, isCompleted: false),
        Place(id: "ldn-buckingham", cityId: "london", name: "Buckingham Palace",
              description: "The official London residence of the British monarch.",
              imageSystemName: "crown.fill", latitude: 51.5014, longitude: -0.1419,
              category: .palace, popularityRank: 3, estimatedVisitTime: "1-2 hours",
              tags: ["royalty", "changing-guard", "iconic"], isPremiumOnly: false, communityTipCount: 30, isCompleted: false),
        Place(id: "ldn-british-museum", cityId: "london", name: "British Museum",
              description: "World-class museum of human history and culture with free admission.",
              imageSystemName: "building.2.fill", latitude: 51.5194, longitude: -0.1270,
              category: .museum, popularityRank: 4, estimatedVisitTime: "3-4 hours",
              tags: ["free", "history", "art"], isPremiumOnly: false, communityTipCount: 28, isCompleted: false),
        Place(id: "ldn-tower-bridge", cityId: "london", name: "Tower Bridge",
              description: "London's most famous bridge with glass walkway and Victorian engine rooms.",
              imageSystemName: "road.lanes", latitude: 51.5055, longitude: -0.0754,
              category: .bridge, popularityRank: 5, estimatedVisitTime: "1 hour",
              tags: ["iconic", "views", "architecture"], isPremiumOnly: false, communityTipCount: 22, isCompleted: false),
    ]
    
    static let istanbulSamples: [Place] = [
        Place(id: "ist-hagia-sophia", cityId: "istanbul", name: "Hagia Sophia",
              description: "A masterpiece of Byzantine architecture, serving as cathedral, mosque, and museum across centuries.",
              imageSystemName: "star.circle.fill", latitude: 41.0086, longitude: 28.9802,
              category: .landmark, popularityRank: 1, estimatedVisitTime: "2 hours",
              tags: ["must-see", "architecture", "history"], isPremiumOnly: false, communityTipCount: 50, isCompleted: false),
        Place(id: "ist-blue-mosque", cityId: "istanbul", name: "Blue Mosque",
              description: "Stunning imperial mosque famous for its blue Iznik tile interior.",
              imageSystemName: "building.columns", latitude: 41.0054, longitude: 28.9768,
              category: .religious, popularityRank: 2, estimatedVisitTime: "1 hour",
              tags: ["architecture", "tiles", "iconic"], isPremiumOnly: false, communityTipCount: 38, isCompleted: false),
        Place(id: "ist-grand-bazaar", cityId: "istanbul", name: "Grand Bazaar",
              description: "One of the largest and oldest covered markets in the world with over 4,000 shops.",
              imageSystemName: "bag.fill", latitude: 41.0107, longitude: 28.9680,
              category: .market, popularityRank: 3, estimatedVisitTime: "2-3 hours",
              tags: ["shopping", "culture", "bargaining"], isPremiumOnly: false, communityTipCount: 42, isCompleted: false),
        Place(id: "ist-topkapi", cityId: "istanbul", name: "Topkapi Palace",
              description: "Grand Ottoman palace that was home to sultans for nearly 400 years.",
              imageSystemName: "crown.fill", latitude: 41.0115, longitude: 28.9833,
              category: .palace, popularityRank: 4, estimatedVisitTime: "2-3 hours",
              tags: ["history", "ottoman", "treasures"], isPremiumOnly: false, communityTipCount: 35, isCompleted: false),
        Place(id: "ist-basilica-cistern", cityId: "istanbul", name: "Basilica Cistern",
              description: "Atmospheric underground water cistern with 336 marble columns.",
              imageSystemName: "drop.fill", latitude: 41.0084, longitude: 28.9779,
              category: .historical, popularityRank: 5, estimatedVisitTime: "1 hour",
              tags: ["underground", "atmospheric", "unique"], isPremiumOnly: false, communityTipCount: 30, isCompleted: false),
        Place(id: "ist-galata-tower", cityId: "istanbul", name: "Galata Tower",
              description: "Medieval stone tower with panoramic views of Istanbul's skyline and the Bosphorus.",
              imageSystemName: "building.fill", latitude: 41.0256, longitude: 28.9741,
              category: .viewpoint, popularityRank: 6, estimatedVisitTime: "1 hour",
              tags: ["views", "photography", "sunset"], isPremiumOnly: false, communityTipCount: 28, isCompleted: false),
        Place(id: "ist-bosphorus", cityId: "istanbul", name: "Bosphorus Cruise",
              description: "Scenic boat ride along the strait that divides Europe and Asia.",
              imageSystemName: "ferry.fill", latitude: 41.0235, longitude: 29.0055,
              category: .entertainment, popularityRank: 7, estimatedVisitTime: "2-3 hours",
              tags: ["scenic", "cruise", "photography"], isPremiumOnly: false, communityTipCount: 25, isCompleted: false),
    ]
    
    static func places(for cityId: String) -> [Place] {
        let all = romeSamples + parisSamples + barcelonaSamples + londonSamples + istanbulSamples
        return all.filter { $0.cityId == cityId }
    }
}
