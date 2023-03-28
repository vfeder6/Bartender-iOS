import Foundation

extension Array where Element == DrinkSummary {
    static var mock: Self {
        [
            .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock,
            .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock,
            .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock,
            .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock,
            .identifiableLongNameMock, .identifiableLongNameMock, .identifiableLongNameMock, .identifiableLongNameMock,
            .identifiableLongNameMock, .identifiableLongNameMock, .identifiableLongNameMock, .identifiableLongNameMock,
            .identifiableLongNameMock, .identifiableLongNameMock, .identifiableLongNameMock, .identifiableLongNameMock,
            .identifiableLongNameMock, .identifiableLongNameMock, .identifiableLongNameMock, .identifiableLongNameMock
        ]
    }
}

extension DrinkSummary {
    static var identifiableMock: Self {
        .init(id: UUID().uuidString, name: "Test drink")
    }

    static var identifiableLongNameMock: Self {
        .init(id: UUID().uuidString, name: "Test drink with very long and overflowing name")
    }
}

extension DrinksListResponse {
    static var mock: Self {
        .init(drinkSummaries: .mock)
    }
}

protocol Multipliable {
    func multiplied(times: Int) -> [Self]
}

extension Multipliable {
    func multiplied(times: Int) -> [Self] {
        var array: [Self] = []
        for _ in 0 ..< times {
            array.append(self)
        }
        return array
    }
}
