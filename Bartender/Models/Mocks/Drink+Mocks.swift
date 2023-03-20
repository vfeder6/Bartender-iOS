import Foundation

extension Drink {
    static var identifiableMock: Self {
        .init(
            id: UUID().uuidString,
            name: mock.name,
            category: mock.category,
            glass: mock.glass,
            alcoholLevel: mock.alcoholLevel,
            ibaCategory: mock.ibaCategory,
            instructions: mock.instructions
        )
    }
}
