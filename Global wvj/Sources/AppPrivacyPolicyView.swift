import SwiftUI

struct AppPrivacyPolicyView: View {
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
            
            Text("Privacy Policy")
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
                icon: "info.circle.fill",
                title: "About Us",
                isSelected: selectedTab == 7
            ) {
                selectedTab = 7
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMenu = false
                }
            }
            
            Divider()
                .background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(
                icon: "lock.shield.fill",
                title: "Privacy Policy",
                isSelected: selectedTab == 8
            ) {
                selectedTab = 8
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