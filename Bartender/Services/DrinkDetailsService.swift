import Foundation
import Networking

struct DrinkDetailsService: Service {
    let networkClient: NetworkClient<DrinkDetailsResponse>

    static var live: Self {
        .init(networkClient: .live)
    }

    func perform(body: Encodable?, queryItems: [URLQueryItem]) async -> Result<DrinkDetailsResponse, NetworkError> {
        await networkClient.responseResult(from: "lookup.php", queryItems: queryItems)
    }

    func perform(drinkID: String) async -> Result<Drink, NetworkError> {
        await perform(body: nil, queryItems: [.init(name: "i", value: drinkID)])
            .flatMap { response in
                guard let drink = response.drinks.first else {
                    return .failure(.notDecodableData(model: type(of: response), json: nil))
                }
                return .success(drink)
            }
    }
}

struct DrinkDetailsResponse: Codable {
    let drinks: [Drink]
}
