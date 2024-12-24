import UIKit
import SafariServices

@MainActor
protocol NewsCoordinating: Coordinator {
    func showArticleDetails(url: URL)
    func showShareSheet(with content: String)
}

@MainActor
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
    
    func showShareSheet(with content: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [content],
            applicationActivities: nil
        )
        
        navigationController.present(activityViewController, animated: true)
    }
}
