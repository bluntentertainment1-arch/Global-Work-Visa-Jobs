import SwiftUI

struct PrivacyPolicyView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        themeManager.background,
                        themeManager.secondaryBackground.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection
                        
                        effectiveDateSection
                        
                        informationCollectionSection
                        
                        cookiesSection
                        
                        googleAdMobSection
                        
                        thirdPartyServicesSection
                        
                        gdprSection
                        
                        dataSecuritySection
                        
                        childrenInformationSection
                        
                        changesToPolicySection
                        
                        contactSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                            Text("Close")
                        }
                        .foregroundColor(themeManager.secondaryText)
                    }
                }
            }
        }
        .tint(themeManager.navigationText)
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
                    .frame(width: 80, height: 80)
                
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(themeManager.accentColor)
            }
            
            Text("Privacy Policy")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .multilineTextAlignment(.center)
            
            Text("We are committed to protecting your privacy and being transparent about our practices.")
                .font(.system(size: 15))
                .foregroundColor(themeManager.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    
    private var effectiveDateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.secondaryText)
                
                Text("Effective Date: February 23, 2026")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.secondaryText)
            }
            
            HStack {
                Image(systemName: "clock")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.secondaryText)
                
                Text("Last Updated: March 20, 2026")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.secondaryText)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.secondaryBackground)
        )
    }
    
    private var informationCollectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "tray.fill", title: "1. Information We Collect")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Global Work Visa Jobs does not require users to create accounts or submit personal information.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("However, we may automatically collect non-personally identifiable information, including:")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        BulletPoint(text: "Browser type")
                        BulletPoint(text: "Device type")
                        BulletPoint(text: "Operating system")
                        BulletPoint(text: "Pages visited")
                        BulletPoint(text: "General usage statistics")
                    }
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("This information helps us improve website performance and user experience.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(themeManager.secondaryText)
                        .italic()
                }
            }
        }
    }
    
    private var cookiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "doc.text.fill", title: "2. Cookies")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Our platform uses cookies to enhance user experience and analyze traffic.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("Cookies are small data files stored on your device. You can disable cookies at any time through your browser settings.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                }
            }
        }
    }
    
    private var googleAdMobSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "rectangle.stack.fill.badge.play", title: "3. Google AdMob & Advertising")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("We use Google AdMob, a third-party advertising service provided by Google Inc.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("Google may use cookies and similar technologies to display ads based on your visits to this and other websites.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("For more information, please review Google's Privacy Policy:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                        
                        Link("https://policies.google.com/privacy", destination: URL(string: "https://policies.google.com/privacy")!)
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.accentColor)
                    }
                }
            }
        }
    }
    
    private var thirdPartyServicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "link", title: "4. Third-Party Services")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("We may use trusted third-party services, including advertising and analytics providers.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("These services may use cookies or similar technologies to:")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        BulletPoint(text: "Improve ad relevance")
                        BulletPoint(text: "Enhance website functionality")
                    }
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("We do not sell, trade, or rent users' personal data.")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(themeManager.primaryText)
                }
            }
        }
    }
    
    private var gdprSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "globe.europe.africa.fill", title: "5. GDPR & EEA User Rights")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Users located in the European Economic Area (EEA) or the United Kingdom may be presented with consent options regarding personalized advertising.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("Users can manage or withdraw consent through their device or browser settings.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                }
            }
        }
    }
    
    private var dataSecuritySection: some View {
        PolicySection(
            icon: "lock.shield.fill",
            title: "6. Data Security",
            content: "We implement reasonable technical and organizational measures to protect data and maintain platform security."
        )
    }
    
    private var childrenInformationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "figure.and.child.holdinghands", title: "7. Children's Information")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Global Work Visa Jobs is not intended for children under the age of 13.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("We do not knowingly collect personal information from children.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                }
            }
        }
    }
    
    private var changesToPolicySection: some View {
        PolicySection(
            icon: "arrow.triangle.2.circlepath",
            title: "8. Changes to This Policy",
            content: "We may update this Privacy Policy from time to time. Any changes will be posted on this page with an updated effective date."
        )
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "envelope.fill", title: "9. Contact Us")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("If you have any questions about this Privacy Policy, please contact us:")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.accentColor)
                        Text("Email: globalworkvisajobs@gmail.com")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(themeManager.primaryText)
                    }
                }
            }
        }
    }
}

struct PolicySection: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: icon, title: title)
            
            PolicyCard {
                Text(content)
                    .font(.system(size: 15))
                    .foregroundColor(themeManager.primaryText.opacity(0.85))
                    .lineSpacing(4)
            }
        }
    }
}

struct PolicySectionHeader: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.accentColor.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(themeManager.accentColor)
            }
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(themeManager.primaryText)
        }
    }
}

struct PolicyCard<Content: View>: View {
    @EnvironmentObject var themeManager: ThemeManager
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.cardBackground)
                    .shadow(color: themeManager.cardShadow.opacity(0.08), radius: 8, x: 0, y: 4)
            )
    }
}

struct BulletPoint: View {
    @EnvironmentObject var themeManager: ThemeManager
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(themeManager.accentColor)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(themeManager.primaryText.opacity(0.85))
        }
    }
}