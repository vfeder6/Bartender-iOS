import SwiftUI

struct DrinkDetailsView: View {
    @StateObject var viewModel: DrinkDetailsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if let drink = viewModel.state.drink {
                HeaderScrollView(title: drink.name, imageType: .actual(viewModel.state.drinkImage ?? Image("mojito")), imageBottomOpacity: 0.8) {
                    content(drink)
                        .horizontalAlignment(.leading)
                        .padding(.top, 16)
                        .padding(.horizontal)
                }
                .background {
                    if let image = viewModel.state.drinkImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.2)
                            .blur(radius: 8)
                    } else {
                        Color.clear
                    }
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
                .font(.lato(.black, 18))
                .foregroundColor(.text)
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
            .font(.lato(.black, 20))
            .foregroundColor(.text)
        ForEach(drink.ingredients) { ingredient in
            Text(" •  \(ingredient.description)")
                .font(.lato(.italic, 16))
                .foregroundColor(.text)
        }
    }

    @ViewBuilder
    private func instructions(_ drink: Drink) -> some View {
        Text("Instructions")
            .font(.lato(.black, 20))
            .foregroundColor(.text)
        Text(drink.instructions)
            .lineSpacing(4)
            .font(.lato(.regular, 16))
            .foregroundColor(.text)
    }
}

extension Drink.Ingredient {
    var description: String {
        measure.flatMap { $0 != ._unknown ? "\(name), \($0)" : nil } ?? name
    }
}

struct DrinkDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkDetailsView(viewModel: .init(drinkDetailsService: .preview, drinkImageService: .preview, drinkID: ""))
            .dismissable(isPresented: .constant(true))
    }
}

extension DrinkDetailsService {
    static var preview: Self {
        .init(networkClient: .mock(returning: .success(DrinkDetailsResponse.mock), expecting: 200, after: .seconds(0.5)))
    }
}

extension DrinkImageService {
    static var preview: Self {
        .init(networkClient: .mock(returning: .success(.init("mojito")), expecting: 200))
    }
}
