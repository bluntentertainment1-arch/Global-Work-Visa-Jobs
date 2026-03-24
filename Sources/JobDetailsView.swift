import SwiftUI

struct JobDetailsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    let job: Job
    @State private var showingRedirectMessage = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if job.featured {
                            HStack {
                                Image(systemName: "star.fill")
                                Text("FEATURED JOB")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(themeManager.accentColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(themeManager.accentColor.opacity(0.2))
                            .cornerRadius(20)
                        }
                        
                        Text(job.title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(themeManager.primaryText)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "tag")
                                    .foregroundColor(themeManager.accentColor)
                                Text(job.category)
                                    .font(.system(size: 16))
                                    .foregroundColor(themeManager.primaryText)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "mappin.circle")
                                    .foregroundColor(themeManager.accentColor)
                                Text(job.location)
                                    .font(.system(size: 16))
                                    .foregroundColor(themeManager.primaryText)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "flag")
                                    .foregroundColor(themeManager.accentColor)
                                Text(job.country)
                                    .font(.system(size: 16))
                                    .foregroundColor(themeManager.primaryText)
                            }
                            
                            if !job.salary.isEmpty {
                                HStack(spacing: 8) {
                                    Image(systemName: "dollarsign.circle")
                                        .font(.system(size: 14))
                                    Text(job.salary)
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .foregroundColor(themeManager.successColor)
                            }
                            
                            if !job.visaTag.isEmpty {
                                HStack(spacing: 8) {
                                    Image(systemName: "doc.text")
                                        .foregroundColor(themeManager.accentColor)
                                    Text(job.visaTag)
                                        .font(.system(size: 16))
                                        .foregroundColor(themeManager.primaryText)
                                }
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "calendar")
                                    .foregroundColor(themeManager.secondaryText)
                                Text("Posted: \(formatDate(job.dateAdded))")
                                    .font(.system(size: 14))
                                    .foregroundColor(themeManager.secondaryText)
                            }
                        }
                        .padding()
                        .background(themeManager.secondaryBackground)
                        .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(themeManager.primaryText)
                            
                            Text(job.description)
                                .font(.system(size: 16))
                                .foregroundColor(themeManager.primaryText)
                                .lineSpacing(4)
                        }
                        
                        Button(action: {
                            if job.featured {
                                AdMobManager.shared.handleApplyButtonTap(jobId: job.id)
                            }
                            openInSystemBrowser()
                        }) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("Apply Now")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }
                
                VStack {
                    Spacer()
                    BannerAdView(adUnitID: AdMobManager.shared.getBannerAdUnitID())
                        .frame(height: 50)
                        .background(themeManager.secondaryBackground)
                }
                .ignoresSafeArea(edges: .bottom)
                
                if showingRedirectMessage {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "arrow.up.forward.app")
                            Text("You are being redirected to the application page.")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(themeManager.accentColor)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationTitle("Job Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(themeManager.accentColor)
                    }
                }
            }
            .onAppear {
                if job.featured {
                    AdMobManager.shared.handleFeaturedJobTap(jobId: job.id)
                }
            }
        }
        .tint(themeManager.navigationText)
    }
    
    private func openInSystemBrowser() {
        guard let url = URL(string: job.applyUrl) else {
            return
        }
        
        withAnimation {
            showingRedirectMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIApplication.shared.open(url)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showingRedirectMessage = false
                }
            }
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