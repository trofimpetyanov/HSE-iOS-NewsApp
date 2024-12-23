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
        do {
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
        } catch is URLError {
            throw APIError.networkError
        } catch is DecodingError {
            throw APIError.decodingError
        } catch {
            throw error
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
        }
    }
} 
