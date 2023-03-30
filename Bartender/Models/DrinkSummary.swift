struct DrinkSummary: Codable, Identifiable, Equatable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
    }
}
