import Foundation
import Networking

struct DrinkDetailsService: Service {
    let networkClient: NetworkClient<DrinkDetailsResponse>

    func perform(drinkID: String) async -> Result<Drink, NetworkError> {
        await networkClient.responseResult(
            from: "lookup.php",
            queryItems: [.init(name: "i", value: drinkID)],
            body: nil,
            method: .get,
            additionalHeaders: [:],
            expectedStatusCode: 200
        )
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
