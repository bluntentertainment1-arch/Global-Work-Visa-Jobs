import SwiftUI

struct ContactUsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedTab: Int
    @State private var showMenu = false
    @State private var showEmailClient = false
    @State private var showCopiedAlert = false
    
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
                        
                        introductionSection
                        
                        emailSection
                        
                        responseTimeSection
                        
                        helpTopicsSection
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
            
            if showCopiedAlert {
                VStack {
                    Spacer()
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        Text("Email copied to clipboard")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(themeManager.successColor)
                    )
                    .shadow(color: themeManager.successColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
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
            
            Text("Contact Us")
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
                
                Image(systemName: "envelope.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(themeManager.accentColor)
            }
            
            Text("Get in Touch")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    
    private var introductionSection: some View {
        PolicyCard {
            Text("Have questions, suggestions, or need assistance? We're here to help! Whether you're looking for information about job listings, visa sponsorship opportunities, or have feedback about our platform, we'd love to hear from you.")
                .font(.system(size: 15))
                .foregroundColor(themeManager.primaryText.opacity(0.85))
                .lineSpacing(6)
                .multilineTextAlignment(.center)
        }
    }
    
    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "envelope.fill", title: "Email Us")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 16) {
                    Text("For general inquiries, support requests, or partnership opportunities, please reach out to us at:")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            openEmailClient()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(themeManager.accentColor)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("globalworkvisajobs@gmail.com")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(themeManager.primaryText)
                                    
                                    Text("Tap to send email")
                                        .font(.system(size: 13))
                                        .foregroundColor(themeManager.secondaryText)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(themeManager.accentColor)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(themeManager.accentColor.opacity(0.1))
                            )
                        }
                        
                        Button(action: {
                            copyEmailToClipboard()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 14))
                                Text("Copy Email Address")
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundColor(themeManager.accentColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(themeManager.accentColor, lineWidth: 1.5)
                            )
                        }
                    }
                }
            }
        }
    }
    
    private var responseTimeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "clock.fill", title: "Response Time")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(themeManager.successColor.opacity(0.15))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(themeManager.successColor)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("24-48 Hours")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(themeManager.primaryText)
                            
                            Text("Typical response time")
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.secondaryText)
                        }
                    }
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                        .padding(.vertical, 4)
                    
                    Text("We typically respond to all inquiries within 24-48 hours during business days. For urgent matters, please mention \"URGENT\" in your email subject line.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                }
            }
        }
    }
    
    private var helpTopicsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "questionmark.circle.fill", title: "What We Can Help With")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    HelpTopicRow(
                        icon: "briefcase.fill",
                        title: "Job Listings & Visa Sponsorship",
                        description: "Questions about job listings and visa sponsorship"
                    )
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                    
                    HelpTopicRow(
                        icon: "wrench.and.screwdriver.fill",
                        title: "Technical Support",
                        description: "Technical support and platform issues"
                    )
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                    
                    HelpTopicRow(
                        icon: "star.fill",
                        title: "Feedback & Suggestions",
                        description: "Feedback and suggestions for improvement"
                    )
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                    
                    HelpTopicRow(
                        icon: "handshake.fill",
                        title: "Partnerships",
                        description: "Partnership and collaboration opportunities"
                    )
                    
                    Divider()
                        .background(themeManager.dividerColor.opacity(0.5))
                    
                    HelpTopicRow(
                        icon: "info.circle.fill",
                        title: "General Inquiries",
                        description: "General inquiries about our services"
                    )
                }
            }
        }
    }
    
    private func openEmailClient() {
        let email = "globalworkvisajobs@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func copyEmailToClipboard() {
        UIPasteboard.general.string = "globalworkvisajobs@gmail.com"
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showCopiedAlert = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showCopiedAlert = false
            }
        }
    }
}

struct HelpTopicRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.accentColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(themeManager.accentColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(themeManager.primaryText)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(themeManager.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
}