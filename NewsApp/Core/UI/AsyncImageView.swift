import UIKit

final class AsyncImageView: UIView {
    private let imageView = UIImageView()
    private let shimmerView = ShimmerView()
    
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
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            shimmerView.topAnchor.constraint(equalTo: topAnchor),
            shimmerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func loadImage(from url: URL) {
        shimmerView.startAnimating()
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                await MainActor.run {
                    if let image = UIImage(data: data) {
                        imageView.image = image
                        shimmerView.stopAnimating()
                        shimmerView.isHidden = true
                    }
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
} 