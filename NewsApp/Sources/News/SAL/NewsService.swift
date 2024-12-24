import Foundation

final class NewsService {
    private let apiClient: APIClient
    private let dtoConverter: NewsDTOConverter
    
    init(apiClient: APIClient = APIClient(urlService: .news), dtoConverter: NewsDTOConverter = NewsDTOConverter()) {
        self.apiClient = apiClient
        self.dtoConverter = dtoConverter
    }
    
    func fetchNews(
        rubricId: Int = 4,
        pageIndex: Int = 1,
        pageSize: Int = 10
    ) async throws -> NewsResponse {
        do {
            let request = NewsAPI.FetchNews(
                rubricId: rubricId,
                pageIndex: pageIndex,
                pageSize: pageSize
            )
            let dto = try await apiClient.send(request)
            
            guard !dto.news.isEmpty else {
                throw NewsError.noData
            }
            
            return dtoConverter.convert(from: dto)
        } catch is DecodingError {
            throw NewsError.parsing
        } catch let error as APIError {
            switch error {
            case .unauthorized:
                throw NewsError.serverError("Unauthorized access")
            case .notFound:
                throw NewsError.serverError("Content not found")
            default:
                throw NewsError.network
            }
        } catch {
            throw NewsError.network
        }
    }
} 
