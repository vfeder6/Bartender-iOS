import SwiftUI

struct CocktailsListView: View {
    @StateObject var viewModel: CocktailsListViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(viewModel.state.cocktails) { cocktail in
                NavigationLink(value: cocktail) {
                    row(for: cocktail)
                }.buttonStyle(.plain)
                Divider()
            }
        }
        .navigationStack(withTitle: "Drinks", forDestination: Cocktail.self) { cocktail in
            CocktailDetailsView()
        }
        .task {
            await viewModel.fetch()
        }
    }

    private func row(for cocktail: Cocktail) -> some View {
        HStack {
            VStack {
                HStack(spacing: 0) {
                    Text(cocktail.name).font(.system(size: 24))
                    Spacer(minLength: 0)
                }
                HStack(spacing: 0) {
                    Text(cocktail.category.rawValue)
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

struct CocktailsListView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailsListView(viewModel: .init(cocktailsListService: CocktailsListServicePreview()))
    }
}
