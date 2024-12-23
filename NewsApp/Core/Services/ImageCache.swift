import UIKit

final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "com.newsapp.imagecache")
    
    private init() {
        cache.countLimit = 100
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        queue.async {
            self.cache.setObject(image, forKey: key as NSString)
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        queue.sync {
            cache.object(forKey: key as NSString)
        }
    }
    
    func clear() {
        queue.async {
            self.cache.removeAllObjects()
        }
    }
} 
