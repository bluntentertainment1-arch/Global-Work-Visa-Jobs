import Foundation
import CoreLocation

class GDPRConsentManager: ObservableObject {
    static let shared = GDPRConsentManager()
    
    @Published var shouldShowConsent = false
    @Published var hasUserConsented = false
    @Published var isEUorUKUser = false
    
    private let consentKey = "gdpr_consent_given"
    private let consentVersionKey = "gdpr_consent_version"
    private let currentConsentVersion = "1.0"
    private let isEUorUKKey = "is_eu_or_uk_user"
    private let hasCheckedLocationKey = "has_checked_location"
    
    private let euCountryCodes: Set<String> = [
        "AT", "BE", "BG", "HR", "CY", "CZ", "DK", "EE", "FI", "FR",
        "DE", "GR", "HU", "IE", "IT", "LV", "LT", "LU", "MT", "NL",
        "PL", "PT", "RO", "SK", "SI", "ES", "SE", "GB", "UK"
    ]
    
    private init() {
        loadConsentStatus()
    }
    
    func checkIfConsentNeeded() {
        let hasCheckedLocation = UserDefaults.standard.bool(forKey: hasCheckedLocationKey)
        
        if !hasCheckedLocation {
            detectUserLocation()
        } else {
            let savedIsEUorUK = UserDefaults.standard.bool(forKey: isEUorUKKey)
            isEUorUKUser = savedIsEUorUK
            
            if isEUorUKUser {
                checkConsentStatus()
            }
        }
    }
    
    private func detectUserLocation() {
        if let regionCode = Locale.current.region?.identifier {
            print("📍 Detected region code: \(regionCode)")
            
            let isEUorUK = euCountryCodes.contains(regionCode)
            self.isEUorUKUser = isEUorUK
            
            UserDefaults.standard.set(isEUorUK, forKey: isEUorUKKey)
            UserDefaults.standard.set(true, forKey: hasCheckedLocationKey)
            
            if isEUorUK {
                print("✅ EU/UK user detected - GDPR consent required")
                checkConsentStatus()
            } else {
                print("ℹ️ Non-EU/UK user - GDPR consent not required")
            }
        } else {
            print("⚠️ Could not detect region - defaulting to show consent")
            self.isEUorUKUser = true
            UserDefaults.standard.set(true, forKey: isEUorUKKey)
            UserDefaults.standard.set(true, forKey: hasCheckedLocationKey)
            checkConsentStatus()
        }
    }
    
    private func checkConsentStatus() {
        let hasConsented = UserDefaults.standard.bool(forKey: consentKey)
        let savedVersion = UserDefaults.standard.string(forKey: consentVersionKey)
        
        if !hasConsented || savedVersion != currentConsentVersion {
            print("🔔 Showing GDPR consent dialog")
            DispatchQueue.main.async {
                self.shouldShowConsent = true
            }
        } else {
            print("✅ User has already consented to version \(currentConsentVersion)")
            DispatchQueue.main.async {
                self.hasUserConsented = true
            }
        }
    }
    
    func grantConsent() {
        UserDefaults.standard.set(true, forKey: consentKey)
        UserDefaults.standard.set(currentConsentVersion, forKey: consentVersionKey)
        hasUserConsented = true
        print("✅ User granted GDPR consent")
    }
    
    func declineConsent() {
        UserDefaults.standard.set(false, forKey: consentKey)
        UserDefaults.standard.set(currentConsentVersion, forKey: consentVersionKey)
        hasUserConsented = false
        print("❌ User declined GDPR consent")
    }
    
    func withdrawConsent() {
        UserDefaults.standard.set(false, forKey: consentKey)
        UserDefaults.standard.removeObject(forKey: consentVersionKey)
        hasUserConsented = false
        shouldShowConsent = true
        print("🔄 User withdrew GDPR consent")
    }
    
    private func loadConsentStatus() {
        let hasConsented = UserDefaults.standard.bool(forKey: consentKey)
        let savedVersion = UserDefaults.standard.string(forKey: consentVersionKey)
        
        if hasConsented && savedVersion == currentConsentVersion {
            hasUserConsented = true
        }
        
        let savedIsEUorUK = UserDefaults.standard.bool(forKey: isEUorUKKey)
        isEUorUKUser = savedIsEUorUK
    }
    
    func resetForTesting() {
        UserDefaults.standard.removeObject(forKey: consentKey)
        UserDefaults.standard.removeObject(forKey: consentVersionKey)
        UserDefaults.standard.removeObject(forKey: isEUorUKKey)
        UserDefaults.standard.removeObject(forKey: hasCheckedLocationKey)
        hasUserConsented = false
        shouldShowConsent = false
        isEUorUKUser = false
        print("🔄 GDPR consent data reset for testing")
    }
}