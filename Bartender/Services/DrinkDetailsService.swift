import Foundation
import Networking

struct DrinkDetailsService: Service {
    let networkService: NetworkService

    static var live: Self {
        .init(networkService: .live)
    }

    func perform(body: Encodable?, queryItems: [URLQueryItem]) async -> Result<Drink, NetworkError> {
        await networkService.body(from: "lookup.php", with: queryItems, decodeTo: DrinksListResponse.self)
            .flatMap { response in
                guard let drink = response.drinks.first else {
                    return .failure(.notDecodableData)
                }
                return .success(drink)
            }
    }

    func perform(drinkID: String) async -> Result<Drink, NetworkError> {
        await perform(body: nil, queryItems: [.init(name: "i", value: drinkID)])
    }
}

extension Drink {
    static var mock: Self {
        .init(
            id: "1",
            name: "Old Fashioned",
            category: .cocktail,
            glass: .oldFashionedGlass,
            isAlcoholic: true,
            ibaCategory: .unforgettables,
            instructions: "Place sugar cube in old fashioned glass and saturate with bitters, add a dash of plain water. Muddle until dissolved.\r\nFill the glass with ice cubes and add whiskey.\r\n\r\nGarnish with orange twist, and a cocktail cherry."
        )
    }
}
