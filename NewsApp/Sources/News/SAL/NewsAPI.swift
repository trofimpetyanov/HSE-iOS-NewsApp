import Foundation

enum NewsAPI {
    struct FetchNews: APIRequest {
        typealias Response = NewsResponseDTO
        
        let rubricId: Int
        let pageIndex: Int
        let pageSize: Int
        
        var path: String { "/Section" }
        
        var queryItems: [URLQueryItem]? {
            [
                URLQueryItem(name: "rubricId", value: "\(rubricId)"),
                URLQueryItem(name: "pageIndex", value: "\(pageIndex)"),
                URLQueryItem(name: "pageSize", value: "\(pageSize)")
            ]
        }
    }
} 
