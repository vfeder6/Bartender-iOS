import Foundation

extension Drink {
    static var mock: Self {
        .init(
            id: "1",
            name: "Old Fashioned",
            category: .cocktail,
            glass: .oldFashionedGlass,
            alcoholLevel: .alcoholic,
            ibaCategory: .unforgettables,
            instructions: "Place sugar cube in old fashioned glass and saturate with bitters, add a dash of plain water. Muddle until dissolved.\r\nFill the glass with ice cubes and add whiskey.\r\n\r\nGarnish with orange twist, and a cocktail cherry.",
            ingredients: [.init(name: "Mint", measure: "2 leaves"), .init(name: "Rhum", measure: "2 oz"), .init(name: "Lemon", measure: nil)]
        )
    }
}

extension Drink {
    static var identifiableMock: Self {
        .init(
            id: UUID().uuidString,
            name: mock.name,
            category: mock.category,
            glass: mock.glass,
            alcoholLevel: mock.alcoholLevel,
            ibaCategory: mock.ibaCategory,
            instructions: mock.instructions,
            ingredients: mock.ingredients
        )
    }
}

extension DrinkDetailsResponse {
    static var mock: Self {
        .init(drinks: [.mock])
    }
}
