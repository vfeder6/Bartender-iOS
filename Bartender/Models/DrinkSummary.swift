struct DrinkSummary: Codable, Identifiable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
    }
}
