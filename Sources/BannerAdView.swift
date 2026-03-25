import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {

    let adUnitID: String

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView()

        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController

        let width = UIScreen.main.bounds.width
        banner.adSize = currentOrientationAnchoredAdaptiveBanner(width: width)

        banner.delegate = context.coordinator
        banner.load(Request())

        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, BannerViewDelegate {

        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("AdMob banner loaded")
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("AdMob banner failed: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: BannerView) {
            print("AdMob impression recorded")
        }

        func bannerViewWillPresentScreen(_ bannerView: BannerView) {
            print("AdMob will present screen")
        }

        func bannerViewWillDismissScreen(_ bannerView: BannerView) {
            print("AdMob will dismiss screen")
        }

        func bannerViewDidDismissScreen(_ bannerView: BannerView) {
            print("AdMob dismissed screen")
        }
    }
}
