import SwiftUI

struct DrinksListView: View {
    @StateObject var viewModel: DrinksListViewModel

    private let gridRowSpacing: CGFloat = 0

    var body: some View {
            GeometryReader { proxy in
                    LazyVGrid(columns: GridItem(.flexible(), spacing: gridRowSpacing).multiplied(times: 2), spacing: 0) {
                        ForEach(viewModel.state.drinkSummaries) { drinkSummary in
                            box(for: drinkSummary, proxy: proxy)
                                .onTapGesture {
                                    viewModel.drinkSelected(drinkSummary)
                                }
                        }
                    }
                .topNavBar()
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

extension View {
    func topNavBar() -> some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    self.padding(.top, proxy.safeAreaInsets.top)
                }
            }.overlay {
                ZStack {
                    Color.clear
                        .ignoresSafeArea(edges: .top)
                        .background(.ultraThinMaterial)
                        .frame(width: proxy.size.width, height: proxy.safeAreaInsets.top / 2)
                        .verticalAlignment(.top)
                    Color.clear
                        .ignoresSafeArea(edges: .top)
                        .background(.ultraThinMaterial)
                        .blur(radius: 8)
                        .frame(width: proxy.size.width + 20, height: proxy.safeAreaInsets.top)
                        .verticalAlignment(.top)
                    HStack {
                        Text("Drinks")
                            .font(.lato(.black, 32))
                            .foregroundColor(.text)
                        Spacer()
                        Button {

                        } label: {
                            Image("search")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 24)
                                .foregroundColor(.text)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 26)
                    .verticalAlignment(.top)
                }
            }
        }
    }
}
