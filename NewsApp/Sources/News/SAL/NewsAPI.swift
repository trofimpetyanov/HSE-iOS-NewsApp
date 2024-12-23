import Foundation

enum NewsAPI {
    struct FetchNews: APIRequest {
        typealias Response = NewsResponseDTO
        
        let rubricId: Int
        let pageIndex: Int
        let pageSize: Int
        
        var endpoint: URLService.Endpoint {
            .section(
                rubricId: rubricId,
                pageIndex: pageIndex,
                pageSize: pageSize
            )
        }
    }
} 
