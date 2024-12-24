import UIKit

final class NewsView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        enum Spacing {
            static let s: CGFloat = 8
        }
        
        enum Layout {
            static let estimatedHeight: CGFloat = 400
            static let interGroupSpacing: CGFloat = 8
            
            static let contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 0,
                bottom: 8,
                trailing: 0
            )
        }
        
        enum Settings {
            static let loadMoreThreshold = 2
        }
        
        enum Error {
            static let imageName = "exclamationmark.triangle.fill"
        }
    }
    
    // MARK: - Properties
    var onArticleSelected: ((Article) -> Void)?
    var onArticleShare: ((Article) -> Void)?
    var onRefresh: (() -> Void)?
    var onLoadMore: (() -> Void)?
    
    // MARK: UI Components
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addAction(
            UIAction { [weak self] _ in
                self?.onRefresh?()
            },
            for: .valueChanged
        )
        return control
    }()
    
    private let cellRegistration = UICollectionView.CellRegistration<NewsCollectionViewCell, Article> { cell, _, article in
        cell.configure(with: article)
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Article> = {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { [cellRegistration] collectionView, indexPath, article in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: article
            )
        }
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    // MARK: Configure
    func configure(with state: NewsState) {
        applySnapshot(with: state.articles)
        
        if !state.isLoading {
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(collectionView)
        collectionView.pin(to: self)
        collectionView.refreshControl = refreshControl
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Constants.Layout.estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Constants.Layout.estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constants.Layout.contentInsets
        section.interGroupSpacing = Constants.Layout.interGroupSpacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func applySnapshot(with articles: [Article]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.main])
        snapshot.appendItems(articles)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension NewsView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let article = dataSource.itemIdentifier(for: indexPath)
        else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        onArticleSelected?(article)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let article = dataSource.itemIdentifier(for: indexPath)
        else { return nil }
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { _ in
            let shareAction = UIAction(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { [weak self] _ in
                self?.onArticleShare?(article)
            }
            
            return UIMenu(children: [shareAction])
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let items = dataSource.snapshot().itemIdentifiers
        let thresholdIndex = items.count - Constants.Settings.loadMoreThreshold
        
        if indexPath.item == thresholdIndex {
            onLoadMore?()
        }
    }
}

// MARK: - Section
private extension NewsView {
    enum Section {
        case main
    }
}
