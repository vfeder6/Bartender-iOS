import Foundation
import Networking

struct DrinkDetailsService: Microservice {
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
                return .failure(._unknown)
            }
            return .success(drink)
        }
    }
}

struct DrinkDetailsResponse: DTO {
    let drinks: [Drink]
}
