import UIKit

protocol AppCoordinating: Coordinator {
    func showNews()
}

final class AppCoordinator: AppCoordinating {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showNews()
    }
    
    func showNews() {
        let newsCoordinator = NewsCoordinator(
            navigationController: navigationController,
            dependenciesContainer: NewsDependenciesContainer()
        )
        addChild(newsCoordinator)
        newsCoordinator.start()
    }
} 
