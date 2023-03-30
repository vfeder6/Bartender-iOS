import Foundation

protocol IdentifiedMultipliable: Identifiable {
    init(id: UUID)
}

extension IdentifiedMultipliable {
    static func multiply(times: Int) -> [Self] {
        var array: [Self] = []
        for _ in 0 ..< times {
            array.append(.init(id: .init()))
        }
        return array
    }
}
