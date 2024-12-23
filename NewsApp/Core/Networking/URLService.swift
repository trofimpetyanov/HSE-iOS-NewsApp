import Foundation

enum URLService {
    enum Constants {
        static let baseURL = "https://news.myseldon.com"
        static let apiPath = "/api"
        static let language = "ru"
    }
    
    enum Endpoint {
        case article(id: Int)
        case section(rubricId: Int, pageIndex: Int, pageSize: Int)
        
        var path: String {
            switch self {
            case .article(let id):
                return "/\(Constants.language)/news/index/\(id)"
            case .section:
                return "\(Constants.apiPath)/Section"
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .article:
                return nil
            case .section(let rubricId, let pageIndex, let pageSize):
                return [
                    URLQueryItem(name: "rubricId", value: "\(rubricId)"),
                    URLQueryItem(name: "pageIndex", value: "\(pageIndex)"),
                    URLQueryItem(name: "pageSize", value: "\(pageSize)")
                ]
            }
        }
    }
    
    static func makeURL(for endpoint: Endpoint) -> URL? {
        var components = URLComponents(string: Constants.baseURL)
        components?.path = endpoint.path
        components?.queryItems = endpoint.queryItems
        return components?.url
    }
    
    static func articleShareURL(id: Int) -> String {
        "\(Constants.baseURL)/\(Constants.language)/news/index/\(id)"
    }
} 
