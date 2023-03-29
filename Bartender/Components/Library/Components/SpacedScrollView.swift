import SwiftUI

struct SpacedScrollView<Content: View>: View {
    var orientation: Orientation = .vertical(alignment: .leading)
    var showsIndicators: Bool = false
    var stackSpacing: CGFloat = 0
    var edgesIgnoringSafeArea: Edge.Set? = nil
    var paddings: Paddings = .init()
    @ViewBuilder let content: () -> Content

    var body: some View {
        ScrollView(orientation.axis, showsIndicators: showsIndicators) {
            stack
                .padding(.leading, paddings.leading)
                .padding(.top, paddings.top)
                .padding(.trailing, paddings.trailing)
                .padding(.bottom, paddings.bottom)
        }
        .ifCanUnwrap(edgesIgnoringSafeArea) { view, edgesIgnoringSafeArea in
            view.edgesIgnoringSafeArea(edgesIgnoringSafeArea)
        }
    }

    @ViewBuilder
    private var stack: some View {
        if case .vertical(let alignment) = orientation {
            LazyVStack(alignment: alignment, spacing: stackSpacing) {
                content()
            }
        } else if case .horizontal(let alignment) = orientation {
            LazyHStack(alignment: alignment, spacing: stackSpacing) {
                content()
            }
        }
    }
}

struct SpacedScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SpacedScrollView(edgesIgnoringSafeArea: .vertical, paddings: .init(leading: 16)) {
            Color.blue.frame(width: 200, height: 200)
            Color.purple.frame(width: 160, height: 160)
            Color.yellow.frame(width: 240, height: 240)
            Color.brown.frame(width: 80, height: 80)
            Color.teal.frame(width: 120, height: 120)
            Color.green.frame(width: 280, height: 280)
        }
    }
}

extension SpacedScrollView {
    enum Orientation: Equatable {
        case horizontal(alignment: VerticalAlignment)
        case vertical(alignment: HorizontalAlignment)

        var axis: Axis.Set {
            switch self {
            case .horizontal:
                return .horizontal

            case .vertical:
                return .vertical
            }
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<IfContent: View>(
        _ condition: Bool,
        ifContent: (Self) -> IfContent
    ) -> some View {
        if condition {
            ifContent(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func ifCanUnwrap<T, IfContent: View>(
        _ optional: T?,
        ifContent: (Self, T) -> IfContent
    ) -> some View {
        if let optional {
            ifContent(self, optional)
        } else {
            self
        }
    }
}
