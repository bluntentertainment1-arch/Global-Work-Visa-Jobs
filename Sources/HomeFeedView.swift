import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds

struct HomeFeedView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var showLanding: Bool
    var onComplete: () -> Void
    @State private var attStatus: ATTrackingManager.AuthorizationStatus = .notDetermined
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            // Gradient background using theme colors
            LinearGradient(
                gradient: Gradient(colors: [
                    themeManager.background,
                    themeManager.secondaryBackground.opacity(0.5),
                    themeManager.background
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo container with shadow
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    themeManager.accentColor.opacity(0.2),
                                    themeManager.accentColor.opacity(0.05)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)
                        .shadow(color: themeManager.accentColor.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "globe")
                        .font(.system(size: 70, weight: .light))
                        .foregroundColor(themeManager.accentColor)
                        .scaleEffect(isPulsing ? 1.05 : 1.0)
                        .opacity(isPulsing ? 0.8 : 1.0)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                isPulsing = true
                            }
                        }
                }
                .padding(.bottom, 40)
                
                // App Name with premium typography
                VStack(spacing: 4) {
                    Text("GLOBAL WORK")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .tracking(4)
                        .foregroundColor(themeManager.secondaryText)
                    
                    // FIX: Use accentColor directly instead of LinearGradient
                    Text("Visa Jobs")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.accentColor)
                }
                .padding(.bottom, 24)
                
                // Elegant divider
                Rectangle()
                    .fill(themeManager.accentColor.opacity(0.3))
                    .frame(width: 60, height: 2)
                    .padding(.bottom, 24)
                
                // Taglines
                VStack(spacing: 12) {
                    Text("Find Your Dream Career Abroad")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text("Discover visa-sponsored opportunities in Canada, UK, Germany & more")
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(themeManager.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 50)
                
                Spacer()
                
                // Premium feature cards
                HStack(spacing: 16) {
                    FeatureCard(
                        icon: "briefcase.fill",
                        title: "Jobs",
                        subtitle: "10K+",
                        color: themeManager.accentColor
                    )
                    
                    FeatureCard(
                        icon: "airplane",
                        title: "Visa Ready",
                        subtitle: "Sponsored",
                        color: themeManager.accentColor
                    )
                    
                    FeatureCard(
                        icon: "mappin.and.ellipse",
                        title: "Global",
                        subtitle: "5+ Countries",
                        color: themeManager.accentColor
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
                
                // Premium CTA Button
                Button(action: {
                    requestTrackingAndProceed()
                }) {
                    HStack(spacing: 12) {
                        Text("Browse Visa Sponsored Jobs")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(themeManager.accentColor)
                            
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        }
                    )
                    .shadow(
                        color: themeManager.accentColor.opacity(0.4),
                        radius: 12,
                        x: 0,
                        y: 6
                    )
                }
                .padding(.horizontal, 24)
                
                // Privacy note with icon
                HStack(spacing: 6) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10))
                    Text("Your privacy matters. We request permission to show relevant ads.")
                }
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(themeManager.secondaryText.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 16)
                
                Spacer()
                    .frame(height: 40)
            }
            .padding(.top, 20)
        }
    }
    
    private func requestTrackingAndProceed() {
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                self.attStatus = status
                self.initializeAdMob()
                
                withAnimation(.easeInOut(duration: 0.4)) {
                    showLanding = false
                    onComplete()
                }
            }
        }
    }
    
    private func initializeAdMob() {
        MobileAds.shared.start { status in
            print("✅ AdMob SDK started with status: \(status.adapterStatusesByClassName)")
        }
    }
}

// MARK: - Premium Feature Card
struct FeatureCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(themeManager.primaryText)
                
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(themeManager.secondaryText.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.secondaryBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}
