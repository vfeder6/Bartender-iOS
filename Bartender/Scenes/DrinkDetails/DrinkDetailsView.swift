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
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                ZStack {
                    Image("mojito")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width, height: proxy.size.height / 2)
                        .foregroundColor(.gray)
                    LinearGradient(colors: [.transparent, .transparent, .transparent, .transparent, .transparent, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                    VStack {
                        Spacer()
                        HStack {
                            Text(drink.name)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.bottom).padding(.leading)
                            Spacer()
                        }
                    }
                }
                if let ibaCategory = drink.ibaCategory {
                    Text("IBA Category: \(ibaCategory.rawValue)")
                }
                Text(drink.alcoholLevel.rawValue)
                Text(drink.glass.rawValue)
                Text(drink.category.rawValue)
                Text(drink.instructions)
            }.ignoresSafeArea(edges: .top)
        }
    }
}

struct DrinkDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DrinkDetailsView(viewModel: .init(drinkDetailsService: .preview, drinkID: ""))
        }
    }
}

extension DrinkDetailsService {
    static var preview: Self {
        try! .init(networkService: .mock(returning: .success(DrinksListResponse.mockSingleValue), expecting: 200, after: .seconds(0.5)))
    }
}

extension Color {
    static var transparent: Self {
        .black.opacity(0)
    }
}
