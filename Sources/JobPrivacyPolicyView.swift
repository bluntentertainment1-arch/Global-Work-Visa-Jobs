import SwiftUI

struct JobPrivacyPolicyView: View {
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
                        
                        lastUpdatedSection
                        
                        introductionSection
                        
                        dataCollectionSection
                        
                        dataUsageSection
                        
                        dataStorageSection
                        
                        thirdPartySection
                        
                        userRightsSection
                        
                        childrenPrivacySection
                        
                        changesSection
                        
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
            
            Text("Your Privacy Matters")
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
    
    private var lastUpdatedSection: some View {
        HStack {
            Image(systemName: "calendar")
                .font(.system(size: 14))
                .foregroundColor(themeManager.secondaryText)
            
            Text("Last Updated: January 2025")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(themeManager.secondaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.secondaryBackground)
        )
    }
    
    private var introductionSection: some View {
        PolicySection(
            icon: "info.circle.fill",
            title: "Introduction",
            content: "This Privacy Policy describes how Global Work Visa Jobs (\"we\", \"our\", or \"the App\") handles information when you use our mobile application. We are committed to protecting your privacy and ensuring transparency in our data practices."
        )
    }
    
    private var dataCollectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "tray.fill", title: "Information We Collect")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("We Do NOT Collect or Store Personal Data")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text("Our app does not collect, store, or process any personal information from users. We do not require account creation, and we do not track your activity within the app. The app displays job listings from external websites through embedded web views.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What This Means:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                        
                        BulletPoint(text: "No email addresses collected")
                        BulletPoint(text: "No names or contact information stored")
                        BulletPoint(text: "No location data tracked")
                        BulletPoint(text: "No browsing history recorded")
                        BulletPoint(text: "No user profiles created")
                        BulletPoint(text: "No cookies or tracking technologies used")
                    }
                }
            }
        }
    }
    
    private var dataUsageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "gearshape.fill", title: "How We Use Information")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Since we do not collect personal data, there is no usage of your personal information. The app functions as a web browser wrapper that displays job listings from external websites. All interactions with job postings occur directly with the third-party websites.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("App Functionality:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                        
                        BulletPoint(text: "Job listings are displayed from external websites")
                        BulletPoint(text: "All data processing happens on external websites")
                        BulletPoint(text: "No analytics or tracking services are integrated")
                        BulletPoint(text: "Theme preferences stored locally on your device")
                    }
                }
            }
        }
    }
    
    private var dataStorageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "externaldrive.fill", title: "Data Storage and Security")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("No Personal Data Storage")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text("We do not store any personal data on our servers or any third-party servers. The only data stored locally on your device is your theme preference (light/dark mode). This preference is stored using iOS UserDefaults and is never transmitted to any server.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Local Storage Only:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                        
                        BulletPoint(text: "Theme preference stored on your device")
                        BulletPoint(text: "No cloud backup of any data")
                        BulletPoint(text: "All data deleted when app is uninstalled")
                        BulletPoint(text: "No server-side data storage")
                    }
                }
            }
        }
    }
    
    private var thirdPartySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "link", title: "Third-Party Services")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("External Websites")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text("Our app displays job listings from external websites and may link to external job posting websites. When you interact with these websites through our app, you are subject to their privacy policies and terms of service. We are not responsible for the privacy practices of these external sites.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Important Notes:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                        
                        BulletPoint(text: "Job listings are provided by third-party websites")
                        BulletPoint(text: "Applications are submitted directly to employers")
                        BulletPoint(text: "We do not control third-party privacy practices")
                        BulletPoint(text: "Review privacy policies of websites you visit")
                    }
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("We recommend reviewing the privacy policies of any third-party websites you visit through our app.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(themeManager.secondaryText)
                        .italic()
                }
            }
        }
    }
    
    private var userRightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "person.fill.checkmark", title: "Your Rights")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Since we do not collect or store personal data, there is no personal information to access, modify, or delete. You have complete control over the app by:")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        BulletPoint(text: "Uninstalling the app to remove all local data")
                        BulletPoint(text: "Clearing app data through device settings")
                        BulletPoint(text: "Using the app without any registration or login")
                        BulletPoint(text: "Changing theme preferences at any time")
                    }
                }
            }
        }
    }
    
    private var childrenPrivacySection: some View {
        PolicySection(
            icon: "figure.and.child.holdinghands",
            title: "Children's Privacy",
            content: "Our app does not knowingly collect any information from children under the age of 13. Since we do not collect personal data from any users, the app is safe for all age groups. Parents and guardians can allow children to use the app without privacy concerns. However, we recommend parental supervision when children interact with external job websites."
        )
    }
    
    private var changesSection: some View {
        PolicySection(
            icon: "arrow.triangle.2.circlepath",
            title: "Changes to This Policy",
            content: "We may update this Privacy Policy from time to time. Any changes will be posted within the app with an updated \"Last Updated\" date. We encourage you to review this policy periodically. Continued use of the app after changes constitutes acceptance of the updated policy."
        )
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "envelope.fill", title: "Contact Us")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("If you have any questions or concerns about this Privacy Policy or our privacy practices, please contact us:")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
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
            
            Text("We are committed to addressing your concerns and protecting your privacy.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(themeManager.secondaryText)
                .italic()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
        }
    }
}