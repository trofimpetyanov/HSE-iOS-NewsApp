import UIKit

@MainActor
protocol AppCoordinating: Coordinator {
    func showNews()
}

@MainActor
final class AppCoordinator: AppCoordinating {
    let navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init() {
        self.navigationController = UINavigationController()
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
