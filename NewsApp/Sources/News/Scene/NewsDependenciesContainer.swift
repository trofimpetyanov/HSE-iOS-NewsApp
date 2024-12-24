import Foundation

final class NewsDependenciesContainer {
    let apiClient: APIClient
    let dtoConverter: NewsDTOConverter
    let newsService: NewsService
    
    init(
        apiClient: APIClient = APIClient(urlService: .news),
        dtoConverter: NewsDTOConverter = NewsDTOConverter()
    ) {
        self.apiClient = apiClient
        self.dtoConverter = dtoConverter
        self.newsService = NewsService(apiClient: apiClient, dtoConverter: dtoConverter)
    }
}
