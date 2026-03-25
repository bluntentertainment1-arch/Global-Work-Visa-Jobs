import SwiftUI

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

struct BannerAdContainerView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let adUnitID: String
    var height: CGFloat = 50
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(themeManager.borderColor.opacity(0.3))
            
            BannerAdView(adUnitID: adUnitID)
                .frame(height: height)
                .background(themeManager.secondaryBackground)
        }
    }
}

struct AdaptiveBannerAdContainerView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let adUnitID: String
    @State private var bannerHeight: CGFloat = 50
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(themeManager.borderColor.opacity(0.3))
            
            BannerAdView(adUnitID: adUnitID)
                .frame(height: bannerHeight)
                .background(themeManager.secondaryBackground)
                .onAppear {
                    calculateBannerHeight()
                }
        }
    }
    
    private func calculateBannerHeight() {
        #if canImport(GoogleMobileAds)
        let frame = UIScreen.main.bounds
        let viewWidth = frame.size.width
        let adaptiveSize = currentOrientationAnchoredAdaptiveBanner(width: viewWidth)
        bannerHeight = adaptiveSize.size.height
        #endif
    }
}

struct StickyBannerAdView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let adUnitID: String
    var position: BannerPosition = .bottom
    
    enum BannerPosition {
        case top
        case bottom
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if position == .top {
                BannerAdContainerView(adUnitID: adUnitID)
                    .shadow(color: themeManager.cardShadow.opacity(0.1), radius: 4, x: 0, y: 2)
                Spacer()
            } else {
                Spacer()
                BannerAdContainerView(adUnitID: adUnitID)
                    .shadow(color: themeManager.cardShadow.opacity(0.1), radius: 4, x: 0, y: -2)
            }
        }
        .ignoresSafeArea(edges: position == .bottom ? .bottom : .top)
    }
}
