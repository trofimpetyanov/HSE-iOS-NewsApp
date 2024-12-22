import UIKit
import SafariServices

protocol NewsCoordinating: Coordinator {
    func showArticleDetails(url: URL)
    func showShareSheet(for article: Article)
}

final class NewsCoordinator: NewsCoordinating {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let dependenciesContainer: NewsDependenciesContainer
    
    init(
        navigationController: UINavigationController,
        dependenciesContainer: NewsDependenciesContainer
    ) {
        self.navigationController = navigationController
        self.dependenciesContainer = dependenciesContainer
    }
    
    func start() {
        showNewsList()
    }
    
    private func showNewsList() {
        let viewController = NewsSceneBuilder().build(
            dependenciesContainer: dependenciesContainer,
            coordinator: self
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showArticleDetails(url: URL) {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        navigationController.present(safariViewController, animated: true)
    }
    
    func showShareSheet(for article: Article) {
        let activityViewController = UIActivityViewController(
            activityItems: [
                article.title,
                article.announce
            ],
            applicationActivities: nil
        )
        
        navigationController.present(activityViewController, animated: true)
    }
} 