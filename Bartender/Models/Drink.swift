struct Drink: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let category: Category
    let glass: Glass
    let alcoholLevel: AlcoholLevel
    let ibaCategory: IBACategory?
    let instructions: String

    init(
        id: String,
        name: String,
        category: Category,
        glass: Glass,
        alcoholLevel: AlcoholLevel,
        ibaCategory: IBACategory?,
        instructions: String
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.glass = glass
        self.alcoholLevel = alcoholLevel
        self.ibaCategory = ibaCategory
        self.instructions = instructions
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = values._decodeDebug(String.self, forKey: .id)
        name = values._decodeDebug(String.self, forKey: .name)
        category = values._decodeDebug(Category.self, forKey: .category)
        glass = values._decodeDebug(Glass.self, forKey: .glass)
        alcoholLevel = values._decodeDebug(AlcoholLevel.self, forKey: .alcoholLevel)
        ibaCategory = values._decodeDebug(IBACategory.self, forKey: .ibaCategory)
        instructions = values._decodeDebug(String.self, forKey: .instructions)
    }

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case glass = "strGlass"
        case alcoholLevel = "strAlcoholic"
        case ibaCategory = "strIBA"
        case instructions = "strInstructions"
    }

    enum Category: String, Codable, _Unknownable {
        case cocktail = "Cocktail"
        case ordinaryDrink = "Ordinary Drink"
        case punchPartyDrink = "Punch / Party Drink"
        case shot = "Shot"
        case beer = "Beer"
        case shake = "Shake"
        case other = "Other / Unknown"
        case homemadeLiqueur = "Homemade Liqueur"
        case _unknown
    }

    enum Glass: String, Codable, _Unknownable {
        case highballGlass = "Highball glass"
        case oldFashionedGlass = "Old-fashioned glass"
        case cocktailGlass = "Cocktail glass"
        case copperMug = "Copper Mug"
        case whiskeyGlass = "Whiskey Glass"
        case beerGlass = "Beer Glass"
        case beerMug = "Beer mug"
        case whiteWineGlass = "White wine glass"
        case shotGlass = "Shot glass"
        case collinsGlass = "Collins glass"
        case irishCoffeeCup = "Irish coffee cup"
        case martiniGlass = "Martini Glass"
        case margaritaGlass = "Margarita/Coupette glass"
        case _unknown
    }

    enum AlcoholLevel: String, Codable, _Unknownable {
        case alcoholic = "Alcoholic"
        case notAlcoholic = "Not alcoholic"
        case _unknown
    }

    enum IBACategory: String, Codable, _Unknownable {
        case contemporaryClassic = "Contemporary Classics"
        case unforgettables = "Unforgettables"
        case _unknown
    }
}
