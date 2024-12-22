import UIKit

final class NewsView: UIView {
    var onArticleSelected: ((Article) -> Void)?
    var onArticleShare: ((Article) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with state: NewsState) {
        // Configure UI
    }
    
    private func setupUI() {
        // Setup UI
    }
}
