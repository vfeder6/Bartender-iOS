import Foundation
import Networking

final class DrinksListViewModel: ObservableObject {
    private let drinksListService: DrinksListService
    @Published private(set) var state: State
    @Published var navigation: Navigation

    struct State {
        var drinks: [Drink]
        var error: NetworkError?
    }

    struct Navigation {
        var selectedDrink: Drink?
    }

    init(drinksListService: DrinksListService = .live) {
        self.drinksListService = drinksListService
        self.state = .init(drinks: [], error: nil)
        self.navigation = .init()
    }

    @MainActor
    func fetch() async {
        switch await drinksListService.perform() {
        case .success(let drinks):
            state.drinks = drinks

        case .failure(let error):
            state.error = error
        }
    }

    func drinkSelected(_ drink: Drink) {
        navigation.selectedDrink = drink
    }
}
