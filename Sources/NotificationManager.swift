import Foundation
import UserNotifications
import UIKit

class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
        checkAuthorizationStatus()
    }
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if granted {
                    print("✅ Notification permission granted")
                    self?.scheduleDailyNotifications()
                } else {
                    print("❌ Notification permission denied")
                }
                
                if let error = error {
                    print("❌ Notification authorization error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func checkAuthorizationStatus() {
        notificationCenter.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func scheduleDailyNotifications() {
        notificationCenter.getNotificationSettings { [weak self] settings in
            guard settings.authorizationStatus == .authorized else {
                print("❌ Notifications not authorized")
                return
            }
            
            self?.removeAllPendingNotifications()
            self?.scheduleWeeklyNotifications()
        }
    }
    
    private func scheduleWeeklyNotifications() {
        let notifications: [(weekday: Int, title: String, body: String, url: String)] = [
            (2, "Fresh Canada Jobs Available 🇨🇦", "Explore new job opportunities in Canada with visa sponsorship. Start your journey today!", "https://mobileworkvisajobs.pages.dev/jobs/canada"),
            (3, "New UK Jobs for Unskilled Workers 🇬🇧", "Discover unskilled job openings in the UK. No experience required for many positions!", "https://mobileworkvisajobs.pages.dev/jobs/uk"),
            (4, "Visa-Sponsored Jobs in the EU 🇪🇺", "Find visa-sponsored opportunities across Europe. Your dream job awaits in Germany and beyond!", "https://mobileworkvisajobs.pages.dev/jobs/germany"),
            (5, "Latest US Job Openings 🇺🇸", "Check out the newest job listings in the United States with potential visa sponsorship.", "https://mobileworkvisajobs.pages.dev"),
            (6, "New Australian and New Zealand Jobs 🇦🇺🇳🇿", "Explore exciting opportunities in Australia and New Zealand. Apply for jobs down under!", "https://mobileworkvisajobs.pages.dev"),
            (7, "Remote Work Opportunities 💼", "Work from anywhere! Browse remote job listings with flexible locations and visa options.", "https://mobileworkvisajobs.pages.dev"),
            (1, "Job Alerts for High-Demand Sectors 🔥", "Don't miss out on high-demand jobs in healthcare, IT, construction, and more!", "https://mobileworkvisajobs.pages.dev")
        ]
        
        for (index, notification) in notifications.enumerated() {
            scheduleNotification(
                identifier: "daily_job_alert_\(notification.weekday)",
                title: notification.title,
                body: notification.body,
                weekday: notification.weekday,
                hour: 8,
                minute: 30,
                url: notification.url
            )
        }
        
        print("✅ Scheduled \(notifications.count) weekly notifications")
        logPendingNotifications()
    }
    
    private func scheduleNotification(
        identifier: String,
        title: String,
        body: String,
        weekday: Int,
        hour: Int,
        minute: Int,
        url: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        content.userInfo = ["url": url, "type": "daily_job_alert"]
        
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification \(identifier): \(error.localizedDescription)")
            } else {
                print("✅ Scheduled notification: \(identifier) for weekday \(weekday) at \(hour):\(minute)")
            }
        }
    }
    
    func removeAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        print("🗑️ Removed all pending notifications")
    }
    
    func logPendingNotifications() {
        notificationCenter.getPendingNotificationRequests { requests in
            print("📋 Pending notifications: \(requests.count)")
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let nextTriggerDate = trigger.nextTriggerDate() {
                    print("  - \(request.identifier): \(request.content.title) at \(nextTriggerDate)")
                }
            }
        }
    }
    
    func handleNotificationResponse(url: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        if let url = URL(string: url) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if url.absoluteString.contains("mobileworkvisajobs.pages.dev") {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("OpenJobURL"),
                        object: nil,
                        userInfo: ["url": url.absoluteString]
                    )
                } else {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        if let urlString = userInfo["url"] as? String {
            handleNotificationResponse(url: urlString)
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        completionHandler()
    }
}