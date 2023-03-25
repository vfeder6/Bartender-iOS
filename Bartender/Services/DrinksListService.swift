import Foundation
import Networking

struct DrinksListService: Service {
    let networkClient: NetworkClient<DrinksListResponse>

    static var live: Self {
        .init(networkClient: .live)
    }

    func perform(body: Encodable?, queryItems: [URLQueryItem]) async -> Result<DrinksListResponse, NetworkError> {
        await networkClient.responseResult(from: "filter.php", queryItems: queryItems)
    }

    func perform() async -> Result<[DrinkSummary], NetworkError> {
        await perform(body: nil, queryItems: [.init(name: "a", value: "Alcoholic")])
            .map(\.drinkSummaries)
    }
}

struct DrinksListResponse: Codable {
    let drinkSummaries: [DrinkSummary]

    enum CodingKeys: String, CodingKey {
        case drinkSummaries = "drinks"
    }
}
