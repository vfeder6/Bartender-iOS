import SwiftUI

struct DrinksListView: View {
    @StateObject var viewModel: DrinksListViewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.state.drinks) { drink in
                    row(for: drink)
                        .onTapGesture {
                            viewModel.drinkSelected(drink)
                        }
                    Divider()
                }
            }
            .navigationTitle("Drinks")
        }
        .fullScreenCover(item: $viewModel.navigation.selectedDrink) { drink in
            DrinkDetailsView(viewModel: .init(drinkID: drink.id))
                .dismissable(isPresented: .optional($viewModel.navigation.selectedDrink))
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

extension Binding where Value == Bool {
    static func optional<T: Identifiable>(_ item: Binding<T?>) -> Self {
        .init(get: { item.wrappedValue != nil }, set: { if !$0 { item.wrappedValue = nil } })
    }
}
