import Networking

extension Microservice where R: Response {
    static var live: Self {
        .init(networkClient: .live)
    }
}

extension Microservice where R: Media {
    static var live: Self {
        .init(networkClient: .live)
    }
}
