import SwiftUI

struct GDPRConsentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var isPresented: Bool
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 24) {
                    headerSection
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            introSection
                            
                            dataCollectionSection
                            
                            yourRightsSection
                            
                            legalBasisSection
                        }
                        .padding(.horizontal, 24)
                    }
                    .frame(maxHeight: 400)
                    
                    actionButtons
                }
                .padding(.vertical, 32)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(themeManager.cardBackground)
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [themeManager.accentColor.opacity(0.2), themeManager.accentColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(themeManager.accentColor)
            }
            
            Text("Your Privacy Matters")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(themeManager.primaryText)
            
            Text("We respect your data protection rights")
                .font(.system(size: 15))
                .foregroundColor(themeManager.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
    }
    
    private var introSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Welcome to Global Work Visa Jobs! 👋")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(themeManager.primaryText)
            
            Text("Before you start exploring job opportunities, we want to be transparent about how we handle your information in compliance with GDPR and UK Data Protection Act.")
                .font(.system(size: 15))
                .foregroundColor(themeManager.primaryText.opacity(0.85))
                .lineSpacing(4)
        }
    }
    
    private var dataCollectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(themeManager.accentColor)
                Text("What We Collect")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(themeManager.primaryText)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ConsentBulletPoint(text: "Basic device information (browser type, OS version)")
                ConsentBulletPoint(text: "App usage statistics (pages visited, features used)")
                ConsentBulletPoint(text: "Anonymous analytics to improve our service")
            }
            
            Text("We do NOT collect: names, email addresses, phone numbers, or precise location data.")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(themeManager.successColor)
                .padding(.top, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.secondaryBackground.opacity(0.5))
        )
    }
    
    private var yourRightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.shield.fill")
                    .foregroundColor(themeManager.accentColor)
                Text("Your Rights Under GDPR")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(themeManager.primaryText)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ConsentBulletPoint(text: "Right to access your data")
                ConsentBulletPoint(text: "Right to rectification and erasure")
                ConsentBulletPoint(text: "Right to restrict processing")
                ConsentBulletPoint(text: "Right to data portability")
                ConsentBulletPoint(text: "Right to object to processing")
                ConsentBulletPoint(text: "Right to withdraw consent at any time")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.secondaryBackground.opacity(0.5))
        )
    }
    
    private var legalBasisSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.fill")
                    .foregroundColor(themeManager.accentColor)
                Text("Legal Basis")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(themeManager.primaryText)
            }
            
            Text("We process your data based on your consent (Article 6(1)(a) GDPR) and our legitimate interest in providing and improving our services (Article 6(1)(f) GDPR).")
                .font(.system(size: 14))
                .foregroundColor(themeManager.primaryText.opacity(0.85))
                .lineSpacing(4)
            
            Text("You can withdraw your consent at any time through the app settings. This won't affect the lawfulness of processing before withdrawal.")
                .font(.system(size: 13))
                .foregroundColor(themeManager.secondaryText)
                .italic()
                .lineSpacing(4)
                .padding(.top, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.secondaryBackground.opacity(0.5))
        )
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                onAccept()
                isPresented = false
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                    Text("I Accept")
                        .font(.system(size: 17, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [themeManager.accentColor, themeManager.accentColor.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            
            Button(action: {
                onDecline()
                isPresented = false
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 18))
                    Text("I Decline")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(themeManager.secondaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(themeManager.borderColor, lineWidth: 1.5)
                )
            }
            
            Button(action: {
                if let url = URL(string: "https://mobileworkvisajobs.pages.dev/privacy") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Read Full Privacy Policy")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.accentColor)
                    .underline()
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 24)
    }
}

struct ConsentBulletPoint: View {
    @EnvironmentObject var themeManager: ThemeManager
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(themeManager.accentColor)
                .padding(.top, 2)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(themeManager.primaryText.opacity(0.85))
        }
    }
}