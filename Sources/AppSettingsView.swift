import SwiftUI
import StoreKit

struct AppSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedTab: Int
    @State private var showPrivacyPolicy = false
    @State private var showAbout = false
    @State private var showMenu = false
    @State private var isDarkModeEnabled = true
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var gdprManager = GDPRConsentManager.shared
    
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
                    VStack(spacing: 24) {
                        headerSection
                        
                        appearanceSection
                        
                        notificationsSection
                        
                        if gdprManager.isEUorUKUser {
                            privacyConsentSection
                        }
                        
                        appSection
                        
                        legalSection
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
        .onAppear {
            isDarkModeEnabled = themeManager.isDarkMode
        }
    }
    
    private var customNavigationBar: some View {
        HStack(spacing: 16) {
            Button(action: {
                if selectedTab == 0 {
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshMainScreen"), object: nil)
                } else {
                    selectedTab = 0
                }
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
            
            Text("Settings")
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
                icon: "briefcase.fill",
                title: "Jobs",
                isSelected: selectedTab == 0
            ) {
                if selectedTab == 0 {
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshMainScreen"), object: nil)
                } else {
                    selectedTab = 0
                }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMenu = false
                }
            }
            
            Divider()
                .background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(
                icon: "bookmark.fill",
                title: "Saved Jobs",
                isSelected: selectedTab == 10
            ) {
                selectedTab = 10
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMenu = false
                }
            }
            
            Divider()
                .background(themeManager.dividerColor.opacity(0.3))
            
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
                icon: "newspaper.fill",
                title: "Blog and Relocation Resources",
                isSelected: selectedTab == 6
            ) {
                selectedTab = 6
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
                icon: "envelope.fill",
                title: "Contact Us",
                isSelected: selectedTab == 9
            ) {
                selectedTab = 9
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
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [themeManager.accentColor, themeManager.accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.white)
            }
            .shadow(color: themeManager.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
            
            Text("App Settings")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(themeManager.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    
    private var appearanceSection: some View {
        VStack(spacing: 12) {
            Text("Appearance")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [themeManager.accentColor.opacity(0.2), themeManager.accentColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: isDarkModeEnabled ? "moon.fill" : "sun.max.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(themeManager.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Dark Mode")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text(isDarkModeEnabled ? "Dark theme enabled" : "Light theme enabled")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(themeManager.secondaryText)
                }
                
                Spacer()
                
                Toggle("", isOn: $isDarkModeEnabled)
                    .labelsHidden()
                    .tint(themeManager.accentColor)
                    .onChange(of: isDarkModeEnabled) { newValue in
                        themeManager.setDarkMode(newValue)
                    }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.cardBackground)
                    .shadow(color: themeManager.cardShadow.opacity(0.08), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var notificationsSection: some View {
        VStack(spacing: 12) {
            Text("Notifications")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [themeManager.accentColor.opacity(0.2), themeManager.accentColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "bell.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(themeManager.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Job Alerts")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text(notificationManager.isAuthorized ? "Enabled at 8:30 AM daily" : "Tap to enable notifications")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(themeManager.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: notificationManager.isAuthorized ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(notificationManager.isAuthorized ? themeManager.successColor : themeManager.warningColor)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.cardBackground)
                    .shadow(color: themeManager.cardShadow.opacity(0.08), radius: 8, x: 0, y: 4)
            )
            .onTapGesture {
                if !notificationManager.isAuthorized {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            }
        }
    }
    
    private var privacyConsentSection: some View {
        VStack(spacing: 12) {
            Text("Privacy & Data Protection")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [themeManager.accentColor.opacity(0.2), themeManager.accentColor.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("GDPR Consent")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(themeManager.primaryText)
                        
                        Text(gdprManager.hasUserConsented ? "You have consented" : "Consent withdrawn")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(themeManager.secondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: gdprManager.hasUserConsented ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(gdprManager.hasUserConsented ? themeManager.successColor : themeManager.errorColor)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(themeManager.cardBackground)
                        .shadow(color: themeManager.cardShadow.opacity(0.08), radius: 8, x: 0, y: 4)
                )
                
                if gdprManager.hasUserConsented {
                    Button(action: {
                        gdprManager.withdrawConsent()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.uturn.backward")
                                .font(.system(size: 16))
                            Text("Withdraw Consent")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(themeManager.errorColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(themeManager.errorColor, lineWidth: 1.5)
                        )
                    }
                } else {
                    Button(action: {
                        gdprManager.shouldShowConsent = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 16))
                            Text("Review & Grant Consent")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(themeManager.accentColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(themeManager.accentColor, lineWidth: 1.5)
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Rights:")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    GDPRRightRow(text: "Right to access your data")
                    GDPRRightRow(text: "Right to rectification and erasure")
                    GDPRRightRow(text: "Right to withdraw consent anytime")
                    GDPRRightRow(text: "Right to data portability")
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(themeManager.secondaryBackground.opacity(0.5))
                )
            }
        }
    }
    
    private var appSection: some View {
        VStack(spacing: 12) {
            Text("App")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SettingsButton(
                icon: "star.fill",
                title: "Rate App",
                subtitle: "Enjoying the app? Rate us!",
                action: {
                    requestAppReview()
                }
            )
            
            SettingsButton(
                icon: "square.and.arrow.up.fill",
                title: "Share App",
                subtitle: "Share with friends",
                action: {
                    shareApp()
                }
            )
            
            SettingsButton(
                icon: "envelope.fill",
                title: "Contact Us",
                subtitle: "Get in touch with us",
                action: {
                    selectedTab = 9
                }
            )
            
            SettingsButton(
                icon: "info.circle.fill",
                title: "About Us",
                subtitle: "Learn more about us",
                action: {
                    selectedTab = 7
                }
            )
        }
    }
    
    private var legalSection: some View {
        VStack(spacing: 12) {
            Text("Legal & Privacy")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SettingsButton(
                icon: "lock.shield.fill",
                title: "Privacy Policy",
                subtitle: "How we protect your data",
                action: {
                    selectedTab = 8
                }
            )
            
            SettingsButton(
                icon: "doc.text.fill",
                title: "Terms & Conditions",
                subtitle: "Terms of service",
                action: {
                    selectedTab = 5
                }
            )
        }
    }
    
    private func requestAppReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func shareApp() {
        let appURL = "https://apps.apple.com/app/id123456789"
        let shareText = "Check out Global Work Visa Jobs app! Find international job opportunities with visa sponsorship. \(appURL)"
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct GDPRRightRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 12))
                .foregroundColor(themeManager.accentColor)
                .padding(.top, 2)
            
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(themeManager.primaryText.opacity(0.85))
        }
    }
}

