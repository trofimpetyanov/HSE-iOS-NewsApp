import Foundation

struct ArticleDTO: Decodable {
    let newsId: Int
    let title: String
    let announce: String
    let date: String
    let sourceIcon: URL
    let sourceName: String
    let img: ArticleImageDTO?
    let timeOfReading: String
    let sectionName: String
} 
