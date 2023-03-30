import Networking

extension Microservice {
    static var live: Self {
        .init(networkClient: .live)
    }
}

extension MediaService {
    static var live: Self {
        .init(networkClient: .live)
    }
}
