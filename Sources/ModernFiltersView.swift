import SwiftUI

struct ModernFiltersView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: JobListingsViewModel
    @State private var selectedTab = 0
    
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
                
                VStack(spacing: 0) {
                    modernTabBar
                    
                    TabView(selection: $selectedTab) {
                        countryFilterView
                            .tag(0)
                        
                        categoryFilterView
                            .tag(1)
                        
                        visaFilterView
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .navigationTitle("Filters")
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Apply")
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.accentColor)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if viewModel.hasActiveFilters {
                    clearAllButton
                }
            }
        }
        .tint(themeManager.navigationText)
    }
    
    private var modernTabBar: some View {
        HStack(spacing: 0) {
            ForEach(0..<3) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: tabIcon(for: index))
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text(tabTitle(for: index))
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(selectedTab == index ? themeManager.accentColor : themeManager.secondaryText)
                        
                        if selectedTab == index {
                            Capsule()
                                .fill(themeManager.accentColor)
                                .frame(height: 3)
                                .transition(.scale)
                        } else {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .background(themeManager.secondaryBackground)
    }
    
    private var countryFilterView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.availableCountries.sorted(), id: \.self) { country in
                    ModernFilterOptionCard(
                        title: country,
                        icon: "flag.fill",
                        isSelected: viewModel.selectedCountries.contains(country),
                        count: viewModel.jobs.filter { $0.country == country }.count
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if viewModel.selectedCountries.contains(country) {
                                viewModel.selectedCountries.remove(country)
                            } else {
                                viewModel.selectedCountries.insert(country)
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
    }
    
    private var categoryFilterView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.availableCategories.sorted(), id: \.self) { category in
                    ModernFilterOptionCard(
                        title: category,
                        icon: "tag.fill",
                        isSelected: viewModel.selectedCategories.contains(category),
                        count: viewModel.jobs.filter { $0.category == category }.count
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if viewModel.selectedCategories.contains(category) {
                                viewModel.selectedCategories.remove(category)
                            } else {
                                viewModel.selectedCategories.insert(category)
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
    }
    
    private var visaFilterView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.availableVisaTags.sorted(), id: \.self) { tag in
                    ModernFilterOptionCard(
                        title: tag,
                        icon: "doc.text.fill",
                        isSelected: viewModel.selectedVisaTags.contains(tag),
                        count: viewModel.jobs.filter { $0.visaTag == tag }.count
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if viewModel.selectedVisaTags.contains(tag) {
                                viewModel.selectedVisaTags.remove(tag)
                            } else {
                                viewModel.selectedVisaTags.insert(tag)
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
    }
    
    private var clearAllButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.clearFilters()
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 16, weight: .semibold))
                Text("Clear All Filters")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [themeManager.errorColor, themeManager.errorColor.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: themeManager.errorColor.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(themeManager.background)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "flag.fill"
        case 1: return "tag.fill"
        case 2: return "doc.text.fill"
        default: return "circle.fill"
        }
    }
    
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Country"
        case 1: return "Category"
        case 2: return "Visa Type"
        default: return ""
        }
    }
}

struct ModernFilterOptionCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    let icon: String
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            isSelected ?
                            LinearGradient(
                                colors: [themeManager.accentColor.opacity(0.2), themeManager.accentColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [themeManager.secondaryBackground, themeManager.secondaryBackground],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isSelected ? themeManager.accentColor : themeManager.secondaryText)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text("\(count) job\(count == 1 ? "" : "s")")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(themeManager.secondaryText)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(isSelected ? themeManager.accentColor : themeManager.borderColor, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(themeManager.accentColor)
                            .frame(width: 14, height: 14)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.cardBackground)
                    .shadow(color: themeManager.cardShadow.opacity(isPressed ? 0.12 : 0.06), radius: isPressed ? 10 : 6, x: 0, y: isPressed ? 5 : 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? themeManager.accentColor.opacity(0.3) : Color.clear,
                        lineWidth: 1.5
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}