import SwiftUI
import UIKit

#if canImport(GoogleMobileAds)
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String
    @State private var bannerView: GADBannerView?
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        DispatchQueue.main.async {
            let banner = GADBannerView(adSize: GADAdSizeBanner)
            banner.adUnitID = adUnitID
            banner.rootViewController = getRootViewController()
            banner.delegate = context.coordinator
            
            banner.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(banner)
            
            NSLayoutConstraint.activate([
                banner.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                banner.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                banner.widthAnchor.constraint(equalToConstant: GADAdSizeBanner.size.width),
                banner.heightAnchor.constraint(equalToConstant: GADAdSizeBanner.size.height)
            ])
            
            let request = GADRequest()
            banner.load(request)
            
            print("🎯 Banner ad initialized with ID: \(adUnitID)")
            print("🎯 Banner size: \(GADAdSizeBanner.size)")
        }
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            print("❌ Could not get root view controller")
            return nil
        }
        return rootViewController
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        var parent: BannerAdView
        
        init(_ parent: BannerAdView) {
            self.parent = parent
        }
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("✅ Banner ad loaded successfully")
            print("✅ Banner frame: \(bannerView.frame)")
            AdMobManager.shared.isBannerLoaded = true
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("❌ Banner ad failed to load: \(error.localizedDescription)")
            AdMobManager.shared.isBannerLoaded = false
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            print("📊 Banner ad impression recorded")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("📱 Banner ad will present screen")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            print("📱 Banner ad will dismiss screen")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            print("📱 Banner ad dismissed screen")
        }
    }
}

#else

struct GADAdSize {
    static let banner = GADAdSize()
    var size: CGSize { CGSize(width: 320, height: 50) }
}

class GADRequest {
    init() {}
}

protocol GADBannerViewDelegate: AnyObject {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView)
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error)
}

class GADBannerView: UIView {
    var adUnitID: String?
    var rootViewController: UIViewController?
    weak var delegate: GADBannerViewDelegate?
    init(adSize: GADAdSize) { 
        super.init(frame: .zero)
        self.backgroundColor = .systemGray6
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func load(_ request: GADRequest) {
        print("⚠️ GoogleMobileAds not available - banner ad will not load")
    }
}

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: BannerAdView
        init(_ parent: BannerAdView) {
            self.parent = parent
        }
    }
}

#endif