import Networking

extension NetworkClient {
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
        "1"
    }

    static var live: NetworkClient {
        .live(baseURL: .init(string: "\(`protocol`)://\(host)/\(path)")!)
    }
}
