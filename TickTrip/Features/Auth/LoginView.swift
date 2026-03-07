import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    
    enum Field { case email, password }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("🦊")
                        .font(.system(size: 50))
                    
                    Text("welcome_back".localized)
                        .font(TTTypography.displaySmall)
                        .foregroundStyle(TTColors.textPrimary)
                    
                    Text("sign_in_continue".localized)
                        .font(TTTypography.bodyMedium)
                        .foregroundStyle(TTColors.textSecondary)
                }
                .padding(.top, 20)
                
                // Email field
                VStack(alignment: .leading, spacing: 8) {
                    Text("email_label".localized)
                        .font(TTTypography.labelLarge)
                        .foregroundStyle(TTColors.textSecondary)
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundStyle(TTColors.textTertiary)
                        TextField("email_placeholder".localized, text: $authManager.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .focused($focusedField, equals: .email)
                    }
                    .padding(14)
                    .background(TTColors.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(focusedField == .email ? TTColors.foxOrange : Color.clear, lineWidth: 2)
                    )
                    
                    if !authManager.email.isEmpty && !authManager.isEmailValid {
                        Label("email_invalid".localized, systemImage: "exclamationmark.circle")
                            .font(TTTypography.captionSmall)
                            .foregroundStyle(TTColors.error)
                    }
                }
                
                // Password field
                VStack(alignment: .leading, spacing: 8) {
                    Text("password_label".localized)
                        .font(TTTypography.labelLarge)
                        .foregroundStyle(TTColors.textSecondary)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(TTColors.textTertiary)
                        SecureField("password_placeholder".localized, text: $authManager.password)
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                    }
                    .padding(14)
                    .background(TTColors.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(focusedField == .password ? TTColors.foxOrange : Color.clear, lineWidth: 2)
                    )
                }
                
                // Forgot password
                HStack {
                    Spacer()
                    Button("forgot_password".localized) {
                        authManager.forgotPassword()
                    }
                    .font(TTTypography.labelMedium)
                    .foregroundStyle(TTColors.foxOrange)
                }
                
                // Login button
                GradientButton(title: "log_in".localized, icon: "arrow.right") {
                    focusedField = nil
                    authManager.signInWithEmail()
                }
                .opacity(authManager.canLogin ? 1.0 : 0.6)
                .disabled(!authManager.canLogin)
                
                // Loading
                if authManager.isLoading {
                    ProgressView()
                        .tint(TTColors.foxOrange)
                }
                
                // Divider
                HStack {
                    Rectangle().fill(TTColors.textTertiary.opacity(0.3)).frame(height: 1)
                    Text("or_divider".localized).font(TTTypography.captionLarge).foregroundStyle(TTColors.textTertiary)
                    Rectangle().fill(TTColors.textTertiary.opacity(0.3)).frame(height: 1)
                }
                
                // Social auth
                Button(action: { authManager.signInWithApple() }) {
                    HStack(spacing: 10) {
                        Image(systemName: "apple.logo")
                        Text("continue_with_apple".localized)
                    }
                    .font(TTTypography.titleSmall)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                
                Button(action: { authManager.signInWithGoogle() }) {
                    HStack(spacing: 10) {
                        Image(systemName: "g.circle.fill")
                        Text("continue_with_google".localized)
                    }
                    .font(TTTypography.titleSmall)
                    .foregroundStyle(TTColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(TTColors.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(TTColors.backgroundPrimary.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(TTColors.textPrimary)
                }
            }
        }
        .alert("error_title".localized, isPresented: $authManager.showError) {
            Button("ok".localized) {}
        } message: {
            Text(authManager.errorMessage ?? "something_went_wrong".localized)
        }
    }
}

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @State private var agreedToTerms = false
    @FocusState private var focusedField: Field?
    
    enum Field { case name, email, password, confirm }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("🦊")
                        .font(.system(size: 50))
                    
                    Text("join_adventure".localized)
                        .font(TTTypography.displaySmall)
                        .foregroundStyle(TTColors.textPrimary)
                    
                    Text("create_account_subtitle".localized)
                        .font(TTTypography.bodyMedium)
                        .foregroundStyle(TTColors.textSecondary)
                }
                .padding(.top, 12)
                
                // Name
                authField(title: "display_name_label".localized, icon: "person.fill", placeholder: "display_name_placeholder".localized,
                         text: $authManager.displayName, field: .name)
                
                // Email
                VStack(alignment: .leading, spacing: 8) {
                    authField(title: "email_label".localized, icon: "envelope.fill", placeholder: "email_placeholder".localized,
                             text: $authManager.email, field: .email, keyboard: .emailAddress)
                    
                    if !authManager.email.isEmpty && !authManager.isEmailValid {
                        Label("email_invalid".localized, systemImage: "exclamationmark.circle")
                            .font(TTTypography.captionSmall)
                            .foregroundStyle(TTColors.error)
                    }
                }
                
                // Password
                VStack(alignment: .leading, spacing: 8) {
                    Text("password_label".localized)
                        .font(TTTypography.labelLarge)
                        .foregroundStyle(TTColors.textSecondary)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(TTColors.textTertiary)
                        SecureField("password_min_chars".localized, text: $authManager.password)
                            .focused($focusedField, equals: .password)
                    }
                    .padding(14)
                    .background(TTColors.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(focusedField == .password ? TTColors.foxOrange : Color.clear, lineWidth: 2)
                    )
                    
                    // Password strength
                    if !authManager.password.isEmpty {
                        HStack(spacing: 4) {
                            ForEach(0..<4, id: \.self) { i in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(passwordStrengthColor(level: i))
                                    .frame(height: 4)
                            }
                        }
                    }
                }
                
                // Confirm password
                VStack(alignment: .leading, spacing: 8) {
                    Text("confirm_password_label".localized)
                        .font(TTTypography.labelLarge)
                        .foregroundStyle(TTColors.textSecondary)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(TTColors.textTertiary)
                        SecureField("confirm_password_placeholder".localized, text: $authManager.confirmPassword)
                            .focused($focusedField, equals: .confirm)
                    }
                    .padding(14)
                    .background(TTColors.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(focusedField == .confirm ? TTColors.foxOrange : Color.clear, lineWidth: 2)
                    )
                    
                    if !authManager.confirmPassword.isEmpty && !authManager.passwordsMatch {
                        Label("passwords_dont_match".localized, systemImage: "exclamationmark.circle")
                            .font(TTTypography.captionSmall)
                            .foregroundStyle(TTColors.error)
                    }
                }
                
                // Terms
                HStack(alignment: .top, spacing: 10) {
                    Button(action: { agreedToTerms.toggle() }) {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                            .font(.system(size: 22))
                            .foregroundStyle(agreedToTerms ? TTColors.foxOrange : TTColors.textTertiary)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("agree_to_terms_prefix".localized)
                            .font(TTTypography.captionLarge)
                            .foregroundStyle(TTColors.textSecondary) +
                        Text("terms_of_service".localized)
                            .font(TTTypography.captionLarge)
                            .foregroundStyle(TTColors.foxOrange) +
                        Text("and".localized)
                            .font(TTTypography.captionLarge)
                            .foregroundStyle(TTColors.textSecondary) +
                        Text("privacy_policy".localized)
                            .font(TTTypography.captionLarge)
                            .foregroundStyle(TTColors.foxOrange)
                    }
                }
                .padding(.top, 4)
                
                // Sign Up button
                GradientButton(title: "create_account".localized, icon: "person.badge.plus") {
                    focusedField = nil
                    authManager.signUpWithEmail()
                }
                .opacity(authManager.canSignUp && agreedToTerms ? 1.0 : 0.6)
                .disabled(!authManager.canSignUp || !agreedToTerms)
                
                if authManager.isLoading {
                    ProgressView()
                        .tint(TTColors.foxOrange)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(TTColors.backgroundPrimary.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(TTColors.textPrimary)
                }
            }
        }
        .alert("error_title".localized, isPresented: $authManager.showError) {
            Button("ok".localized) {}
        } message: {
            Text(authManager.errorMessage ?? "something_went_wrong".localized)
        }
    }
    
    private func authField(title: String, icon: String, placeholder: String, text: Binding<String>, field: Field, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(TTTypography.labelLarge)
                .foregroundStyle(TTColors.textSecondary)
            
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(TTColors.textTertiary)
                TextField(placeholder, text: text)
                    .keyboardType(keyboard)
                    .autocapitalization(keyboard == .emailAddress ? .none : .words)
                    .focused($focusedField, equals: field)
            }
            .padding(14)
            .background(TTColors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(focusedField == field ? TTColors.foxOrange : Color.clear, lineWidth: 2)
            )
        }
    }
    
    private func passwordStrengthColor(level: Int) -> Color {
        let length = authManager.password.count
        if length < 6 { return level == 0 ? TTColors.error : TTColors.backgroundSecondary }
        if length < 8 { return level <= 1 ? TTColors.warning : TTColors.backgroundSecondary }
        if length < 12 { return level <= 2 ? TTColors.foxOrange : TTColors.backgroundSecondary }
        return TTColors.success
    }
}

struct ForgotPasswordView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @State private var emailSent = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            FoxMascotView(message: emailSent ? "fox_reset_sent".localized : "fox_reset_unsent".localized, size: 80)
            
            Text(emailSent ? "email_sent".localized : "reset_password".localized)
                .font(TTTypography.displaySmall)
                .foregroundStyle(TTColors.textPrimary)
            
            Text(emailSent ? "check_email_instruction".localized : "reset_email_instruction".localized)
                .font(TTTypography.bodyMedium)
                .foregroundStyle(TTColors.textSecondary)
                .multilineTextAlignment(.center)
            
            if !emailSent {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(TTColors.textTertiary)
                    TextField("email_placeholder".localized, text: $authManager.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding(14)
                .background(TTColors.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                GradientButton(title: "send_reset_link".localized, icon: "paperplane.fill") {
                    emailSent = true
                    authManager.forgotPassword()
                }
            } else {
                GradientButton(title: "back_to_login".localized, icon: "arrow.left") {
                    dismiss()
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 28)
        .background(TTColors.backgroundPrimary.ignoresSafeArea())
    }
}
