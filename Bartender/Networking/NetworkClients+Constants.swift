import Networking
import SwiftUI

extension NetworkClient where R: Response {
    private static var apiKey: String {
        "1"
    }

    static var live: Self {
        .json(baseURL: URLBuilder(
            protocol: .https,
            host: "www.thecocktaildb.com",
            pathComponents: "api", "json", "v2", apiKey
        ).build())
    }
}

extension NetworkClient where R: Media {
    private static var apiKey: String {
        "1"
    }

    static var live: Self {
        .media(baseURL: URLBuilder(
            protocol: .https,
            host: "www.thecocktaildb.com",
            pathComponents: "images"
        ).build())
    }
}
