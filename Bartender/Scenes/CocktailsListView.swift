import SwiftUI

struct CocktailsListView: View {
    @StateObject var viewModel: CocktailsListViewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.state.cocktails) { cocktail in
                    NavigationLink(value: cocktail) {
                        HStack {
                            VStack {
                                HStack(spacing: 0) {
                                    Text(cocktail.name).font(.system(size: 24))
                                    Spacer(minLength: 0)
                                }
                                HStack(spacing: 0) {
                                    Text(cocktail.category)
                                    Spacer(minLength: 0)
                                }
                            }
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 20).padding(.horizontal)
                        .contentShape(Rectangle())
                    }.buttonStyle(.plain)
                    Divider()
                }
            }
            .navigationTitle("Drinks")
                .navigationDestination(for: Cocktail.self) { cocktail in
                    CocktailDetailsView()
                }
        }
        .task {
            await viewModel.fetch()
        }
    }
}

struct CocktailsListView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailsListView(viewModel: .init(cocktailsListService: CocktailsListServicePreview()))
    }
}
