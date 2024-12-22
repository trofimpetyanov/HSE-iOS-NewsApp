import Foundation

final class NewsStore: Store {
    @Published private(set) var state: NewsState
    var statePublisher: Published<NewsState>.Publisher { $state }
    
    private let dependenciesContainer: NewsDependenciesContainer
    private let coordinator: NewsCoordinator

    init(
        dependenciesContainer: NewsDependenciesContainer,
        coordinator: NewsCoordinator
    ) {
        self.state = NewsState()
        self.dependenciesContainer = dependenciesContainer
        self.coordinator = coordinator
    }

    func handle(_ event: NewsEvent) {
        switch event {
        case .viewDidLoad:
            Task { await loadNews() }
            
        case .refresh:
            Task { await loadNews() }
            
        case .selectArticle(let article):
            if let url = URL(string: "https://news.myseldon.com/ru/news/index/\(article.id)") {
                coordinator.showArticleDetails(url: url)
            }
            
        case .shareArticle(let article):
            coordinator.showShareSheet(for: article)
        }
    }
    
    private func loadNews() async {
        state.isLoading = true
        
        do {
            let news = try await dependenciesContainer.newsService.fetchNews()
            await MainActor.run {
                state.articles = news.news
                state.isLoading = false
            }
        } catch {
            await MainActor.run {
                state.error = error
                state.isLoading = false
            }
        }
    }
}
