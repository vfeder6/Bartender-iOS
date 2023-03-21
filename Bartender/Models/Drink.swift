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

        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        category = try values.decode(Category.self, forKey: .category)
        glass = try values.decode(Glass.self, forKey: .glass)
        alcoholLevel = try values.decode(AlcoholLevel.self, forKey: .alcoholLevel)
        ibaCategory = values._decodeDebug(IBACategory.self, forKey: .ibaCategory)
        instructions = try values.decode(String.self, forKey: .instructions)
        ingredients = []

        let ingredient1 = try? values.decode(String.self, forKey: .ingredient1)
        let ingredient2 = try? values.decode(String.self, forKey: .ingredient2)
        let ingredient3 = try? values.decode(String.self, forKey: .ingredient3)
        let ingredient4 = try? values.decode(String.self, forKey: .ingredient4)
        let ingredient5 = try? values.decode(String.self, forKey: .ingredient5)
        let ingredient6 = try? values.decode(String.self, forKey: .ingredient6)
        let ingredient7 = try? values.decode(String.self, forKey: .ingredient7)
        let ingredient8 = try? values.decode(String.self, forKey: .ingredient8)
        let ingredient9 = try? values.decode(String.self, forKey: .ingredient9)
        let ingredient10 = try? values.decode(String.self, forKey: .ingredient10)
        let ingredient11 = try? values.decode(String.self, forKey: .ingredient11)
        let ingredient12 = try? values.decode(String.self, forKey: .ingredient12)
        let ingredient13 = try? values.decode(String.self, forKey: .ingredient13)
        let ingredient14 = try? values.decode(String.self, forKey: .ingredient14)
        let ingredient15 = try? values.decode(String.self, forKey: .ingredient15)
        let measure1 = try? values.decode(String.self, forKey: .measure1)
        let measure2 = try? values.decode(String.self, forKey: .measure2)
        let measure3 = try? values.decode(String.self, forKey: .measure3)
        let measure4 = try? values.decode(String.self, forKey: .measure4)
        let measure5 = try? values.decode(String.self, forKey: .measure5)
        let measure6 = try? values.decode(String.self, forKey: .measure6)
        let measure7 = try? values.decode(String.self, forKey: .measure7)
        let measure8 = try? values.decode(String.self, forKey: .measure8)
        let measure9 = try? values.decode(String.self, forKey: .measure9)
        let measure10 = try? values.decode(String.self, forKey: .measure10)
        let measure11 = try? values.decode(String.self, forKey: .measure11)
        let measure12 = try? values.decode(String.self, forKey: .measure12)
        let measure13 = try? values.decode(String.self, forKey: .measure13)
        let measure14 = try? values.decode(String.self, forKey: .measure14)
        let measure15 = try? values.decode(String.self, forKey: .measure15)

        ingredient1.map { ingredients.append(.init(name: $0, measure: measure1)) }
        ingredient2.map { ingredients.append(.init(name: $0, measure: measure2)) }
        ingredient3.map { ingredients.append(.init(name: $0, measure: measure3)) }
        ingredient4.map { ingredients.append(.init(name: $0, measure: measure4)) }
        ingredient5.map { ingredients.append(.init(name: $0, measure: measure5)) }
        ingredient6.map { ingredients.append(.init(name: $0, measure: measure6)) }
        ingredient7.map { ingredients.append(.init(name: $0, measure: measure7)) }
        ingredient8.map { ingredients.append(.init(name: $0, measure: measure8)) }
        ingredient9.map { ingredients.append(.init(name: $0, measure: measure9)) }
        ingredient10.map { ingredients.append(.init(name: $0, measure: measure10)) }
        ingredient11.map { ingredients.append(.init(name: $0, measure: measure11)) }
        ingredient12.map { ingredients.append(.init(name: $0, measure: measure12)) }
        ingredient13.map { ingredients.append(.init(name: $0, measure: measure13)) }
        ingredient14.map { ingredients.append(.init(name: $0, measure: measure14)) }
        ingredient15.map { ingredients.append(.init(name: $0, measure: measure15)) }
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

        guard let ingredients = Mirror(reflecting: self).children
            .first(where: { $0.label == "ingredients" })
            .flatMap({ $0.value as? [Ingredient] })
        else {
            throw EncodingError.invalidValue(
                "ingredients",
                .init(codingPath: [], debugDescription: "Could not encode ingredients")
            )
        }

        for (index, ingredient) in ingredients.enumerated() {
            let index = index + 1

            guard let ingredientCodingKey = CodingKeys(rawValue: "strIngredient\(String(index))")
            else { continue }

            try container.encode(ingredient.name, forKey: ingredientCodingKey)

            guard
                let measure = ingredient.measure,
                let measureCodingKey = CodingKeys(rawValue: "strMeasure\(String(index))")
            else { continue }

            try container.encode(measure, forKey: measureCodingKey)
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

    enum Category: String, Codable {
        case ordinaryDrink = "Ordinary Drink"
        case cocktail = "Cocktail"
        case shake = "Shake"
        case other = "Other / Unknown"
        case cocoa = "Cocoa"
        case shot = "Shot"
        case coffeTea = "Coffe / Tea"
        case homemadeLiqueur = "Homemade Liqueur"
        case punchPartyDrink = "Punch / Party Drink"
        case beer = "Beer"
        case softDrink = "Soft Drink"
    }

    enum Glass: String, Codable {
        case highball = "Highball glass"
        case cocktail = "Cocktail glass"
        case oldFashioned = "Old-fashioned glass"
        case whiskey = "Whiskey Glass"
        case collins = "Collins glass"
        case pousseCafe = "Pousse cafe glass"
        case champagneFlute = "Champagne flute"
        case whiskeySour = "Whiskey sour glass"
        case cordial = "Cordial glass"
        case brandySnifter = "Brandy snifter"
        case whiteWine = "White wine glass"
        case nickAndNora = "Nick and Nora Glass"
        case hurricane = "Hurricane glass"
        case coffeeMug = "Coffee mug"
        case shot = "Shot glass"
        case jar = "Jar"
        case irishCoffeeCup = "Irish coffee cup"
        case punchBowl = "Punch bowl"
        case pitcher = "Pitcher"
        case pint = "Pint glass"
        case copperMug = "Copper Mug"
        case wine = "Wine Glass"
        case beerMug = "Beer mug"
        case margaritaGlass = "Margarita/Coupette glass"
        case beerPilsner = "Beer pilsner"
        case beerGlass = "Beer Glass"
        case parfait = "Parfait glass"
        case masonJar = "Mason jar"
        case margarita = "Margarita glass"
        case martiniGlass = "Martini Glass"
        case baloon = "Baloon Glass"
        case coupe = "Couple glass"
    }

    enum AlcoholLevel: String, Codable {
        case alcoholic = "Alcoholic"
        case nonAlcoholic = "Non alcoholic"
        case optionalAlcohol = "Optional alcohol"
    }

    enum IBACategory: String, Codable, _Unknownable {
        case contemporaryClassic = "Contemporary Classics"
        case unforgettables = "Unforgettables"
        case _unknown
    }
}

extension Drink {
    struct Ingredient: Codable, Hashable, Identifiable {
        let name: String
        let measure: String?

        var id: String {
            name
        }
    }
}
