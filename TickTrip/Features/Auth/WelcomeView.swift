import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.colorScheme) var colorScheme
    @State private var showLogin = false
    @State private var showSignUp = false
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var animateContent = true
    @State private var foxBounce: CGFloat = 0
    @State private var backgroundOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Animated background
                backgroundLayer
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 40)
                        
                        // Logo & Fox
                        heroSection
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 30)
                        
                        Spacer(minLength: 32)
                        
                        // Auth buttons
                        authSection
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 40)
                        
                        // Legal
                        legalSection
                            .opacity(animateContent ? 1 : 0)
                            .padding(.bottom, 16)
                    }
                    .padding(.horizontal, 28)
                    .frame(minHeight: UIScreen.main.bounds.height - 60)
                }
            }
            .background(
                colorScheme == .dark
                    ? Color(hue: 0.08, saturation: 0.25, brightness: 0.12)
                    : Color(hue: 0.08, saturation: 0.15, brightness: 0.98)
            )
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
            .sheet(isPresented: $showTerms) {
                TermsOfServiceView()
            }
            .sheet(isPresented: $showPrivacy) {
                PrivacyPolicyView()
            }

        }
    }
    
    // MARK: - Background
    private var backgroundLayer: some View {
        ZStack {
            // Adaptive gradient for light/dark mode
            Group {
                if colorScheme == .dark {
                    LinearGradient(
                        colors: [
                            Color(hue: 0.08, saturation: 0.25, brightness: 0.12),
                            Color(hue: 0.05, saturation: 0.20, brightness: 0.10),
                            Color(hue: 0.55, saturation: 0.15, brightness: 0.08),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    LinearGradient(
                        colors: [
                            Color(hue: 0.08, saturation: 0.15, brightness: 0.98),
                            Color(hue: 0.05, saturation: 0.08, brightness: 0.96),
                            Color(hue: 0.55, saturation: 0.10, brightness: 0.95),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .ignoresSafeArea()
            
            // Floating destination icons
            GeometryReader { geo in
                ForEach(0..<6, id: \.self) { i in
                    let icons = ["✈️", "🗼", "🏛️", "⛩️", "🕌", "🗽"]
                    Text(icons[i])
                        .font(.system(size: CGFloat.random(in: 30...50)))
                        .opacity(0.12)
                        .offset(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height) + backgroundOffset * CGFloat(i % 3 + 1) * 0.3
                        )
                }
            }
            .ignoresSafeArea()
        }
    }
    
    // MARK: - Hero
    private var heroSection: some View {
        VStack(spacing: 20) {
            // Fox mascot — compact, centered layout
            ZStack {
                Circle()
                    .fill(TTColors.foxOrange.opacity(0.08))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(TTColors.foxOrange.opacity(0.04))
                    .frame(width: 150, height: 150)
                
                Text("🦊")
                    .font(.system(size: 64))
                    .offset(y: foxBounce)
            }
            .frame(height: 150)
            
            // App name
            VStack(spacing: 10) {
                Text("app_name".localized)
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [TTColors.foxOrange, TTColors.premiumGold],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("welcome_tagline".localized)
                    .font(TTTypography.bodyLarge)
                    .foregroundStyle(TTColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("welcome_subtitle".localized)
                    .font(TTTypography.captionLarge)
                    .foregroundStyle(TTColors.textTertiary)
                    .italic()
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    // MARK: - Auth Buttons
    private var authSection: some View {
        VStack(spacing: 12) {
            // Apple Sign In
            Button(action: { authManager.signInWithApple() }) {
                HStack(spacing: 10) {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 20))
                    Text("continue_with_apple".localized)
                        .font(TTTypography.titleMedium)
                }
                .foregroundStyle(colorScheme == .dark ? .black : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(colorScheme == .dark ? Color.white : Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            
            // Google Sign In
            Button(action: { authManager.signInWithGoogle() }) {
                HStack(spacing: 10) {
                    Image(systemName: "g.circle.fill")
                        .font(.system(size: 20))
                    Text("continue_with_google".localized)
                        .font(TTTypography.titleMedium)
                }
                .foregroundStyle(TTColors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 4, x: 0, y: 2)
            }
            
            // Email options
            HStack(spacing: 12) {
                Button(action: { showSignUp = true }) {
                    Text("sign_up".localized)
                        .font(TTTypography.titleMedium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(TTColors.primaryGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                
                Button(action: { showLogin = true }) {
                    Text("log_in".localized)
                        .font(TTTypography.titleMedium)
                        .foregroundStyle(TTColors.foxOrange)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(TTColors.foxOrange, lineWidth: 2)
                        )
                }
            }
            
            // 18+ Notice
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.shield.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(TTColors.textTertiary)
                Text("age_restriction".localized)
                    .font(TTTypography.captionSmall)
                    .foregroundStyle(TTColors.textTertiary)
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - Legal
    private var legalSection: some View {
        VStack(spacing: 6) {
            Text("legal_prefix".localized)
                .font(TTTypography.captionSmall)
                .foregroundStyle(TTColors.textTertiary)
            
            HStack(spacing: 4) {
                Button("terms_of_service".localized) {
                    showTerms = true
                }
                .font(TTTypography.captionSmall)
                .foregroundStyle(TTColors.foxOrange)
                
                Text("and".localized)
                    .font(TTTypography.captionSmall)
                    .foregroundStyle(TTColors.textTertiary)
                
                Button("privacy_policy".localized) {
                    showPrivacy = true
                }
                .font(TTTypography.captionSmall)
                .foregroundStyle(TTColors.foxOrange)
            }
        }
        .padding(.top, 12)
    }
}
