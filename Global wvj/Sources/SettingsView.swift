import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showPrivacyPolicy = false
    @State private var showAbout = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        themeManager.background,
                        themeManager.secondaryBackground.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        legalSection
                        
                        appInfoSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView()
                    .environmentObject(themeManager)
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
                    .environmentObject(themeManager)
            }
        }
        .tint(themeManager.navigationText)
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [themeManager.accentColor, themeManager.accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.white)
            }
            .shadow(color: themeManager.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
            
            Text("App Settings")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(themeManager.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    
    private var legalSection: some View {
        VStack(spacing: 12) {
            Text("Legal & Privacy")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SettingsButton(
                icon: "lock.shield.fill",
                title: "Privacy Policy",
                subtitle: "How we protect your data",
                action: {
                    showPrivacyPolicy = true
                }
            )
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 12) {
            Text("About")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SettingsButton(
                icon: "info.circle.fill",
                title: "About App",
                subtitle: "Version and information",
                action: {
                    showAbout = true
                }
            )
        }
    }
}

struct SettingsButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [themeManager.accentColor.opacity(0.2), themeManager.accentColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(themeManager.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(themeManager.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(themeManager.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.cardBackground)
                    .shadow(color: themeManager.cardShadow.opacity(0.08), radius: 8, x: 0, y: 4)
            )
        }
    }
}

struct AboutView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        themeManager.background,
                        themeManager.secondaryBackground.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [themeManager.accentColor.opacity(0.2), themeManager.accentColor.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "globe.americas.fill")
                            .font(.system(size: 50, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Work Visa Jobs")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(themeManager.primaryText)
                        
                        Text("Version 1.0.0")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(themeManager.secondaryText)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Find global job opportunities")
                            .font(.system(size: 16))
                            .foregroundColor(themeManager.primaryText)
                        
                        Text("with visa sponsorship")
                            .font(.system(size: 16))
                            .foregroundColor(themeManager.primaryText)
                    }
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Text("© 2025 Work Visa Jobs. All rights reserved.")
                        .font(.system(size: 13))
                        .foregroundColor(themeManager.secondaryText)
                        .padding(.bottom, 32)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                            Text("Close")
                        }
                        .foregroundColor(themeManager.secondaryText)
                    }
                }
            }
        }
        .tint(themeManager.navigationText)
    }
}