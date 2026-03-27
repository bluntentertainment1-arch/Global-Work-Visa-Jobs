import UIKit
import GoogleMobileAds
import AppTrackingTransparency

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Request ATT permission first, then initialize AdMob
        requestTrackingPermission()
        
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    // MARK: - ATT Permission & AdMob Init
    
    private func requestTrackingPermission() {
        // Wait a moment for the app to fully launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        print("✅ Tracking authorized")
                    case .denied:
                        print("❌ Tracking denied")
                    case .notDetermined:
                        print("⚠️ Tracking not determined")
                    case .restricted:
                        print("⚠️ Tracking restricted")
                    @unknown default:
                        break
                    }
                    
                    // Initialize AdMob AFTER ATT response
                    self?.initializeAdMob()
                }
            }
        }
    }
    
    private func initializeAdMob() {
        MobileAds.shared.start { status in
            print("✅ AdMob SDK started")
            print(status.adapterStatusesByClassName)
        }
    }
}
