import Foundation
import SwiftUI

class JobListingsViewModel: ObservableObject {
    @Published var jobs: [Job] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var searchText = ""
    @Published var selectedCountries: Set<String> = []
    @Published var selectedCategories: Set<String> = []
    @Published var selectedVisaTags: Set<String> = []
    
    var availableCountries: [String] {
        Array(Set(jobs.map { $0.country })).sorted()
    }
    
    var availableCategories: [String] {
        Array(Set(jobs.map { $0.category })).sorted()
    }
    
    var availableVisaTags: [String] {
        Array(Set(jobs.map { $0.visaTag }.filter { !$0.isEmpty })).sorted()
    }
    
    var hasActiveFilters: Bool {
        !selectedCountries.isEmpty || !selectedCategories.isEmpty || !selectedVisaTags.isEmpty
    }
    
    var filteredJobs: [Job] {
        var filtered = jobs
        
        if !searchText.isEmpty {
            filtered = filtered.filter { job in
                job.title.localizedCaseInsensitiveContains(searchText) ||
                job.description.localizedCaseInsensitiveContains(searchText) ||
                job.category.localizedCaseInsensitiveContains(searchText) ||
                job.location.localizedCaseInsensitiveContains(searchText) ||
                job.country.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !selectedCountries.isEmpty {
            filtered = filtered.filter { selectedCountries.contains($0.country) }
        }
        
        if !selectedCategories.isEmpty {
            filtered = filtered.filter { selectedCategories.contains($0.category) }
        }
        
        if !selectedVisaTags.isEmpty {
            filtered = filtered.filter { selectedVisaTags.contains($0.visaTag) }
        }
        
        return filtered.sorted { job1, job2 in
            if job1.featured != job2.featured {
                return job1.featured
            }
            return job1.dateAdded > job2.dateAdded
        }
    }
    
    func clearFilters() {
        selectedCountries.removeAll()
        selectedCategories.removeAll()
        selectedVisaTags.removeAll()
    }
    
    @MainActor
    func loadJobs() async {
        isLoading = true
        
        do {
            let fetchedJobs = try await GoogleSheetsService.shared.fetchJobs()
            self.jobs = fetchedJobs
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
        
        isLoading = false
    }
}