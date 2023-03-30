import Foundation
import Networking
import SwiftUI

final class DrinkDetailsViewModel: ObservableObject {
    private let drinkDetailsService: DrinkDetailsService
    private let drinkImageService: DrinkImageService
    @Published private(set) var state: State

    struct State {
        let drinkID: String
        var drink: Drink?
        var drinkImage: Image?
        var error: NetworkError?
    }

    init(drinkDetailsService: DrinkDetailsService = .live, drinkImageService: DrinkImageService = .live, drinkID: String) {
        self.drinkDetailsService = drinkDetailsService
        self.drinkImageService = drinkImageService
        self.state = .init(drinkID: drinkID, drink: nil, drinkImage: nil, error: nil)
    }

    @MainActor
    func fetch() async {
        switch await drinkDetailsService.perform(drinkID: state.drinkID) {
        case .success(let drink):
            state.drink = drink
            await fetchImage(for: drink)

        case .failure(let error):
            state.error = error
        }
    }

    @MainActor
    private func fetchImage(for drink: Drink) async {
        switch await drinkImageService.fetch(fileName: drink.imageFileName) {
        case .success(let image):
            state.drinkImage = image

        case .failure(let error):
            state.error = error
        }
    }
}

private extension Drink {
    var imageFileName: String {
        let urlString = imageURL.absoluteString
        guard let index = urlString.lastIndex(of: "/")
        else { return "" }
        return String(urlString[index...]).replacingOccurrences(of: "/", with: "")
    }
}
