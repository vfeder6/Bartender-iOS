import Foundation

final class CocktailsListViewModel: ObservableObject {
    let cocktailsListService: CocktailsListServiceProtocol
    @Published private(set) var state: State

    struct State {
        var cocktails: [Cocktail]
    }

    init(cocktailsListService: CocktailsListServiceProtocol = CocktailsListService()) {
        self.cocktailsListService = cocktailsListService
        self.state = .init(cocktails: [])
    }

    @MainActor
    func fetch() async {
        state.cocktails = await cocktailsListService.perform()
    }
}
