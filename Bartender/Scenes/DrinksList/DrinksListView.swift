import SwiftUI

struct DrinksListView: View {
    @StateObject var viewModel: DrinksListViewModel

    private let gridRowSpacing: CGFloat = 0

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ScrollView {
                    LazyVGrid(columns: GridItem(.flexible(), spacing: gridRowSpacing).multiplied(times: 2), spacing: 0) {
                        ForEach(viewModel.state.drinkSummaries) { drinkSummary in
                            box(for: drinkSummary, proxy: proxy)
                                .onTapGesture {
                                    viewModel.drinkSelected(drinkSummary)
                                }
                        }
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

    private func box(for drinkSummary: DrinkSummary, proxy: GeometryProxy) -> some View {
        ZStack {
            ZStack {
                Image("mojito")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width / 2 - (gridRowSpacing / 2), height: proxy.size.height / 2.5)
                    .clipped()
                LinearGradient(colors: Color.transparent.multiplied(times: 2) + [.black.opacity(0.65)], startPoint: .top, endPoint: .bottom)
            }
            Text(drinkSummary.name)
                .lineLimit(2)
                .font(.lato(.black, 16))
                .foregroundColor(.white)
                .verticalAlignment(.bottom)
                .horizontalAlignment(.leading)
                .padding(.horizontal, 8).padding(.bottom, 8)
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
        try! .init(networkClient: .mock(returning: .success(DrinksListResponse.mock), expecting: 200, after: .seconds(0.5)))
    }
}

extension GridItem: Multipliable { }
extension Color: Multipliable { }
