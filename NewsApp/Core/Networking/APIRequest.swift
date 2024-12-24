import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    associatedtype EndpointType: Endpoint
    
    var endpoint: EndpointType { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

extension APIRequest {
    var method: HTTPMethod { .get }
    var body: Data? { nil }
} 
