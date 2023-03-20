struct Drink: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let category: Category
    let glass: Glass
    let alcoholLevel: AlcoholLevel
    let ibaCategory: IBACategory?
    let instructions: String
    var ingredients: [Ingredient]

    init(
        id: String,
        name: String,
        category: Category,
        glass: Glass,
        alcoholLevel: AlcoholLevel,
        ibaCategory: IBACategory?,
        instructions: String,
        ingredients: [Ingredient]
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.glass = glass
        self.alcoholLevel = alcoholLevel
        self.ibaCategory = ibaCategory
        self.instructions = instructions
        self.ingredients = ingredients
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
        ingredients = []

        let ingredient1 = values._decodeDebug(String.self, forKey: .ingredient1)
        let ingredient2 = values._decodeDebug(String.self, forKey: .ingredient2)
        let ingredient3 = values._decodeDebug(String.self, forKey: .ingredient3)
        let ingredient4 = values._decodeDebug(String.self, forKey: .ingredient4)
        let ingredient5 = values._decodeDebug(String.self, forKey: .ingredient5)
        let ingredient6 = values._decodeDebug(String.self, forKey: .ingredient6)
        let ingredient7 = values._decodeDebug(String.self, forKey: .ingredient7)
        let ingredient8 = values._decodeDebug(String.self, forKey: .ingredient8)
        let ingredient9 = values._decodeDebug(String.self, forKey: .ingredient9)
        let ingredient10 = values._decodeDebug(String.self, forKey: .ingredient10)
        let ingredient11 = values._decodeDebug(String.self, forKey: .ingredient11)
        let ingredient12 = values._decodeDebug(String.self, forKey: .ingredient12)
        let ingredient13 = values._decodeDebug(String.self, forKey: .ingredient13)
        let ingredient14 = values._decodeDebug(String.self, forKey: .ingredient14)
        let ingredient15 = values._decodeDebug(String.self, forKey: .ingredient15)
        let measure1 = values._decodeDebug(String.self, forKey: .measure1)
        let measure2 = values._decodeDebug(String.self, forKey: .measure2)
        let measure3 = values._decodeDebug(String.self, forKey: .measure3)
        let measure4 = values._decodeDebug(String.self, forKey: .measure4)
        let measure5 = values._decodeDebug(String.self, forKey: .measure5)
        let measure6 = values._decodeDebug(String.self, forKey: .measure6)
        let measure7 = values._decodeDebug(String.self, forKey: .measure7)
        let measure8 = values._decodeDebug(String.self, forKey: .measure8)
        let measure9 = values._decodeDebug(String.self, forKey: .measure9)
        let measure10 = values._decodeDebug(String.self, forKey: .measure10)
        let measure11 = values._decodeDebug(String.self, forKey: .measure11)
        let measure12 = values._decodeDebug(String.self, forKey: .measure12)
        let measure13 = values._decodeDebug(String.self, forKey: .measure13)
        let measure14 = values._decodeDebug(String.self, forKey: .measure14)
        let measure15 = values._decodeDebug(String.self, forKey: .measure15)

        ingredients.appendUnknownable(.init(ingredient: ingredient1, measure: measure1))
        ingredients.appendUnknownable(.init(ingredient: ingredient2, measure: measure2))
        ingredients.appendUnknownable(.init(ingredient: ingredient3, measure: measure3))
        ingredients.appendUnknownable(.init(ingredient: ingredient4, measure: measure4))
        ingredients.appendUnknownable(.init(ingredient: ingredient5, measure: measure5))
        ingredients.appendUnknownable(.init(ingredient: ingredient6, measure: measure6))
        ingredients.appendUnknownable(.init(ingredient: ingredient7, measure: measure7))
        ingredients.appendUnknownable(.init(ingredient: ingredient8, measure: measure8))
        ingredients.appendUnknownable(.init(ingredient: ingredient9, measure: measure9))
        ingredients.appendUnknownable(.init(ingredient: ingredient10, measure: measure10))
        ingredients.appendUnknownable(.init(ingredient: ingredient11, measure: measure11))
        ingredients.appendUnknownable(.init(ingredient: ingredient12, measure: measure12))
        ingredients.appendUnknownable(.init(ingredient: ingredient13, measure: measure13))
        ingredients.appendUnknownable(.init(ingredient: ingredient14, measure: measure14))
        ingredients.appendUnknownable(.init(ingredient: ingredient15, measure: measure15))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(glass, forKey: .glass)
        try container.encode(alcoholLevel, forKey: .alcoholLevel)
        try container.encode(ibaCategory, forKey: .ibaCategory)
        try container.encode(instructions, forKey: .instructions)

        let mirror = Mirror(reflecting: self)

        for (index, child) in mirror.children.enumerated() {
            if let label = child.label,
               let value = child.value as? String,
               label.starts(with: "ingredient"),
               let codingKey = CodingKeys(rawValue: "str\(label)\(String(index))") {
                try container.encode(value, forKey: codingKey)
            }
        }

        for (index, child) in mirror.children.enumerated() {
            if let label = child.label,
               let value = child.value as? String,
               label.starts(with: "measure"),
               let codingKey = CodingKeys(rawValue: "str\(label)\(String(index))") {
                try container.encode(value, forKey: codingKey)
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case glass = "strGlass"
        case alcoholLevel = "strAlcoholic"
        case ibaCategory = "strIBA"
        case instructions = "strInstructions"
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case measure1 = "strMeasure1"
        case measure2 = "strMeasure2"
        case measure3 = "strMeasure3"
        case measure4 = "strMeasure4"
        case measure5 = "strMeasure5"
        case measure6 = "strMeasure6"
        case measure7 = "strMeasure7"
        case measure8 = "strMeasure8"
        case measure9 = "strMeasure9"
        case measure10 = "strMeasure10"
        case measure11 = "strMeasure11"
        case measure12 = "strMeasure12"
        case measure13 = "strMeasure13"
        case measure14 = "strMeasure14"
        case measure15 = "strMeasure15"
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

extension Drink {
    struct Ingredient: Codable, Hashable, _Unknownable {
        let ingredient: String
        let measure: String?

        static var _unknown: Self {
            .init(ingredient: ._unknown, measure: ._unknown)
        }
    }
}
