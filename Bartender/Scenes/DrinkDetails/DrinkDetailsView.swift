import SwiftUI

struct DrinkDetailsView: View {
    @StateObject var viewModel: DrinkDetailsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if let drink = viewModel.state.drink {
                HeaderScrollView(title: drink.name, imageReference: "mojito") {
                    content(drink)
                        .horizontalAlignment(.leading)
                        .padding(.top, 16)
                        .padding(.horizontal)
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.fetch()
        }
    }

    private func content(_ drink: Drink) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(drink.category.rawValue) - \(drink.alcoholLevel.rawValue)")
                .font(.lato(.black, 20))
            if let ibaCategory = drink.ibaCategory {
                ColoredLabel(title: ibaCategory.rawValue.uppercased(), color: .red)
            }
            ColoredLabel(title: drink.glass.rawValue.uppercased(), color: .blue, font: .lato(.black, 14))
            Divider().padding(.vertical, 8)
            ingredients(drink)
            Divider().padding(.vertical, 8)
            instructions(drink)
        }
    }

    @ViewBuilder
    private func ingredients(_ drink: Drink) -> some View {
        Text("Ingredients")
            .font(.lato(.black, 24))
        ForEach(drink.ingredients) { ingredient in
            Text(" •  \(ingredient.description)")
                .font(.lato(.italic, 18))
        }
    }

    @ViewBuilder
    private func instructions(_ drink: Drink) -> some View {
        Text("Instructions")
            .font(.lato(.black, 24))
        Text(drink.instructions)
            .lineSpacing(4)
            .font(.lato(.regular, 18))
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
        try! .init(networkClient: .mock(returning: .success(DrinkDetailsResponse.mock), expecting: 200, after: .seconds(0.5)))
    }
}
