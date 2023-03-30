import SwiftUI

struct ColoredLabel: View {
    let title: String
    let color: Color
    var font: Font = .lato(.black, 18)
    var cornerRadius: CGFloat = 6
    var internalPadding: CGFloat = 6

    var body: some View {
        Text(title)
            .foregroundColor(color)
            .font(font)
            .padding(internalPadding)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(color.opacity(0.5))
            }
    }
}

struct ColoredLabel_Previews: PreviewProvider {
    static var previews: some View {
        ColoredLabel(title: "Test", color: .red)
    }
}
