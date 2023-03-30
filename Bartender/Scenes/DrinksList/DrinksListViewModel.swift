import Foundation
import Networking

final class DrinksListViewModel: ObservableObject {
    private let drinksListService: DrinksListService
    @Published private(set) var state: State
    @Published var navigation: Navigation

    struct State {
        var drinkSummaries: [DrinkSummary]
        var error: NetworkError?
        var isSearching: Bool
        var searchText: String
    }

    struct Navigation {
        var selectedDrink: DrinkSummary?
    }

    init(drinksListService: DrinksListService = .live) {
        self.drinksListService = drinksListService
        self.state = .init(drinkSummaries: [], error: nil, isSearching: false, searchText: "")
        self.navigation = .init()
    }

    @MainActor
    func fetch() async {
        switch await drinksListService.perform() {
        case .success(let drinkSummaries):
            state.drinkSummaries = drinkSummaries

        case .failure(let error):
            state.error = error
        }
    }

    func drinkSelected(_ drinkSummary: DrinkSummary) {
        navigation.selectedDrink = drinkSummary
    }

    func searchButtonSelected() {
        state.isSearching = true
    }

    func closeSearchButtonSelected() {
        state.isSearching = false
        state.searchText = ""
    }

    func searchTextChanged(to newText: String) {
        state.searchText = newText
    }
}
