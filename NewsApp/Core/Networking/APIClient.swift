import Foundation

actor APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func send<R: APIRequest>(_ request: R) async throws -> R.Response {
        let (data, response) = try await session.data(for: request.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return try decoder.decode(R.Response.self, from: data)
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
    case invalidResponse
    case unauthorized
    case notFound
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .unauthorized:
            return "Unauthorized"
        case .notFound:
            return "Resource not found"
        case .serverError(let code):
            return "Server error: \(code)"
        }
    }
} 