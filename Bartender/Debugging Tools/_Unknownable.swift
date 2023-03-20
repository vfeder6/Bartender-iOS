extension KeyedDecodingContainer {
    func _decodeDebug<T>(_ type: T.Type, forKey key: Self.Key) -> T where T: Decodable & _Unknownable {
        do {
            return try decode(type, forKey: key)
        } catch {
            if case .dataCorrupted(let context) = (error as? DecodingError) {
                print("DECODING:", context.debugDescription)
            } else {
                print("DECODING: UNKNOWN", error)
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

extension Array where Element: _Unknownable {
    mutating func appendUnknownable(_ element: Element) {
        if element != ._unknown {
            append(element)
        }
    }
}
