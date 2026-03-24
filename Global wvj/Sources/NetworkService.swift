import Foundation

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = AppConstants.baseUrl
    
    private init() {}
    
    func login(email: String, password: String) async throws -> AppUser {
        let url = URL(string: "\(baseURL)/data/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginRequest = LoginRequest(
            app_id: AppConstants.appId,
            email: email,
            password: password,
            provider: "email"
        )
        
        request.httpBody = try JSONEncoder().encode(loginRequest)
        
        print("-> Request: Login")
        print("-> POST: \(url.absoluteString)")
        print("-> Parameters: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1)
        }
        
        print("<- Response: Login")
        print("<- POST: \(url.absoluteString)")
        print("<- Status Code: \(httpResponse.statusCode)")
        print("<- Response Body: \(String(data: data, encoding: .utf8) ?? "")")
        
        if httpResponse.statusCode == 400 {
            throw NSError(domain: "Invalid credentials", code: 400)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "Server error", code: httpResponse.statusCode)
        }
        
        let user = try JSONDecoder().decode(AppUser.self, from: data)
        return user
    }
    
    func createUser(email: String, password: String) async throws -> AppUser {
        let url = URL(string: "\(baseURL)/data")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let createRequest = CreateUserRequest(
            app_id: AppConstants.appId,
            table_name: "users",
            data: CreateUserRequest.UserData(
                email: email,
                password: password,
                provider: "email"
            )
        )
        
        request.httpBody = try JSONEncoder().encode(createRequest)
        
        print("-> Request: Create User")
        print("-> POST: \(url.absoluteString)")
        print("-> Parameters: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1)
        }
        
        print("<- Response: Create User")
        print("<- POST: \(url.absoluteString)")
        print("<- Status Code: \(httpResponse.statusCode)")
        print("<- Response Body: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "Failed to create user", code: httpResponse.statusCode)
        }
        
        let user = try JSONDecoder().decode(AppUser.self, from: data)
        return user
    }
    
    func fetchPosts() async throws -> [AppPost] {
        let urlString = "\(baseURL)/data?app_id=\(AppConstants.appId)&table_name=posts"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        
        print("-> Request: Fetch Posts")
        print("-> GET: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1)
        }
        
        print("<- Response: Fetch Posts")
        print("<- GET: \(url.absoluteString)")
        print("<- Status Code: \(httpResponse.statusCode)")
        print("<- Response Body: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "Failed to fetch posts", code: httpResponse.statusCode)
        }
        
        let posts = try JSONDecoder().decode([AppPost].self, from: data)
        return posts.sorted { ($0.created_at ?? "") > ($1.created_at ?? "") }
    }
    
    func createPost(userId: String, content: String, imageUrl: String?) async throws -> AppPost {
        let url = URL(string: "\(baseURL)/data")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let createRequest = CreatePostRequest(
            app_id: AppConstants.appId,
            table_name: "posts",
            data: CreatePostRequest.PostData(
                user_id: userId,
                content: content,
                image_url: imageUrl
            )
        )
        
        request.httpBody = try JSONEncoder().encode(createRequest)
        
        print("-> Request: Create Post")
        print("-> POST: \(url.absoluteString)")
        print("-> Parameters: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1)
        }
        
        print("<- Response: Create Post")
        print("<- POST: \(url.absoluteString)")
        print("<- Status Code: \(httpResponse.statusCode)")
        print("<- Response Body: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "Failed to create post", code: httpResponse.statusCode)
        }
        
        let post = try JSONDecoder().decode(AppPost.self, from: data)
        return post
    }
    
    func fetchComments(postId: String) async throws -> [AppComment] {
        let urlString = "\(baseURL)/data?app_id=\(AppConstants.appId)&table_name=comments&post_id=\(postId)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        
        print("-> Request: Fetch Comments")
        print("-> GET: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1)
        }
        
        print("<- Response: Fetch Comments")
        print("<- GET: \(url.absoluteString)")
        print("<- Status Code: \(httpResponse.statusCode)")
        print("<- Response Body: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "Failed to fetch comments", code: httpResponse.statusCode)
        }
        
        let comments = try JSONDecoder().decode([AppComment].self, from: data)
        return comments
    }
    
    func createComment(postId: String, userId: String, content: String) async throws -> AppComment {
        let url = URL(string: "\(baseURL)/data")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let createRequest = CreateCommentRequest(
            app_id: AppConstants.appId,
            table_name: "comments",
            data: CreateCommentRequest.CommentData(
                post_id: postId,
                user_id: userId,
                content: content
            )
        )
        
        request.httpBody = try JSONEncoder().encode(createRequest)
        
        print("-> Request: Create Comment")
        print("-> POST: \(url.absoluteString)")
        print("-> Parameters: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1)
        }
        
        print("<- Response: Create Comment")
        print("<- POST: \(url.absoluteString)")
        print("<- Status Code: \(httpResponse.statusCode)")
        print("<- Response Body: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "Failed to create comment", code: httpResponse.statusCode)
        }
        
        let comment = try JSONDecoder().decode(AppComment.self, from: data)
        return comment
    }
    
    func uploadImage(imageData: Data, userId: String) async throws -> String {
        let url = URL(string: "\(baseURL)/data/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"app_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(AppConstants.appId)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(userId)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        print("-> Request: Upload Image")
        print("-> POST: \(url.absoluteString)")
        print("-> Parameters: multipart/form-data with image")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1)
        }
        
        print("<- Response: Upload Image")
        print("<- POST: \(url.absoluteString)")
        print("<- Status Code: \(httpResponse.statusCode)")
        print("<- Response Body: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "Failed to upload image", code: httpResponse.statusCode)
        }
        
        let uploadResponse = try JSONDecoder().decode(UploadResponse.self, from: data)
        return uploadResponse.url ?? ""
    }
    
    func fetchLikes(postId: String) async throws -> [AppLike] {
        let urlString = "\(baseURL)/data?app_id=\(AppConstants.appId)&table_name=likes&post_id=\(postId)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "Failed to fetch likes", code: httpResponse.statusCode)
        }
        
        let likes = try JSONDecoder().decode([AppLike].self, from: data)
        return likes
    }
    
    func createLike(postId: String, userId: String) async throws -> AppLike {
        let url = URL(string: "\(baseURL)/data")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let createRequest = CreateLikeRequest(
            app_id: AppConstants.appId,
            table_name: "likes",
            data: CreateLikeRequest.LikeData(
                post_id: postId,
                user_id: userId
            )
        )
        
        request.httpBody = try JSONEncoder().encode(createRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "Failed to create like", code: httpResponse.statusCode)
        }
        
        let like = try JSONDecoder().decode(AppLike.self, from: data)
        return like
    }
}