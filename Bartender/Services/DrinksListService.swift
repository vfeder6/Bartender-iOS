import Foundation
import Networking

struct DrinksListService: Service {
    let networkClient: NetworkClient<DrinksListResponse>

    func perform() async -> Result<[DrinkSummary], NetworkError> {
        await networkClient.responseResult(
            from: "filter.php",
            queryItems: [.init(name: "a", value: "Alcoholic")],
            body: nil,
            method: .get,
            additionalHeaders: [:],
            expectedStatusCode: 200
        )
        .map(\.drinkSummaries)
    }
}

struct DrinksListResponse: Codable {
    let drinkSummaries: [DrinkSummary]

    enum CodingKeys: String, CodingKey {
        case drinkSummaries = "drinks"
    }
}
