import SwiftUI

struct ModernJobDetailsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    let job: Job
    @State private var showApplyWebView = false
    @State private var scrollOffset: CGFloat = 0
    
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
                    VStack(spacing: 0) {
                        headerSection
                        
                        contentSection
                    }
                }
                
                VStack {
                    Spacer()
                    applyButton
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(themeManager.secondaryBackground.opacity(0.9))
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(themeManager.primaryText)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        shareJob()
                    }) {
                        ZStack {
                            Circle()
                                .fill(themeManager.secondaryBackground.opacity(0.9))
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(themeManager.primaryText)
                        }
                    }
                }
            }
            .sheet(isPresented: $showApplyWebView) {
                JobApplyWebView(job: job)
                    .environmentObject(themeManager)
            }
        }
        .tint(themeManager.navigationText)
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: job.featured ? 
                                [themeManager.warningColor.opacity(0.2), themeManager.warningColor.opacity(0.1)] :
                                [themeManager.accentColor.opacity(0.2), themeManager.accentColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: job.featured ? "star.fill" : "briefcase.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(job.featured ? themeManager.warningColor : themeManager.accentColor)
            }
            .shadow(color: (job.featured ? themeManager.warningColor : themeManager.accentColor).opacity(0.2), radius: 12, x: 0, y: 6)
            
            VStack(spacing: 12) {
                if job.featured {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                        Text("FEATURED JOB")
                            .font(.system(size: 13, weight: .bold))
                            .tracking(1)
                    }
                    .foregroundColor(themeManager.warningColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(themeManager.warningColor.opacity(0.15))
                    )
                }
                
                Text(job.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(themeManager.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                HStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 14))
                        Text(job.category)
                            .font(.system(size: 15, weight: .medium))
                    }
                    
                    Circle()
                        .fill(themeManager.secondaryText.opacity(0.5))
                        .frame(width: 4, height: 4)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 14))
                        Text(job.location)
                            .font(.system(size: 15, weight: .medium))
                    }
                }
                .foregroundColor(themeManager.secondaryText)
            }
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 20)
    }
    
    private var contentSection: some View {
        VStack(spacing: 20) {
            quickInfoCards
            
            descriptionCard
            
            additionalInfoCard
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
    
    private var quickInfoCards: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                InfoCard(
                    icon: "flag.fill",
                    title: "Country",
                    value: job.country,
                    color: themeManager.accentColor
                )
                
                if !job.salary.isEmpty {
                    InfoCard(
                        icon: "dollarsign.circle.fill",
                        title: "Salary",
                        value: job.salary,
                        color: themeManager.successColor
                    )
                }
            }
            
            if !job.visaTag.isEmpty {
                InfoCard(
                    icon: "doc.text.fill",
                    title: "Visa Type",
                    value: job.visaTag,
                    color: themeManager.warningColor,
                    fullWidth: true
                )
            }
        }
    }
    
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 18))
                    .foregroundColor(themeManager.accentColor)
                
                Text("Job Description")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(themeManager.primaryText)
            }
            
            Text(job.description)
                .font(.system(size: 16))
                .foregroundColor(themeManager.primaryText.opacity(0.85))
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.cardBackground)
                .shadow(color: themeManager.cardShadow.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
    
    private var additionalInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(themeManager.accentColor)
                
                Text("Additional Information")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(themeManager.primaryText)
            }
            
            VStack(spacing: 12) {
                InfoRow(icon: "calendar", title: "Posted", value: formatDate(job.dateAdded))
                InfoRow(icon: "mappin.circle", title: "Location", value: job.location)
                InfoRow(icon: "building.2", title: "Category", value: job.category)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.cardBackground)
                .shadow(color: themeManager.cardShadow.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
    
    private var applyButton: some View {
        Button(action: {
            showApplyWebView = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Apply Now")
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [themeManager.accentColor, themeManager.accentColor.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: themeManager.accentColor.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(
            LinearGradient(
                colors: [themeManager.background.opacity(0), themeManager.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
        )
    }
    
    private func shareJob() {
        let text = "Check out this job opportunity: \(job.title) in \(job.location). Apply here: \(job.applyUrl)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct InfoCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let value: String
    let color: Color
    var fullWidth: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(themeManager.secondaryText)
            }
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(themeManager.primaryText)
                .lineLimit(2)
        }
        .frame(maxWidth: fullWidth ? .infinity : nil, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.cardBackground)
                .shadow(color: themeManager.cardShadow.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

struct InfoRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.accentColor.opacity(0.12))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(themeManager.accentColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(themeManager.secondaryText)
                
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(themeManager.primaryText)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.secondaryBackground.opacity(0.5))
        )
    }
}