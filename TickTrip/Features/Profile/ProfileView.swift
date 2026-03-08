import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var authManager: AuthManager
    @State private var showPlacesDetail = false
    @State private var showCitiesDetail = false
    @State private var showCountriesDetail = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile header
                    profileHeader
                    
                    // Progress section
                    progressSection
                    
                    // Stats grid
                    statsGrid
                    
                    // Achievements
                    achievementsSection
                    
                    // Titles
                    titlesSection
                    
                    // Premium card
                    if !viewModel.user.isPremium {
                        premiumCard
                    }
                    
                    // Settings
                    settingsSection
                }
                .padding(.bottom, 30)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(TTColors.foxOrange)
                }
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundStyle(TTColors.foxOrange)
                        Text("profile_tab".localized)
                            .font(TTTypography.headlineLarge)
                            .foregroundStyle(TTColors.textPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(TTColors.textSecondary)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showPaywall) {
                PaywallView(viewModel: viewModel.subscriptionManager)
            }
            .sheet(isPresented: $viewModel.showSettings) {
                SettingsView(authManager: authManager, profileViewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showEditProfile) {
                EditProfileView(viewModel: viewModel)
            }
            .sheet(isPresented: $showPlacesDetail) {
                PlacesDetailView(viewModel: viewModel)
            }
            .sheet(isPresented: $showCitiesDetail) {
                CitiesDetailView(viewModel: viewModel)
            }
            .sheet(isPresented: $showCountriesDetail) {
                CountriesDetailView(viewModel: viewModel)
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 14) {
            // Avatar
            ZStack {
                Circle()
                    .fill(TTColors.primaryGradient)
                    .frame(width: 90, height: 90)
                
                Text(String(viewModel.user.displayName.prefix(1)))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                // Level badge
                ZStack {
                    Circle()
                        .fill(TTColors.foxOrange)
                        .frame(width: 28, height: 28)
                    
                    Text("\(viewModel.user.travelLevel)")
                        .font(TTTypography.badgeFont)
                        .foregroundStyle(.white)
                }
                .offset(x: 32, y: 32)
            }
            
            VStack(spacing: 4) {
                Text(viewModel.user.displayName)
                    .font(TTTypography.headlineLarge)
                    .foregroundStyle(TTColors.textPrimary)
                
                Text("@\(viewModel.user.username)")
                    .font(TTTypography.captionLarge)
                    .foregroundStyle(TTColors.textTertiary)
            }
            
            // Current title
            HStack(spacing: 6) {
                Text("🦊")
                    .font(.system(size: 16))
                Text(viewModel.user.currentTitle)
                    .font(TTTypography.titleSmall)
                    .foregroundStyle(TTColors.foxOrange)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(TTColors.foxOrange.opacity(0.1))
            .clipShape(Capsule())
            
            // Streak
            if viewModel.user.currentStreak > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(TTColors.foxOrange)
                    Text("day_streak_format".localized(viewModel.user.currentStreak))
                        .font(TTTypography.labelMedium)
                        .foregroundStyle(TTColors.textSecondary)
                }
            }
        }
        .padding(.top, 10)
    }
    
    // MARK: - Progress
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "world_progress".localized)
                .padding(.horizontal, 16)
            
            VStack(spacing: 14) {
                progressRow(label: "World", progress: viewModel.worldProgress, icon: "globe", gradient: TTColors.primaryGradient)
                progressRow(label: "Europe", progress: viewModel.europeProgress, icon: "globe.europe.africa", gradient: TTColors.tealGradient)
                progressRow(label: "Asia", progress: viewModel.asiaProgress, icon: "globe.asia.australia", gradient: TTColors.goldGradient)
            }
            .ttCard()
            .padding(.horizontal, 16)
        }
    }
    
    private func progressRow(label: String, progress: Double, icon: String, gradient: LinearGradient) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label(label, systemImage: icon)
                    .font(TTTypography.titleSmall)
                    .foregroundStyle(TTColors.textPrimary)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(TTTypography.progressFont)
                    .foregroundStyle(TTColors.foxOrange)
            }
            
            TTProgressBar(progress: progress, height: 8, gradient: gradient)
        }
    }
    
    // MARK: - Stats
    private var statsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "travel_stats".localized)
                .padding(.horizontal, 16)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                Button { showPlacesDetail = true } label: {
                    statCard(value: "\(viewModel.totalPlaces)", label: "places_label".localized, icon: "checkmark.circle.fill", color: TTColors.foxOrange)
                }
                .buttonStyle(.plain)
                
                Button { showCitiesDetail = true } label: {
                    statCard(value: "\(viewModel.totalCities)", label: "cities_label".localized, icon: "building.2.fill", color: TTColors.secondaryFallback)
                }
                .buttonStyle(.plain)
                
                Button { showCountriesDetail = true } label: {
                    statCard(value: "\(viewModel.totalCountries)", label: "countries_label".localized, icon: "globe.americas.fill", color: TTColors.success)
                }
                .buttonStyle(.plain)
                
                statCard(value: "\(viewModel.user.totalTipsShared)", label: "tips_label".localized, icon: "bubble.left.fill", color: TTColors.info)
                statCard(value: "\(TripManager.shared.trips.count)", label: "trips_label".localized, icon: "suitcase.fill", color: TTColors.warning)
                statCard(value: "\(viewModel.unlockedAchievements.count)", label: "badges_label".localized, icon: "star.fill", color: TTColors.premiumGold)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(color)
            
            Text(value)
                .font(TTTypography.headlineMedium)
                .foregroundStyle(TTColors.textPrimary)
            
            Text(label)
                .font(TTTypography.captionSmall)
                .foregroundStyle(TTColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(TTColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: TTColors.cardShadow, radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Achievements
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "achievements_title".localized, action: "see_all".localized) {
                viewModel.showAchievements = true
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.achievements.prefix(8)) { achievement in
                        AchievementBadge(achievement: achievement, size: 65)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - Titles
    private var titlesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "titles_label".localized)
                .padding(.horizontal, 16)
            
            VStack(spacing: 8) {
                ForEach(viewModel.titles.prefix(5)) { title in
                    let isUnlocked = viewModel.user.titlesUnlocked.contains(where: { $0 == title.titleName })
                    
                    HStack(spacing: 12) {
                        Image(systemName: isUnlocked ? "crown.fill" : "lock.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(isUnlocked ? TTColors.premiumGold : TTColors.textTertiary)
                            .frame(width: 32)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(title.titleName)
                                .font(TTTypography.titleSmall)
                                .foregroundStyle(isUnlocked ? TTColors.textPrimary : TTColors.textTertiary)
                            
                            Text(title.regionScope.rawValue.capitalized)
                                .font(TTTypography.captionSmall)
                                .foregroundStyle(TTColors.textTertiary)
                        }
                        
                        Spacer()
                        
                        if isUnlocked {
                            Text("✓")
                                .foregroundStyle(TTColors.success)
                        }
                        
                        if viewModel.user.currentTitle == title.titleName {
                            Text("active_label".localized)
                                .font(TTTypography.badgeFont)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(TTColors.foxOrange)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(12)
                    .background(isUnlocked ? TTColors.cardBackground : TTColors.backgroundSecondary.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Premium
    private var premiumCard: some View {
        Button(action: { viewModel.showPaywall = true }) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(TTColors.premiumGold)
                        Text("explorer_pro".localized)
                            .font(TTTypography.headlineSmall)
                            .foregroundStyle(.white)
                    }
                    
                    Text("premium_unlock_message".localized)
                        .font(TTTypography.captionLarge)
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(18)
            .background(TTColors.goldGradient)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: TTColors.premiumGold.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Settings
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "settings_title".localized)
                .padding(.horizontal, 16)
            
            VStack(spacing: 2) {
                settingsRow(icon: "bell.fill", title: "notifications".localized, color: TTColors.error)
                settingsRow(icon: "eye.fill", title: "privacy".localized, color: TTColors.info)
                settingsRow(icon: "paintbrush.fill", title: "appearance".localized, color: TTColors.foxOrange)
                settingsRow(icon: "questionmark.circle.fill", title: "help_support".localized, color: TTColors.success)
                settingsRow(icon: "doc.text.fill", title: "terms_of_service".localized, color: TTColors.textSecondary)
                settingsRow(icon: "lock.shield.fill", title: "privacy_policy".localized, color: TTColors.textSecondary)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 16)
            
            Button(action: { authManager.signOut() }) {
                Text("sign_out".localized)
                    .font(TTTypography.titleMedium)
                    .foregroundStyle(TTColors.error)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(TTColors.error.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func settingsRow(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)
                .frame(width: 32)
            
            Text(title)
                .font(TTTypography.bodyMedium)
                .foregroundStyle(TTColors.textPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(TTColors.textTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(TTColors.cardBackground)
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @ObservedObject var authManager: AuthManager
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var localizationManager = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var showTerms = false
    @State private var showPrivacy = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("account_section".localized) {
                    Button(action: {
                        dismiss()
                        profileViewModel.showEditProfile = true
                    }) {
                        Label("edit_profile".localized, systemImage: "person.fill")
                            .foregroundStyle(TTColors.textPrimary)
                    }
                    
                    NavigationLink {
                        ChangePasswordView()
                    } label: {
                        Label("change_password".localized, systemImage: "lock.fill")
                            .foregroundStyle(TTColors.textPrimary)
                    }
                    
                    NavigationLink {
                        LinkedAccountsView()
                    } label: {
                        Label("linked_accounts".localized, systemImage: "link")
                            .foregroundStyle(TTColors.textPrimary)
                    }
                }
                
                Section("preferences_section".localized) {
                    NavigationLink {
                        NotificationsSettingsView()
                    } label: {
                        Label("notifications".localized, systemImage: "bell.fill")
                            .foregroundStyle(TTColors.textPrimary)
                    }
                    
                    NavigationLink {
                        PrivacySettingsView()
                    } label: {
                        Label("privacy_settings".localized, systemImage: "eye.fill")
                            .foregroundStyle(TTColors.textPrimary)
                    }
                    
                    NavigationLink {
                        AppearanceSettingsView()
                    } label: {
                        Label("appearance_settings".localized, systemImage: "paintbrush.fill")
                            .foregroundStyle(TTColors.textPrimary)
                    }
                    
                    Label("travel_preferences".localized, systemImage: "heart.fill")
                }
                
                // Language Selection
                Section("language_settings".localized) {
                    ForEach(LocalizationManager.Language.allCases) { language in
                        Button(action: {
                            localizationManager.setLanguage(language)
                            HapticManager.shared.selection()
                        }) {
                            HStack(spacing: 12) {
                                Text(language.flag)
                                    .font(.system(size: 22))
                                
                                Text(language.displayName)
                                    .font(TTTypography.bodyMedium)
                                    .foregroundStyle(TTColors.textPrimary)
                                
                                Spacer()
                                
                                if localizationManager.currentLanguage == language {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(TTColors.foxOrange)
                                }
                            }
                        }
                    }
                }
                
                Section("about_section".localized) {
                    Button(action: { showTerms = true }) {
                        Label("terms_of_service".localized, systemImage: "doc.text")
                            .foregroundStyle(TTColors.textPrimary)
                    }
                    Button(action: { showPrivacy = true }) {
                        Label("privacy_policy".localized, systemImage: "lock.shield")
                            .foregroundStyle(TTColors.textPrimary)
                    }
                    Label("version_format".localized("1.0.0"), systemImage: "info.circle")
                }
                
                Section {
                    Button(action: {
                        dismiss()
                        authManager.signOut()
                    }) {
                        Label("sign_out".localized, systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(TTColors.error)
                    }
                }
            }
            .navigationTitle("settings_title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) { dismiss() }
                        .foregroundStyle(TTColors.foxOrange)
                }
            }
            .sheet(isPresented: $showTerms) {
                TermsOfServiceView()
            }
            .sheet(isPresented: $showPrivacy) {
                PrivacyPolicyView()
            }
        }
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var displayName = ""
    @State private var username = ""
    @State private var bio = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            Circle()
                                .fill(TTColors.primaryGradient)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text(String(displayName.prefix(1)))
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundStyle(.white)
                                )
                            
                            Button("change_photo".localized) {}
                                .font(TTTypography.labelMedium)
                                .foregroundStyle(TTColors.foxOrange)
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section("display_name_label".localized) {
                    TextField("display_name_placeholder".localized, text: $displayName)
                }
                
                Section("username_label".localized) {
                    TextField("username_placeholder".localized, text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section("bio_label".localized) {
                    TextEditor(text: $bio)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("edit_profile".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel".localized) { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save_changes".localized) {
                        viewModel.updateProfile(displayName: displayName, username: username, bio: bio)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(displayName.isEmpty || username.isEmpty)
                }
            }
            .onAppear {
                displayName = viewModel.user.displayName
                username = viewModel.user.username
                bio = viewModel.user.bio ?? ""
            }
        }
    }
}

// MARK: - Settings Detail Views
struct NotificationsSettingsView: View {
    @AppStorage("pushEnabled") private var pushEnabled = true
    @AppStorage("tripReminders") private var tripReminders = true
    @AppStorage("communityLikes") private var communityLikes = true
    
    var body: some View {
        List {
            Section("notification_channels".localized) {
                Toggle("push_notifications".localized, isOn: $pushEnabled)
            }
            
            Section("notification_types".localized) {
                Toggle("trip_reminders".localized, isOn: $tripReminders)
                Toggle("community_likes".localized, isOn: $communityLikes)
            }
        }
        .navigationTitle("notifications".localized)
    }
}

struct PrivacySettingsView: View {
    @AppStorage("profilePublic") private var profilePublic = true
    @AppStorage("showTrips") private var showTrips = true
    
    var body: some View {
        List {
            Section("profile_visibility".localized) {
                Toggle("public_profile".localized, isOn: $profilePublic)
                Toggle("show_my_trips".localized, isOn: $showTrips)
            }
            
            Section("blocked_users".localized) {
                NavigationLink("manage_blocked".localized) {
                    Text("No blocked users").foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("privacy".localized)
    }
}

struct AppearanceSettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        List {
            Section("theme_label".localized) {
                Toggle("dark_mode".localized, isOn: $isDarkMode)
            }
        }
        .navigationTitle("appearance".localized)
    }
}

struct LinkedAccountsView: View {
    var body: some View {
        List {
            HStack {
                Circle().fill(.gray.opacity(0.2)).frame(width: 24, height: 24)
                    .overlay(Text("G").font(.caption).bold())
                Text("Google")
                Spacer()
                Text("connected_label".localized).foregroundStyle(.secondary)
            }
            
            HStack {
                Image(systemName: "apple.logo")
                Text("Apple")
                Spacer()
                Button("connect_label".localized) {}
                    .foregroundStyle(TTColors.foxOrange)
            }
        }
        .navigationTitle("linked_accounts".localized)
    }
}

struct ChangePasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SecureField("current_password_placeholder".localized, text: $currentPassword)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                SecureField("new_password_placeholder".localized, text: $newPassword)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                SecureField("confirm_password_placeholder".localized, text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                GradientButton(title: "update_password".localized, icon: "lock.fill") {
                    // Update password logic
                }
                .padding()
            }
            .padding(.top)
        }
        .navigationTitle("change_password".localized)
    }
}

// MARK: - Places Detail View (grouped by city)
struct PlacesDetailView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.completedPlacesByCity.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Summary card
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(TTColors.foxOrange.opacity(0.15))
                                        .frame(width: 56, height: 56)
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(TTColors.foxOrange)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(viewModel.totalPlaces)")
                                        .font(TTTypography.displaySmall)
                                        .foregroundStyle(TTColors.textPrimary)
                                    Text("places_visited".localized)
                                        .font(TTTypography.bodyMedium)
                                        .foregroundStyle(TTColors.textSecondary)
                                }
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(TTColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: TTColors.cardShadow, radius: 6, x: 0, y: 3)
                            .padding(.horizontal, 16)
                            
                            // Places grouped by city
                            ForEach(Array(viewModel.completedPlacesByCity.enumerated()), id: \.offset) { _, group in
                                VStack(alignment: .leading, spacing: 10) {
                                    // City header
                                    HStack(spacing: 8) {
                                        Text(group.countryFlag)
                                            .font(.system(size: 20))
                                        Text(group.cityName)
                                            .font(TTTypography.headlineSmall)
                                            .foregroundStyle(TTColors.textPrimary)
                                        
                                        Spacer()
                                        
                                        Text("\(group.places.count)")
                                            .font(TTTypography.badgeFont)
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(TTColors.foxOrange)
                                            .clipShape(Capsule())
                                    }
                                    .padding(.horizontal, 16)
                                    
                                    // Places in this city
                                    VStack(spacing: 6) {
                                        ForEach(group.places) { place in
                                            HStack(spacing: 12) {
                                                Image(systemName: place.category.icon)
                                                    .font(.system(size: 16))
                                                    .foregroundStyle(TTColors.foxOrange)
                                                    .frame(width: 28)
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(place.name)
                                                        .font(TTTypography.titleSmall)
                                                        .foregroundStyle(TTColors.textPrimary)
                                                    
                                                    Text(place.category.rawValue)
                                                        .font(TTTypography.captionSmall)
                                                        .foregroundStyle(TTColors.textTertiary)
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundStyle(TTColors.success)
                                                    .font(.system(size: 18))
                                            }
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                        }
                                    }
                                    .background(TTColors.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .shadow(color: TTColors.cardShadow, radius: 4, x: 0, y: 2)
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 30)
                    }
                }
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("places_label".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) { dismiss() }
                        .foregroundStyle(TTColors.foxOrange)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "map")
                .font(.system(size: 48))
                .foregroundStyle(TTColors.textTertiary)
            Text("no_places_yet".localized)
                .font(TTTypography.headlineSmall)
                .foregroundStyle(TTColors.textSecondary)
            Text("start_exploring_places".localized)
                .font(TTTypography.bodyMedium)
                .foregroundStyle(TTColors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

// MARK: - Cities Detail View
struct CitiesDetailView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.visitedCitiesDetail.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Summary card
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(TTColors.secondaryFallback.opacity(0.15))
                                        .frame(width: 56, height: 56)
                                    Image(systemName: "building.2.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(TTColors.secondaryFallback)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(viewModel.totalCities)")
                                        .font(TTTypography.displaySmall)
                                        .foregroundStyle(TTColors.textPrimary)
                                    Text("cities_explored".localized)
                                        .font(TTTypography.bodyMedium)
                                        .foregroundStyle(TTColors.textSecondary)
                                }
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(TTColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: TTColors.cardShadow, radius: 6, x: 0, y: 3)
                            .padding(.horizontal, 16)
                            
                            // City cards
                            VStack(spacing: 10) {
                                ForEach(Array(viewModel.visitedCitiesDetail.enumerated()), id: \.offset) { _, item in
                                    HStack(spacing: 14) {
                                        // City icon
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(cityGradient(for: item.city))
                                                .frame(width: 48, height: 48)
                                            Text(item.country.flagEmoji)
                                                .font(.system(size: 24))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack {
                                                Text(item.city.name)
                                                    .font(TTTypography.titleSmall)
                                                    .foregroundStyle(TTColors.textPrimary)
                                                
                                                Spacer()
                                                
                                                Text("\(item.completed)/\(item.total)")
                                                    .font(TTTypography.labelMedium)
                                                    .foregroundStyle(TTColors.foxOrange)
                                            }
                                            
                                            TTProgressBar(
                                                progress: item.total > 0 ? Double(item.completed) / Double(item.total) : 0,
                                                height: 6
                                            )
                                        }
                                    }
                                    .padding(14)
                                    .background(TTColors.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .shadow(color: TTColors.cardShadow, radius: 4, x: 0, y: 2)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 30)
                    }
                }
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("cities_label".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) { dismiss() }
                        .foregroundStyle(TTColors.foxOrange)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "building.2")
                .font(.system(size: 48))
                .foregroundStyle(TTColors.textTertiary)
            Text("no_cities_yet".localized)
                .font(TTTypography.headlineSmall)
                .foregroundStyle(TTColors.textSecondary)
            Text("start_exploring_cities".localized)
                .font(TTTypography.bodyMedium)
                .foregroundStyle(TTColors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
    
    private func cityGradient(for city: City) -> LinearGradient {
        let hue = Double(abs(city.id.hashValue) % 360) / 360.0
        return LinearGradient(
            colors: [
                Color(hue: hue, saturation: 0.35, brightness: 0.9),
                Color(hue: hue + 0.05, saturation: 0.45, brightness: 0.75)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Countries Detail View
struct CountriesDetailView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.visitedCountriesDetail.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Summary card
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(TTColors.success.opacity(0.15))
                                        .frame(width: 56, height: 56)
                                    Image(systemName: "globe.americas.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(TTColors.success)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(viewModel.totalCountries)")
                                        .font(TTTypography.displaySmall)
                                        .foregroundStyle(TTColors.textPrimary)
                                    Text("countries_explored".localized)
                                        .font(TTTypography.bodyMedium)
                                        .foregroundStyle(TTColors.textSecondary)
                                }
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(TTColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: TTColors.cardShadow, radius: 6, x: 0, y: 3)
                            .padding(.horizontal, 16)
                            
                            // Country cards
                            VStack(spacing: 10) {
                                ForEach(Array(viewModel.visitedCountriesDetail.enumerated()), id: \.offset) { _, item in
                                    HStack(spacing: 14) {
                                        Text(item.country.flagEmoji)
                                            .font(.system(size: 36))
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack {
                                                Text(item.country.name)
                                                    .font(TTTypography.titleSmall)
                                                    .foregroundStyle(TTColors.textPrimary)
                                                
                                                Spacer()
                                                
                                                Text("\(item.completed)/\(item.total)")
                                                    .font(TTTypography.labelMedium)
                                                    .foregroundStyle(TTColors.foxOrange)
                                            }
                                            
                                            TTProgressBar(
                                                progress: item.total > 0 ? Double(item.completed) / Double(item.total) : 0,
                                                height: 6,
                                                gradient: TTColors.tealGradient
                                            )
                                            
                                            Text(item.country.continent)
                                                .font(TTTypography.captionSmall)
                                                .foregroundStyle(TTColors.textTertiary)
                                        }
                                    }
                                    .padding(14)
                                    .background(TTColors.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .shadow(color: TTColors.cardShadow, radius: 4, x: 0, y: 2)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 30)
                    }
                }
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("countries_label".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) { dismiss() }
                        .foregroundStyle(TTColors.foxOrange)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe")
                .font(.system(size: 48))
                .foregroundStyle(TTColors.textTertiary)
            Text("no_countries_yet".localized)
                .font(TTTypography.headlineSmall)
                .foregroundStyle(TTColors.textSecondary)
            Text("start_exploring_countries".localized)
                .font(TTTypography.bodyMedium)
                .foregroundStyle(TTColors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}
