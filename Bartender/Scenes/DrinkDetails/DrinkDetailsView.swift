import SwiftUI

struct DrinkDetailsView: View {
    @StateObject var viewModel: DrinkDetailsViewModel

    var body: some View {
        wrapper()
            .task {
                await viewModel.fetch()
            }
    }

    private func wrapper() -> some View {
        Group {
            if let drink = viewModel.state.drink {
                view(for: drink)
            } else {
                ProgressView()
            }
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
        DrinkDetailsView(viewModel: .init(drinkDetailsService: .preview, drinkID: "11001"))
    }
}

extension DrinkDetailsService {
    static var preview: Self {
        try! .init(networkService: .mock(returning: .success(DrinksListResponse.mockSingleValue), expecting: 200, after: .seconds(0.2)))
    }
}
