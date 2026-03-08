import SwiftUI

struct ExploreView: View {
    @ObservedObject var viewModel: ExploreViewModel
    @State private var showSearch = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Hero section
                    heroSection
                    
                    // Search bar
                    searchBar
                    
                    // Continent filter
                    continentFilter
                    
                    // Sort options
                    sortOptions
                    
                    // Country list
                    LazyVStack(spacing: 14) {
                        ForEach(viewModel.filteredCountries) { country in
                            NavigationLink(destination: CountryDetailView(country: country, viewModel: viewModel)) {
                                CountryCard(country: country)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Fox message
                    if viewModel.filteredCountries.isEmpty {
                        EmptyStateView(
                            icon: "magnifyingglass",
                            title: "no_countries_found".localized,
                            message: "try_different_search".localized,
                            foxMessage: "fox_no_countries".localized
                        )
                        .padding(.top, 40)
                    }
                }
                .padding(.bottom, 30)
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Text("🦊")
                            .font(.system(size: 22))
                        Text("explore_tab".localized)
                            .font(TTTypography.headlineLarge)
                            .foregroundStyle(TTColors.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Hero
    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            Image("world_map_hero")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.black.opacity(0.4))
            )
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("your_world_awaits".localized)
                        .font(TTTypography.displaySmall)
                        .foregroundStyle(.white)
                    
                    Text("countries_cities_format".localized(Country.samples.count, City.samples.count))
                        .font(TTTypography.bodySmall)
                        .foregroundStyle(.white.opacity(0.85))
                }
                
                Spacer()
                
                TTCircularProgress(
                    progress: 0.04,
                    size: 64,
                    lineWidth: 5,
                    gradient: LinearGradient(colors: [.white, .white.opacity(0.7)], startPoint: .top, endPoint: .bottom),
                    showLabel: true
                )
            }
            .padding(20)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Search
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(TTColors.textTertiary)
            
            TextField("search_countries".localized, text: $viewModel.searchText)
                .font(TTTypography.bodyMedium)
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(TTColors.textTertiary)
                }
            }
        }
        .padding(12)
        .background(TTColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: TTColors.cardShadow, radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Continent Filter
    private var continentFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip("filter_all".localized, isSelected: viewModel.selectedContinent == nil) {
                    viewModel.selectedContinent = nil
                }
                
                ForEach(viewModel.continents, id: \.self) { continent in
                    filterChip(continent, isSelected: viewModel.selectedContinent == continent) {
                        viewModel.selectedContinent = continent
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func filterChip(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            HapticManager.shared.selection()
        }) {
            Text(title)
                .font(TTTypography.labelMedium)
                .foregroundStyle(isSelected ? .white : TTColors.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AnyShapeStyle(TTColors.primaryGradient) : AnyShapeStyle(TTColors.backgroundSecondary))
                .clipShape(Capsule())
        }
    }
    
    // MARK: - Sort
    private var sortOptions: some View {
        HStack(spacing: 0) {
            ForEach(ExploreViewModel.SortOption.allCases, id: \.self) { option in
                Button(action: {
                    viewModel.sortOption = option
                    HapticManager.shared.selection()
                }) {
                    Text(option.rawValue)
                        .font(TTTypography.labelMedium)
                        .foregroundStyle(viewModel.sortOption == option ? TTColors.foxOrange : TTColors.textTertiary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
        }
        .background(TTColors.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 16)
    }
}

// MARK: - Country Detail
struct CountryDetailView: View {
    let country: Country
    @ObservedObject var viewModel: ExploreViewModel
    @State private var searchText = ""
    
    var cities: [City] {
        let allCities = viewModel.cities(for: country)
        if searchText.isEmpty { return allCities }
        return allCities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero header
                ZStack(alignment: .bottomLeading) {
                    Image(country.heroImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(LinearGradient(
                                colors: [.clear, .black.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(country.flagEmoji)
                            .font(.system(size: 60))
                        
                        Text(country.name)
                            .font(TTTypography.displayMedium)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: 12) {
                            Label("cities_format".localized(country.totalCities), systemImage: "building.2")
                            Label("complete_format".localized(Int(country.completionPercentage * 100)), systemImage: "chart.pie")
                        }
                        .font(TTTypography.captionLarge)
                        .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(20)
                }
                .padding(.horizontal, 16)
                
                // Progress bar
                VStack(alignment: .leading, spacing: 8) {
                    Text("country_progress".localized)
                        .font(TTTypography.headlineSmall)
                        .foregroundStyle(TTColors.textPrimary)
                    
                    TTProgressBar(progress: country.completionPercentage, height: 8, showLabel: true)
                }
                .padding(.horizontal, 16)
                
                // Search
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(TTColors.textTertiary)
                    TextField("search_cities".localized, text: $searchText)
                        .font(TTTypography.bodyMedium)
                }
                .padding(12)
                .background(TTColors.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal, 16)
                
                // City cards
                LazyVStack(spacing: 12) {
                    ForEach(cities) { city in
                        NavigationLink(destination: CityDetailView(city: city, viewModel: viewModel)) {
                            let places = viewModel.places(for: city)
                            let completed = viewModel.progressManager.completedCount(for: city.id, places: places)
                            let total = places.isEmpty ? city.totalPlaces : places.count
                            CityCard(city: city, completedCount: completed, totalCount: total)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 30)
        }
        .background(TTColors.backgroundPrimary.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var countryColors: [Color] {
        let hue = Double(abs(country.id.hashValue) % 360) / 360.0
        return [
            Color(hue: hue, saturation: 0.55, brightness: 0.75),
            Color(hue: hue + 0.06, saturation: 0.65, brightness: 0.55)
        ]
    }
}

// MARK: - City Detail
struct CityDetailView: View {
    let city: City
    @ObservedObject var viewModel: ExploreViewModel
    @State private var showCommunityTips = false
    @State private var showMap = false
    
    var places: [Place] {
        viewModel.places(for: city)
    }
    
    var completedCount: Int {
        viewModel.progressManager.completedCount(for: city.id, places: places)
    }
    
    var progress: Double {
        viewModel.progressManager.completionPercentage(for: city.id, places: places)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero
                ZStack(alignment: .bottomLeading) {
                    Image(city.heroImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(LinearGradient(
                                colors: [.clear, .black.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if let country = Country.samples.first(where: { $0.id == city.countryId }) {
                            Text("\(country.flagEmoji) \(country.name)")
                                .font(TTTypography.labelMedium)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        
                        Text(city.name)
                            .font(TTTypography.displayLarge)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: 16) {
                            Label("\(completedCount)/\(places.isEmpty ? city.totalPlaces : places.count)", systemImage: "checkmark.circle")
                            Label("\(Int(progress * 100))%", systemImage: "chart.pie")
                        }
                        .font(TTTypography.bodySmall)
                        .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(20)
                }
                .padding(.horizontal, 16)
                
                // Fox encouragement
                if let foxMessage = viewModel.progressManager.foxMessage {
                    FoxMascotView(message: foxMessage, size: 50, showSpeechBubble: true)
                        .padding(.horizontal, 16)
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Progress
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeader(title: "progress_label".localized)
                    TTProgressBar(progress: progress, height: 10, showLabel: true)
                }
                .padding(.horizontal, 16)
                
                // Action buttons
                HStack(spacing: 12) {
                    Button(action: {
                        viewModel.addCityToActiveTrip(city.id)
                    }) {
                        Label("add_to_trip".localized, systemImage: "suitcase")
                            .font(TTTypography.labelMedium)
                            .foregroundStyle(TTColors.foxOrange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(TTColors.foxOrange.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    
                    Button(action: { showMap = true }) {
                        Label("map".localized, systemImage: "map")
                            .font(TTTypography.labelMedium)
                            .foregroundStyle(TTColors.secondaryFallback)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(TTColors.secondaryFallback.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    
                    Button(action: { showCommunityTips = true }) {
                        Label("tips".localized, systemImage: "bubble.left.fill")
                            .font(TTTypography.labelMedium)
                            .foregroundStyle(TTColors.info)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(TTColors.info.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                // Places checklist
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "must_see_places".localized, action: "places_total_format".localized(places.count))
                    
                    if places.isEmpty {
                        EmptyStateView(
                            icon: "mappin",
                            title: "coming_soon".localized,
                            message: "places_curated_format".localized(city.name),
                            foxMessage: "fox_preparing_format".localized(city.name)
                        )
                        .frame(height: 250)
                    } else {
                        ForEach(places) { place in
                            PlaceCard(
                                place: place,
                                isCompleted: viewModel.progressManager.isCompleted(place.id),
                                onToggle: {
                                    viewModel.progressManager.togglePlace(place.id, cityId: city.id, countryId: city.countryId)
                                    viewModel.updateCountryProgress(city.countryId)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .overlay(alignment: .top) {
                if viewModel.showAddFeedback {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("city_added_to_trip".localized)
                    }
                    .font(TTTypography.labelMedium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(TTColors.success)
                    .clipShape(Capsule())
                    .padding(.top, 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .padding(.bottom, 30)
        }
        .background(TTColors.backgroundPrimary.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showMap) {
            CityMapView(city: city)
        }
    }
    
    private var cityColors: [Color] {
        let hue = Double(abs(city.id.hashValue) % 360) / 360.0
        return [
            Color(hue: hue, saturation: 0.5, brightness: 0.75),
            Color(hue: hue + 0.08, saturation: 0.6, brightness: 0.5)
        ]
    }
}

import MapKit

struct CityMapView: View {
    let city: City
    @Environment(\.dismiss) var dismiss
    @State private var position: MapCameraPosition
    
    init(city: City) {
        self.city = city
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.8719, longitude: 12.5674), 
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        self._position = State(initialValue: .region(region))
    }
    
    var body: some View {
        NavigationStack {
            Map(position: $position) {
                Marker(city.name, coordinate: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922))
                    .tint(TTColors.foxOrange)
            }
            .navigationTitle(city.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) { dismiss() }
                        .foregroundStyle(TTColors.foxOrange)
                }
            }
        }
    }
}
