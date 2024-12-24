import Foundation

enum NewsEndpoint: Endpoint {
    case news(rubricId: Int, pageIndex: Int, pageSize: Int)
    case article(id: Int)
    
    var path: String {
        switch self {
        case .news:
            return "/api/Section"
        case .article(let id):
            return "/ru/news/index/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .news(rubricId, pageIndex, pageSize):
            return [
                URLQueryItem(name: "rubricId", value: "\(rubricId)"),
                URLQueryItem(name: "pageIndex", value: "\(pageIndex)"),
                URLQueryItem(name: "pageSize", value: "\(pageSize)")
            ]
        case .article:
            return nil
        }
    }
} 