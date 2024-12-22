import Foundation

@MainActor
struct NewsSceneBuilder {
    func build(
        dependenciesContainer: NewsDependenciesContainer,
        coordinator: NewsCoordinator
    ) -> NewsViewController {
        NewsViewController(
            viewStore: ViewStore(
                NewsStore(
                    dependenciesContainer: dependenciesContainer,
                    coordinator: coordinator
                )
            )
        )
    }
}
