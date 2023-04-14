import SwiftUI

struct DrinksListView: View {
    @StateObject var viewModel: DrinksListViewModel

    private let columns: Int = 2
    private let horizontalPadding: CGFloat = 0
    private let rowSpacing: CGFloat = 0
    private let columnSpacing: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            TopBar(
                title: "Drinks",
                isSearching: viewModel.state.isSearching,
                text: .init(get: { viewModel.state.searchText }, set: viewModel.searchTextChanged(to:)),
                onSearchStarted: viewModel.searchButtonSelected,
                onSearchFinished: viewModel.closeSearchButtonSelected
            ) {
                IdentifiedLazyVGrid(
                    columns: columns,
                    paddings: .init(leading: horizontalPadding, top: 20, trailing: horizontalPadding),
                    spacings: .init(column: columnSpacing, row: rowSpacing),
                    models: viewModel.state.drinkSummaries
                ) { drinkSummary in
                    gridElement(
                        for: drinkSummary,
                        minWidth: proxy.size.width / Double(columns) - (2 * horizontalPadding) - columnSpacing / 2,
                        height: proxy.size.height / 4
                    ).onTapGesture {
                        viewModel.drinkSelected(drinkSummary)
                    }
                }
            }
        }
        .dismissableFullScreenCover(item: $viewModel.navigation.selectedDrink) { drinkSummary in
            DrinkDetailsView(viewModel: .init(drinkID: drinkSummary.id))
        }
        .task {
            await viewModel.fetch()
        }
    }

    private func gridElement(for drinkSummary: DrinkSummary, minWidth: CGFloat, height: CGFloat) -> some View {
        ZStack {
            ZStack {
                Image("mojito")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: minWidth, minHeight: height, maxHeight: height, alignment: .center)
                    .clipped()
                LinearGradient(
                    colors: Color.clear.multiplied(times: 2) + [.black.opacity(0.65)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            Text(drinkSummary.name)
                .lineLimit(2)
                .font(.lato(.black, 16))
                .foregroundColor(.white)
                .verticalAlignment(.bottom)
                .horizontalAlignment(.leading)
                .padding(.horizontal, 12).padding(.bottom, 12)
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
        .init(networkClient: .mock(returning: .success(DrinksListResponse.mock), expecting: 200, after: .seconds(0.5)))
    }
}

extension Color: Multipliable { }
