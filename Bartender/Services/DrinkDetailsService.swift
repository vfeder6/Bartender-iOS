import Foundation
import Networking

struct DrinkDetailsService: Service {
    let networkService: NetworkService

    static var live: Self {
        .init(networkService: .live)
    }

    func perform(body: Encodable?, queryItems: [URLQueryItem]) async -> Result<Drink, NetworkError> {
        await networkService.body(from: "lookup.php", with: queryItems, decodeTo: DrinkDetailsResponse.self)
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

struct DrinkDetailsResponse: Codable {
    let drinks: [Drink]
}
