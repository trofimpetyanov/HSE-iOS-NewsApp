import Foundation

struct NewsDTOConverter {
    func convert(from dto: NewsResponseDTO) -> NewsResponse {
        NewsResponse(
            news: dto.news.map(convert),
            requestId: dto.requestId
        )
    }
    
    private func convert(from dto: ArticleDTO) -> Article {
        Article(
            id: dto.id,
            title: dto.title,
            announce: dto.announce,
            date: parseDate(dto.date),
            sourceIcon: dto.sourceIcon,
            sourceName: dto.sourceName,
            image: dto.image.map(convert),
            timeOfReading: dto.timeOfReading,
            sectionName: dto.sectionName
        )
    }
    
    private func convert(from dto: ArticleImageDTO) -> ArticleImage {
        ArticleImage(
            url: dto.url,
            isRemote: dto.isRemote
        )
    }
    
    private func parseDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: dateString) ?? Date()
    }
} 
