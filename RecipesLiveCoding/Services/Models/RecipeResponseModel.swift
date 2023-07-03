import Foundation

struct RecipeResponseModel: Decodable {
    let offset: Int
    let number: Int
    let results: [RecipeResultsResponseModel]?
    let totalResults: Int
}

struct RecipeResultsResponseModel: Decodable {
    let id: Int
    let title: String?
    let image: String?
    let instructions: String?
}
