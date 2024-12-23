import Foundation

struct Article {
    let id: Int
    let title: String
    let announce: String
    let date: Date
    let sourceIcon: URL
    let sourceName: String
    let image: ArticleImage?
    let timeOfReading: String
    let sectionName: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "newsId"
        case title
        case announce
        case date
        case sourceIcon
        case sourceName
        case image = "img"
        case timeOfReading
        case sectionName
    }
} 

extension Article: Identifiable, Equatable, Hashable { }
