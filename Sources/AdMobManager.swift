import Foundation
import SwiftUI
import GoogleMobileAdsSwift  // Use the SwiftUI package wrapper

@MainActor
class AdManager: ObservableObject {
    
    static let shared = AdManager()
    
    @Published var showRewardedPrompt = false
    @Published var isInterstitialReady = false
    @Published var isRewardedReady = false
    
    private var interstitial: InterstitialAd?
    private var rewarded: RewardedAd?
    
    private var rewardedTimer: Timer?
    
    private init() {
        setupAds()
    }
    
    // MARK: - Setup Ads
    private func setupAds() {
        // Initialize interstitial & rewarded ads
        loadInterstitial()
        loadRewarded()
        
        // Start rewarded ad prompt timer
        rewardedTimer?.invalidate()
        rewardedTimer = Timer.scheduledTimer(withTimeInterval: 240, repeats: true) { [weak self] _ in
            self?.showRewardedPrompt = true
        }
    }
    
    // MARK: - Interstitial
    func loadInterstitial() {
        interstitial = InterstitialAd(adUnitID: "YOUR_INTERSTITIAL_ID") { [weak self] ready in
            self?.isInterstitialReady = ready
        }
    }
    
    func showInterstitial(from root: UIViewController) {
        guard let interstitial = interstitial, isInterstitialReady else {
            loadInterstitial()
            return
        }
        interstitial.present(from: root) { [weak self] success in
            self?.isInterstitialReady = false
            self?.loadInterstitial()
        }
    }
    
    // MARK: - Rewarded
    func loadRewarded() {
        rewarded = RewardedAd(adUnitID: "YOUR_REWARDED_ID") { [weak self] ready in
            self?.isRewardedReady = ready
        }
    }
    
    func showRewarded(from root: UIViewController, onReward: @escaping () -> Void) {
        guard let rewarded = rewarded, isRewardedReady else {
            loadRewarded()
            return
        }
        rewarded.present(from: root) {
            onReward()
            self.isRewardedReady = false
            self.loadRewarded()
            self.showRewardedPrompt = false
        }
    }
    
    func dismissRewardedPrompt() {
        showRewardedPrompt = false
    }
}
