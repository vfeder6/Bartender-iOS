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
                VStack {
                    GeometryReader { proxy in
                        ZStack {
                            Image("mojito")
                                .resizable()
                                .scaledToFill()
                                .frame(height: headerHeight(from: proxy))
                                .clipped()
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
                        .offset(x: 0, y: topBlockingScrollOffset(from: proxy))
                    }
                    .frame(height: proxy.size.height / 3)
                    if let ibaCategory = drink.ibaCategory {
                        Text("IBA Category: \(ibaCategory.rawValue)")
                    }
                    Text(drink.alcoholLevel.rawValue)
                    Text(drink.glass.rawValue)
                    Text(drink.category.rawValue)
                    Text(drink.instructions)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    private func scrollOffset(from proxy: GeometryProxy) -> CGFloat {
        proxy.frame(in: .global).minY
    }

    private func topBlockingScrollOffset(from proxy: GeometryProxy) -> CGFloat {
        let offset = scrollOffset(from: proxy)
        return offset > 0 ? -offset : 0
    }

    private func headerHeight(from proxy: GeometryProxy) -> CGFloat {
        let offset = scrollOffset(from: proxy)
        return offset > 0 ? proxy.size.height + offset : proxy.size.height
    }
}

struct DrinkDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkDetailsView(viewModel: .init(drinkDetailsService: .preview, drinkID: ""))
            .dismissable(isPresented: .constant(true))
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
