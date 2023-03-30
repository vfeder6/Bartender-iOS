import Networking

extension NetworkClient {
    private static var apiKey: String {
        "1"
    }

    static var live: NetworkClient {
        .live(baseURL: URLBuilder(
            protocol: .https,
            host: "www.thecocktaildb.com",
            pathComponents: "api", "json", "v2", apiKey
        ).build())
    }
}
