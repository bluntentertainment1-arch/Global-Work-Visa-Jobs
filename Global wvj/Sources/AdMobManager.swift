import Foundation
import UIKit
#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

class AdMobManager: NSObject, ObservableObject {
    static let shared = AdMobManager()
    
    @Published var isBannerLoaded = false
    @Published var isInterstitialLoaded = false
    @Published var isRewardedLoaded = false
    @Published var showRewardedAdPrompt = false
    
    private var externalLinkClickCount = 0
    private var shouldShowInterstitial = true
    private var lastFeaturedJobId: String?
    private var shouldShowRewardedForFeaturedJob = false
    private var lastAdActivityTime: Date = Date()
    private var adActivityTimer: Timer?
    private var rewardedAdTimer: Timer?
    private var lastRewardedAdTime: Date?
    
    private let adMobAppID = "ca-app-pub-1819215492028258~8467640467"
    private let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411821905"
    private let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"
    private let adActivityInterval: TimeInterval = 120
    private let rewardedAdInterval: TimeInterval = 240
    
    #if canImport(GoogleMobileAds)
    private var rewardedAd: GADRewardedAd?
    #endif
    
    private override init() {
        super.init()
        initializeAdMob()
        startAdActivityTimer()
        startRewardedAdTimer()
    }
    
    private func initializeAdMob() {
        #if canImport(GoogleMobileAds)
        DispatchQueue.main.async {
            GADMobileAds.sharedInstance().start { status in
                print("✅ AdMob SDK initialized successfully")
                print("Adapter statuses: \(status.adapterStatusesByClassName)")
                self.loadInterstitialAd()
                self.loadRewardedAd()
            }
        }
        #else
        print("⚠️ GoogleMobileAds framework not available")
        #endif
    }
    
    func getBannerAdUnitID() -> String {
        return bannerAdUnitID
    }
    
    func getInterstitialAdUnitID() -> String {
        return interstitialAdUnitID
    }
    
    func getRewardedAdUnitID() -> String {
        return rewardedAdUnitID
    }
    
    private func startAdActivityTimer() {
        adActivityTimer?.invalidate()
        adActivityTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.checkAdActivity()
        }
    }
    
    private func startRewardedAdTimer() {
        rewardedAdTimer?.invalidate()
        rewardedAdTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkRewardedAdTiming()
        }
    }
    
    private func checkRewardedAdTiming() {
        guard let lastTime = lastRewardedAdTime else {
            lastRewardedAdTime = Date()
            return
        }
        
        let timeSinceLastAd = Date().timeIntervalSince(lastTime)
        if timeSinceLastAd >= rewardedAdInterval {
            print("⏰ 4 minutes passed - showing rewarded ad prompt")
            DispatchQueue.main.async {
                self.showRewardedAdPrompt = true
            }
        }
    }
    
    private func checkAdActivity() {
        let timeSinceLastActivity = Date().timeIntervalSince(lastAdActivityTime)
        if timeSinceLastActivity >= adActivityInterval {
            print("No ad activity for 2 minutes - showing interstitial")
            showInterstitialAd()
            resetAdActivityTimer()
        }
    }
    
    private func resetAdActivityTimer() {
        lastAdActivityTime = Date()
    }
    
    func loadInterstitialAd() {
        #if canImport(GoogleMobileAds)
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: interstitialAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("❌ Failed to load interstitial ad: \(error.localizedDescription)")
                self?.isInterstitialLoaded = false
                return
            }
            print("✅ Interstitial ad loaded successfully")
            self?.isInterstitialLoaded = true
        }
        #else
        print("AdMob framework not available - interstitial ad loading disabled")
        isInterstitialLoaded = false
        #endif
    }
    
    func loadRewardedAd() {
        #if canImport(GoogleMobileAds)
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: rewardedAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("❌ Failed to load rewarded ad: \(error.localizedDescription)")
                self?.isRewardedLoaded = false
                self?.rewardedAd = nil
                return
            }
            print("✅ Rewarded ad loaded successfully")
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.isRewardedLoaded = true
        }
        #else
        print("AdMob framework not available - rewarded ad loading disabled")
        isRewardedLoaded = false
        #endif
    }
    
    func handleExternalLinkClick() {
        resetAdActivityTimer()
        showInterstitialAd()
    }
    
    func handleFeaturedJobTap(jobId: String) {
        resetAdActivityTimer()
        lastFeaturedJobId = jobId
        shouldShowRewardedForFeaturedJob = true
    }
    
    func handleApplyButtonTap(jobId: String) {
        resetAdActivityTimer()
        if shouldShowRewardedForFeaturedJob && lastFeaturedJobId == jobId {
            showRewardedAd()
            shouldShowRewardedForFeaturedJob = false
            lastFeaturedJobId = nil
        }
    }
    
    func showInterstitialForBlog() {
        resetAdActivityTimer()
        showInterstitialAd()
    }
    
    private func showInterstitialAd() {
        resetAdActivityTimer()
        #if canImport(GoogleMobileAds)
        guard isInterstitialLoaded else {
            print("⚠️ Interstitial ad not loaded yet")
            loadInterstitialAd()
            return
        }
        
        guard let rootViewController = getRootViewController() else {
            print("❌ Could not get root view controller")
            return
        }
        
        print("📺 Showing interstitial ad")
        loadInterstitialAd()
        #else
        print("AdMob framework not available - interstitial ad display disabled")
        #endif
    }
    
    func showRewardedAd() {
        #if canImport(GoogleMobileAds)
        guard let rewardedAd = rewardedAd else {
            print("⚠️ Rewarded ad not loaded yet")
            loadRewardedAd()
            return
        }
        
        guard let rootViewController = getRootViewController() else {
            print("❌ Could not get root view controller")
            return
        }
        
        print("🎁 Showing rewarded ad")
        rewardedAd.present(fromRootViewController: rootViewController) {
            let reward = rewardedAd.adReward
            print("🎉 User earned reward: \(reward.amount) \(reward.type)")
        }
        #else
        print("AdMob framework not available - rewarded ad display disabled")
        #endif
    }
    
    func dismissRewardedPrompt() {
        DispatchQueue.main.async {
            self.showRewardedAdPrompt = false
            self.lastRewardedAdTime = Date()
        }
    }
    
    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return nil
        }
        return rootViewController
    }
    
    deinit {
        adActivityTimer?.invalidate()
        rewardedAdTimer?.invalidate()
    }
}

#if canImport(GoogleMobileAds)
extension AdMobManager: GADFullScreenContentDelegate {
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("📊 Rewarded ad recorded impression")
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Rewarded ad failed to present: \(error.localizedDescription)")
        loadRewardedAd()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("📱 Rewarded ad will present")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("📱 Rewarded ad dismissed")
        dismissRewardedPrompt()
        loadRewardedAd()
    }
}
#endif