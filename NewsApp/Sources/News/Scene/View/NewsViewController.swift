import UIKit
import Combine

final class NewsViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let title = "News"
        
        enum Error {
            static let imageName = "exclamationmark.triangle.fill"
            static let buttonTitle = "Try Again"
        }
        
        enum Loading {
            static let title = "Loading News..."
            static let message = "Please wait while we fetch the latest news"
        }
    }
    
    // MARK: - Properties
    private let viewStore: ViewStore<NewsViewState, NewsViewEvent>
    private var theView: NewsView { view as! NewsView }
    private var observations: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    init(viewStore: ViewStore<NewsViewState, NewsViewEvent>) {
        self.viewStore = viewStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NewsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        bind(to: viewStore)
        bindToView()
        viewStore.handle(.viewDidLoad)
    }
    
    // MARK: - Setup
    private func setupNavigation() {
        navigationItem.title = Constants.title
    }
    
    // MARK: - Bindings
    private func bind(to viewStore: ViewStore<NewsViewState, NewsViewEvent>) {
        viewStore
            .$state
            .sink { [weak self] state in
                self?.theView.configure(with: state)
                self?.configureContentState(for: state)
            }
            .store(in: &observations)
    }
    
    private func bindToView() {
        theView.onArticleSelected = { [weak self] article in
            self?.viewStore.handle(.selectArticle(article))
        }
        
        theView.onArticleShare = { [weak self] article in
            self?.viewStore.handle(.shareArticle(article))
        }
        
        theView.onRefresh = { [weak self] in
            self?.viewStore.handle(.refresh)
        }
        
        theView.onLoadMore = { [weak self] in
            self?.viewStore.handle(.loadMore)
        }
    }
    
    // MARK: - Configuration
    private func configureContentState(for state: NewsState) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            if state.isLoading && state.articles.isEmpty {
                var configuration = UIContentUnavailableConfiguration.loading()
                configuration.text = Constants.Loading.title
                configuration.secondaryText = Constants.Loading.message
                self.contentUnavailableConfiguration = configuration
            } else if let error = state.error {
                var configuration = UIContentUnavailableConfiguration.empty()
                configuration.image = UIImage(systemName: Constants.Error.imageName)
                configuration.text = error.localizedDescription
                configuration.secondaryText = error.recoverySuggestion
                
                var buttonConfiguration = UIButton.Configuration.filled()
                buttonConfiguration.title = Constants.Error.buttonTitle
                buttonConfiguration.cornerStyle = .large
                
                configuration.button = buttonConfiguration
                configuration.buttonProperties.primaryAction = UIAction { [weak self] _ in
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    self?.viewStore.handle(.retry)
                }
                
                self.contentUnavailableConfiguration = configuration
            } else {
                self.contentUnavailableConfiguration = nil
            }
        }
        animator.startAnimation()
    }
}
