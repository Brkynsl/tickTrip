import SwiftUI

struct PaywallView: View {
    @ObservedObject var viewModel: SubscriptionManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedProduct: SubscriptionProduct?
    @State private var animateIn = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(hue: 0.08, saturation: 0.12, brightness: 0.98),
                    Color(hue: 0.07, saturation: 0.08, brightness: 0.95),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Close button
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(TTColors.textTertiary.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Hero
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(TTColors.goldGradient)
                                .frame(width: 90, height: 90)
                            
                            Image(systemName: "crown.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(.white)
                        }
                        .scaleEffect(animateIn ? 1.0 : 0.6)
                        
                        Text("explorer_pro".localized)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [TTColors.foxOrange, TTColors.premiumGold],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("unlock_full_world".localized)
                            .font(TTTypography.bodyLarge)
                            .foregroundStyle(TTColors.textSecondary)
                    }
                    .opacity(animateIn ? 1 : 0)
                    
                    // Features
                    VStack(spacing: 0) {
                        ForEach(Array(viewModel.premiumFeatures.enumerated()), id: \.offset) { index, feature in
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(TTColors.foxOrange.opacity(0.12))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: feature.icon)
                                        .font(.system(size: 18))
                                        .foregroundStyle(TTColors.foxOrange)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(feature.title)
                                        .font(TTTypography.titleSmall)
                                        .foregroundStyle(TTColors.textPrimary)
                                    
                                    Text(feature.description)
                                        .font(TTTypography.captionLarge)
                                        .foregroundStyle(TTColors.textSecondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            
                            if index < viewModel.premiumFeatures.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(18)
                    .background(TTColors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: TTColors.cardShadow, radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)
                    .opacity(animateIn ? 1 : 0)
                    
                    // Subscription options
                    VStack(spacing: 12) {
                        ForEach(viewModel.products) { product in
                            Button(action: {
                                selectedProduct = product
                                HapticManager.shared.selection()
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(spacing: 6) {
                                            Text(product.duration)
                                                .font(TTTypography.titleMedium)
                                                .foregroundStyle(TTColors.textPrimary)
                                            
                                            if product.isBestValue {
                                                Text("best_value".localized)
                                                    .font(TTTypography.badgeFont)
                                                    .foregroundStyle(.white)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(TTColors.success)
                                                    .clipShape(Capsule())
                                            }
                                        }
                                        
                                        if let savings = product.savings {
                                            Text(savings)
                                                .font(TTTypography.captionSmall)
                                                .foregroundStyle(TTColors.success)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text(product.priceDisplay)
                                        .font(TTTypography.headlineSmall)
                                        .foregroundStyle(TTColors.textPrimary)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(selectedProduct?.id == product.id ? TTColors.foxOrange.opacity(0.08) : TTColors.cardBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(
                                            selectedProduct?.id == product.id ? TTColors.foxOrange : TTColors.backgroundSecondary,
                                            lineWidth: selectedProduct?.id == product.id ? 2 : 1
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .opacity(animateIn ? 1 : 0)
                    
                    // Purchase button
                    GradientButton(
                        title: "start_exploring_pro".localized,
                        icon: "crown.fill",
                        gradient: TTColors.goldGradient
                    ) {
                        if let product = selectedProduct {
                            viewModel.purchase(product)
                        }
                    }
                    .disabled(selectedProduct == nil)
                    .opacity(selectedProduct == nil ? 0.5 : 1)
                    .padding(.horizontal, 20)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(TTColors.foxOrange)
                    }
                    
                    // Restore
                    Button(action: { viewModel.restorePurchases() }) {
                        Text("restore_purchases".localized)
                            .font(TTTypography.labelMedium)
                            .foregroundStyle(TTColors.textTertiary)
                    }
                    
                    // Legal
                    VStack(spacing: 4) {
                        Text("subscription_legal".localized)
                            .font(TTTypography.captionSmall)
                            .foregroundStyle(TTColors.textTertiary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 8) {
                            Button("terms_short".localized) {}
                                .font(TTTypography.captionSmall)
                                .foregroundStyle(TTColors.foxOrange)
                            Text("•")
                                .foregroundStyle(TTColors.textTertiary)
                            Button("privacy_short".localized) {}
                                .font(TTTypography.captionSmall)
                                .foregroundStyle(TTColors.foxOrange)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            selectedProduct = viewModel.products.first(where: { $0.isBestValue })
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                animateIn = true
            }
        }
    }
}
