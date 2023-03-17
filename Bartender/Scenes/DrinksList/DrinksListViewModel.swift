import Foundation

final class DrinksListViewModel: ObservableObject {
    let drinksListService: DrinksListServiceProtocol
    @Published private(set) var state: State

    struct State {
        var drinks: [Drink]
    }

    init(drinksListService: DrinksListServiceProtocol = DrinksListService()) {
        self.drinksListService = drinksListService
        self.state = .init(drinks: [])
    }

    @MainActor
    func fetch() async {
        state.drinks = await drinksListService.perform()
    }
}
