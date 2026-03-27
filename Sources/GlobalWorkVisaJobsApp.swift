import SwiftUI
import UserNotifications

@main
struct GlobalWorkVisaJobsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var eventManager = SimpleForegroundLogger.shared
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var gdprManager = GDPRConsentManager.shared
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("hasSeenLanding") private var hasSeenLanding: Bool = false
    @State private var showSplash = true
    @State private var showLanding = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView()
                        .environmentObject(themeManager)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showSplash = false
                                    
                                    // Show landing on first launch, otherwise go to main app
                                    if !hasSeenLanding {
                                        showLanding = true
                                    } else {
                                        isFirstLaunch = false
                                        setupNotifications()
                                    }
                                }
                            }
                        }
                        .transition(.opacity)
                        .zIndex(1000)
                } else if showLanding {
                    // Native landing screen with ATT
                    HomeFeedView(showLanding: $showLanding, onComplete: {
                        hasSeenLanding = true
                        isFirstLaunch = false
                        setupNotifications()
                    })
                    .environmentObject(themeManager)
                    .transition(.opacity)
                    .zIndex(999)
                } else {
                    MainTabView()
                        .environmentObject(themeManager)
                        .onAppear {
                            gdprManager.checkIfConsentNeeded()
                        }
                        .transition(.opacity)
                    
                    if gdprManager.shouldShowConsent {
                        GDPRConsentView(
                            isPresented: $gdprManager.shouldShowConsent,
                            onAccept: {
                                gdprManager.grantConsent()
                            },
                            onDecline: {
                                gdprManager.declineConsent()
                            }
                        )
                        .environmentObject(themeManager)
                        .transition(.opacity)
                        .zIndex(999)
                    }
                }
            }
        }
    }
    
    private func setupNotifications() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationManager.shared.requestAuthorization()
            NotificationManager.shared.scheduleDailyNotifications()
        }
    }
}
