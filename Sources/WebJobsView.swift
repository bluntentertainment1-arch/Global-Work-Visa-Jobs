import SwiftUI
import WebKit
import StoreKit
import Combine

struct WebJobsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let urlString: String
    let title: String
    @Binding var selectedTab: Int
    @StateObject private var webViewModel: WebJobsViewModel
    @State private var showMenu = false
    
    init(urlString: String, title: String, selectedTab: Binding<Int>) {
        self.urlString = urlString
        self.title = title
        self._selectedTab = selectedTab
        _webViewModel = StateObject(wrappedValue: WebJobsViewModel(urlString: urlString))
    }
    
    var body: some View {
        ZStack {
            themeManager.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                customNavigationBar
                
                // Use UIViewControllerRepresentable for stable rotation handling
                WebViewContainer(viewModel: webViewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(spacing: 0) {
                    Divider()
                        .background(themeManager.borderColor.opacity(0.3))
                    
                    BannerAdView(adUnitID: AdMobManager.shared.getBannerAdUnitID())
                        .frame(height: 50)
                        .background(themeManager.secondaryBackground)
                }
            }
            
            if webViewModel.showError {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(themeManager.errorColor)
                    
                    Text("Failed to Load Page")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text(webViewModel.errorMessage)
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        webViewModel.reload()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.clockwise")
                            Text("Retry")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(themeManager.accentColor)
                        .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(themeManager.background)
            }
            
            if showMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showMenu = false
                        }
                    }
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        menuDropdown
                            .padding(.top, 60)
                            .padding(.trailing, 16)
                    }
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
    
    private var customNavigationBar: some View {
        HStack(spacing: 16) {
            Button(action: {
                if selectedTab == 0 {
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshMainScreen"), object: nil)
                } else {
                    selectedTab = 0
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Home")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(selectedTab == 0 ? themeManager.accentColor : themeManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedTab == 0 ? themeManager.accentColor.opacity(0.15) : Color.clear)
                )
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMenu.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Text("Main Menu")
                        .font(.system(size: 17, weight: .semibold))
                    Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                        .font(.system(size: 20, weight: .semibold))
                }
                .foregroundColor(showMenu ? themeManager.accentColor : themeManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(showMenu ? themeManager.accentColor.opacity(0.15) : Color.clear)
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(themeManager.secondaryBackground)
                .shadow(color: themeManager.cardShadow.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private var menuDropdown: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "App Features")
            
            MenuItemButton(icon: "gearshape.fill", title: "Settings", isSelected: selectedTab == 4) {
                selectedTab = 4; showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "star.fill", title: "Rate App", isSelected: false) {
                rateApp(); showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "square.and.arrow.up.fill", title: "Share App", isSelected: false) {
                shareApp(); showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "envelope.fill", title: "Contact Us", isSelected: selectedTab == 9) {
                selectedTab = 9; showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "info.circle.fill", title: "About Us", isSelected: selectedTab == 7) {
                selectedTab = 7; showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "lock.shield.fill", title: "Privacy Policy", isSelected: selectedTab == 8) {
                selectedTab = 8; showMenu = false
            }
            
            SectionHeader(title: "Browse Jobs")
            
            MenuItemButton(icon: "briefcase.fill", title: "All Jobs", isSelected: selectedTab == 0) {
                if selectedTab == 0 {
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshMainScreen"), object: nil)
                } else {
                    selectedTab = 0
                }
                showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "bookmark.fill", title: "Saved Jobs", isSelected: selectedTab == 10) {
                selectedTab = 10; showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "flag.fill", title: "Canada Jobs", isSelected: selectedTab == 1) {
                selectedTab = 1; showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "flag.fill", title: "UK Jobs", isSelected: selectedTab == 2) {
                AdMobManager.shared.showInterstitialForMenuItem(menuTitle: "UK Jobs") {
                    selectedTab = 2
                }
                showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "flag.fill", title: "Germany Jobs", isSelected: selectedTab == 3) {
                selectedTab = 3; showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "newspaper.fill", title: "Blog & Resources", isSelected: selectedTab == 6) {
                AdMobManager.shared.showInterstitialForMenuItem(menuTitle: "Blog") {
                    selectedTab = 6
                }
                showMenu = false
            }
            
            Divider().background(themeManager.dividerColor.opacity(0.3))
            
            MenuItemButton(icon: "doc.text.fill", title: "Terms & Conditions", isSelected: selectedTab == 5) {
                selectedTab = 5; showMenu = false
            }
        }
        .frame(width: 240)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.cardBackground)
                .shadow(color: themeManager.cardShadow.opacity(0.2), radius: 12, x: 0, y: 4)
        )
    }
    
    private func shareApp() {
        let appURL = "https://apps.apple.com/app/id123456789"
        let shareText = "Check out Global Work Visa Jobs app! Find international job opportunities with visa sponsorship. \(appURL)"
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

struct MenuItemButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isSelected ? themeManager.accentColor : themeManager.primaryText)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? themeManager.accentColor : themeManager.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(themeManager.accentColor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(isSelected ? themeManager.accentColor.opacity(0.1) : Color.clear)
            )
        }
    }
}

struct SectionHeader: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    
    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(themeManager.secondaryText.opacity(0.7))
                .tracking(1.2)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(themeManager.secondaryBackground.opacity(0.5))
    }
}

// MARK: - Stable WebView Container using UIViewController
struct WebViewContainer: UIViewControllerRepresentable {
    @ObservedObject var viewModel: WebJobsViewModel
    
    func makeUIViewController(context: Context) -> WebViewController {
        let controller = WebViewController()
        controller.viewModel = viewModel
        return controller
    }
    
    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
        // No updates needed - controller handles rotation itself
    }
}

// MARK: - UIViewController that handles rotation properly
class WebViewController: UIViewController {
    var viewModel: WebJobsViewModel?
    private var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView?.navigationDelegate = self
        webView?.allowsBackForwardNavigationGestures = true
        
        // Clip to bounds
        webView?.clipsToBounds = true
        
        // Use safe area
        webView?.scrollView.contentInsetAdjustmentBehavior = .automatic
        
        // Disable zoom
        webView?.scrollView.delegate = self
        webView?.scrollView.minimumZoomScale = 1.0
        webView?.scrollView.maximumZoomScale = 1.0
        webView?.scrollView.bouncesZoom = false
        
        if let webView = webView {
            view.addSubview(webView)
            viewModel?.webView = webView
            viewModel?.load()
        }
    }
    
    // CRITICAL: Handle rotation at UIKit level
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Animate the transition
        coordinator.animate(alongsideTransition: { _ in
            self.webView?.frame = CGRect(origin: .zero, size: size)
        }, completion: { _ in
            // Reset zoom after rotation completes
            self.webView?.scrollView.zoomScale = 1.0
            self.webView?.scrollView.contentOffset = .zero
            
            // Notify website
            self.webView?.evaluateJavaScript("window.dispatchEvent(new Event('resize'));", completionHandler: nil)
        })
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.viewModel?.isLoading = true
            self.viewModel?.showError = false
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.viewModel?.isLoading = false
            self.viewModel?.canGoBack = webView.canGoBack
            self.viewModel?.canGoForward = webView.canGoForward
            
            // Inject viewport if needed
            let script = """
                var meta = document.querySelector('meta[name=viewport]');
                if (!meta) {
                    meta = document.createElement('meta');
                    meta.name = 'viewport';
                    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover';
                    document.getElementsByTagName('head')[0].appendChild(meta);
                }
            """
            webView.evaluateJavaScript(script, completionHandler: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.viewModel?.isLoading = false
            self.viewModel?.showError = true
            self.viewModel?.errorMessage = error.localizedDescription
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.viewModel?.isLoading = false
            self.viewModel?.showError = true
            self.viewModel?.errorMessage = error.localizedDescription
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if url.scheme == "tel" || url.scheme == "mailto" {
            AdMobManager.shared.openExternalURL(url)
            decisionHandler(.cancel)
            return
        }
        
        let hostString = url.host ?? ""
        if !hostString.contains("mobileworkvisajobs.pages.dev") && navigationAction.navigationType == .linkActivated {
            AdMobManager.shared.openExternalURL(url)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}

extension WebViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

// MARK: - ViewModel
class WebJobsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    let urlString: String
    var webView: WKWebView?
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func load() {
        guard let url = URL(string: urlString) else {
            showError = true
            errorMessage = "Invalid URL format"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 30.0
        
        webView?.load(request)
    }
    
    func reload() {
        showError = false
        isLoading = true
        webView?.reload()
    }
    
    func goBack() {
        webView?.goBack()
    }
    
    func goForward() {
        webView?.goForward()
    }
}
