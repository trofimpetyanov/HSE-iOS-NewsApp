import Foundation

struct NewsResponseDTO: Decodable {
    let news: [ArticleDTO]
    let requestId: String
} 
