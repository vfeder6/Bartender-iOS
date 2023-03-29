import SwiftUI

struct DrinksListView: View {
    @StateObject var viewModel: DrinksListViewModel

    private let gridRowSpacing: CGFloat = 16
    private let padding: CGFloat = 16
    private let columns: Int = 2

    var body: some View {
        GeometryReader { proxy in
            VStack {
                LazyVGrid(columns: GridItem(.flexible(), spacing: gridRowSpacing).multiplied(times: columns), spacing: gridRowSpacing) {
                    ForEach(viewModel.state.drinkSummaries) { drinkSummary in
                        box(for: drinkSummary, minWidth: proxy.size.width / Double(columns) - 2 * padding - gridRowSpacing, height: proxy.size.height / 4)
                            .onTapGesture {
                                viewModel.drinkSelected(drinkSummary)
                            }
                    }.padding(.top)
                }.padding(.horizontal, padding)
            }
            .topNavBar(
                isSearching: viewModel.state.isSearching,
                text: .init(
                    get: { viewModel.state.searchText },
                    set: viewModel.searchTextChanged(to:)
                )
            ) {
                viewModel.searchButtonSelected()
            } onSearchFinished: {
                viewModel.closeSearchButtonSelected()
            }
        }
        .dismissableFullScreenCover(item: $viewModel.navigation.selectedDrink) { drinkSummary in
            DrinkDetailsView(viewModel: .init(drinkID: drinkSummary.id))
        }
        .task {
            await viewModel.fetch()
        }
    }

    private func box(for drinkSummary: DrinkSummary, minWidth: CGFloat, height: CGFloat) -> some View {
        ZStack {
            ZStack {
                Image("mojito")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: minWidth, minHeight: height, maxHeight: height, alignment: .center)
                LinearGradient(colors: Color.transparent.multiplied(times: 2) + [.black.opacity(0.65)], startPoint: .top, endPoint: .bottom)
            }
            Text(drinkSummary.name)
                .lineLimit(2)
                .font(.lato(.black, 16))
                .foregroundColor(.white)
                .verticalAlignment(.bottom)
                .horizontalAlignment(.leading)
                .padding(.horizontal, 12).padding(.bottom, 12)
        }
        .cornerRadius(20)
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
    func topNavBar(
        isSearching: Bool,
        text: Binding<String>,
        onSearchStarted: @escaping () -> Void,
        onSearchFinished: @escaping () -> Void
    ) -> some View {
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
                        if isSearching {
                            TextField("Search", text: text)
                                .textFieldStyle(.roundedBorder)
                                .font(.lato(.regular, 16))
                        } else {
                            Text("Drinks")
                                .font(.lato(.black, 32))
                                .foregroundColor(.text)
                        }
                        Spacer()
                        Button(action: isSearching ? onSearchFinished : onSearchStarted) {
                            if isSearching {
                                Image("cross")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 24)
                                    .foregroundColor(.text)
                            } else {
                                searchImage
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 26)
                    .verticalAlignment(.top)
                }
            }
        }
    }

    var searchImage: some View {
        Image("search")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(height: 24)
            .foregroundColor(.text)
    }
}
