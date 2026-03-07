import Foundation
import Combine

/// A service to fetch high-quality travel images from Unsplash
class UnsplashService: ObservableObject {
    static let shared = UnsplashService()
    
    // Memory cache for fetched URLs
    private var cache = NSCache<NSString, NSURL>()
    
    private init() {}
    
    /// Models the Unsplash search response
    struct SearchResponse: Codable {
        let results: [UnsplashImage]
    }
    
    /// Models an individual Unsplash image result
    struct UnsplashImage: Codable, Identifiable {
        let id: String
        let urls: URLs
        let user: User
        
        struct URLs: Codable {
            let raw: String
            let full: String
            let regular: String
            let small: String
            let thumb: String
        }
        
        struct User: Codable {
            let name: String
            let username: String
        }
    }
    
    /// Fetches a random image URL for a given search query (e.g., "Paris France")
    func fetchImageURL(for query: String) async throws -> URL? {
        let cacheKey = NSString(string: query)
        
        // 1. Check memory cache
        if let cachedURL = cache.object(forKey: cacheKey) as URL? {
            return cachedURL
        }
        
        // 2. Perform network request
        guard var urlComponents = URLComponents(string: "\(UnsplashConfig.baseURL)/search/photos") else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "orientation", value: "landscape"),
            URLQueryItem(name: "per_page", value: "1")
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(UnsplashConfig.accessKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // Unsplash rate limits or invalid key
            print("Unsplash API Error: \(response)")
            return nil
        }
        
        let searchResult = try JSONDecoder().decode(SearchResponse.self, from: data)
        
        guard let firstResult = searchResult.results.first, let imageURL = URL(string: firstResult.urls.regular) else {
            return nil
        }
        
        // 3. Cache the result for future calls
        cache.setObject(imageURL as NSURL, forKey: cacheKey)
        
        return imageURL
    }
}
