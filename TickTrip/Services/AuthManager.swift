import SwiftUI
import Combine
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class AuthManager: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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
    
    // Apple Sign In state
    private var currentNonce: String?
    
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
        startSignInWithAppleFlow()
    }
    
    func signInWithGoogle() {
        // Google Sign-In SDK requires manual setup. Returning an error for now to safely launch.
        showErrorMessage("Google Sign In SDK is pending configuration. Please use Apple or Email for now.")
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
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.showErrorMessage(error.localizedDescription)
                } else {
                    HapticManager.shared.notification(.success)
                    // We rely on the caller/UI to show "Email Sent" alert
                }
            }
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
                    if let error = error {
                        self.isLoading = false
                        self.showErrorMessage(error.localizedDescription)
                    } else if let user = authResult?.user {
                        self.updateAuthState(user: user, isNewUser: false)
                    }
                }
            }
        }
    }
    
    private func updateAuthState(user: FirebaseAuth.User, isNewUser: Bool) {
        if isNewUser {
            // Create a new TickTrip User Model
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
            
            Task {
                await UserService.shared.saveUser(tickTripUser)
                await MainActor.run {
                    self.currentUser = tickTripUser
                    self.isLoading = false
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        self.isAuthenticated = true
                    }
                    HapticManager.shared.notification(.success)
                }
            }
        } else {
            // Fetch existing user from Firestore
            Task {
                if let existingUser = await UserService.shared.fetchUser(userId: user.uid) {
                    await MainActor.run {
                        self.currentUser = existingUser
                        self.isLoading = false
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            self.isAuthenticated = true
                        }
                        HapticManager.shared.notification(.success)
                    }
                } else {
                    // Fallback if no Firestore doc exists but Firebase Auth does
                    await MainActor.run {
                        self.isLoading = false
                        self.signOut()
                        self.showErrorMessage("User profile not found. Please sign up again.")
                    }
                }
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
    
    // MARK: - Apple Sign In Flow
    
    private func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                showErrorMessage("Invalid state: A login nonce was not found.")
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                showErrorMessage("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                showErrorMessage("Unable to serialize token string")
                return
            }
            
            isLoading = true
            let credential = OAuthProvider.credential(withProviderID: "apple.com", IDToken: idTokenString, rawNonce: nonce)
            
            // Save name if provided (only available on first login)
            if let fullName = appleIDCredential.fullName, let givenName = fullName.givenName {
                let family = fullName.familyName ?? ""
                self.displayName = "\(givenName) \(family)".trimmingCharacters(in: .whitespaces)
            }
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let error = error {
                        self.isLoading = false
                        self.showErrorMessage(error.localizedDescription)
                        return
                    }
                    if let user = authResult?.user {
                        let isNew = authResult?.additionalUserInfo?.isNewUser ?? false
                        self.updateAuthState(user: user, isNewUser: isNew)
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // user cancelled or other error
        print("Sign in with Apple errored: \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return ASPresentationAnchor()
        }
        return window
    }
    
    // MARK: - Crypto Helpers
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}
