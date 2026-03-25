import Foundation
import SwiftUI
import UIKit
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
    private var interstitialCompletion: (() -> Void)?

    private override init() {
        super.init()
        startAdMob()
    }

    private func startAdMob() {
        MobileAds.shared.start { status in
            print("✅ AdMob started")
        }
        loadInterstitialAd()
        loadRewardedAd()
        startRewardedAdTimer()
    }

    // MARK: - Banner
    func getBannerAdUnitID() -> String { bannerAdUnitID }

    // MARK: - Interstitial
    func loadInterstitialAd() {
        let request = Request()
        InterstitialAd.load(with: interstitialAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("❌ Interstitial failed: \(error)")
                self?.isInterstitialLoaded = false
                return
            }
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            self?.isInterstitialLoaded = true
        }
    }

    func showInterstitialAd(completion: (() -> Void)? = nil) {
        guard let ad = interstitialAd else {
            print("⚠️ Interstitial not ready")
            completion?()
            loadInterstitialAd()
            return
        }
        guard let root = getRootViewController() else {
            print("❌ Root VC missing")
            completion?()
            return
        }
        interstitialCompletion = completion
        ad.present(from: root)
    }

    // MARK: - Universal External Link Handler
    func openExternalURL(_ url: URL, completion: (() -> Void)? = nil) {
        showInterstitialAd {
            UIApplication.shared.open(url) { _ in
                completion?()
            }
        }
    }

    // MARK: - Rewarded
    func loadRewardedAd() {
        let request = Request()
        RewardedAd.load(with: rewardedAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("❌ Rewarded failed: \(error)")
                self?.isRewardedLoaded = false
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.isRewardedLoaded = true
        }
    }

    private func startRewardedAdTimer() {
        rewardedAdTimer?.invalidate()
        rewardedAdTimer = Timer.scheduledTimer(withTimeInterval: 240, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.showRewardedAdPrompt = true
            }
        }
    }

    private func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else { return nil }
        return root
    }
}

extension AdMobManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        if ad === interstitialAd {
            interstitialAd = nil
            interstitialCompletion?()
            interstitialCompletion = nil
            loadInterstitialAd()
        }
        if ad === rewardedAd {
            rewardedAd = nil
            loadRewardedAd()
        }
    }
}
