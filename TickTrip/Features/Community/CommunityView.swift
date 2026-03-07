import SwiftUI

struct CommunityView: View {
    @ObservedObject var viewModel: CommunityViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Hero
                    communityHero
                    
                    // Country/City filter
                    filterSection
                    
                    // Sort & filter
                    sortSection
                    
                    // Tips list
                    if viewModel.filteredPosts.isEmpty {
                        EmptyStateView(
                            icon: "bubble.left.and.bubble.right",
                            title: "no_tips_yet".localized,
                            message: "be_first_tip".localized,
                            foxMessage: "fox_needs_wisdom".localized,
                            buttonTitle: "write_a_tip".localized,
                            buttonAction: { viewModel.showCreateTip = true }
                        )
                        .frame(minHeight: 300)
                    } else {
                        LazyVStack(spacing: 14) {
                            ForEach(viewModel.filteredPosts) { post in
                                CommunityPostCard(post: post, viewModel: viewModel)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 30)
            }
            .overlay {
                if viewModel.isLoading && viewModel.posts.isEmpty {
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
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .foregroundStyle(TTColors.foxOrange)
                        Text("community_tab".localized)
                            .font(TTTypography.headlineLarge)
                            .foregroundStyle(TTColors.textPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showCreateTip = true }) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 18))
                            .foregroundStyle(TTColors.foxOrange)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showCreateTip) {
                CreateTipView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchPosts()
            }
            .refreshable {
                viewModel.fetchPosts()
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
    
    // MARK: - Hero
    private var communityHero: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hue: 0.75, saturation: 0.45, brightness: 0.65), Color(hue: 0.80, saturation: 0.55, brightness: 0.45)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 130)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("travel_tips".localized)
                        .font(TTTypography.displaySmall)
                        .foregroundStyle(.white)
                    Text("community_subtitle".localized)
                        .font(TTTypography.bodySmall)
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text("💬")
                    .font(.system(size: 48))
            }
            .padding(20)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Filter
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button(action: {
                    viewModel.selectedCountry = nil
                    viewModel.selectedCity = nil
                }) {
                    Text("filter_all".localized)
                        .font(TTTypography.labelMedium)
                        .foregroundStyle(viewModel.selectedCountry == nil ? .white : TTColors.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            viewModel.selectedCountry == nil ?
                            AnyShapeStyle(TTColors.primaryGradient) : AnyShapeStyle(TTColors.backgroundSecondary)
                        )
                        .clipShape(Capsule())
                }
                
                ForEach(Country.samples.prefix(6)) { country in
                    Button(action: {
                        viewModel.selectedCountry = country
                        viewModel.selectedCity = nil
                        HapticManager.shared.selection()
                    }) {
                        HStack(spacing: 4) {
                            Text(country.flagEmoji)
                            Text(country.name)
                                .font(TTTypography.labelMedium)
                        }
                        .foregroundStyle(viewModel.selectedCountry?.id == country.id ? .white : TTColors.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            viewModel.selectedCountry?.id == country.id ?
                            AnyShapeStyle(TTColors.primaryGradient) : AnyShapeStyle(TTColors.backgroundSecondary)
                        )
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Sort
    private var sortSection: some View {
        HStack {
            // Sort
            Menu {
                ForEach(CommunityViewModel.SortOption.allCases, id: \.self) { option in
                    Button(action: { viewModel.sortBy = option }) {
                        Label(option.rawValue, systemImage: viewModel.sortBy == option ? "checkmark" : "")
                    }
                }
            } label: {
                Label(viewModel.sortBy.rawValue, systemImage: "arrow.up.arrow.down")
                    .font(TTTypography.labelMedium)
                    .foregroundStyle(TTColors.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(TTColors.backgroundSecondary)
                    .clipShape(Capsule())
            }
            
            // Type filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(CommunityPost.PostType.allCases, id: \.self) { type in
                        Button(action: {
                            viewModel.filterType = viewModel.filterType == type ? nil : type
                        }) {
                            Label(type.rawValue, systemImage: type.icon)
                                .font(TTTypography.captionSmall)
                                .foregroundStyle(viewModel.filterType == type ? .white : TTColors.textTertiary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    viewModel.filterType == type ?
                                    AnyShapeStyle(TTColors.primaryGradient) : AnyShapeStyle(TTColors.backgroundSecondary)
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Post Card
struct CommunityPostCard: View {
    let post: CommunityPost
    @ObservedObject var viewModel: CommunityViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 10) {
                Circle()
                    .fill(TTColors.primaryGradient)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text(String(post.userName.prefix(1)))
                            .font(TTTypography.labelMedium)
                            .foregroundStyle(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.userName)
                        .font(TTTypography.titleSmall)
                        .foregroundStyle(TTColors.textPrimary)
                    Text(post.userTitle)
                        .font(TTTypography.captionSmall)
                        .foregroundStyle(TTColors.textTertiary)
                }
                
                Spacer()
                
                // Type badge
                Label(post.type.rawValue, systemImage: post.type.icon)
                    .font(TTTypography.captionSmall)
                    .foregroundStyle(TTColors.foxOrange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(TTColors.foxOrange.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            // Place tag
            if let placeName = post.placeName {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                    Text(placeName)
                        .font(TTTypography.captionLarge)
                }
                .foregroundStyle(TTColors.secondaryFallback)
            }
            
            // Content
            Text(post.content)
                .font(TTTypography.bodyMedium)
                .foregroundStyle(TTColors.textPrimary)
                .lineLimit(4)
            
            // Actions
            HStack(spacing: 20) {
                Button(action: { viewModel.toggleLike(post.id) }) {
                    Label("\(post.likesCount)", systemImage: post.isLiked ? "heart.fill" : "heart")
                        .font(TTTypography.captionLarge)
                        .foregroundStyle(post.isLiked ? TTColors.error : TTColors.textTertiary)
                }
                
                Button(action: { viewModel.toggleSave(post.id) }) {
                    Label("\(post.savesCount)", systemImage: post.isSaved ? "bookmark.fill" : "bookmark")
                        .font(TTTypography.captionLarge)
                        .foregroundStyle(post.isSaved ? TTColors.foxOrange : TTColors.textTertiary)
                }
                
                Spacer()
                
                Text(post.createdAt, style: .relative)
                    .font(TTTypography.captionSmall)
                    .foregroundStyle(TTColors.textTertiary)
            }
        }
        .ttCard()
    }
}

// MARK: - Create Tip
struct CreateTipView: View {
    @ObservedObject var viewModel: CommunityViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedCity: City?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FoxMascotView(message: "fox_share_wisdom".localized, size: 60)
                        .frame(maxWidth: .infinity)
                    
                    // Type picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("tip_type_label".localized)
                            .font(TTTypography.labelLarge)
                            .foregroundStyle(TTColors.textSecondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(CommunityPost.PostType.allCases, id: \.self) { type in
                                    Button(action: { viewModel.newTipType = type }) {
                                        Label(type.rawValue, systemImage: type.icon)
                                            .font(TTTypography.labelMedium)
                                            .foregroundStyle(viewModel.newTipType == type ? .white : TTColors.textSecondary)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(
                                                viewModel.newTipType == type ?
                                                AnyShapeStyle(TTColors.primaryGradient) : AnyShapeStyle(TTColors.backgroundSecondary)
                                            )
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }
                    
                    // City selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("city_label".localized)
                            .font(TTTypography.labelLarge)
                            .foregroundStyle(TTColors.textSecondary)
                        
                        Menu {
                            ForEach(City.samples.prefix(10)) { city in
                                Button(city.name) { selectedCity = city }
                            }
                        } label: {
                            HStack {
                                Text(selectedCity?.name ?? "select_city".localized)
                                    .foregroundStyle(selectedCity != nil ? TTColors.textPrimary : TTColors.textTertiary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(TTColors.textTertiary)
                            }
                            .font(TTTypography.bodyMedium)
                            .padding(14)
                            .background(TTColors.backgroundSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 8) {
                        Text("your_tip_label".localized)
                            .font(TTTypography.labelLarge)
                            .foregroundStyle(TTColors.textSecondary)
                        
                        TextEditor(text: $viewModel.newTipContent)
                            .font(TTTypography.bodyMedium)
                            .frame(minHeight: 120)
                            .padding(10)
                            .background(TTColors.backgroundSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .scrollContentBackground(.hidden)
                    }
                    
                    // Guidelines
                    VStack(alignment: .leading, spacing: 6) {
                        Label("community_guidelines".localized, systemImage: "info.circle")
                            .font(TTTypography.labelMedium)
                            .foregroundStyle(TTColors.textSecondary)
                        
                        Text("guidelines_text".localized)
                            .font(TTTypography.captionLarge)
                            .foregroundStyle(TTColors.textTertiary)
                    }
                    .padding(12)
                    .background(TTColors.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    GradientButton(title: "share_tip".localized, icon: "paperplane.fill") {
                        if let city = selectedCity {
                            viewModel.createTip(cityId: city.id, placeId: nil)
                        }
                        dismiss()
                    }
                    .disabled(viewModel.newTipContent.isEmpty || selectedCity == nil)
                    .opacity(viewModel.newTipContent.isEmpty || selectedCity == nil ? 0.5 : 1)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("new_tip".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel".localized) { dismiss() }
                        .foregroundStyle(TTColors.textSecondary)
                }
            }
        }
    }
}
