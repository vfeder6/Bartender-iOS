import Networking

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
