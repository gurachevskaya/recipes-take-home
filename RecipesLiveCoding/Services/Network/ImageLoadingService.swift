import UIKit
import Combine

class ImageLoadingService: ImageLoadingProtocol {
    
    static let shared = ImageLoadingService()
    
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    func downloadImage(from string: String) -> AnyPublisher<UIImage?, Never> {
        let key = NSString(string: string)
        
        if let image = cache.object(forKey: key)  {
            return Just(image).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: string) else {
            return Just(nil).eraseToAnyPublisher()
        }
                
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ (data, response) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            })
            .map { UIImage(data: $0) }
            .handleEvents(receiveOutput: { [weak self] image in
                if let image = image {
                    self?.cache.setObject(image, forKey: key)
                }
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
