import Foundation
import Combine

class RecipesViewModel {
    private let recipesService: RecipesServiceProtocol
    
    init(recipesService: RecipesServiceProtocol) {
        self.recipesService = recipesService
    }
    
    @Published var isLoading = false
    @Published var hasError = false
    @Published var recipes: [RecipeModel] = []
    
    var offset = 0
    let number = 20
    var isFetchingRecipes = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadRecipes() {
        guard !isFetchingRecipes else { return }
        
        isFetchingRecipes = true
        if offset == 0 { isLoading = true }
        
        recipesService.loadRecipes(offset: offset, number: number)
            .receive(on: DispatchQueue.main)
            .map { [weak self] in self?.mapRecipes($0) ?? [] }
            .sink { [weak self] completion in
                guard let self else { return }
                
                self.isFetchingRecipes = false
                self.isLoading = false
                
                switch completion {
                case .finished:
                    self.offset += self.number
                case .failure(let error):
                    self.hasError = true
                }
            } receiveValue: { [weak self] recipes in
                self?.recipes += recipes
                print("received recipes", recipes.count)
                print(self?.recipes.count)
            }
            .store(in: &cancellables)
    }
    
    private func mapRecipes(_ model: RecipeResponseModel) -> [RecipeModel] {
        model.results?.map { recipe in
            RecipeModel(imageURL: recipe.image, name: recipe.title ?? "")
        } ?? []
    }
}
