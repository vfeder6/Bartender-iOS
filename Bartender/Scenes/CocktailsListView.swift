import SwiftUI

struct CocktailsListView: View {
    @State var presentDetails: Bool = false

    var body: some View {
        NavigationStack {
            Button("to Cocktail Details") {
                presentDetails = true
            }
            .navigationDestination(isPresented: $presentDetails) {
                CocktailDetailsView()
            }
        }
    }
}

struct Cocktail {
    let name: String
}

struct CocktailsListView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailsListView()
    }
}
