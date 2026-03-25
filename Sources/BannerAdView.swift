import SwiftUI
import UIKit

#if canImport(GoogleMobileAds)
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    
    let adUnitID: String
    
    func makeUIView(context: Context) -> UIView {
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        DispatchQueue.main.async {
            
            let viewWidth = UIScreen.main.bounds.width
            let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
            
            let banner = GADBannerView(adSize: adaptiveSize)
            banner.adUnitID = adUnitID
            banner.rootViewController = getRootViewController()
            banner.delegate = context.coordinator
            
            banner.translatesAutoresizingMaskIntoConstraints = false
            
            containerView.addSubview(banner)
            
            NSLayoutConstraint.activate([
                banner.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                banner.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
            
            print("🎯 Banner initialized with ID: \(adUnitID)")
            
            // Delay load to ensure SwiftUI hierarchy is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let request = GADRequest()
                banner.load(request)
                print("📡 Loading banner ad request")
            }
        }
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No update needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func getRootViewController() -> UIViewController? {
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            
            print("❌ Could not get rootViewController")
            return nil
        }
        
        return root
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        
        var parent: BannerAdView
        
        init(_ parent: BannerAdView) {
            self.parent = parent
        }
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("✅ Banner ad loaded")
            AdMobManager.shared.isBannerLoaded = true
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("❌ Banner failed: \(error.localizedDescription)")
            AdMobManager.shared.isBannerLoaded = false
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            print("📊 Banner impression recorded")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("📱 Banner will present screen")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            print("📱 Banner dismissed screen")
        }
    }
}

#else

// Fallback if GoogleMobileAds SDK is not installed

struct BannerAdView: UIViewRepresentable {
    
    let adUnitID: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray6
        print("⚠️ GoogleMobileAds SDK missing")
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#endif
