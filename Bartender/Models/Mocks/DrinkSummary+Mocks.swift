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
