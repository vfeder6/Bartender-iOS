import Foundation
import Networking

struct DrinkDetailsService: Service {
    let networkService: NetworkService

    static var live: Self {
        .init(networkService: .live)
    }

    func perform(body: (any Encodable)?, queryItems: [URLQueryItem]) async -> Result<Drink, NetworkError> {
        await networkService.body(from: "lookup.php", with: queryItems, decodeTo: Drink.self)
    }

    func perform(drinkID: String) async -> Result<Drink, NetworkError> {
        await perform(body: nil, queryItems: [.init(name: "i", value: drinkID)])
    }
}

extension DrinkDetailsService {
    static var preview: Self {
        try! .init(networkService: .mock(returning: .success(Drink.mock)))
    }
}

extension Drink {
    static var mock: Self {
        .init(
            id: "1",
            name: "Test",
            category: .cocktail,
            glass: .highballGlass,
            isAlcoholic: true,
            ibaCategory: .contemporaryClassic,
            instructions: "test instructions"
        )
    }
}