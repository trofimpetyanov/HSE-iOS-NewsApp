import Foundation

enum NewsError: LocalizedError {
    case network
    case parsing
    case noData
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .network:
            return "Network connection error"
        case .parsing:
            return "Failed to load content"
        case .noData:
            return "No content available"
        case .serverError(let message):
            return message
        }
    }
} 
