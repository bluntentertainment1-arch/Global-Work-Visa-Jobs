import Foundation

class GoogleSheetsService {
    static let shared = GoogleSheetsService()
    
    private let spreadsheetId = "1QYcwYcw9U6KkWP7Wkc83yQV3FbaveRaRQBvrQphDxNY"
    private let sheetName = "Sheet1"
    private let apiKey = "AIzaSyBSi_wKCUB-KsKsKsKsKsKsKsKsKsKsKsKs"
    
    private init() {}
    
    func fetchJobs() async throws -> [Job] {
        let range = "\(sheetName)!A:K"
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range)?key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        
        print("-> Request: Fetch Jobs from Google Sheets")
        print("-> GET: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30.0
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1)
        }
        
        print("<- Response: Fetch Jobs")
        print("<- Status Code: \(httpResponse.statusCode)")
        print("<- Response Body: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "Failed to fetch jobs: \(errorMessage)", code: httpResponse.statusCode)
        }
        
        let sheetsResponse = try JSONDecoder().decode(GoogleSheetsResponse.self, from: data)
        
        var jobs: [Job] = []
        
        for (index, row) in sheetsResponse.values.enumerated() {
            if index == 0 {
                continue
            }
            
            guard row.count >= 11 else {
                print("Skipping row \(index) - insufficient columns: \(row.count)")
                continue
            }
            
            let id = row[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let country = row[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let category = row[2].trimmingCharacters(in: .whitespacesAndNewlines)
            let title = row[3].trimmingCharacters(in: .whitespacesAndNewlines)
            let location = row[4].trimmingCharacters(in: .whitespacesAndNewlines)
            let salary = row[5].trimmingCharacters(in: .whitespacesAndNewlines)
            let description = row[6].trimmingCharacters(in: .whitespacesAndNewlines)
            let visaTag = row[7].trimmingCharacters(in: .whitespacesAndNewlines)
            let applyUrl = row[8].trimmingCharacters(in: .whitespacesAndNewlines)
            let dateAdded = row[9].trimmingCharacters(in: .whitespacesAndNewlines)
            let featuredString = row[10].trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            if id.isEmpty || title.isEmpty {
                print("Skipping row \(index) - missing required fields")
                continue
            }
            
            let featured = featuredString == "true" || featuredString == "1" || featuredString == "yes"
            
            let job = Job(
                id: id,
                country: country,
                category: category,
                title: title,
                location: location,
                salary: salary,
                description: description,
                visaTag: visaTag,
                applyUrl: applyUrl,
                dateAdded: dateAdded,
                featured: featured
            )
            
            jobs.append(job)
            print("Added job: \(title) in \(country)")
        }
        
        print("Total jobs fetched: \(jobs.count)")
        return jobs
    }
}

struct GoogleSheetsResponse: Codable {
    let range: String
    let majorDimension: String
    let values: [[String]]
}