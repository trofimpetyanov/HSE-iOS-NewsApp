import Foundation

struct URLService {
    let scheme: String
    let host: String
    
    func makeURL(for endpoint: Endpoint) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        return components.url
    }
} 
