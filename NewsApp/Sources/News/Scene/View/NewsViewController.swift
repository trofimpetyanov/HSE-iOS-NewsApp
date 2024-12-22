import UIKit
import Combine

final class NewsViewController: UIViewController {
    private let viewStore: ViewStore<NewsViewState, NewsViewEvent>
    private var theView: NewsView { view as! NewsView }
    private var observations: Set<AnyCancellable> = []

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
        bind(to: viewStore)
    }

    private func bind(to viewStore: ViewStore<NewsViewState, NewsViewEvent>) {
        viewStore.$state
            .sink { [weak self] state in
                self?.theView.configure(with: state)
            }
            .store(in: &observations)
        
        viewStore.handle(.viewDidLoad)
    }
}
