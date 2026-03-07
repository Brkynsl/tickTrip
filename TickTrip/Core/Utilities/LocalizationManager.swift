import SwiftUI
import Combine

/// Manages app language, supporting both system default and manual override.
/// When a user selects a language in Settings, it persists and overrides the device language.
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    /// Supported languages with display names
    enum Language: String, CaseIterable, Identifiable {
        case system = "system"
        case english = "en"
        case spanish = "es"
        case german = "de"
        case french = "fr"
        case turkish = "tr"
        
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .system: return NSLocalizedString("system_default", comment: "")
            case .english: return "English"
            case .spanish: return "Español"
            case .german: return "Deutsch"
            case .french: return "Français"
            case .turkish: return "Türkçe"
            }
        }
        
        var flag: String {
            switch self {
            case .system: return "🌐"
            case .english: return "🇬🇧"
            case .spanish: return "🇪🇸"
            case .german: return "🇩🇪"
            case .french: return "🇫🇷"
            case .turkish: return "🇹🇷"
            }
        }
    }
    
    private static let languageKey = "selectedLanguage"
    
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: Self.languageKey)
            updateBundle()
        }
    }
    
    /// The bundle to use for localized strings
    @Published var bundle: Bundle = .main
    
    private init() {
        let saved = UserDefaults.standard.string(forKey: Self.languageKey) ?? "system"
        self.currentLanguage = Language(rawValue: saved) ?? .system
        updateBundle()
    }
    
    private func updateBundle() {
        let languageCode: String
        
        if currentLanguage == .system {
            // Use device's preferred language, fallback to English
            let preferred = Bundle.main.preferredLocalizations.first ?? "en"
            languageCode = preferred
        } else {
            languageCode = currentLanguage.rawValue
        }
        
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
        } else if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
                  let bundle = Bundle(path: path) {
            // Fallback to English
            self.bundle = bundle
        } else {
            self.bundle = .main
        }
    }
    
    /// Get a localized string for a given key
    func localized(_ key: String) -> String {
        bundle.localizedString(forKey: key, value: nil, table: nil)
    }
    
    /// Get a localized string with format arguments
    func localized(_ key: String, _ args: CVarArg...) -> String {
        let format = bundle.localizedString(forKey: key, value: nil, table: nil)
        return String(format: format, arguments: args)
    }
    
    /// Set language and notify observers
    func setLanguage(_ language: Language) {
        currentLanguage = language
    }
}

// MARK: - String Extension for Convenience
extension String {
    /// Returns the localized version of this string key
    var localized: String {
        LocalizationManager.shared.localized(self)
    }
    
    /// Returns the localized version with format arguments
    func localized(_ args: CVarArg...) -> String {
        let format = LocalizationManager.shared.bundle.localizedString(forKey: self, value: nil, table: nil)
        return String(format: format, arguments: args)
    }
}

// MARK: - View Modifier for Localization Refresh
struct LocalizationRefresh: ViewModifier {
    @ObservedObject var manager = LocalizationManager.shared
    
    func body(content: Content) -> some View {
        content
            .id(manager.currentLanguage.rawValue) // Force view refresh on language change
            .environment(\.locale, Locale(identifier: manager.currentLanguage == .system ?
                                         (Bundle.main.preferredLocalizations.first ?? "en") :
                                         manager.currentLanguage.rawValue))
    }
}

extension View {
    func localizable() -> some View {
        modifier(LocalizationRefresh())
    }
}
