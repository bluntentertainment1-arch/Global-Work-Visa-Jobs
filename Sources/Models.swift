import Foundation

struct AppUser: Codable, Identifiable {
    var id: String?
    var email: String?
    var provider: String?
    var created_at: String?
}

struct AppPost: Codable, Identifiable {
    var id: String?
    var user_id: String?
    var content: String?
    var image_url: String?
    var created_at: String?
}

struct AppComment: Codable, Identifiable {
    var id: String?
    var post_id: String?
    var user_id: String?
    var content: String?
    var created_at: String?
}

struct AppLike: Codable, Identifiable {
    var id: String?
    var post_id: String?
    var user_id: String?
}

struct APIResponse<T: Codable>: Codable {
    let data: T?
    let message: String?
}

struct UploadResponse: Codable {
    let url: String?
}

struct LoginRequest: Codable {
    let app_id: String
    let email: String
    let password: String
    let provider: String
}

struct CreateUserRequest: Codable {
    let app_id: String
    let table_name: String
    let data: UserData
    
    struct UserData: Codable {
        let email: String
        let password: String
        let provider: String
    }
}

struct CreatePostRequest: Codable {
    let app_id: String
    let table_name: String
    let data: PostData
    
    struct PostData: Codable {
        let user_id: String
        let content: String
        let image_url: String?
    }
}

struct CreateCommentRequest: Codable {
    let app_id: String
    let table_name: String
    let data: CommentData
    
    struct CommentData: Codable {
        let post_id: String
        let user_id: String
        let content: String
    }
}

struct CreateLikeRequest: Codable {
    let app_id: String
    let table_name: String
    let data: LikeData
    
    struct LikeData: Codable {
        let post_id: String
        let user_id: String
    }
}