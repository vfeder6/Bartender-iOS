import SwiftUI

struct DrinkDetailsView: View {
    @StateObject var viewModel: DrinkDetailsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if let drink = viewModel.state.drink {
                view(for: drink)
            } else {
                ProgressView()
            }
        }
        .optionalNavigationTitle(viewModel.state.drink?.name)
        .task {
            await viewModel.fetch()
        }
    }

    private func view(for drink: Drink) -> some View {
        ScrollView(showsIndicators: false) {
            HStack(spacing: 0) {
                Text(drink.name)
                Spacer(minLength: 0)
            }
            Text(drink.instructions)
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

extension View {
    @ViewBuilder
    func optionalNavigationTitle(_ title: String?) -> some View {
        if let title {
            self.navigationTitle(title)
        }
    }
}
