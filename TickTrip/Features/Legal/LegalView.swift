import SwiftUI

// MARK: - Terms of Service
struct TermsOfServiceView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("TickTrip — Terms of Service")
                            .font(TTTypography.displaySmall)
                            .foregroundStyle(TTColors.textPrimary)
                        
                        Text("Last updated: March 7, 2025")
                            .font(TTTypography.captionLarge)
                            .foregroundStyle(TTColors.textTertiary)
                        
                        Text("Effective date: March 7, 2025")
                            .font(TTTypography.captionLarge)
                            .foregroundStyle(TTColors.textTertiary)
                    }
                    
                    Divider()
                    
                    // Age Restriction
                    legalSection(
                        number: "1",
                        title: "Age Requirement",
                        content: """
                        TickTrip is intended for users who are at least 18 years of age. By creating an account or using this application, you confirm that you are 18 years of age or older. If you are under 18, you may not use this application.
                        
                        We do not knowingly collect personal information from individuals under 18. If we become aware that a user is under 18, we will promptly delete their account and all associated data.
                        """
                    )
                    
                    legalSection(
                        number: "2",
                        title: "Acceptance of Terms",
                        content: """
                        By downloading, installing, or using TickTrip ("the App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, do not use the App.
                        
                        We reserve the right to update or modify these Terms at any time. Continued use of the App after changes constitutes acceptance of the revised Terms.
                        """
                    )
                    
                    legalSection(
                        number: "3",
                        title: "Description of Service",
                        content: """
                        TickTrip is a gamified travel checklist application that allows users to:
                        • Explore countries and cities
                        • Track visited places through checklists
                        • Earn achievements, titles, and badges
                        • Share travel tips with the community
                        • Plan and manage trips
                        
                        The App is provided "as is" and may be updated, modified, or discontinued at any time.
                        """
                    )
                    
                    legalSection(
                        number: "4",
                        title: "User Accounts",
                        content: """
                        To access certain features, you must create an account. You agree to:
                        • Provide accurate and complete information
                        • Maintain the security of your account credentials
                        • Notify us immediately of any unauthorized use
                        • Accept responsibility for all activity under your account
                        
                        We reserve the right to suspend or terminate accounts that violate these Terms.
                        """
                    )
                    
                    legalSection(
                        number: "5",
                        title: "User Content & Community Guidelines",
                        content: """
                        You may submit travel tips, reviews, and other content ("User Content"). By submitting User Content, you grant TickTrip a non-exclusive, worldwide, royalty-free license to use, display, and distribute such content within the App.
                        
                        You agree NOT to post content that:
                        • Is offensive, abusive, hateful, or discriminatory
                        • Contains spam, advertising, or promotional material
                        • Infringes on intellectual property rights of others
                        • Contains malicious links or harmful software
                        • Is false, misleading, or deceptive
                        • Violates any applicable law or regulation
                        
                        We reserve the right to remove any User Content and suspend accounts that violate these guidelines without prior notice.
                        """
                    )
                    
                    legalSection(
                        number: "6",
                        title: "Subscriptions & In-App Purchases",
                        content: """
                        TickTrip may offer premium features through subscriptions ("Explorer Pro") and in-app purchases.
                        
                        • Payment is charged to your Apple ID account upon purchase confirmation
                        • Subscriptions automatically renew unless canceled at least 24 hours before the end of the current billing period
                        • You can manage and cancel subscriptions in your Apple ID Account Settings
                        • No refunds are provided for the unused portion of any subscription period
                        • Prices are subject to change; any price changes will be communicated in advance
                        
                        Free trial periods, if offered, will convert to paid subscriptions unless canceled before the trial period ends.
                        """
                    )
                    
                    legalSection(
                        number: "7",
                        title: "Intellectual Property",
                        content: """
                        All content, design, graphics, trademarks, and software in the App are the property of TickTrip and are protected by international copyright and trademark laws.
                        
                        You may not copy, modify, distribute, sell, or create derivative works based on any part of the App without our prior written consent.
                        """
                    )
                    
                    legalSection(
                        number: "8",
                        title: "Disclaimer of Warranties",
                        content: """
                        The App is provided on an "AS IS" and "AS AVAILABLE" basis. We make no warranties, express or implied, regarding:
                        
                        • The accuracy or completeness of travel information
                        • The availability, reliability, or security of the App
                        • The suitability of the App for any particular purpose
                        
                        Travel information provided in the App is for reference purposes only. Always verify travel details with official sources before making travel plans.
                        """
                    )
                    
                    legalSection(
                        number: "9",
                        title: "Limitation of Liability",
                        content: """
                        To the maximum extent permitted by law, TickTrip shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the App, including but not limited to loss of data, loss of profits, or personal injury.
                        
                        Our total liability shall not exceed the amount you paid for the App or any subscription in the 12 months preceding the claim.
                        """
                    )
                    
                    legalSection(
                        number: "10",
                        title: "Termination",
                        content: """
                        We may suspend or terminate your access to the App at any time, with or without cause, and with or without notice. Upon termination:
                        
                        • Your right to use the App ceases immediately
                        • We may delete your account and data
                        • Provisions that by nature should survive termination will remain in effect
                        """
                    )
                    
                    legalSection(
                        number: "11",
                        title: "Governing Law",
                        content: """
                        These Terms shall be governed by and construed in accordance with the laws of the Republic of Turkey, without regard to its conflict of law provisions.
                        
                        Any disputes arising from these Terms shall be resolved in the courts of Istanbul, Turkey.
                        """
                    )
                    
                    legalSection(
                        number: "12",
                        title: "Contact",
                        content: """
                        If you have any questions about these Terms, please contact us at:
                        
                        Email: support@ticktrip.app
                        """
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("terms_of_service".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) { dismiss() }
                        .foregroundStyle(TTColors.foxOrange)
                }
            }
        }
    }
    
    private func legalSection(number: String, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(number). \(title)")
                .font(TTTypography.headlineSmall)
                .foregroundStyle(TTColors.textPrimary)
            
            Text(content)
                .font(TTTypography.bodyMedium)
                .foregroundStyle(TTColors.textSecondary)
                .lineSpacing(4)
        }
    }
}

// MARK: - Privacy Policy
struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("TickTrip — Privacy Policy")
                            .font(TTTypography.displaySmall)
                            .foregroundStyle(TTColors.textPrimary)
                        
                        Text("Last updated: March 7, 2025")
                            .font(TTTypography.captionLarge)
                            .foregroundStyle(TTColors.textTertiary)
                        
                        Text("Effective date: March 7, 2025")
                            .font(TTTypography.captionLarge)
                            .foregroundStyle(TTColors.textTertiary)
                    }
                    
                    // Age notice
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(TTColors.warning)
                        
                        Text("This application is intended for users aged 18 and older. We do not knowingly collect data from individuals under 18.")
                            .font(TTTypography.bodySmall)
                            .foregroundStyle(TTColors.textSecondary)
                    }
                    .padding(14)
                    .background(TTColors.warning.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    Divider()
                    
                    privacySection(
                        number: "1",
                        title: "Introduction",
                        content: """
                        TickTrip ("we", "our", or "us") respects your privacy and is committed to protecting your personal data. This Privacy Policy explains how we collect, use, store, and share your information when you use the TickTrip mobile application ("the App").
                        
                        By using the App, you consent to the practices described in this Privacy Policy.
                        """
                    )
                    
                    privacySection(
                        number: "2",
                        title: "Information We Collect",
                        content: """
                        We collect the following types of information:
                        
                        Account Information:
                        • Email address
                        • Display name / username
                        • Profile picture (if provided)
                        • Authentication credentials (encrypted)
                        
                        Usage Data:
                        • Places visited / checked off
                        • Trip data and travel progress
                        • Achievements and titles earned
                        • Community tips and interactions
                        
                        Device Information:
                        • Device type and operating system version
                        • App version
                        • Language and region settings
                        • Anonymous usage analytics
                        
                        We do NOT collect:
                        • Precise GPS location data
                        • Contact lists
                        • Financial information (payments are processed by Apple)
                        • Health or biometric data
                        """
                    )
                    
                    privacySection(
                        number: "3",
                        title: "How We Use Your Information",
                        content: """
                        We use collected information to:
                        
                        • Provide and maintain the App's functionality
                        • Track your travel progress and achievements
                        • Display community tips and social features
                        • Personalize your experience and recommendations
                        • Send important service notifications
                        • Improve the App through anonymous analytics
                        • Prevent fraud and ensure security
                        • Comply with legal obligations
                        
                        We will NEVER sell your personal information to third parties.
                        """
                    )
                    
                    privacySection(
                        number: "4",
                        title: "Data Storage & Security",
                        content: """
                        Your data is stored securely using industry-standard encryption and security practices:
                        
                        • Data is transmitted using TLS/SSL encryption
                        • Passwords are hashed and never stored in plain text
                        • Access to user data is restricted to authorized personnel
                        • Regular security audits are performed
                        
                        While we strive to protect your data, no method of transmission or storage is 100% secure. We cannot guarantee absolute security.
                        """
                    )
                    
                    privacySection(
                        number: "5",
                        title: "Third-Party Services",
                        content: """
                        The App may use the following third-party services:
                        
                        • Apple Sign In — for authentication
                        • Google Sign In — for authentication
                        • Apple App Store — for subscription and payment processing
                        • Firebase / Analytics — for anonymous usage analytics
                        
                        Each third-party service has its own privacy policy. We encourage you to review their policies.
                        """
                    )
                    
                    privacySection(
                        number: "6",
                        title: "Data Sharing",
                        content: """
                        We may share your information only in the following circumstances:
                        
                        • Community Content: Tips and reviews you post are visible to other users
                        • Leaderboards: Your username, title, and progress may appear on public leaderboards (configurable in settings)
                        • Legal Requirements: When required by law, court order, or government regulation
                        • Safety: To protect the rights, safety, or property of TickTrip or its users
                        
                        We do NOT share personal data with advertisers or data brokers.
                        """
                    )
                    
                    privacySection(
                        number: "7",
                        title: "Your Rights",
                        content: """
                        You have the right to:
                        
                        • Access: Request a copy of your personal data
                        • Correction: Update or correct inaccurate information
                        • Deletion: Request deletion of your account and all associated data
                        • Portability: Export your data in a standard format
                        • Withdrawal: Withdraw consent for data processing at any time
                        • Objection: Object to certain types of data processing
                        
                        To exercise any of these rights, contact us at support@ticktrip.app or use the "Delete Account" option in Settings.
                        
                        Account deletion requests will be processed within 30 days.
                        """
                    )
                    
                    privacySection(
                        number: "8",
                        title: "Data Retention",
                        content: """
                        We retain your data for as long as your account is active or as needed to provide services. Upon account deletion:
                        
                        • Personal data is deleted within 30 days
                        • Anonymous, aggregated analytics data may be retained
                        • Backup copies are purged within 90 days
                        • Legal retention obligations may require longer storage
                        """
                    )
                    
                    privacySection(
                        number: "9",
                        title: "Children's Privacy",
                        content: """
                        TickTrip is rated 18+ and is not intended for use by individuals under the age of 18. We do not knowingly collect personal information from anyone under 18 years of age.
                        
                        If you are a parent or guardian and believe your child has provided us with personal information, please contact us immediately at support@ticktrip.app. We will take steps to remove such information from our systems.
                        """
                    )
                    
                    privacySection(
                        number: "10",
                        title: "International Data Transfers",
                        content: """
                        Your information may be transferred to and processed in countries other than your country of residence. These countries may have different data protection laws.
                        
                        We ensure appropriate safeguards are in place for international data transfers in compliance with applicable regulations, including GDPR and KVKK (Turkish Data Protection Law).
                        """
                    )
                    
                    privacySection(
                        number: "11",
                        title: "Changes to This Policy",
                        content: """
                        We may update this Privacy Policy from time to time. We will notify you of significant changes through:
                        
                        • In-app notifications
                        • Email communication
                        • Updated "Last modified" date
                        
                        Continued use of the App after changes constitutes acceptance of the updated policy.
                        """
                    )
                    
                    privacySection(
                        number: "12",
                        title: "Contact Us",
                        content: """
                        If you have questions, concerns, or requests regarding this Privacy Policy or your personal data, please contact us:
                        
                        Email: support@ticktrip.app
                        
                        For GDPR/KVKK-related inquiries:
                        Data Protection Officer: dpo@ticktrip.app
                        """
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(TTColors.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("privacy_policy".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) { dismiss() }
                        .foregroundStyle(TTColors.foxOrange)
                }
            }
        }
    }
    
    private func privacySection(number: String, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(number). \(title)")
                .font(TTTypography.headlineSmall)
                .foregroundStyle(TTColors.textPrimary)
            
            Text(content)
                .font(TTTypography.bodyMedium)
                .foregroundStyle(TTColors.textSecondary)
                .lineSpacing(4)
        }
    }
}
