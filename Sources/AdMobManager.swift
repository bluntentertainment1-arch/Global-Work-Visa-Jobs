import Foundation
import UIKit
import SwiftUI
import GoogleMobileAds

class AdMobManager: NSObject, ObservableObject {

    static let shared = AdMobManager()

    @Published var isBannerLoaded = false
    @Published var isInterstitialLoaded = false
    @Published var isRewardedLoaded = false
    @Published var showRewardedAdPrompt = false

    private let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    private let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"

    private var interstitialAd: InterstitialAd?
    private var rewardedAd: RewardedAd?

    private var rewardedAdTimer: Timer?
    private var lastRewardedAdTime: Date?

    private override init() {
        super.init()
        startAdMob()
    }

    // MARK: - Start AdMob

    private func startAdMob() {

        MobileAds.shared.start { status in
            print("✅ AdMob started")
            print(status.adapterStatusesByClassName)
        }

        loadInterstitialAd()
        loadRewardedAd()
        startRewardedAdTimer()
    }

    // MARK: - Banner

    func getBannerAdUnitID() -> String {
        bannerAdUnitID
    }

    // MARK: - Interstitial

    func loadInterstitialAd() {

        let request = Request()

        InterstitialAd.load(
            withAdUnitID: interstitialAdUnitID,
            request: request
        ) { [weak self] ad, error in

            if let error = error {
                print("❌ Interstitial failed: \(error.localizedDescription)")
                self?.isInterstitialLoaded = false
                return
            }

            print("✅ Interstitial loaded")

            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            self?.isInterstitialLoaded = true
        }
    }

    func showInterstitialAd() {

        guard let ad = interstitialAd else {
            print("⚠️ Interstitial not ready")
            loadInterstitialAd()
            return
        }

        guard let root = getRootViewController() else {
            print("❌ Root VC missing")
            return
        }

        ad.present(fromRootViewController: root)
    }

    func handleExternalLinkClick() {
        showInterstitialAd()
    }

    // MARK: - Rewarded

    func loadRewardedAd() {

        let request = Request()

        RewardedAd.load(
            withAdUnitID: rewardedAdUnitID,
            request: request
        ) { [weak self] ad, error in

            if let error = error {
                print("❌ Rewarded failed: \(error.localizedDescription)")
                self?.isRewardedLoaded = false
                return
            }

            print("✅ Rewarded loaded")

            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.isRewardedLoaded = true
        }
    }

    func showRewardedAd() {

        guard let ad = rewardedAd else {
            print("⚠️ Rewarded not ready")
            loadRewardedAd()
            return
        }

        guard let root = getRootViewController() else {
            print("❌ Root VC missing")
            return
        }

        ad.present(fromRootViewController: root) {

            let reward = ad.adReward
            print("🎁 Reward earned: \(reward.amount) \(reward.type)")
        }
    }

    // MARK: - Rewarded Prompt Timer

    private func startRewardedAdTimer() {

        rewardedAdTimer?.invalidate()

        rewardedAdTimer = Timer.scheduledTimer(
            withTimeInterval: 240,
            repeats: true
        ) { [weak self] _ in

            DispatchQueue.main.async {
                print("⏰ Showing rewarded prompt")
                self?.showRewardedAdPrompt = true
            }
        }
    }

    func dismissRewardedPrompt() {

        DispatchQueue.main.async {
            self.showRewardedAdPrompt = false
            self.lastRewardedAdTime = Date()
        }
    }

    // MARK: - Root Controller

    private func getRootViewController() -> UIViewController? {

        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else {
            return nil
        }

        return root
    }
}

extension AdMobManager: FullScreenContentDelegate {

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("📺 Ad will present")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {

        print("📉 Ad dismissed")

        if ad === interstitialAd {
            interstitialAd = nil
            loadInterstitialAd()
        }

        if ad === rewardedAd {
            rewardedAd = nil
            loadRewardedAd()
            dismissRewardedPrompt()
        }
    }

    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {

        print("❌ Failed to present ad: \(error.localizedDescription)")

        if ad === interstitialAd {
            loadInterstitialAd()
        }

        if ad === rewardedAd {
            loadRewardedAd()
        }
    }
}
