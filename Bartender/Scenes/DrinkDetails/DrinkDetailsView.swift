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
                VStack(spacing: 0) {
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
                    .padding(.bottom, 16)
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let ibaCategory = drink.ibaCategory {
                                Text(ibaCategory.rawValue.uppercased())
                                    .foregroundColor(.red)
                                    .font(.system(size: 16, weight: .bold))
                                    .padding(6)
                                    .background {
                                        RoundedRectangle(cornerRadius: 4)
                                            .foregroundColor(.red.opacity(0.5))
                                    }
                            }
                            Text("\(drink.category.rawValue) - \(drink.alcoholLevel.rawValue)")
                                .font(.system(.headline))
                            Text("Serve in: \(drink.glass.rawValue)")
                            Text("Ingredients".uppercased())
                                .padding(.top, 20)
                            ForEach(drink.ingredients) { ingredient in
                                Text(" - \(ingredient.description)")
                            }
                            Text("Instructions".uppercased())
                                .padding(.top, 20)
                            Text(drink.instructions)
                        }
                        Spacer(minLength: 0)
                    }.padding(.horizontal)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

extension DrinkDetailsView {
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

extension Color {
    static var transparent: Self {
        .black.opacity(0)
    }
}

extension Drink.Ingredient {
    var description: String {
        measure.flatMap { $0 != ._unknown ? "\(name), \($0)" : nil } ?? name
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
        try! .init(networkService: .mock(returning: .success(DrinkDetailsResponse.mock), expecting: 200, after: .seconds(0.5)))
    }
}
