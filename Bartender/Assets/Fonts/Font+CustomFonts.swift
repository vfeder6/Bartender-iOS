import SwiftUI

extension Font {
    static func lato(_ kind: Kind, _ size: CGFloat) -> Self {
        .custom(.name(of: .lato, for: kind), size: size)
    }
}

private extension String {
    static func name(of family: Font.Family, for kind: Font.Kind) -> Self {
        "\(family.rawValue)-\(kind.rawValue)"
    }
}

extension Font {
    enum Family: String {
        case lato = "Lato"
    }

    enum Kind: String {
        case black = "Black"
        case blackItalic = "BlackItalic"
        case regular = "Regular"
        case italic = "Italic"
        case light = "Light"
        case lightItalic = "LightItalic"
    }
}
