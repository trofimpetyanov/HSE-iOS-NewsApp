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
            id: dto.newsId,
            title: dto.title,
            announce: dto.announce,
            date: parseDate(dto.date),
            sourceIcon: dto.sourceIcon,
            sourceName: dto.sourceName,
            image: dto.img.map(convert),
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
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString) ?? Date()
    }
} 
