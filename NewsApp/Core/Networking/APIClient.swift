import Foundation

final class APIClient {
    private let urlSession: URLSession
    private let urlService: URLService
    
    init(
        urlSession: URLSession = .shared,
        urlService: URLService
    ) {
        self.urlSession = urlSession
        self.urlService = urlService
    }
    
    func send<R: APIRequest>(_ request: R) async throws -> R.Response {
        guard let url = urlService.makeURL(for: request.endpoint) else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return try JSONDecoder().decode(R.Response.self, from: data)
        case 401:
            throw APIError.unauthorized
        case 404:
            throw APIError.notFound
        default:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}

enum APIError: LocalizedError {
    case invalidRequest
    case invalidResponse
    case networkError
    case decodingError
    case unauthorized
    case notFound
    case serverError(statusCode: Int)
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "Invalid response"
        case .networkError:
            return "Network error"
        case .decodingError:
            return "Failed to decode response"
        case .unauthorized:
            return "Unauthorized"
        case .notFound:
            return "Not found"
        case .serverError(let code):
            return "Server error: \(code)"
        case .invalidURL:
            return "Invalid URL"
        }
    }
} 
