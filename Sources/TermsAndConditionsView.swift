import SwiftUI

struct TermsAndConditionsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedTab: Int
    @State private var showMenu = false
    
    var body: some View {
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
            
            VStack(spacing: 0) {
                customNavigationBar
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection
                        
                        lastUpdatedSection
                        
                        acceptanceSection
                        
                        serviceDescriptionSection
                        
                        userResponsibilitiesSection
                        
                        intellectualPropertySection
                        
                        disclaimerSection
                        
                        limitationOfLiabilitySection
                        
                        thirdPartyLinksSection
                        
                        modificationsSection
                        
                        governingLawSection
                        
                        contactSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
            
            if showMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showMenu = false
                        }
                    }
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        menuDropdown
                            .padding(.top, 60)
                            .padding(.trailing, 16)
                    }
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
    
    private var customNavigationBar: some View {
        HStack(spacing: 16) {
            Button(action: {
                selectedTab = 0
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Home")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(themeManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            
            Spacer()
            
            Text("Terms & Conditions")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(themeManager.primaryText)
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMenu.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Text("Main Menu")
                        .font(.system(size: 17, weight: .semibold))
                    Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                        .font(.system(size: 20, weight: .semibold))
                }
                .foregroundColor(showMenu ? themeManager.accentColor : themeManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(showMenu ? themeManager.accentColor.opacity(0.15) : Color.clear)
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(themeManager.secondaryBackground)
                .shadow(color: themeManager.cardShadow.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private var menuDropdown: some View {
        VStack(spacing: 0) {
            MenuItemButton(
                icon: "flag.fill",
                title: "Canada Jobs",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMenu = false
                }
            }
            
            Divider()
                .background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(
                icon: "flag.fill",
                title: "UK Jobs",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMenu = false
                }
            }
            
            Divider()
                .background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(
                icon: "flag.fill",
                title: "Germany Jobs",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMenu = false
                }
            }
            
            Divider()
                .background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(
                icon: "doc.text.fill",
                title: "Terms & Conditions",
                isSelected: selectedTab == 5
            ) {
                selectedTab = 5
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMenu = false
                }
            }
            
            Divider()
                .background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(
                icon: "gearshape.fill",
                title: "Settings",
                isSelected: selectedTab == 4
            ) {
                selectedTab = 4
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMenu = false
                }
            }
        }
        .frame(width: 220)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.cardBackground)
                .shadow(color: themeManager.cardShadow.opacity(0.2), radius: 12, x: 0, y: 4)
        )
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
                
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(themeManager.accentColor)
            }
            
            Text("Terms and Conditions")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Please read these terms carefully before using our app.")
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
    
    private var acceptanceSection: some View {
        PolicySection(
            icon: "checkmark.circle.fill",
            title: "Acceptance of Terms",
            content: "By downloading, installing, or using the Global Work Visa Jobs mobile application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the app."
        )
    }
    
    private var serviceDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "app.fill", title: "Description of Service")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Global Work Visa Jobs is a mobile application that provides access to job listings from various countries through embedded web views. The app displays job opportunities that may offer visa sponsorship.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("The Service Includes:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                        
                        BulletPoint(text: "Access to job listings from external websites")
                        BulletPoint(text: "Filtering and search functionality")
                        BulletPoint(text: "Direct links to job application pages")
                        BulletPoint(text: "Theme customization options")
                    }
                }
            }
        }
    }
    
    private var userResponsibilitiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "person.fill.checkmark", title: "User Responsibilities")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("As a user of this app, you agree to:")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        BulletPoint(text: "Use the app only for lawful purposes")
                        BulletPoint(text: "Not attempt to interfere with the app's functionality")
                        BulletPoint(text: "Not use automated systems to access the app")
                        BulletPoint(text: "Verify job information independently before applying")
                        BulletPoint(text: "Comply with the terms of third-party websites you access")
                        BulletPoint(text: "Not misrepresent yourself in job applications")
                    }
                }
            }
        }
    }
    
    private var intellectualPropertySection: some View {
        PolicySection(
            icon: "c.circle.fill",
            title: "Intellectual Property",
            content: "All content, features, and functionality of the Global Work Visa Jobs app, including but not limited to text, graphics, logos, and software, are the property of the app developers and are protected by international copyright, trademark, and other intellectual property laws. You may not copy, modify, distribute, or reverse engineer any part of the app without express written permission."
        )
    }
    
    private var disclaimerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "exclamationmark.triangle.fill", title: "Disclaimer")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Important Notice")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(themeManager.warningColor)
                    
                    Text("The app provides access to job listings from third-party websites. We do not:")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        BulletPoint(text: "Verify the accuracy of job postings")
                        BulletPoint(text: "Guarantee visa sponsorship availability")
                        BulletPoint(text: "Endorse any employer or job opportunity")
                        BulletPoint(text: "Act as a recruitment agency or employer")
                        BulletPoint(text: "Guarantee job placement or visa approval")
                    }
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("THE APP IS PROVIDED \"AS IS\" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. WE DO NOT WARRANT THAT THE APP WILL BE UNINTERRUPTED, ERROR-FREE, OR FREE OF VIRUSES.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(themeManager.secondaryText)
                        .italic()
                }
            }
        }
    }
    
    private var limitationOfLiabilitySection: some View {
        PolicySection(
            icon: "shield.fill",
            title: "Limitation of Liability",
            content: "To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses resulting from your use of the app. We are not responsible for any issues arising from job applications, employment decisions, or visa processes."
        )
    }
    
    private var thirdPartyLinksSection: some View {
        PolicySection(
            icon: "link",
            title: "Third-Party Links and Content",
            content: "The app contains links to third-party websites and displays content from external sources. We are not responsible for the content, privacy policies, or practices of these third-party sites. Your interactions with third-party websites are governed by their respective terms and conditions. We recommend reviewing their policies before submitting any personal information or applications."
        )
    }
    
    private var modificationsSection: some View {
        PolicySection(
            icon: "arrow.triangle.2.circlepath",
            title: "Modifications to Terms",
            content: "We reserve the right to modify these Terms and Conditions at any time. Changes will be effective immediately upon posting within the app. Your continued use of the app after changes constitutes acceptance of the modified terms. We encourage you to review these terms periodically."
        )
    }
    
    private var governingLawSection: some View {
        PolicySection(
            icon: "building.columns.fill",
            title: "Governing Law",
            content: "These Terms and Conditions shall be governed by and construed in accordance with the laws of the jurisdiction in which the app developer is located, without regard to its conflict of law provisions. Any disputes arising from these terms shall be subject to the exclusive jurisdiction of the courts in that jurisdiction."
        )
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "envelope.fill", title: "Contact Information")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("If you have any questions about these Terms and Conditions, please contact us:")
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
                        
                        HStack(spacing: 8) {
                            Image(systemName: "globe")
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.accentColor)
                            Text("Website: mobileworkvisajobs.pages.dev")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(themeManager.primaryText)
                        }
                    }
                }
            }
            
            Text("By using this app, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(themeManager.secondaryText)
                .italic()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
        }
    }
}