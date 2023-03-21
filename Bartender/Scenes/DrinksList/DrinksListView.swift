import SwiftUI

struct DrinksListView: View {
    @StateObject var viewModel: DrinksListViewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.state.drinkSummaries) { drinkSummary in
                        row(for: drinkSummary)
                            .onTapGesture {
                                viewModel.drinkSelected(drinkSummary)
                            }
                        Divider()
                    }
                }
            }
            .navigationTitle("Drinks")
        }
        .fullScreenCover(item: $viewModel.navigation.selectedDrink) { drinkSummary in
            DrinkDetailsView(viewModel: .init(drinkID: drinkSummary.id))
                .dismissable(isPresented: .optional($viewModel.navigation.selectedDrink))
        }
        .task {
            await viewModel.fetch()
        }
    }

    private func row(for drinkSummary: DrinkSummary) -> some View {
        HStack {
            VStack {
                HStack(spacing: 0) {
                    Text(drinkSummary.name).font(.system(size: 24))
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
