import SwiftUI

struct RootView: View {
    @State var tab: Tab = .cocktailsList

    var body: some View {
        TabView(selection: $tab) {
            CocktailsListView(viewModel: .init())
                .tag(Tab.cocktailsList)
                .tabItem {
                    Text("Cocktails")
                }
            IngredientsListView()
                .tag(Tab.ingredientsList)
                .tabItem {
                    Text("Ingredients")
                }
        }
    }
}

enum Tab {
    case cocktailsList
    case ingredientsList
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
