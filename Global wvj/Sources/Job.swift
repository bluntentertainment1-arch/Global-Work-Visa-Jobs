import Foundation

struct Job: Identifiable, Codable {
    let id: String
    let country: String
    let category: String
    let title: String
    let location: String
    let salary: String
    let description: String
    let visaTag: String
    let applyUrl: String
    let dateAdded: String
    let featured: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case country
        case category
        case title
        case location
        case salary
        case description
        case visaTag = "visa_tag"
        case applyUrl = "apply_url"
        case dateAdded = "date_added"
        case featured
    }
}