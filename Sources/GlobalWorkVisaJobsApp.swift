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
    @State private var showSplash = true
    
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
                                    isFirstLaunch = false
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        NotificationManager.shared.requestAuthorization()
                                        NotificationManager.shared.scheduleDailyNotifications()
                                    }
                                }
                            }
                        }
                        .transition(.opacity)
                        .zIndex(1000)
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
}