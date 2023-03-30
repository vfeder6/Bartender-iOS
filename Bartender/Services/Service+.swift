import Networking

extension Service {
    static var live: Self {
        .init(networkClient: .live)
    }
}
