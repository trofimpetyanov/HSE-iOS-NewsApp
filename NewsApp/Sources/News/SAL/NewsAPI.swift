import Foundation

enum NewsAPI {
    struct FetchNews: APIRequest {
        typealias Response = NewsResponseDTO
        typealias EndpointType = NewsEndpoint
        
        let endpoint: NewsEndpoint
        
        init(rubricId: Int = 4, pageIndex: Int = 1, pageSize: Int = 10) {
            self.endpoint = .news(
                rubricId: rubricId,
                pageIndex: pageIndex,
                pageSize: pageSize
            )
        }
    }
} 
