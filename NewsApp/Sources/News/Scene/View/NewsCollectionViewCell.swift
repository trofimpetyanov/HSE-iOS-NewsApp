import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    private enum Constants {
        enum Spacing {
            static let s: CGFloat = 8
            static let m: CGFloat = 12
            static let l: CGFloat = 16
        }
        
        enum Size {
            static let sourceIconSize: CGFloat = 20
            static let cornerRadius: CGFloat = 12
            static let imageAspectRatio: CGFloat = 0.6
        }
        
        enum Settings {
            static let numberOfLines: Int = 3
        }
    }
    
    // MARK: - Views
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = Constants.Size.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var newsImageView = AsyncImageView()
    
    private lazy var sourceIconView: AsyncImageView = {
        let view = AsyncImageView()
        view.layer.cornerRadius = Constants.Size.sourceIconSize / 2
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var sourceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = Constants.Settings.numberOfLines
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = Constants.Settings.numberOfLines
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    private lazy var sourceStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.Spacing.s
        stack.alignment = .center
        
        stack.addArrangedSubview(sourceIconView)
        stack.addArrangedSubview(sourceTitleLabel)
        
        return stack
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.Spacing.s
        
        stack.addArrangedSubview(sourceStackView)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(dateLabel)
        
        return stack
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.pinHorizontal(to: contentView, Constants.Spacing.l)
        containerView.pinVertical(to: contentView, Constants.Spacing.s)
        
        containerView.addSubview(newsImageView)
        newsImageView.pinTop(to: containerView)
        newsImageView.pinHorizontal(to: containerView)
        newsImageView.pinHeight(to: newsImageView.widthAnchor, Constants.Size.imageAspectRatio)
        
        sourceIconView.setWidth(Constants.Size.sourceIconSize)
        sourceIconView.setHeight(Constants.Size.sourceIconSize)
        
        containerView.addSubview(contentStackView)
        contentStackView.pinHorizontal(to: containerView, Constants.Spacing.m)
        contentStackView.pinTop(to: newsImageView.bottomAnchor, Constants.Spacing.m)
        contentStackView.pinBottom(to: containerView, Constants.Spacing.m)
    }
    
    // MARK: - Configuration
    func configure(with article: Article) {
        if let imageURL = article.image?.url {
            newsImageView.loadImage(from: imageURL)
        }
        
        sourceIconView.loadImage(from: article.sourceIcon)
        sourceTitleLabel.text = article.sourceName
        titleLabel.text = article.title
        descriptionLabel.text = article.announce
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        dateLabel.text = formatter.localizedString(for: article.date, relativeTo: Date())
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.reset()
        sourceIconView.reset()
    }
} 
