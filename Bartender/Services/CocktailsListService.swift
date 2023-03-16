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
            .init(id: "1", name: "Margarita", category: "Cocktail", glass: "Boh"),
            .init(id: "2", name: "Margarita", category: "Party drink", glass: "Boh"),
            .init(id: "3", name: "Margarita", category: "Classical drink", glass: "Boh"),
            .init(id: "4", name: "Margarita", category: "Cocktail", glass: "Boh"),
            .init(id: "5", name: "Margarita", category: "Cocktail", glass: "Boh")
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
    let category: String
    let glass: String

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case glass = "strGlass"
    }
}
