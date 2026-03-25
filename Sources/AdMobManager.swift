import Foundation
import GoogleMobileAds
import UIKit

class AdMobManager: NSObject, ObservableObject {

    static let shared = AdMobManager()

    private var interstitialAd: InterstitialAd?
    private var rewardedAd: RewardedAd?

    override init() {
        super.init()
    }

    // MARK: - Initialize AdMob

    func start() {
        MobileAds.shared.start(completionHandler: nil)
    }

    // MARK: - Load Interstitial

    func loadInterstitial(adUnitID: String) {
        let request = Request()

        InterstitialAd.load(
            with: adUnitID,
            request: request
        ) { [weak self] ad, error in

            if let error = error {
                print("Interstitial failed to load: \(error.localizedDescription)")
                return
            }

            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self

            print("Interstitial loaded")
        }
    }

    // MARK: - Show Interstitial

    func showInterstitial(from viewController: UIViewController) {
        guard let ad = interstitialAd else {
            print("Interstitial not ready")
            return
        }

        ad.present(from: viewController)
    }

    // MARK: - Load Rewarded

    func loadRewarded(adUnitID: String) {
        let request = Request()

        RewardedAd.load(
            with: adUnitID,
            request: request
        ) { [weak self] ad, error in

            if let error = error {
                print("Rewarded failed to load: \(error.localizedDescription)")
                return
            }

            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self

            print("Rewarded loaded")
        }
    }

    // MARK: - Show Rewarded

    func showRewarded(from viewController: UIViewController, rewardHandler: @escaping () -> Void) {

        guard let ad = rewardedAd else {
            print("Rewarded ad not ready")
            return
        }

        ad.present(from: viewController) {
            rewardHandler()
        }
    }
}

// MARK: - FullScreen Delegate

extension AdMobManager: FullScreenContentDelegate {

    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("Ad impression recorded")
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("Ad clicked")
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Ad will present")
    }

    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Ad will dismiss")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Ad dismissed")

        if ad === interstitialAd {
            interstitialAd = nil
        }

        if ad === rewardedAd {
            rewardedAd = nil
        }
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present: \(error.localizedDescription)")
    }
}
