import Foundation

struct URLBuilder {
    private let `protocol`: `Protocol`
    private let host: String
    private let path: String

    enum `Protocol`: String {
        case http
        case https
    }

    init(protocol: `Protocol`, host: String, pathComponents: String...) {
        self.protocol = `protocol`
        self.host = host
        self.path = pathComponents.reduce("") { "\($0)/\($1)" }
    }

    func build() -> URL {
        .init(string: "\(`protocol`.rawValue)://\(host)\(path)")!
    }
}
