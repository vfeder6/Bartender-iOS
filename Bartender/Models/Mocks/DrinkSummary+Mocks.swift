import Foundation

extension Array where Element == DrinkSummary {
    static var mock: Self {
        [.identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock, .identifiableMock]
    }
}

extension DrinkSummary {
    static var identifiableMock: Self {
        .init(id: UUID().uuidString, name: "Test drink")
    }
}

extension DrinksListResponse {
    static var mock: Self {
        .init(drinkSummaries: .mock)
    }
}
