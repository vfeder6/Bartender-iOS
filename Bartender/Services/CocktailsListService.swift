import Foundation
import Networking

protocol CocktailsListServiceProtocol {
    var networkService: NetworkService { get }

    func perform() async -> [Cocktail]
}

struct CocktailsListService: CocktailsListServiceProtocol {
    let networkService: NetworkService = .live

    func perform() async -> [Cocktail] {
        switch await networkService.body(from: "popular.php", decodeTo: CocktailsListResponse.self) {
        case .success(let response):
            return response.drinks

        case .failure:
            return []
        }
    }
}

struct CocktailsListServicePreview: CocktailsListServiceProtocol {
    let networkService: NetworkService = .mock

    func perform() async -> [Cocktail] {
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

struct CocktailsListResponse: Decodable {
    let drinks: [Cocktail]
}

struct Cocktail: Decodable, Hashable, Identifiable {
    let id: String
    let name: String
    let category: DrinkCategory
    let glass: Glass
    let isAlcoholic: Bool
    let ibaCategory: IBACategory?
    let instructions: String

    init(
        id: String,
        name: String,
        category: DrinkCategory,
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
        category = values.decodeDebug(DrinkCategory.self, forKey: .category)
        glass = values.decodeDebug(Glass.self, forKey: .glass)
        isAlcoholic = values.decodeDebug(String.self, forKey: .isAlcoholic) == "Alcoholic"
        ibaCategory = values.decodeDebug(IBACategory.self, forKey: .ibaCategory)
        instructions = values.decodeDebug(String.self, forKey: .instructions)
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

    enum DrinkCategory: String, Decodable, Unknownable {
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
