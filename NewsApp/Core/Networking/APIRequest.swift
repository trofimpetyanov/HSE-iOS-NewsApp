import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    var endpoint: URLService.Endpoint { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

extension APIRequest {
    var method: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var body: Data? { nil }
    
    var urlRequest: URLRequest {
        guard let url = URLService.makeURL(for: endpoint) else {
            preconditionFailure("Invalid URL for endpoint: \(endpoint)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        return request
    }
} 