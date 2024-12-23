import Foundation

struct NewsState: Equatable {
    var articles: [Article] = []
    var isLoading: Bool = false
    var error: NewsError?
    
    static func == (lhs: NewsState, rhs: NewsState) -> Bool {
        lhs.articles == rhs.articles && 
        lhs.isLoading == rhs.isLoading && 
        (lhs.error != nil) == (rhs.error != nil)
    }
}

enum NewsEvent {
    case viewDidLoad
    case refresh
    case loadMore
    case selectArticle(Article)
    case shareArticle(Article)
}

typealias NewsViewState = NewsState
typealias NewsViewEvent = NewsEvent
