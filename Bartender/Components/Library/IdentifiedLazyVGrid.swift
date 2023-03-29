import SwiftUI

struct IdentifiedLazyVGrid<Model: Identifiable, Content: View>: View {
    let columns: Int
    let paddings: Paddings
    let spacings: Spacings

    let models: [Model]
    let gridElement: (Model) -> Content
    var gridItemSize: GridItem.Size = .flexible()

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
    struct Paddings {
        var leading: CGFloat = 0
        var top: CGFloat = 0
        var trailing: CGFloat = 0
        var bottom: CGFloat = 0
    }

    struct Spacings {
        var column: CGFloat = 0
        var row: CGFloat = 0
    }
}

struct IdentifiedLazyVGrid_Previews: PreviewProvider {
    private struct Test: Identifiable, IdentifiedMultipliable {
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

private protocol IdentifiedMultipliable: Identifiable {
    init(id: UUID)
}

private extension IdentifiedMultipliable {
    static func multiply(times: Int) -> [Self] {
        var array: [Self] = []
        for _ in 0 ..< times {
            array.append(.init(id: .init()))
        }
        return array
    }
}
