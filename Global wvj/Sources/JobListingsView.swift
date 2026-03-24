import SwiftUI

struct JobListingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel = JobListingsViewModel()
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var selectedJob: Job?
    @State private var showCountryPicker = false
    @State private var showSettings = false
    
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
                    modernHeaderView
                    
                    searchAndFilterBar
                    
                    if viewModel.isLoading && viewModel.jobs.isEmpty {
                        modernLoadingView
                    } else if viewModel.filteredJobs.isEmpty {
                        modernEmptyStateView
                    } else {
                        modernJobsListView
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(themeManager.accentColor)
                },
                trailing: Button(action: {
                    Task {
                        await viewModel.loadJobs()
                    }
                }) {
                    if #available(iOS 18.0, *) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                            .symbolEffect(.rotate, value: viewModel.isLoading)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(themeManager.accentColor)
                    }
                }
            )
            .sheet(isPresented: $showFilters) {
                ModernFiltersView(viewModel: viewModel)
                    .environmentObject(themeManager)
            }
            .sheet(item: $selectedJob) { job in
                ModernJobDetailsView(job: job)
                    .environmentObject(themeManager)
            }
            .sheet(isPresented: $showCountryPicker) {
                CountryPickerView(viewModel: viewModel)
                    .environmentObject(themeManager)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(themeManager)
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .task {
                await viewModel.loadJobs()
            }
            .refreshable {
                await viewModel.loadJobs()
            }
        }
        .tint(themeManager.navigationText)
    }
    
    private var modernHeaderView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [themeManager.accentColor, themeManager.accentColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "globe.americas.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                }
                .shadow(color: themeManager.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Work Visa Jobs")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text("Global Opportunities")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(themeManager.secondaryText)
                }
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "briefcase.fill")
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.accentColor)
                    
                    Text("\(viewModel.filteredJobs.count) Jobs")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(themeManager.accentColor.opacity(0.15))
                )
                
                if viewModel.filteredJobs.filter({ $0.featured }).count > 0 {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.warningColor)
                        
                        Text("\(viewModel.filteredJobs.filter({ $0.featured }).count) Featured")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(themeManager.primaryText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(themeManager.warningColor.opacity(0.15))
                    )
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(themeManager.secondaryBackground)
                .shadow(color: themeManager.cardShadow.opacity(0.1), radius: 8, x: 0, y: 2)
        )
    }
    
    private var searchAndFilterBar: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(themeManager.secondaryText)
                    
                    TextField("Search jobs, locations...", text: $searchText)
                        .font(.system(size: 16))
                        .foregroundColor(themeManager.primaryText)
                        .onChange(of: searchText) { newValue in
                            viewModel.searchText = newValue
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(themeManager.secondaryBackground)
                        .shadow(color: themeManager.cardShadow.opacity(0.08), radius: 8, x: 0, y: 2)
                )
                
                Button(action: {
                    showFilters = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                viewModel.hasActiveFilters ?
                                LinearGradient(
                                    colors: [themeManager.accentColor, themeManager.accentColor.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    colors: [themeManager.secondaryBackground, themeManager.secondaryBackground],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: viewModel.hasActiveFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(viewModel.hasActiveFilters ? .white : themeManager.primaryText)
                        
                        if viewModel.hasActiveFilters {
                            Circle()
                                .fill(themeManager.errorColor)
                                .frame(width: 10, height: 10)
                                .offset(x: 12, y: -12)
                        }
                    }
                }
                .shadow(color: viewModel.hasActiveFilters ? themeManager.accentColor.opacity(0.3) : themeManager.cardShadow.opacity(0.08), radius: 8, x: 0, y: 2)
            }
            
            if viewModel.hasActiveFilters {
                activeFiltersView
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var activeFiltersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                if !viewModel.selectedCountries.isEmpty {
                    ForEach(Array(viewModel.selectedCountries), id: \.self) { country in
                        ModernFilterChip(text: country, icon: "flag.fill", onRemove: {
                            viewModel.selectedCountries.remove(country)
                        })
                    }
                }
                
                if !viewModel.selectedCategories.isEmpty {
                    ForEach(Array(viewModel.selectedCategories), id: \.self) { category in
                        ModernFilterChip(text: category, icon: "tag.fill", onRemove: {
                            viewModel.selectedCategories.remove(category)
                        })
                    }
                }
                
                if !viewModel.selectedVisaTags.isEmpty {
                    ForEach(Array(viewModel.selectedVisaTags), id: \.self) { tag in
                        ModernFilterChip(text: tag, icon: "doc.text.fill", onRemove: {
                            viewModel.selectedVisaTags.remove(tag)
                        })
                    }
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.clearFilters()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                        Text("Clear All")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(themeManager.errorColor.opacity(0.15))
                    )
                    .foregroundColor(themeManager.errorColor)
                }
            }
        }
    }
    
    private var modernLoadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(themeManager.accentColor.opacity(0.2), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [themeManager.accentColor, themeManager.accentColor.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(viewModel.isLoading ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: viewModel.isLoading)
            }
            
            Text("Loading opportunities...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(themeManager.secondaryText)
            
            Spacer()
        }
    }
    
    private var modernEmptyStateView: some View {
        Group {
            if #available(iOS 17.0, *) {
                ContentUnavailableView {
                    if #available(iOS 17.0, *) {
                        Label("No Jobs Found", systemImage: "briefcase.fill")
                            .symbolEffect(.bounce, value: viewModel.hasActiveFilters)
                    } else {
                        Label("No Jobs Found", systemImage: "briefcase.fill")
                    }
                } description: {
                    Text(viewModel.hasActiveFilters ? "Try adjusting your filters to see more results" : "Check back soon for new opportunities")
                } actions: {
                    if viewModel.hasActiveFilters {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.clearFilters()
                            }
                        }) {
                            Text("Clear Filters")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(themeManager.accentColor)
                    }
                }
            } else {
                VStack(spacing: 16) {
                    Label("No Jobs Found", systemImage: "briefcase.fill")
                    Text(viewModel.hasActiveFilters ? "Try adjusting your filters to see more results" : "Check back soon for new opportunities")
                    if viewModel.hasActiveFilters {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.clearFilters()
                            }
                        }) {
                            Text("Clear Filters")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(themeManager.accentColor)
                    }
                }
                .padding()
            }
        }
    }
    
    private var modernJobsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredJobs) { job in
                    ModernJobCardView(job: job)
                        .onTapGesture {
                            selectedJob = job
                        }
                        .transition(AnyTransition.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct ModernFilterChip: View {
    let text: String
    let icon: String
    let onRemove: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(text)
                .font(.system(size: 14, weight: .medium))
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(themeManager.accentColor.opacity(0.15))
        )
        .foregroundColor(themeManager.accentColor)
    }
}

struct ModernJobCardView: View {
    let job: Job
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(job.title)
                    .font(.headline)
                    .foregroundColor(themeManager.primaryText)
                Spacer()
                if job.featured {
                    Image(systemName: "star.fill")
                        .foregroundColor(themeManager.warningColor)
                }
            }
        }
        .padding()
        .background(themeManager.secondaryBackground)
        .cornerRadius(12)
        .shadow(color: themeManager.cardShadow.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct CountryPickerView: View {
    @ObservedObject var viewModel: JobListingsViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            List(viewModel.availableCountries, id: \.self) { country in
                Button(action: {
                    if viewModel.selectedCountries.contains(country) {
                        viewModel.selectedCountries.remove(country)
                    } else {
                        viewModel.selectedCountries.insert(country)
                    }
                }) {
                    HStack {
                        Text(country)
                        Spacer()
                        if viewModel.selectedCountries.contains(country) {
                            Image(systemName: "checkmark")
                                .foregroundColor(themeManager.accentColor)
                        }
                    }
                }
            }
            .navigationTitle("Select Countries")
        }
    }
}