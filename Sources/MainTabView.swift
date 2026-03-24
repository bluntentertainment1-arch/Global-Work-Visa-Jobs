import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var adManager = AdMobManager.shared
    @State private var selectedTab = 0
    @State private var notificationURL: String?
    @State private var refreshID = UUID()
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    WebJobsView(urlString: notificationURL ?? "https://mobileworkvisajobs.pages.dev", title: "Home", selectedTab: $selectedTab)
                        .id(refreshID)
                case 1:
                    WebJobsView(urlString: "https://mobileworkvisajobs.pages.dev/jobs/canada", title: "Canada Jobs", selectedTab: $selectedTab)
                case 2:
                    WebJobsView(urlString: "https://mobileworkvisajobs.pages.dev/jobs/uk", title: "UK Jobs", selectedTab: $selectedTab)
                case 3:
                    WebJobsView(urlString: "https://mobileworkvisajobs.pages.dev/jobs/germany", title: "Germany Jobs", selectedTab: $selectedTab)
                case 4:
                    AppSettingsView(selectedTab: $selectedTab)
                case 5:
                    WebJobsView(urlString: "https://mobileworkvisajobs.pages.dev/terms", title: "Terms & Conditions", selectedTab: $selectedTab)
                case 6:
                    WebJobsView(urlString: "https://mobileworkvisajobs.pages.dev/blog", title: "Blog and Relocation Resources", selectedTab: $selectedTab)
                case 7:
                    AboutUsView(selectedTab: $selectedTab)
                case 8:
                    AppPrivacyPolicyView(selectedTab: $selectedTab)
                case 9:
                    ContactUsView(selectedTab: $selectedTab)
                case 10:
                    WebJobsView(urlString: "https://mobileworkvisajobs.pages.dev/saved", title: "Saved Jobs", selectedTab: $selectedTab)
                default:
                    WebJobsView(urlString: "https://mobileworkvisajobs.pages.dev", title: "Home", selectedTab: $selectedTab)
                }
            }
            .environmentObject(themeManager)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenJobURL"))) { notification in
                if let urlString = notification.userInfo?["url"] as? String {
                    notificationURL = urlString
                    selectedTab = 0
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RefreshMainScreen"))) { _ in
                refreshID = UUID()
            }
            
            if adManager.showRewardedAdPrompt {
                RewardedAdPromptView()
                    .environmentObject(themeManager)
                    .zIndex(1000)
            }
        }
    }
}