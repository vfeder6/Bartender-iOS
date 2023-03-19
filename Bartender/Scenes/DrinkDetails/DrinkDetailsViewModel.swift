import Foundation
import Networking

final class DrinkDetailsViewModel: ObservableObject {
    private let drinkDetailsService: DrinkDetailsService
    @Published private(set) var state: State

    struct State {
        let drinkID: String
        var drink: Drink?
        var error: NetworkError?
    }

    init(drinkDetailsService: DrinkDetailsService = .live, drinkID: String) {
        self.drinkDetailsService = drinkDetailsService
        self.state = .init(drinkID: drinkID, drink: nil, error: nil)
    }

    @MainActor
    func fetch() async {
        switch await drinkDetailsService.perform(drinkID: state.drinkID) {
        case .success(let drink):
            state.drink = drink

        case .failure(let error):
            state.error = error
        }
    }
}
