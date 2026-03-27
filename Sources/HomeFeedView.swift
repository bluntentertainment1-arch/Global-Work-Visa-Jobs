import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds

struct HomeFeedView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var showLanding: Bool
    @State private var showATTAlert = false
    @State private var attStatus: ATTrackingManager.AuthorizationStatus = .notDetermined
    
    var body: some View {
        ZStack {
            themeManager.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo/Icon with animation
                Image(systemName: "globe")
                    .font(.system(size: 90, weight: .light))
                    .foregroundColor(themeManager.accentColor)
                    .symbolEffect(.pulse)
                    .padding(.bottom, 32)
                
                // App Name
                Text("Global Work")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(themeManager.primaryText)
                
                Text("Visa Jobs")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(themeManager.accentColor)
                    .padding(.bottom, 20)
                
                // Taglines
                VStack(spacing: 8) {
                    Text("Find Your Dream Career Abroad")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text("Discover visa-sponsored opportunities in Canada, UK, Germany & more")
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 60)
                
                Spacer()
                
                // Features highlight
                HStack(spacing: 24) {
                    FeatureItem(icon: "briefcase.fill", title: "Jobs")
                    FeatureItem(icon: "airplane", title: "Visa Ready")
                    FeatureItem(icon: "mappin.and.ellipse", title: "Global")
                }
                .padding(.bottom, 50)
                
                // CTA Button
                Button(action: {
                    requestTrackingAndProceed()
                }) {
                    HStack(spacing: 12) {
                        Text("Browse Visa Sponsored Jobs")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 20))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        LinearGradient(
                            colors: [themeManager.accentColor, themeManager.accentColor.opacity(0.85)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: themeManager.accentColor.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 28)
                
                // Privacy note
                Text("Your privacy matters. We request permission to show relevant ads.")
                    .font(.system(size: 12))
                    .foregroundColor(themeManager.secondaryText.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 16)
                
                Spacer()
                    .frame(height: 50)
            }
            .padding(.top, 20)
        }
        .onAppear {
            // Check current status
            attStatus = ATTrackingManager.trackingAuthorizationStatus
        }
    }
    
    private func requestTrackingAndProceed() {
        // Request ATT permission
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                self.attStatus = status
                
                // Initialize AdMob after permission response
                self.initializeAdMob()
                
                // Dismiss landing screen with animation
                withAnimation(.easeInOut(duration: 0.4)) {
                    showLanding = false
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

// Feature item component
struct FeatureItem: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(themeManager.accentColor)
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(themeManager.secondaryText)
        }
    }
}
