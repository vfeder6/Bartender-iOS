import SwiftUI

struct DrinksListView: View {
    @StateObject var viewModel: DrinksListViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(viewModel.state.drinks) { drink in
                NavigationLink(value: drink) {
                    row(for: drink)
                }.buttonStyle(.plain)
                Divider()
            }
        }
        .navigationStack(withTitle: "Drinks", forDestination: Drink.self) { drink in
            DrinkDetailsView(viewModel: .init(drinkID: drink.id))
        }
        .task {
            await viewModel.fetch()
        }
    }

    private func row(for drink: Drink) -> some View {
        HStack {
            VStack {
                HStack(spacing: 0) {
                    Text(drink.name).font(.system(size: 24))
                    Spacer(minLength: 0)
                }
                HStack(spacing: 0) {
                    Text(drink.category.rawValue)
                    Spacer(minLength: 0)
                }
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 20).padding(.horizontal)
        .contentShape(Rectangle())
    }
}

private extension View {
    func navigationStack<Destination, Content>(
        withTitle title: String,
        forDestination data: Destination.Type,
        _ destinationContent: @escaping (Destination) -> Content
    ) -> some View where Destination: Hashable, Content: View {
        NavigationStack {
            self
                .navigationTitle(title)
                .navigationDestination(for: data, destination: destinationContent)
        }
    }
}

struct DrinksListView_Previews: PreviewProvider {
    static var previews: some View {
        DrinksListView(viewModel: .init(drinksListService: .preview))
    }
}

extension DrinksListService {
    static var preview: Self {
        try! .init(networkService: .mock(returning: .success(DrinksListResponse.mock), expecting: 200, after: .seconds(0.5)))
    }
}
