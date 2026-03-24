import SwiftUI

struct RewardedAdPromptView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var adManager = AdMobManager.shared
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        adManager.dismissRewardedPrompt()
                    }
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        themeManager.accentColor.opacity(0.3),
                                        themeManager.accentColor.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 50, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Watch A Short Ad")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(themeManager.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Text("To keep this project alive and free 🚀")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(themeManager.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                adManager.showRewardedAd()
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Watch Ad")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [
                                        themeManager.accentColor,
                                        themeManager.accentColor.opacity(0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(14)
                            .shadow(color: themeManager.accentColor.opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                adManager.dismissRewardedPrompt()
                            }
                        }) {
                            Text("Maybe Later")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(themeManager.secondaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                    }
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.successColor)
                            Text("Supports free access for everyone")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(themeManager.primaryText.opacity(0.8))
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.successColor)
                            Text("Takes only 15-30 seconds")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(themeManager.primaryText.opacity(0.8))
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.successColor)
                            Text("Helps us maintain the app")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(themeManager.primaryText.opacity(0.8))
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(themeManager.cardBackground)
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .transition(.opacity)
        .onAppear {
            isAnimating = true
        }
    }
}