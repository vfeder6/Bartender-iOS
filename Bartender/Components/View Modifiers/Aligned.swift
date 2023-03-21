import SwiftUI

struct VerticallyAligned: ViewModifier {
    let alignment: Alignment.Vertical
    var stackAlignment: HorizontalAlignment = .center

    func body(content: Content) -> some View {
        switch alignment {
        case .top:
            VStack(alignment: stackAlignment, spacing: 0) {
                content
                Spacer(minLength: 0)
            }
        case .center:
            VStack(alignment: stackAlignment, spacing: 0) {
                Spacer(minLength: 0)
                content
                Spacer(minLength: 0)
            }
        case .bottom:
            VStack(alignment: stackAlignment, spacing: 0) {
                Spacer(minLength: 0)
                content
            }
        }
    }
}

struct HorizontallyAligned: ViewModifier {
    let alignment: Alignment.Horizontal
    var stackAlignment: VerticalAlignment = .center

    func body(content: Content) -> some View {
        switch alignment {
        case .leading:
            HStack(alignment: stackAlignment, spacing: 0) {
                content
                Spacer(minLength: 0)
            }
        case .center:
            HStack(alignment: stackAlignment, spacing: 0) {
                Spacer(minLength: 0)
                content
                Spacer(minLength: 0)
            }
        case .trailing:
            HStack(alignment: stackAlignment, spacing: 0) {
                Spacer(minLength: 0)
                content
            }
        }
    }
}

enum Alignment {
    case horizontal(Horizontal)
    case vertical(Vertical)

    enum Horizontal {
        case leading
        case center
        case trailing
    }

    enum Vertical {
        case top
        case center
        case bottom
    }
}

extension View {
    func verticalAlignment(_ alignment: Alignment.Vertical, internalStackAlignment: HorizontalAlignment = .center) -> some View {
        modifier(VerticallyAligned(alignment: alignment, stackAlignment: internalStackAlignment))
    }

    func horizontalAlignment(_ alignment: Alignment.Horizontal, internalStackAlignment: VerticalAlignment = .center) -> some View {
        modifier(HorizontallyAligned(alignment: alignment, stackAlignment: internalStackAlignment))
    }
}
