import Foundation

extension URLService {
    static let news = URLService(
        scheme: "https",
        host: "news.myseldon.com"
    )
    
    func articleShareURL(id: Int) -> String {
        "https://\(host)/ru/news/index/\(id)"
    }
} 