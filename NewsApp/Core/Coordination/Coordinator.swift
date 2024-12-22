import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        parentCoordinator?.removeChild(self)
    }
    
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
