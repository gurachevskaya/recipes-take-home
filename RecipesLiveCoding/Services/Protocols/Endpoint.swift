import Foundation

protocol Endpoint {
    // HTTP or HTTPS
    var scheme: String { get }
    
    var baseURL: String { get }

    var path: String { get }
    
    var queryItems: [URLQueryItem] { get }
    
    var headers: [String: String] { get }
    
    var method: String { get }
}
