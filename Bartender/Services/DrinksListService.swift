import Foundation
import Networking

struct DrinksListService: Service {
    let networkService: NetworkService

    static var live: Self {
        .init(networkService: .live)
    }

    func perform(body: Encodable?, queryItems: [URLQueryItem]) async -> Result<[DrinkSummary], NetworkError> {
        await networkService.body(from: "filter.php", with: queryItems, decodeTo: DrinksListResponse.self).map(\.drinkSummaries)
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
