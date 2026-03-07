import Foundation

struct CommunityPost: Identifiable, Codable, Hashable {
    let id: String
    var userId: String
    var userName: String
    var userTitle: String
    var countryId: String
    var cityId: String
    var placeId: String?
    var placeName: String?
    var content: String
    var type: PostType
    var likesCount: Int
    var savesCount: Int
    var reportsCount: Int
    var createdAt: Date
    var updatedAt: Date
    var moderationStatus: ModerationStatus
    var isLiked: Bool
    var isSaved: Bool
    
    enum PostType: String, Codable, Hashable, CaseIterable {
        case tip = "Tip"
        case recommendation = "Recommendation"
        case warning = "Warning"
        case hiddenGem = "Hidden Gem"
        case food = "Food & Drink"
        case timing = "Timing"
        case photoSpot = "Photo Spot"
        case general = "General"
        
        var icon: String {
            switch self {
            case .tip: return "lightbulb.fill"
            case .recommendation: return "star.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .hiddenGem: return "sparkles"
            case .food: return "fork.knife"
            case .timing: return "clock.fill"
            case .photoSpot: return "camera.fill"
            case .general: return "bubble.left.fill"
            }
        }
        
        var color: String {
            switch self {
            case .tip: return "yellow"
            case .recommendation: return "blue"
            case .warning: return "red"
            case .hiddenGem: return "purple"
            case .food: return "orange"
            case .timing: return "green"
            case .photoSpot: return "pink"
            case .general: return "gray"
            }
        }
    }
    
    enum ModerationStatus: String, Codable, Hashable {
        case approved, pending, rejected, flagged
    }
}

extension CommunityPost {
    static let samples: [CommunityPost] = [
        CommunityPost(id: "post-001", userId: "user-002", userName: "Sofia M.", userTitle: "Rome Explorer",
                      countryId: "it", cityId: "rome", placeId: "rome-trevi", placeName: "Trevi Fountain",
                      content: "Visit before 8 AM for the best photos without crowds. The fountain is beautifully lit at night too! 🌙",
                      type: .tip, likesCount: 128, savesCount: 45, reportsCount: 0,
                      createdAt: Date().addingTimeInterval(-86400 * 2), updatedAt: Date().addingTimeInterval(-86400 * 2),
                      moderationStatus: .approved, isLiked: false, isSaved: true),
        CommunityPost(id: "post-002", userId: "user-003", userName: "Marco R.", userTitle: "Italy Traveler",
                      countryId: "it", cityId: "rome", placeId: "rome-trastevere", placeName: "Trastevere",
                      content: "Try the gelato at Fior di Luna on Via della Lungaretta. Best pistachio gelato in Rome! 🍦",
                      type: .food, likesCount: 89, savesCount: 62, reportsCount: 0,
                      createdAt: Date().addingTimeInterval(-86400 * 5), updatedAt: Date().addingTimeInterval(-86400 * 5),
                      moderationStatus: .approved, isLiked: true, isSaved: false),
        CommunityPost(id: "post-003", userId: "user-004", userName: "Claire D.", userTitle: "Europe Explorer",
                      countryId: "it", cityId: "rome", placeId: "rome-colosseum", placeName: "Colosseum",
                      content: "Book the underground tour in advance—it's incredible to see the tunnels where gladiators walked.",
                      type: .recommendation, likesCount: 156, savesCount: 78, reportsCount: 0,
                      createdAt: Date().addingTimeInterval(-86400 * 8), updatedAt: Date().addingTimeInterval(-86400 * 8),
                      moderationStatus: .approved, isLiked: false, isSaved: false),
        CommunityPost(id: "post-004", userId: "user-005", userName: "James K.", userTitle: "City Collector",
                      countryId: "fr", cityId: "paris", placeId: "paris-eiffel", placeName: "Eiffel Tower",
                      content: "The best photo spot isn't from Trocadéro—go to Rue de l'Université for an unobstructed view. 📸",
                      type: .photoSpot, likesCount: 234, savesCount: 120, reportsCount: 0,
                      createdAt: Date().addingTimeInterval(-86400 * 3), updatedAt: Date().addingTimeInterval(-86400 * 3),
                      moderationStatus: .approved, isLiked: true, isSaved: true),
        CommunityPost(id: "post-005", userId: "user-006", userName: "Ana L.", userTitle: "Museum Hunter",
                      countryId: "fr", cityId: "paris", placeId: "paris-louvre", placeName: "Louvre Museum",
                      content: "Enter through the Porte des Lions entrance—almost no line! The main pyramid entrance can have 2+ hour waits.",
                      type: .tip, likesCount: 312, savesCount: 198, reportsCount: 0,
                      createdAt: Date().addingTimeInterval(-86400 * 1), updatedAt: Date().addingTimeInterval(-86400 * 1),
                      moderationStatus: .approved, isLiked: false, isSaved: false),
        CommunityPost(id: "post-006", userId: "user-007", userName: "Ahmet Y.", userTitle: "Istanbul Expert",
                      countryId: "tr", cityId: "istanbul", placeId: "ist-grand-bazaar", placeName: "Grand Bazaar",
                      content: "Don't buy from the first stall! Walk deeper into the bazaar for better prices. And always drink the tea they offer. 🍵",
                      type: .tip, likesCount: 189, savesCount: 95, reportsCount: 0,
                      createdAt: Date().addingTimeInterval(-86400 * 4), updatedAt: Date().addingTimeInterval(-86400 * 4),
                      moderationStatus: .approved, isLiked: false, isSaved: false),
    ]
}
