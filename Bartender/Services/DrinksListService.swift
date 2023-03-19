import Foundation
import Networking

struct DrinksListService: Service {
    let networkService: NetworkService

    static var live: Self {
        .init(networkService: .live)
    }

    func perform(body: Encodable?, queryItems: [URLQueryItem]) async -> Result<[Drink], NetworkError> {
        await networkService.body(from: "popular.php", decodeTo: DrinksListResponse.self).map(\.drinks)
    }

    func perform() async -> Result<[Drink], NetworkError> {
        await perform(body: nil, queryItems: [])
    }
}

extension Array where Element == Drink {
    static var mock: Self {
        [
            .init(id: "1", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "2", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "3", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "4", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "5", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "6", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "7", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "8", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "9", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "10", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "11", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
            .init(id: "12", name: "Test", category: .cocktail, glass: .highballGlass, isAlcoholic: true, ibaCategory: .contemporaryClassic, instructions: "test instructions"),
        ]
    }
}

extension DrinksListResponse {
    static var mock: Self {
        .init(drinks: .mock)
    }

    static var mockSingleValue: Self {
        .init(drinks: [.mock])
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
    let drinks: [Drink]
}

struct Drink: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let category: Category
    let glass: Glass
    let isAlcoholic: Bool
    let ibaCategory: IBACategory?
    let instructions: String

    init(
        id: String,
        name: String,
        category: Category,
        glass: Glass,
        isAlcoholic: Bool,
        ibaCategory: IBACategory?,
        instructions: String
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.glass = glass
        self.isAlcoholic = isAlcoholic
        self.ibaCategory = ibaCategory
        self.instructions = instructions
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = values.decodeDebug(String.self, forKey: .id)
        name = values.decodeDebug(String.self, forKey: .name)
        category = values.decodeDebug(Category.self, forKey: .category)
        glass = values.decodeDebug(Glass.self, forKey: .glass)
        isAlcoholic = values.decodeDebug(String.self, forKey: .isAlcoholic) == "Alcoholic"
        ibaCategory = values.decodeDebug(IBACategory.self, forKey: .ibaCategory)
        instructions = values.decodeDebug(String.self, forKey: .instructions)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category.rawValue, forKey: .category)
        try container.encode(glass.rawValue, forKey: .glass)
        try container.encode(isAlcoholic ? "Alcoholic" : "Not alcoholic", forKey: .isAlcoholic)
        try container.encode(ibaCategory?.rawValue, forKey: .ibaCategory)
        try container.encode(instructions, forKey: .instructions)
    }

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case glass = "strGlass"
        case isAlcoholic = "strAlcoholic"
        case ibaCategory = "strIBA"
        case instructions = "strInstructions"
    }

    enum IBACategory: String, Decodable, Unknownable {
        case contemporaryClassic = "Contemporary Classics"
        case unforgettables = "Unforgettables"
        case unknown
    }

    enum Category: String, Decodable, Unknownable {
        case cocktail = "Cocktail"
        case ordinaryDrink = "Ordinary Drink"
        case punchPartyDrink = "Punch / Party Drink"
        case unknown
    }

    enum Glass: String, Decodable, Unknownable {
        case highballGlass = "Highball glass"
        case oldFashionedGlass = "Old-fashioned glass"
        case cocktailGlass = "Cocktail glass"
        case copperMug = "Copper Mug"
        case whiskeyGlass = "Whiskey Glass"
        case unknown
    }
}

extension KeyedDecodingContainer {
    func decodeDebug<T>(_ type: T.Type, forKey key: Self.Key) -> T where T: Decodable & Unknownable {
        do {
            return try decode(type, forKey: key)
        } catch {
            if case .dataCorrupted(let context) = (error as? DecodingError) {
                print("DECODING:", context.debugDescription)
            } else {
                print("DECODING: UNKNOWN", error)
            }
            return .unknown
        }
    }
}

protocol Unknownable {
    static var unknown: Self { get }
}

extension String: Unknownable {
    static var unknown: String {
        "Unknown"
    }
}
