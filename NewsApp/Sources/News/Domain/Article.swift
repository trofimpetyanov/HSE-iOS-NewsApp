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
} 

extension Article: Equatable, Hashable { }
