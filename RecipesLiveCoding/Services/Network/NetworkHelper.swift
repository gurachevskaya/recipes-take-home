import Foundation
import Combine

enum NetworkError: Error {
    case badURL
    case invalidResponse
    case invalidData
}

class NetworkHelper: NetworkHelperProtocol {
    func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        print(components)
        
        guard let url = components.url else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = endpoint.headers
        request.httpMethod = endpoint.method
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ (data, response) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError.invalidResponse
                }
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? NetworkError {
                    return error
                } else {
                    return NetworkError.invalidData
                }
            }
            .eraseToAnyPublisher()
    }
}
