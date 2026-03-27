import SwiftUI
import WebKit
import StoreKit

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
                
                ZStack {
                    
                    if webViewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.2)
                            .tint(themeManager.accentColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    WebJobsContentView(viewModel: webViewModel)
                        .opacity(webViewModel.isLoading ? 0 : 1)
                }
                
                VStack(spacing: 0) {
                    
                    Divider()
                        .background(themeManager.borderColor.opacity(0.3))
                    
                    BannerAdView(adUnitID: AdMobManager.shared.getBannerAdUnitID())
                        .frame(minHeight: 50)
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
                    
                    Button {
                        webViewModel.reload()
                    } label: {
                        
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
                        withAnimation {
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
            }
        }
        .safeAreaInset(edge: .top) {
            customNavigationBar
        }
    }
    
    private var customNavigationBar: some View {
        
        HStack(spacing: 16) {
            
            Button {
                
                if selectedTab == 0 {
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshMainScreen"), object: nil)
                } else {
                    selectedTab = 0
                }
                
            } label: {
                
                HStack(spacing: 8) {
                    
                    Image(systemName: "house.fill")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text("Home")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(selectedTab == 0 ? themeManager.accentColor : themeManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    showMenu.toggle()
                }
            } label: {
                
                HStack(spacing: 8) {
                    
                    Text("Main Menu")
                        .font(.system(size: 17, weight: .semibold))
                    
                    Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                        .font(.system(size: 20, weight: .semibold))
                }
                .foregroundColor(showMenu ? themeManager.accentColor : themeManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(themeManager.secondaryBackground)
    }
    
    private var menuDropdown: some View {
        
        VStack(spacing: 0) {
            
            SectionHeader(title: "App Features")
            
            MenuItemButton(icon: "gearshape.fill", title: "Settings", isSelected: selectedTab == 4) {
                selectedTab = 4
                showMenu = false
            }
            
            Divider()
            
            MenuItemButton(icon: "star.fill", title: "Rate App", isSelected: false) {
                rateApp()
                showMenu = false
            }
            
            Divider()
            
            MenuItemButton(icon: "square.and.arrow.up.fill", title: "Share App", isSelected: false) {
                shareApp()
                showMenu = false
            }
            
            Divider()
            
            MenuItemButton(icon: "envelope.fill", title: "Contact Us", isSelected: selectedTab == 9) {
                selectedTab = 9
                showMenu = false
            }
            
            Divider()
            
            MenuItemButton(icon: "info.circle.fill", title: "About Us", isSelected: selectedTab == 7) {
                selectedTab = 7
                showMenu = false
            }
            
            Divider()
            
            MenuItemButton(icon: "lock.shield.fill", title: "Privacy Policy", isSelected: selectedTab == 8) {
                selectedTab = 8
                showMenu = false
            }
            
            SectionHeader(title: "Browse Jobs")
            
            MenuItemButton(icon: "briefcase.fill", title: "All Jobs", isSelected: selectedTab == 0) {
                selectedTab = 0
                showMenu = false
            }
            
            Divider()
            
            MenuItemButton(icon: "flag.fill", title: "Canada Jobs", isSelected: selectedTab == 1) {
                selectedTab = 1
                showMenu = false
            }
            
            Divider()
            
            MenuItemButton(icon: "flag.fill", title: "UK Jobs", isSelected: selectedTab == 2) {
                selectedTab = 2
                showMenu = false
            }
            
            Divider()
            
            MenuItemButton(icon: "flag.fill", title: "Germany Jobs", isSelected: selectedTab == 3) {
                selectedTab = 3
                showMenu = false
            }
        }
        .frame(width: 240)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.cardBackground)
        )
    }
    
    private func shareApp() {
        
        let url = "https://apps.apple.com/app/id123456789"
        let text = "Check out Global Work Visa Jobs: \(url)"
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func rateApp() {
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
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
                    .frame(width: 24)
                
                Text(title)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
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
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

class WebJobsViewModel: ObservableObject {
    
    @Published var isLoading = true
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
            errorMessage = "Invalid URL"
            return
        }
        
        webView?.load(URLRequest(url: url))
    }
    
    func reload() {
        showError = false
        webView?.reload()
    }
}

struct WebJobsContentView: UIViewRepresentable {
    
    @ObservedObject var viewModel: WebJobsViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        let config = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        webView.navigationDelegate = context.coordinator
        
        webView.allowsBackForwardNavigationGestures = true
        
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        
        viewModel.webView = webView
        
        viewModel.load()
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        var parent: WebJobsContentView
        
        let allowedDomains = [
            "mobileworkvisajobs.pages.dev"
        ]
        
        init(_ parent: WebJobsContentView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            
            DispatchQueue.main.async {
                self.parent.viewModel.isLoading = true
                self.parent.viewModel.showError = false
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
            DispatchQueue.main.async {
                self.parent.viewModel.isLoading = false
            }
            
            let viewportScript =
            """
            (function() {
                var meta = document.querySelector('meta[name=viewport]');
                if(!meta){
                    meta = document.createElement('meta');
                    meta.name='viewport';
                    meta.content='width=device-width, initial-scale=1.0, viewport-fit=cover';
                    document.head.appendChild(meta);
                }
            })();
            """
            
            webView.evaluateJavaScript(viewportScript)
        }
        
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            
            let host = url.host ?? ""
            
            if allowedDomains.contains(where: { host.contains($0) }) {
                decisionHandler(.allow)
            } else {
                AdMobManager.shared.openExternalURL(url)
                decisionHandler(.cancel)
            }
        }
    }
}
