extension KeyedDecodingContainer {
    func _decodeDebug<T>(_ type: T.Type, forKey key: Self.Key) -> T where T: Decodable & _Unknownable {
        do {
            return try decode(type, forKey: key)
        } catch {
            if case .dataCorrupted(let context) = (error as? DecodingError) {
                print("DECODING:", context.debugDescription)
            } else {
                print("DECODINGUNKNOWN:", error)
            }
            return ._unknown
        }
    }
}

protocol _Unknownable: Equatable {
    static var _unknown: Self { get }
}

extension String: _Unknownable {
    static var _unknown: String {
        "Unknown"
    }
}
