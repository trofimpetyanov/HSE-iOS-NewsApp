import Foundation

@MainActor
final class NewsStore: Store {
    @Published private(set) var state: NewsState
    var statePublisher: Published<NewsState>.Publisher { $state }
    
    private let dependenciesContainer: NewsDependenciesContainer
    private let newsService: NewsService
    private let coordinator: NewsCoordinator
    
    private var currentPage = 1
    private var isLoadingMore = false

    init(
        dependenciesContainer: NewsDependenciesContainer,
        coordinator: NewsCoordinator
    ) {
        self.state = NewsState()
        self.newsService = dependenciesContainer.newsService
        self.dependenciesContainer = dependenciesContainer
        self.coordinator = coordinator
    }

    func handle(_ event: NewsEvent) {
        switch event {
        case .viewDidLoad, .refresh, .retry:
            currentPage = 1
            Task { await loadNews() }
            
        case .loadMore:
            guard !isLoadingMore else { return }
            currentPage += 1
            Task { await loadNews(isLoadingMore: true) }
            
        case .selectArticle(let article):
            if let url = URLService.news.makeURL(for: NewsEndpoint.article(id: article.id)) {
                coordinator.showArticleDetails(url: url)
            }
            
        case .shareArticle(let article):
            coordinator.showShareSheet(for: article)
        }
    }
    
    private func loadNews(isLoadingMore: Bool = false) async {
        self.isLoadingMore = isLoadingMore
        
        do {
            let news = try await newsService.fetchNews(
                pageIndex: currentPage
            )
            
            if news.news.isEmpty {
                state.error = .noData
                state.isLoading = false
                self.isLoadingMore = false
                return
            }
            
            if isLoadingMore {
                state.articles.append(contentsOf: news.news)
            } else {
                state.articles = news.news
            }
            state.error = nil
            state.isLoading = false
            self.isLoadingMore = false
            
        } catch let error as NewsError {
            state.error = error
            state.isLoading = false
            state.articles.removeAll()
            self.isLoadingMore = false
        } catch {
            state.error = .network
            state.isLoading = false
            state.articles.removeAll()
            self.isLoadingMore = false
        }
    }
}
