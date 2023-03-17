import SwiftUI

struct DrinkDetailsView: View {
    @StateObject var viewModel: DrinkDetailsViewModel

    var body: some View {
        Text(viewModel.state.drink?.name ?? "")
            .task {
                await viewModel.fetch()
            }
    }
}

struct DrinkDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkDetailsView(viewModel: .init(drinkDetailsService: .preview, drinkID: ""))
    }
}
