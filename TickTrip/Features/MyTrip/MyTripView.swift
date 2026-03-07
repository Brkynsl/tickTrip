import SwiftUI

struct MyTripView: View {
    @ObservedObject var viewModel: MyTripViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                TTColors.backgroundPrimary.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.tripManager.isLoading && viewModel.trips.isEmpty {
                            ProgressView()
                                .padding(.top, 40)
                        } else if let activeTrip = viewModel.activeTrip {
                        // Active trip section
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "active_trip".localized)
                            
                            NavigationLink(destination: TripDetailView(trip: activeTrip, viewModel: viewModel)) {
                                ActiveTripHeroCard(trip: activeTrip)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 16)
                        
                        // Quick resume cities
                        if !activeTrip.cityIds.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "trip_cities".localized)
                                
                                ForEach(activeTrip.cityIds, id: \.self) { cityId in
                                    if let city = City.samples.first(where: { $0.id == cityId }) {
                                        let cityProgress = activeTrip.cityProgress.first(where: { $0.cityId == cityId })
                                        let countryId = city.countryId
                                        
                                        NavigationLink(destination: CityChecklistView(city: city, countryId: countryId)) {
                                            TripCityRow(
                                                city: city,
                                                isActive: cityId == activeTrip.currentCityId,
                                                completedCount: cityProgress?.completedPlaceIds.count ?? 0,
                                                totalCount: city.totalPlaces
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    } else {
                        // Empty state
                        EmptyStateView(
                            icon: "suitcase",
                            title: "no_active_trip".localized,
                            message: "no_trip_message".localized,
                            foxMessage: "fox_plan_trip".localized,
                            buttonTitle: "create_trip".localized,
                            buttonAction: { viewModel.showCreateTrip = true }
                        )
                        .frame(minHeight: 400)
                    }
                    
                    // All trips
                    if viewModel.trips.count > 1 || (viewModel.trips.count == 1 && viewModel.activeTrip == nil) {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "all_trips".localized, action: "see_all".localized)
                            
                            ForEach(viewModel.trips) { trip in
                                if trip.id != viewModel.activeTrip?.id {
                                    NavigationLink(destination: TripDetailView(trip: trip, viewModel: viewModel)) {
                                        TripCard(trip: trip)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                }
                .refreshable {
                    viewModel.tripManager.fetchTrips()
                    viewModel.syncProgressWithTrips()
                }
                .onAppear {
                    viewModel.syncProgressWithTrips()
                }
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Image(systemName: "suitcase.fill")
                            .foregroundStyle(TTColors.foxOrange)
                        Text("my_trip_tab".localized)
                            .font(TTTypography.headlineLarge)
                            .foregroundStyle(TTColors.textPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showCreateTrip = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(TTColors.foxOrange)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showCreateTrip) {
                CreateTripView(viewModel: viewModel)
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.tripManager.errorMessage != nil },
                set: { if !$0 { viewModel.tripManager.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                if let error = viewModel.tripManager.errorMessage {
                    Text(error)
                }
            }
        }
    }
}

// MARK: - Active Trip Hero
struct ActiveTripHeroCard: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "airplane")
                            .font(.system(size: 12))
                            .foregroundStyle(TTColors.success)
                        Text("active_label".localized)
                            .font(TTTypography.badgeFont)
                            .foregroundStyle(TTColors.success)
                    }
                    
                    Text(trip.name)
                        .font(TTTypography.displaySmall)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                TTCircularProgress(
                    progress: trip.overallProgress,
                    size: 60,
                    lineWidth: 5,
                    gradient: LinearGradient(colors: [.white, .white.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                )
            }
            
            // Flags
            HStack(spacing: 8) {
                ForEach(trip.countryIds, id: \.self) { countryId in
                    if let country = Country.samples.first(where: { $0.id == countryId }) {
                        Text(country.flagEmoji)
                            .font(.system(size: 28))
                    }
                }
                
                Spacer()
                
                if let date = trip.startDate {
                    Text(date, style: .date)
                        .font(TTTypography.captionLarge)
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            TTProgressBar(
                progress: trip.overallProgress,
                height: 6,
                gradient: LinearGradient(colors: [.white, .white.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
            )
        }
        .padding(20)
        .background(TTColors.primaryGradient)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: TTColors.foxOrange.opacity(0.3), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Trip City Row
struct TripCityRow: View {
    let city: City
    let isActive: Bool
    let completedCount: Int
    let totalCount: Int
    
    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
    
    var body: some View {
        HStack(spacing: 14) {
            if isActive {
                Circle()
                    .fill(TTColors.success)
                    .frame(width: 10, height: 10)
            } else {
                Circle()
                    .stroke(TTColors.textTertiary.opacity(0.3), lineWidth: 2)
                    .frame(width: 10, height: 10)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(city.name)
                        .font(TTTypography.titleMedium)
                        .foregroundStyle(TTColors.textPrimary)
                    
                    if isActive {
                        Text("current_label".localized)
                            .font(TTTypography.badgeFont)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(TTColors.success)
                            .clipShape(Capsule())
                    }
                }
                
                Text("places_count_format".localized(totalCount))
                    .font(TTTypography.captionLarge)
                    .foregroundStyle(TTColors.textSecondary)
            }
            
            Spacer()
            
            TTCircularProgress(progress: progress, size: 38, lineWidth: 4)
        }
        .ttCard(padding: 14)
    }
}

// MARK: - Trip Detail
struct TripDetailView: View {
    let trip: Trip
    @ObservedObject var viewModel: MyTripViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showCityPicker = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Trip info
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(trip.name)
                            .font(TTTypography.displaySmall)
                            .foregroundStyle(TTColors.textPrimary)
                        
                        Spacer()
                        
                        Label(trip.visibility.rawValue, systemImage: trip.visibility.icon)
                            .font(TTTypography.captionSmall)
                            .foregroundStyle(TTColors.textTertiary)
                    }
                    
                    // Flags
                    HStack(spacing: 6) {
                        ForEach(trip.countryIds, id: \.self) { countryId in
                            if let country = Country.samples.first(where: { $0.id == countryId }) {
                                Text(country.flagEmoji)
                                    .font(.system(size: 32))
                            }
                        }
                    }
                    
                    TTProgressBar(progress: trip.overallProgress, height: 10, showLabel: true)
                }
                .padding(.horizontal, 16)
                
                // City progress cards
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "cities_label".localized)
                    
                    ForEach(trip.cityIds, id: \.self) { cityId in
                        if let city = City.samples.first(where: { $0.id == cityId }) {
                            let cp = trip.cityProgress.first(where: { $0.cityId == cityId })
                            TripCityRow(
                                city: city,
                                isActive: cityId == trip.currentCityId,
                                completedCount: cp?.completedPlaceIds.count ?? 0,
                                totalCount: city.totalPlaces
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                // Actions
                VStack(spacing: 12) {
                    if trip.status != .active {
                        GradientButton(title: "set_active_trip".localized, icon: "airplane") {
                            viewModel.tripManager.setActiveTrip(trip)
                        }
                    }
                    
                    Button(action: { showCityPicker = true }) {
                        Label("add_city".localized, systemImage: "plus")
                            .font(TTTypography.titleMedium)
                            .foregroundStyle(TTColors.foxOrange)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(TTColors.foxOrange, lineWidth: 2)
                            )
                    }
                    
                    Button(role: .destructive, action: { showDeleteAlert = true }) {
                        Label("delete_trip".localized, systemImage: "trash")
                            .font(TTTypography.titleMedium)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 30)
        }
        .background(TTColors.backgroundPrimary.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCityPicker) {
            CityPickerSheet(trip: trip, tripManager: viewModel.tripManager)
        }
        .alert("delete_trip_confirm_title".localized, isPresented: $showDeleteAlert) {
            Button("delete".localized, role: .destructive) {
                viewModel.tripManager.deleteTrip(trip.id)
                dismiss()
            }
            Button("cancel".localized, role: .cancel) {}
        } message: {
            Text("delete_trip_confirm_message".localized)
        }
    }
}

// MARK: - City Picker Sheet
struct CityPickerSheet: View {
    let trip: Trip
    @ObservedObject var tripManager: TripManager
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var filteredCities: [City] {
        let allCities = City.samples.filter { !trip.cityIds.contains($0.id) }
        if searchText.isEmpty { return allCities }
        return allCities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredCities) { city in
                Button(action: {
                    tripManager.addCityToTrip(trip.id, cityId: city.id)
                    HapticManager.shared.notification(.success)
                    dismiss()
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(city.name)
                                .font(TTTypography.titleSmall)
                                .foregroundStyle(TTColors.textPrimary)
                            
                            if let country = Country.samples.first(where: { $0.id == city.countryId }) {
                                Text("\(country.flagEmoji) \(country.name)")
                                    .font(TTTypography.captionLarge)
                                    .foregroundStyle(TTColors.textSecondary)
                            }
                        }
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(TTColors.foxOrange)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "search_cities".localized)
            .navigationTitle("add_city".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) { dismiss() }
                }
            }
        }
    }
}

// MARK: - Create Trip
struct CreateTripView: View {
    @ObservedObject var viewModel: MyTripViewModel
    @Environment(\.dismiss) var dismiss
    @State private var tripName = ""
    @State private var selectedCountries: Set<String> = []
    @State private var selectedCities: Set<String> = []
    @State private var visibility: Trip.TripVisibility = .privateTrip
    @State private var currentStep = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Step indicator
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(i <= currentStep ? TTColors.foxOrange : TTColors.backgroundSecondary)
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                ScrollView {
                    VStack(spacing: 24) {
                        if currentStep == 0 {
                            tripNameStep
                        } else if currentStep == 1 {
                            countryStep
                        } else {
                            cityStep
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
                
                // Bottom button
                VStack(spacing: 12) {
                    if currentStep < 2 {
                        GradientButton(title: "next".localized, icon: "arrow.right") {
                            withAnimation { currentStep += 1 }
                        }
                        .disabled(currentStep == 0 && tripName.isEmpty)
                        .opacity(currentStep == 0 && tripName.isEmpty ? 0.5 : 1)
                    } else {
                        GradientButton(title: "create_trip".localized, icon: "suitcase.fill") {
                            viewModel.tripManager.createTrip(
                                name: tripName,
                                countryIds: Array(selectedCountries),
                                cityIds: Array(selectedCities),
                                startDate: nil,
                                endDate: nil,
                                visibility: visibility
                            )
                            dismiss()
                        }
                        .disabled(selectedCities.isEmpty)
                        .opacity(selectedCities.isEmpty ? 0.5 : 1)
                    }
                    
                    if currentStep > 0 {
                        Button("back".localized) { withAnimation { currentStep -= 1 } }
                            .font(TTTypography.labelLarge)
                            .foregroundStyle(TTColors.textTertiary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("new_trip".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel".localized) { dismiss() }
                        .foregroundStyle(TTColors.textSecondary)
                }
            }
        }
    }
    
    private var tripNameStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            FoxMascotView(message: "fox_plan_exciting".localized, size: 60)
                .frame(maxWidth: .infinity)
            
            Text("name_your_trip".localized)
                .font(TTTypography.headlineLarge)
                .foregroundStyle(TTColors.textPrimary)
            
            TextField("trip_name_placeholder".localized, text: $tripName)
                .font(TTTypography.bodyLarge)
                .padding(16)
                .background(TTColors.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            
            // Visibility picker
            VStack(alignment: .leading, spacing: 8) {
                Text("trip_visibility".localized)
                    .font(TTTypography.labelLarge)
                    .foregroundStyle(TTColors.textSecondary)
                
                HStack(spacing: 8) {
                    ForEach(Trip.TripVisibility.allCases, id: \.self) { vis in
                        Button(action: { visibility = vis }) {
                            Label(vis.rawValue, systemImage: vis.icon)
                                .font(TTTypography.captionLarge)
                                .foregroundStyle(visibility == vis ? .white : TTColors.textSecondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    visibility == vis ?
                                    AnyShapeStyle(TTColors.primaryGradient) :
                                    AnyShapeStyle(TTColors.backgroundSecondary)
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }
    
    private var countryStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("select_countries".localized)
                .font(TTTypography.headlineLarge)
                .foregroundStyle(TTColors.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(Country.samples) { country in
                    Button(action: {
                        if selectedCountries.contains(country.id) {
                            selectedCountries.remove(country.id)
                            selectedCities = selectedCities.filter { cityId in
                                City.samples.first(where: { $0.id == cityId })?.countryId != country.id
                            }
                        } else {
                            selectedCountries.insert(country.id)
                        }
                        HapticManager.shared.selection()
                    }) {
                        HStack(spacing: 8) {
                            Text(country.flagEmoji)
                                .font(.system(size: 24))
                            Text(country.name)
                                .font(TTTypography.labelMedium)
                                .lineLimit(1)
                        }
                        .foregroundStyle(selectedCountries.contains(country.id) ? .white : TTColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            selectedCountries.contains(country.id) ?
                            AnyShapeStyle(TTColors.primaryGradient) :
                            AnyShapeStyle(TTColors.cardBackground)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: TTColors.cardShadow, radius: 4, x: 0, y: 2)
                    }
                }
            }
        }
    }
    
    private var cityStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("select_cities".localized)
                .font(TTTypography.headlineLarge)
                .foregroundStyle(TTColors.textPrimary)
            
            ForEach(Array(selectedCountries), id: \.self) { countryId in
                if let country = Country.samples.first(where: { $0.id == countryId }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(country.flagEmoji) \(country.name)")
                            .font(TTTypography.titleMedium)
                            .foregroundStyle(TTColors.textPrimary)
                        
                        ForEach(City.samples.filter({ $0.countryId == countryId })) { city in
                            Button(action: {
                                if selectedCities.contains(city.id) {
                                    selectedCities.remove(city.id)
                                } else {
                                    selectedCities.insert(city.id)
                                }
                                HapticManager.shared.selection()
                            }) {
                                HStack {
                                    Image(systemName: selectedCities.contains(city.id) ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(selectedCities.contains(city.id) ? TTColors.foxOrange : TTColors.textTertiary)
                                    
                                    Text(city.name)
                                        .font(TTTypography.bodyMedium)
                                        .foregroundStyle(TTColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("places_count_format".localized(city.totalPlaces))
                                        .font(TTTypography.captionSmall)
                                        .foregroundStyle(TTColors.textTertiary)
                                }
                                .padding(12)
                                .background(
                                    selectedCities.contains(city.id) ?
                                    TTColors.foxOrange.opacity(0.08) :
                                    TTColors.backgroundSecondary
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                        }
                    }
                }
            }
        }
    }
}
