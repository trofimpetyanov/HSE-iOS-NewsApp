import Foundation

final class NewsService {
    private let apiClient: APIClient
    private let dtoConverter: NewsDTOConverter
    
    init(apiClient: APIClient, dtoConverter: NewsDTOConverter) {
        self.apiClient = apiClient
        self.dtoConverter = dtoConverter
    }
    
    func fetchNews(
        rubricId: Int = 4,
        pageIndex: Int = 1,
        pageSize: Int = 20
    ) async throws -> NewsResponse {
        let request = NewsAPI.FetchNews(
            rubricId: rubricId,
            pageIndex: pageIndex,
            pageSize: pageSize
        )
        let dto = try await apiClient.send(request)
        return dtoConverter.convert(from: dto)
    }
} 
