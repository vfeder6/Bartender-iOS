import Foundation

extension Drink {
    static var mock: Self {
        .init(
            id: "1",
            name: "Old Fashioned",
            category: .cocktail,
            glass: .oldFashioned,
            alcoholLevel: .alcoholic,
            ibaCategory: .unforgettables,
            imageURL: .init(string: "https://example.com")!,
            instructions:
                """
                Place sugar cube in old fashioned glass and saturate with bitters, add a dash of plain water.
                Muddle until dissolved.\r\nFill the glass with ice cubes and add whiskey.\r\n\r\n
                Garnish with orange twist, and a cocktail cherry.
                """,
            ingredients: [
                .init(name: "Mint", measure: "2 leaves"),
                .init(name: "Rhum", measure: "2 oz"),
                .init(name: "Lemon", measure: nil)
            ]
        )
    }
}

extension DrinkDetailsResponse {
    static var mock: Self {
        .init(drinks: [.mock])
    }
}
