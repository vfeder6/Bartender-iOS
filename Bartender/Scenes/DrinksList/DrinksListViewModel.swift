import Networking
import Foundation

final class DrinksListViewModel: ObservableObject {
    private let drinksListService: DrinksListService
    @Published private(set) var state: State

    struct State {
        var drinks: [Drink]
        var error: NetworkError?
    }

    init(drinksListService: DrinksListService = .live) {
        self.drinksListService = drinksListService
        self.state = .init(drinks: [], error: nil)
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
}
