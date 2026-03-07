import SwiftUI
import Combine
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // Email auth fields
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var displayName: String = ""
    
    // Validation
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        password.count >= 8
    }
    
    var passwordsMatch: Bool {
        password == confirmPassword
    }
    
    var canSignUp: Bool {
        isEmailValid && isPasswordValid && passwordsMatch && !displayName.isEmpty
    }
    
    var canLogin: Bool {
        isEmailValid && isPasswordValid
    }
    
    // MARK: - Auth Methods
    
    func signInWithApple() {
        performAuth(provider: .apple)
    }
    
    func signInWithGoogle() {
        performAuth(provider: .google)
    }
    
    func signInWithEmail() {
        guard canLogin else {
            showErrorMessage("Please check your email and password.")
            return
        }
        performAuth(provider: .email)
    }
    
    func signUpWithEmail() {
        guard canSignUp else {
            if !isEmailValid {
                showErrorMessage("Please enter a valid email address.")
            } else if !isPasswordValid {
                showErrorMessage("Password must be at least 8 characters.")
            } else if !passwordsMatch {
                showErrorMessage("Passwords do not match.")
            } else if displayName.isEmpty {
                showErrorMessage("Please enter your display name.")
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.isLoading = false
                self.showErrorMessage(error.localizedDescription)
                return
            }
            
            // Update display name
            let changeRequest = authResult?.user.createProfileChangeRequest()
            changeRequest?.displayName = self.displayName
            changeRequest?.commitChanges { error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.showErrorMessage(error.localizedDescription)
                    } else if let user = authResult?.user {
                        self.updateAuthState(user: user, isNewUser: true)
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            withAnimation(.easeInOut(duration: 0.3)) {
                isAuthenticated = false
                currentUser = nil
                clearFields()
            }
        } catch {
            showErrorMessage("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func forgotPassword() {
        guard isEmailValid else {
            showErrorMessage("Please enter a valid email address.")
            return
        }
        isLoading = true
        // Simulate network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            // In production: send password reset email
        }
    }
    
    // MARK: - Private
    
    private func performAuth(provider: User.AuthProvider) {
        isLoading = true
        errorMessage = nil
        
        if provider == .email {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.showErrorMessage(error.localizedDescription)
                    } else if let user = authResult?.user {
                        self.updateAuthState(user: user, isNewUser: false)
                    }
                }
            }
        } else {
            // Temporary mock for Apple/Google until fully implemented
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
                self.currentUser = User.sample
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    self.isAuthenticated = true
                }
                HapticManager.shared.notification(.success)
            }
        }
    }
    
    private func updateAuthState(user: FirebaseAuth.User, isNewUser: Bool) {
        // Map Firebase User to TickTrip User Model
        let tickTripUser = User(
            id: user.uid,
            displayName: user.displayName ?? (self.displayName.isEmpty ? "Traveler" : self.displayName),
            username: user.email?.components(separatedBy: "@").first ?? "user",
            email: user.email ?? self.email,
            authProvider: .email,
            profilePhotoURL: user.photoURL?.absoluteString,
            bio: nil,
            currentTitle: "novice_explorer".localized,
            titlesUnlocked: ["novice_explorer".localized],
            selectedTheme: "default",
            isPremium: false,
            subscriptionStatus: .free,
            visibilitySettings: User.VisibilitySettings(profilePublic: true, tripsPublic: true, progressPublic: true),
            notificationSettings: User.NotificationSettings(pushEnabled: true, reminderEnabled: true, socialEnabled: true, tipsEnabled: true),
            favoriteRegions: [],
            travelStyle: .explorer,
            totalPlacesCompleted: 0,
            totalCitiesVisited: 0,
            totalCountriesVisited: 0,
            totalTipsShared: 0,
            currentStreak: 0,
            travelLevel: 1,
            createdAt: user.metadata.creationDate ?? Date(),
            updatedAt: Date()
        )
        
        self.currentUser = tickTripUser
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            self.isAuthenticated = true
        }
        HapticManager.shared.notification(.success)
        
        // Setup initial user document in Firestore if new user
        if isNewUser {
            Task {
                await UserService.shared.saveUser(tickTripUser)
            }
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        HapticManager.shared.error()
    }
    
    private func clearFields() {
        email = ""
        password = ""
        confirmPassword = ""
        displayName = ""
    }
}
