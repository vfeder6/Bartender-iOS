import SwiftUI

struct DrinkDetailsView: View {
    @StateObject var viewModel: DrinkDetailsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if let drink = viewModel.state.drink {
                view(for: drink)
            }
        }
        .task {
            await viewModel.fetch()
        }
    }

    private func view(for drink: Drink) -> some View {
        HeaderScrollView(title: drink.name, imageReference: "mojito") {
            content(drink)
                .padding(.top, 16)
        }
    }

    private func content(_ drink: Drink) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let ibaCategory = drink.ibaCategory {
                Text(ibaCategory.rawValue.uppercased())
                    .foregroundColor(.red)
                    .font(.system(size: 16, weight: .bold))
                    .padding(6)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.red.opacity(0.5))
                    }
            }
            Text("\(drink.category.rawValue) - \(drink.alcoholLevel.rawValue)")
                .font(.system(.headline))
            Text("Serve in: \(drink.glass.rawValue)")
            Text("Ingredients".uppercased())
                .padding(.top, 20)
            ForEach(drink.ingredients) { ingredient in
                Text(" - \(ingredient.description)")
            }
            Text("Instructions".uppercased())
                .padding(.top, 20)
            Text(drink.instructions)
        }
    }
}

extension Color {
    static var transparent: Self {
        .black.opacity(0)
    }
}

extension Drink.Ingredient {
    var description: String {
        measure.flatMap { $0 != ._unknown ? "\(name), \($0)" : nil } ?? name
    }
}

struct DrinkDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkDetailsView(viewModel: .init(drinkDetailsService: .preview, drinkID: ""))
            .dismissable(isPresented: .constant(true))
    }
}

extension DrinkDetailsService {
    static var preview: Self {
        try! .init(networkService: .mock(returning: .success(DrinkDetailsResponse.mock), expecting: 200, after: .seconds(0.5)))
    }
}
