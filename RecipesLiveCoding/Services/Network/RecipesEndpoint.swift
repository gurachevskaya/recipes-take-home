import Foundation

//https://api.spoonacular.com/recipes/complexSearch?query=pasta&maxFat=25&number=10

enum RecipesEndpoint: Endpoint {
    case getAvocadoRecipes(offset: Int, number: Int)

    var baseURL: String {
        return "api.spoonacular.com"
    }
    
    var scheme: String {
        return "https"
    }
    
    var path: String {
        switch self {
        case .getAvocadoRecipes:
            return "/recipes/complexSearch"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getAvocadoRecipes(let offset, let number):
            return [
                URLQueryItem(name: "query", value: "avocado"),
                URLQueryItem(name: "number", value: String(number)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .getAvocadoRecipes:
            return [
                "Content-Type": "application/json",
                "X-API-KEY": Constants.apiKey
            ]
        }
    }
    
    var method: String {
        switch self {
        case .getAvocadoRecipes:
            return "GET"
        }
    }
    
}
