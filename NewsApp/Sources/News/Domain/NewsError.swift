import Foundation

enum NewsError: LocalizedError {
    case network
    case parsing
    case noData
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .network: "Unable to load news"
        case .parsing: "Unable to process server response"
        case .noData: "No news available"
        case .serverError(let message): message
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .network: "Please check your internet connection"
        case .parsing: "Our team has been notified. Please try again later"
        case .noData: "Pull down to refresh"
        case .serverError: "Please try again later"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .network: "Network connection failed"
        case .parsing: "Data format error"
        case .noData: "Empty response"
        case .serverError: "Server error"
        }
    }
} 
