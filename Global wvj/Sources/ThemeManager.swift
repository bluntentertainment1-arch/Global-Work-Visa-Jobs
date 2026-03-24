import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool
    
    init() {
        let savedMode = UserDefaults.standard.object(forKey: "isDarkModeEnabled") as? Bool ?? true
        self.isDarkMode = savedMode
    }
    
    func setDarkMode(_ enabled: Bool) {
        self.isDarkMode = enabled
        UserDefaults.standard.set(enabled, forKey: "isDarkModeEnabled")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = enabled ? .dark : .light
            }
        }
    }
    
    var background: Color {
        isDarkMode ? Color(hex: "#1A1A1F") : Color(hex: "#F8F8F9")
    }
    
    var secondaryBackground: Color {
        isDarkMode ? Color(hex: "#25252D") : Color.white
    }
    
    var primaryText: Color {
        isDarkMode ? Color(hex: "#FFFFFF") : Color(hex: "#3B3B45")
    }
    
    var secondaryText: Color {
        isDarkMode ? Color(hex: "#B0B0B8") : Color(hex: "#6B6B75")
    }
    
    var accentColor: Color {
        Color(hex: "#4A90E2")
    }
    
    var buttonBackground: Color {
        Color(hex: "#4A90E2")
    }
    
    var buttonText: Color {
        Color.white
    }
    
    var navigationText: Color {
        isDarkMode ? Color.white : Color(hex: "#3B3B45")
    }
    
    var borderColor: Color {
        isDarkMode ? Color(hex: "#3B3B45").opacity(0.5) : Color(hex: "#E5E5EA")
    }
    
    var tabBarBackground: Color {
        isDarkMode ? Color(hex: "#25252D") : Color.white
    }
    
    var tabBarSelected: Color {
        Color(hex: "#4A90E2")
    }
    
    var tabBarUnselected: Color {
        isDarkMode ? Color(hex: "#8E8E93") : Color(hex: "#3B3B45").opacity(0.6)
    }
    
    var cardShadow: Color {
        isDarkMode ? Color.black.opacity(0.4) : Color(hex: "#3B3B45").opacity(0.08)
    }
    
    var dividerColor: Color {
        isDarkMode ? Color(hex: "#3B3B45").opacity(0.5) : Color(hex: "#E5E5EA")
    }
    
    var inputBackground: Color {
        isDarkMode ? Color(hex: "#25252D") : Color(hex: "#F5F5F7")
    }
    
    var placeholderText: Color {
        isDarkMode ? Color(hex: "#8E8E93") : Color(hex: "#3B3B45").opacity(0.5)
    }
    
    var successColor: Color {
        Color(hex: "#34C759")
    }
    
    var errorColor: Color {
        Color(hex: "#FF3B30")
    }
    
    var warningColor: Color {
        Color(hex: "#FF9500")
    }
    
    var cardBackground: Color {
        isDarkMode ? Color(hex: "#25252D") : Color.white
    }
    
    var overlayBackground: Color {
        Color.black.opacity(0.5)
    }
    
    var shimmerBase: Color {
        isDarkMode ? Color(hex: "#25252D") : Color(hex: "#E5E5EA")
    }
    
    var shimmerHighlight: Color {
        isDarkMode ? Color(hex: "#3B3B45") : Color.white
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}