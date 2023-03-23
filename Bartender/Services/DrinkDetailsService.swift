import Foundation
import Networking

struct DrinkDetailsService: Service {
    let networkClient: NetworkClient

    static var live: Self {
        .init(networkClient: .live)
    }

    func perform(body: Encodable?, queryItems: [URLQueryItem]) async -> Result<Drink, NetworkError> {
        await networkClient.response(from: "lookup.php", queryItems: queryItems, decode: DrinkDetailsResponse.self)
            .flatMap { response in
                guard let drink = response.drinks.first else {
                    return .failure(.notDecodableData(model: type(of: response), json: nil))
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
