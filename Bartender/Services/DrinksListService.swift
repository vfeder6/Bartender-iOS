import Foundation
import Networking

struct DrinksListService: Service {
    let networkClient: NetworkClient

    static var live: Self {
        .init(networkClient: .live)
    }

    func perform(body: Encodable?, queryItems: [URLQueryItem]) async -> Result<[DrinkSummary], NetworkError> {
        await networkClient.response(from: "filter.php", queryItems: queryItems, decode: DrinksListResponse.self).map(\.drinkSummaries)
    }

    func perform() async -> Result<[DrinkSummary], NetworkError> {
        await perform(body: nil, queryItems: [.init(name: "a", value: "Alcoholic")])
    }
}

struct DrinksListResponse: Codable {
    let drinkSummaries: [DrinkSummary]

    enum CodingKeys: String, CodingKey {
        case drinkSummaries = "drinks"
    }
}
