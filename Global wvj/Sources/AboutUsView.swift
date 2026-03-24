import SwiftUI

struct AboutUsView: View {
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
                        
                        missionSection
                        
                        whatWeDoSection
                        
                        transparencySection
                        
                        commitmentSection
                        
                        whoWeServeSection
                        
                        contactSection
                        
                        lookingAheadSection
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
            
            Text("About Us")
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
                
                Image(systemName: "globe.americas.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(themeManager.accentColor)
            }
            
            Text("About Us — Global Work Visa Jobs")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Connecting People to Verified Work Opportunities Abroad")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(themeManager.accentColor)
                .multilineTextAlignment(.center)
            
            Text("Global Work Visa Jobs is an online platform dedicated to helping job seekers discover employment opportunities across Europe and other international destinations that may offer work visa sponsorship.")
                .font(.system(size: 15))
                .foregroundColor(themeManager.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Text("Our goal is simple — to make international job opportunities easier to find, transparent, and accessible to everyone, regardless of location.")
                .font(.system(size: 15))
                .foregroundColor(themeManager.primaryText.opacity(0.85))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    
    private var missionSection: some View {
        PolicySection(
            icon: "target",
            title: "Our Mission",
            content: "We aim to bridge the gap between global job seekers and employers offering legitimate overseas opportunities by organizing publicly available job listings into one easy-to-use platform."
        )
    }
    
    private var whatWeDoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "briefcase.fill", title: "What We Do")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Job Aggregation")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(themeManager.primaryText)
                        
                        Text("We collect publicly available job listings from verified sources such as:")
                            .font(.system(size: 15))
                            .foregroundColor(themeManager.primaryText.opacity(0.85))
                        
                        BulletPoint(text: "Government job portals")
                        BulletPoint(text: "Healthcare recruitment platforms")
                        BulletPoint(text: "Employer career websites")
                    }
                    
                    Divider().background(themeManager.dividerColor.opacity(0.5))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Daily Job Updates")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(themeManager.primaryText)
                        
                        Text("Our platform is regularly updated with new opportunities across industries including:")
                            .font(.system(size: 15))
                            .foregroundColor(themeManager.primaryText.opacity(0.85))
                        
                        BulletPoint(text: "Healthcare")
                        BulletPoint(text: "Logistics")
                        BulletPoint(text: "Construction")
                        BulletPoint(text: "IT")
                        BulletPoint(text: "Hospitality")
                        BulletPoint(text: "Skilled trades")
                    }
                    
                    Divider().background(themeManager.dividerColor.opacity(0.5))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Easy Job Search")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(themeManager.primaryText)
                        
                        Text("Users can easily browse jobs by:")
                            .font(.system(size: 15))
                            .foregroundColor(themeManager.primaryText.opacity(0.85))
                        
                        BulletPoint(text: "Country")
                        BulletPoint(text: "Job category")
                        BulletPoint(text: "Industry")
                        BulletPoint(text: "Visa sponsorship availability")
                    }
                    
                    Divider().background(themeManager.dividerColor.opacity(0.5))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Career Resources")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(themeManager.primaryText)
                        
                        Text("We also provide helpful resources such as:")
                            .font(.system(size: 15))
                            .foregroundColor(themeManager.primaryText.opacity(0.85))
                        
                        BulletPoint(text: "Work visa guidance")
                        BulletPoint(text: "Interview preparation tips")
                        BulletPoint(text: "International job search advice")
                        BulletPoint(text: "Awareness on avoiding recruitment scams")
                    }
                }
            }
        }
    }
    
    private var transparencySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "exclamationmark.shield.fill", title: "Transparency & Disclaimer")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Global Work Visa Jobs is not a recruitment agency and does not directly hire candidates or process visas.")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(themeManager.warningColor)
                    
                    Text("All job listings are sourced from publicly available platforms. Applicants should verify job details directly with the employer before applying.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                    
                    Divider().background(themeManager.dividerColor.opacity(0.5))
                    
                    Text("We do not guarantee:")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    BulletPoint(text: "Employment")
                    BulletPoint(text: "Interviews")
                    BulletPoint(text: "Visa approval")
                    BulletPoint(text: "Immigration outcomes")
                }
            }
        }
    }
    
    private var commitmentSection: some View {
        PolicySection(
            icon: "checkmark.shield.fill",
            title: "Our Commitment",
            content: "We are committed to maintaining a trustworthy and transparent platform while complying with advertising and content quality standards, including Google AdSense policies. User privacy and platform security remain a top priority."
        )
    }
    
    private var whoWeServeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "person.3.fill", title: "Who We Serve")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("We support:")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    BulletPoint(text: "Professionals")
                    BulletPoint(text: "Skilled workers")
                    BulletPoint(text: "Graduates")
                    BulletPoint(text: "Job seekers worldwide")
                    
                    Divider().background(themeManager.dividerColor.opacity(0.5))
                    
                    Text("From healthcare workers to engineers, drivers, and technicians — we help users discover global opportunities in one place.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                        .lineSpacing(4)
                }
            }
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolicySectionHeader(icon: "envelope.fill", title: "Contact Us")
            
            PolicyCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("We welcome feedback, partnerships, and suggestions.")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryText.opacity(0.85))
                    
                    Divider().background(themeManager.dividerColor.opacity(0.5))
                    
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
    
    private var lookingAheadSection: some View {
        PolicySection(
            icon: "arrow.up.forward.circle.fill",
            title: "Looking Ahead",
            content: "As we grow, we aim to expand job coverage, improve search tools, and provide even more resources to help users make informed decisions when pursuing careers abroad."
        )
    }
}