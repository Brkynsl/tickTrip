import SwiftUI
import MapKit

/// Shared view that shows a city's places as a checklist with tick marks and directions
struct CityChecklistView: View {
    let city: City
    let countryId: String
    @ObservedObject var progressManager = ProgressManager.shared
    @Environment(\.dismiss) var dismiss
    
    var places: [Place] {
        Place.places(for: city.id)
    }
    
    var completedCount: Int {
        places.filter { progressManager.completedPlaces.contains($0.id) }.count
    }
    
    var progress: Double {
        places.isEmpty ? 0 : Double(completedCount) / Double(places.count)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // City hero
                cityHero
                
                // Fox message
                if let message = progressManager.foxMessage {
                    Text(message)
                        .font(TTTypography.bodyMedium)
                        .foregroundStyle(TTColors.foxOrange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(TTColors.foxOrange.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring, value: progressManager.foxMessage)
                }
                
                // Places list
                VStack(spacing: 8) {
                    ForEach(places) { place in
                        let isCompleted = progressManager.completedPlaces.contains(place.id)
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 14) {
                                // Check button
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        progressManager.togglePlace(place.id, cityId: city.id, countryId: countryId)
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(isCompleted ? TTColors.foxOrange : TTColors.backgroundSecondary)
                                            .frame(width: 36, height: 36)
                                        
                                        if isCompleted {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundStyle(.white)
                                        }
                                        
                                        Circle()
                                            .stroke(isCompleted ? TTColors.foxOrange : TTColors.textTertiary.opacity(0.3), lineWidth: 2)
                                            .frame(width: 36, height: 36)
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                Image(place.id)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 6) {
                                        Text(place.name)
                                            .font(TTTypography.titleSmall)
                                            .foregroundStyle(isCompleted ? TTColors.textSecondary : TTColors.textPrimary)
                                            .strikethrough(isCompleted, color: TTColors.textTertiary)
                                        
                                        if place.isPremiumOnly {
                                            Image(systemName: "crown.fill")
                                                .font(.system(size: 10))
                                                .foregroundStyle(TTColors.premiumGold)
                                        }
                                    }
                                    
                                    HStack(spacing: 8) {
                                        Label(place.category.rawValue, systemImage: place.category.icon)
                                            .font(TTTypography.captionSmall)
                                            .foregroundStyle(TTColors.textTertiary)
                                        
                                        Text("~\(place.estimatedVisitTime)")
                                            .font(TTTypography.captionSmall)
                                            .foregroundStyle(TTColors.textTertiary)
                                    }
                                    
                                    Text(place.description)
                                        .font(TTTypography.captionLarge)
                                        .foregroundStyle(TTColors.textSecondary)
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                                
                                // Directions button
                                Button(action: {
                                    openInMaps(place: place)
                                }) {
                                    VStack(spacing: 2) {
                                        Image(systemName: "map.fill")
                                            .font(.system(size: 16))
                                        Text("Yol Tarifi")
                                            .font(.system(size: 9, weight: .medium))
                                    }
                                    .foregroundStyle(TTColors.secondaryFallback)
                                    .frame(width: 52, height: 46)
                                    .background(TTColors.secondaryFallback.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(isCompleted ? TTColors.backgroundSecondary.opacity(0.5) : TTColors.cardBackground)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(isCompleted ? TTColors.foxOrange.opacity(0.2) : Color.clear, lineWidth: 1)
                            )
                            .shadow(color: TTColors.cardShadow, radius: isCompleted ? 2 : 6, x: 0, y: isCompleted ? 1 : 3)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer(minLength: 30)
            }
        }
        .background(TTColors.backgroundPrimary.ignoresSafeArea())
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var cityHero: some View {
        VStack(spacing: 12) {
            Image(city.heroImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 16)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(completedCount)/\(places.count) tamamlandı")
                        .font(TTTypography.titleMedium)
                        .foregroundStyle(TTColors.textPrimary)
                    
                    Text("\(places.count) keşfedilecek konum")
                        .font(TTTypography.captionLarge)
                        .foregroundStyle(TTColors.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                TTCircularProgress(progress: progress, size: 52, lineWidth: 5)
            }
            .padding(.horizontal, 16)
            
            TTProgressBar(progress: progress, height: 6, showLabel: false)
                .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Open in Maps
    private func openInMaps(place: Place) {
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ])
        HapticManager.shared.impact(.medium)
    }
}
