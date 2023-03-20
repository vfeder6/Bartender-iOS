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

extension Array where Element == DrinkSummary {
    static var mock: Self {
        [.identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock]
    }
}

extension DrinksListResponse {
    static var mock: Self {
        .init(drinkSummaries: .mock)
    }
}

extension Drink {
    static var identifiableMock: Self {
        .init(
            id: UUID().uuidString,
            name: mock.name,
            category: mock.category,
            glass: mock.glass,
            alcoholLevel: mock.alcoholLevel,
            ibaCategory: mock.ibaCategory,
            instructions: mock.instructions
        )
    }
}

extension NetworkService {
    private static var `protocol`: String {
        "https"
    }

    private static var host: String {
        "www.thecocktaildb.com"
    }

    private static var path: String {
        "api/json/v2/\(apiKey)"
    }

    private static var apiKey: String {
        "9973533"
    }

    static var live: NetworkService {
        .live(host: .init(string: "\(`protocol`)://\(host)/\(path)")!)
    }
}

struct DrinksListResponse: Codable {
    let drinkSummaries: [DrinkSummary]

    enum CodingKeys: String, CodingKey {
        case drinkSummaries = "drinks"
    }
}

struct DrinkSummary: Codable, Identifiable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
    }
}

extension DrinkSummary {
    static var identifiableMock: Self {
        .init(id: UUID().uuidString, name: "Test drink")
    }
}

struct Drink: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let category: Category
    let glass: Glass
    let alcoholLevel: AlcoholLevel
    let ibaCategory: IBACategory?
    let instructions: String

    init(
        id: String,
        name: String,
        category: Category,
        glass: Glass,
        alcoholLevel: AlcoholLevel,
        ibaCategory: IBACategory?,
        instructions: String
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.glass = glass
        self.alcoholLevel = alcoholLevel
        self.ibaCategory = ibaCategory
        self.instructions = instructions
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = values._decodeDebug(String.self, forKey: .id)
        name = values._decodeDebug(String.self, forKey: .name)
        category = values._decodeDebug(Category.self, forKey: .category)
        glass = values._decodeDebug(Glass.self, forKey: .glass)
        alcoholLevel = values._decodeDebug(AlcoholLevel.self, forKey: .alcoholLevel)
        ibaCategory = values._decodeDebug(IBACategory.self, forKey: .ibaCategory)
        instructions = values._decodeDebug(String.self, forKey: .instructions)
    }

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case glass = "strGlass"
        case alcoholLevel = "strAlcoholic"
        case ibaCategory = "strIBA"
        case instructions = "strInstructions"
    }

    enum Category: String, Codable, _Unknownable {
        case cocktail = "Cocktail"
        case ordinaryDrink = "Ordinary Drink"
        case punchPartyDrink = "Punch / Party Drink"
        case _unknown
    }

    enum Glass: String, Codable, _Unknownable {
        case highballGlass = "Highball glass"
        case oldFashionedGlass = "Old-fashioned glass"
        case cocktailGlass = "Cocktail glass"
        case copperMug = "Copper Mug"
        case whiskeyGlass = "Whiskey Glass"
        case _unknown
    }

    enum AlcoholLevel: String, Codable, _Unknownable {
        case alcoholic = "Alcoholic"
        case notAlcoholic = "Not alcoholic"
        case _unknown
    }

    enum IBACategory: String, Codable, _Unknownable {
        case contemporaryClassic = "Contemporary Classics"
        case unforgettables = "Unforgettables"
        case _unknown
    }
}

extension KeyedDecodingContainer {
    func _decodeDebug<T>(_ type: T.Type, forKey key: Self.Key) -> T where T: Decodable & _Unknownable {
        do {
            return try decode(type, forKey: key)
        } catch {
            if case .dataCorrupted(let context) = (error as? DecodingError) {
                print("DECODING:", context.debugDescription)
            } else {
                print("DECODING: UNKNOWN", error)
            }
            return ._unknown
        }
    }
}

protocol _Unknownable {
    static var _unknown: Self { get }
}

extension String: _Unknownable {
    static var _unknown: String {
        "Unknown"
    }
}
