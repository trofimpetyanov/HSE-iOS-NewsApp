import UIKit

final class AsyncImageView: UIView {
    private enum Constants {
        static let warningImageName = "exclamationmark.triangle.fill"
        static let warningImageSize: CGFloat = 40
        static let warningTintColor: UIColor = .tertiaryLabel
    }
    
    private let imageView = UIImageView()
    private let shimmerView = ShimmerView()
    private let warningImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.warningTintColor
        imageView.image = UIImage(systemName: Constants.warningImageName)
        imageView.isHidden = true
        return imageView
    }()
    
    private var currentLoadingURL: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        addSubview(shimmerView)
        addSubview(warningImageView)
        
        imageView.pin(to: self)
        shimmerView.pin(to: self)
        
        warningImageView.pinCenter(to: self)
        warningImageView.setWidth(Constants.warningImageSize)
        warningImageView.setHeight(Constants.warningImageSize)
    }
    
    func loadImage(from url: URL) {
        guard currentLoadingURL != url else { return }
        
        reset()
        currentLoadingURL = url
        
        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            imageView.image = cachedImage
            shimmerView.stopAnimating()
            shimmerView.isHidden = true
            warningImageView.isHidden = true
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard currentLoadingURL == url else { return }
                
                await MainActor.run {
                    if let image = UIImage(data: data) {
                        ImageCache.shared.setImage(image, forKey: url.absoluteString)
                        
                        imageView.image = image
                        shimmerView.stopAnimating()
                        shimmerView.isHidden = true
                        warningImageView.isHidden = true
                    } else {
                        showWarningState()
                    }
                }
            } catch {
                guard currentLoadingURL == url else { return }
                await MainActor.run {
                    showWarningState()
                }
            }
            
            currentLoadingURL = nil
        }
    }
    
    private func showWarningState() {
        shimmerView.stopAnimating()
        shimmerView.isHidden = true
        warningImageView.isHidden = false
    }
    
    func reset() {
        currentLoadingURL = nil
        imageView.image = nil
        shimmerView.isHidden = false
        shimmerView.startAnimating()
        warningImageView.isHidden = true
    }
} 
