import SwiftUI

struct PostDetailsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: PostDetailsViewModel
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("user_id") private var userId: String = ""
    @State private var showAuthSheet = false
    
    init(post: AppPost) {
        _viewModel = StateObject(wrappedValue: PostDetailsViewModel(post: post))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        postContentView
                        
                        Divider()
                            .background(themeManager.borderColor)
                            .padding(.vertical, 16)
                        
                        commentsSection
                    }
                    .padding(.horizontal)
                }
                
                VStack {
                    Spacer()
                    commentInputView
                }
            }
            .navigationTitle("Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(themeManager.primaryText)
                    }
                }
            }
            .sheet(isPresented: $showAuthSheet) {
                AuthenticationView()
                    .environmentObject(themeManager)
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .task {
                await viewModel.loadComments()
                await viewModel.loadLikes()
            }
        }
        .tint(themeManager.navigationText)
    }
    
    private var postContentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(themeManager.secondaryText)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.post.user_id ?? "Unknown User")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(themeManager.primaryText)
                    
                    Text(formatDate(viewModel.post.created_at ?? ""))
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.secondaryText)
                }
                
                Spacer()
            }
            
            Text(viewModel.post.content ?? "")
                .font(.system(size: 17))
                .foregroundColor(themeManager.primaryText)
            
            if let imageUrl = viewModel.post.image_url, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 400)
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundColor(themeManager.secondaryText)
                            .frame(height: 300)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            HStack(spacing: 24) {
                Button(action: {
                    if isLoggedIn {
                        Task {
                            await viewModel.toggleLike(userId: userId)
                        }
                    } else {
                        showAuthSheet = true
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: viewModel.isLikedByUser ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isLikedByUser ? themeManager.accentColor : themeManager.secondaryText)
                        Text("\(viewModel.likesCount)")
                            .foregroundColor(themeManager.secondaryText)
                    }
                    .font(.system(size: 16))
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "bubble.right")
                        .foregroundColor(themeManager.secondaryText)
                    Text("\(viewModel.comments.count)")
                        .foregroundColor(themeManager.secondaryText)
                }
                .font(.system(size: 16))
                
                Spacer()
            }
        }
        .padding(.vertical, 16)
    }
    
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Comments")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(themeManager.primaryText)
            
            if viewModel.comments.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 40))
                        .foregroundColor(themeManager.secondaryText)
                    
                    Text("No comments yet")
                        .font(.body)
                        .foregroundColor(themeManager.secondaryText)
                    
                    Text("Be the first to comment!")
                        .font(.caption)
                        .foregroundColor(themeManager.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(viewModel.comments) { comment in
                    CommentRowView(comment: comment)
                }
            }
        }
        .padding(.bottom, 80)
    }
    
    private var commentInputView: some View {
        VStack(spacing: 0) {
            Divider()
                .background(themeManager.borderColor)
            
            HStack(spacing: 12) {
                TextField("Add a comment...", text: $viewModel.commentText)
                    .padding(12)
                    .background(themeManager.secondaryBackground)
                    .foregroundColor(themeManager.primaryText)
                    .cornerRadius(20)
                
                Button(action: {
                    if isLoggedIn {
                        Task {
                            await viewModel.postComment(userId: userId)
                        }
                    } else {
                        showAuthSheet = true
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                        .foregroundColor(viewModel.commentText.isEmpty ? themeManager.secondaryText : themeManager.accentColor)
                        .frame(width: 44, height: 44)
                        .background(themeManager.secondaryBackground)
                        .clipShape(Circle())
                }
                .disabled(viewModel.commentText.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(themeManager.background)
        }
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

struct CommentRowView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let comment: AppComment
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(themeManager.secondaryText)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(comment.user_id ?? "Unknown User")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(themeManager.primaryText)
                
                Text(comment.content ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(themeManager.primaryText)
            }
            
            Spacer()
        }
        .padding(12)
        .background(themeManager.secondaryBackground)
        .cornerRadius(10)
    }
}

class PostDetailsViewModel: ObservableObject {
    @Published var post: AppPost
    @Published var comments: [AppComment] = []
    @Published var commentText = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var likesCount = 0
    @Published var isLikedByUser = false
    private var likes: [AppLike] = []
    
    init(post: AppPost) {
        self.post = post
    }
    
    @MainActor
    func loadComments() async {
        guard let postId = post.id else { return }
        
        do {
            let fetchedComments = try await NetworkService.shared.fetchComments(postId: postId)
            self.comments = fetchedComments
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
    
    @MainActor
    func loadLikes() async {
        guard let postId = post.id else { return }
        
        do {
            let fetchedLikes = try await NetworkService.shared.fetchLikes(postId: postId)
            self.likes = fetchedLikes
            self.likesCount = fetchedLikes.count
            
            let userId = UserDefaults.standard.string(forKey: "user_id") ?? ""
            self.isLikedByUser = fetchedLikes.contains { $0.user_id == userId }
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
    
    @MainActor
    func postComment(userId: String) async {
        guard !commentText.isEmpty, let postId = post.id else { return }
        
        isLoading = true
        
        do {
            let newComment = try await NetworkService.shared.createComment(
                postId: postId,
                userId: userId,
                content: commentText
            )
            
            self.comments.append(newComment)
            self.commentText = ""
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
        
        isLoading = false
    }
    
    @MainActor
    func toggleLike(userId: String) async {
        guard let postId = post.id else { return }
        
        if isLikedByUser {
            return
        }
        
        do {
            _ = try await NetworkService.shared.createLike(postId: postId, userId: userId)
            await loadLikes()
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
}