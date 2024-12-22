import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

extension APIRequest {
    var baseURL: URL {
        URL(string: "https://news.myseldon.com/api")!
    }
    
    var headers: [String: String]? { nil }
    var method: HTTPMethod { .get }
    var body: Data? { nil }
    var queryItems: [URLQueryItem]? { nil }
    
    var urlRequest: URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        return request
    }
} 