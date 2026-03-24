import SwiftUI

struct HomeFeedView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel = HomeFeedViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("user_id") private var userId: String = ""
    @State private var showAuthSheet = false
    @State private var selectedPost: AppPost?
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    searchBarView
                    
                    if viewModel.isLoading && viewModel.posts.isEmpty {
                        loadingView
                    } else if viewModel.posts.isEmpty {
                        emptyStateView
                    } else {
                        postsListView
                    }
                }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        if isLoggedIn {
                            viewModel.showCreatePost = true
                        } else {
                            showAuthSheet = true
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(themeManager.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showAuthSheet) {
                AuthenticationView()
                    .environmentObject(themeManager)
            }
            .sheet(isPresented: $viewModel.showCreatePost) {
                CreatePostView()
                    .environmentObject(themeManager)
                    .onDisappear {
                        Task {
                            await viewModel.loadPosts()
                        }
                    }
            }
            .sheet(item: $selectedPost) { post in
                PostDetailsView(post: post)
                    .environmentObject(themeManager)
                    .onDisappear {
                        Task {
                            await viewModel.loadPosts()
                        }
                    }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .task {
                await viewModel.loadPosts()
            }
            .refreshable {
                await viewModel.loadPosts()
            }
        }
        .tint(themeManager.navigationText)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.secondaryText)
            
            TextField("Search posts...", text: $searchText)
                .foregroundColor(themeManager.primaryText)
        }
        .padding(12)
        .background(themeManager.secondaryBackground)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
                .tint(themeManager.accentColor)
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "text.bubble")
                .font(.system(size: 60))
                .foregroundColor(themeManager.secondaryText)
            
            Text("No posts yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.primaryText)
            
            Text("Be the first to share something!")
                .font(.body)
                .foregroundColor(themeManager.secondaryText)
            
            Spacer()
        }
    }
    
    private var postsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredPosts) { post in
                    PostCardView(post: post)
                        .onTapGesture {
                            selectedPost = post
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    private var filteredPosts: [AppPost] {
        if searchText.isEmpty {
            return viewModel.posts
        } else {
            return viewModel.posts.filter { post in
                (post.content ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct PostCardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let post: AppPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(themeManager.secondaryText)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.user_id ?? "Unknown User")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text(formatDate(post.created_at ?? ""))
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.secondaryText)
                }
                
                Spacer()
            }
            
            Text(post.content ?? "")
                .font(.system(size: 16))
                .foregroundColor(themeManager.primaryText)
                .lineLimit(3)
            
            if let imageUrl = post.image_url, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 50))
                            .foregroundColor(themeManager.secondaryText)
                            .frame(height: 200)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            HStack(spacing: 20) {
                Label("Like", systemImage: "heart")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.secondaryText)
                
                Label("Comment", systemImage: "bubble.right")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.secondaryText)
                
                Spacer()
            }
        }
        .padding(16)
        .background(themeManager.secondaryBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: dateString) else {
            return "Just now"
        }
        
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let days = components.day, days > 0 {
            return "\(days)d ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m ago"
        } else {
            return "Just now"
        }
    }
}

class HomeFeedViewModel: ObservableObject {
    @Published var posts: [AppPost] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showCreatePost = false
    
    @MainActor
    func loadPosts() async {
        isLoading = true
        
        do {
            let fetchedPosts = try await NetworkService.shared.fetchPosts()
            self.posts = fetchedPosts
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
        
        isLoading = false
    }
}