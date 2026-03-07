import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if !authManager.isAuthenticated {
                WelcomeView()
            } else if !appState.hasCompletedOnboarding {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.4), value: authManager.isAuthenticated)
        .animation(.easeInOut(duration: 0.4), value: appState.hasCompletedOnboarding)
    }
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var exploreVM = ExploreViewModel()
    @StateObject private var tripVM = MyTripViewModel()
    @StateObject private var socialVM = SocialViewModel()
    @StateObject private var communityVM = CommunityViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            ExploreView(viewModel: exploreVM)
                .tabItem {
                    Label(AppTab.explore.title, systemImage: AppTab.explore.icon)
                }
                .tag(AppTab.explore)
            
            MyTripView(viewModel: tripVM)
                .tabItem {
                    Label(AppTab.myTrip.title, systemImage: AppTab.myTrip.icon)
                }
                .tag(AppTab.myTrip)
            
            WorldView(viewModel: socialVM)
                .tabItem {
                    Label(AppTab.world.title, systemImage: AppTab.world.icon)
                }
                .tag(AppTab.world)
            
            CommunityView(viewModel: communityVM)
                .tabItem {
                    Label(AppTab.community.title, systemImage: AppTab.community.icon)
                }
                .tag(AppTab.community)
            
            ProfileView(viewModel: profileVM)
                .tabItem {
                    Label(AppTab.profile.title, systemImage: AppTab.profile.icon)
                }
                .tag(AppTab.profile)
        }
        .tint(TTColors.primary)
    }
}
