import SwiftUI

struct IdentifiedLazyVGrid<Model: Identifiable, Content: View>: View {
    let columns: Int
    var paddings: Paddings = .init()
    var spacings: Spacings = .init()
    var gridItemSize: GridItem.Size = .flexible()
    let models: [Model]
    let gridElement: (Model) -> Content

    var body: some View {
        VStack {
            LazyVGrid(columns: GridItem(gridItemSize, spacing: spacings.column).multiplied(times: columns), spacing: spacings.row) {
                ForEach(models) { model in
                    gridElement(model)
                }
            }
            .padding(.leading, paddings.leading)
            .padding(.top, paddings.top)
            .padding(.trailing, paddings.trailing)
            .padding(.bottom, paddings.bottom)
        }
    }
}

extension IdentifiedLazyVGrid {
    struct Spacings {
        var column: CGFloat = 0
        var row: CGFloat = 0
    }
}

extension GridItem: Multipliable { }

struct IdentifiedLazyVGrid_Previews: PreviewProvider {
    struct Test: Identifiable, IdentifiedMultipliable {
        let id: UUID
    }

    static var previews: some View {
        IdentifiedLazyVGrid(
            columns: 4,
            paddings: .init(leading: 16, trailing: 16),
            spacings: .init(column: 16, row: 12),
            models: Test.multiply(times: 40)) { model in
                Text(model.id.uuidString)
                    .horizontalAlignment(.leading)
                    .frame(height: 50)
                    .border(.blue)
            }
    }
}
