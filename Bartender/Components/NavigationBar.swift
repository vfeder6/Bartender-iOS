import SwiftUI

struct NavigationBar<Content: View>: View {
    private let materialYOffset: CGFloat = 40

    let title: String
    let isSearching: Bool
    let text: Binding<String>
    let surroundedContent: () -> Content
    var onSearchStarted: () -> Void
    var onSearchFinished: () -> Void

    var body: some View {
        GeometryReader { proxy in
            SpacedScrollView(paddings: .init(top: proxy.safeAreaInsets.top + 20)) {
                surroundedContent()
            }
            .overlay {
                ZStack {
                    material
                        .blur(radius: 8)
                        .frame(width: proxy.size.width + 20, height: proxy.safeAreaInsets.top + 3.5 * materialYOffset)
                        .position(x: proxy.size.width / 2, y: -materialYOffset)
                        .verticalAlignment(.top)
                    navigationBarContent
                }
            }
        }
    }

    private var material: some View {
        Color.clear.background(Material.thinMaterial)
    }

    private var navigationBarContent: some View {
        HStack {
            if isSearching {
                TextField("Search", text: text)
                    .textFieldStyle(.roundedBorder)
                    .font(.lato(.regular, 16))
            } else {
                Text(title)
                    .font(.lato(.black, 32))
                    .foregroundColor(.text)
            }
            Spacer()
            Button(action: isSearching ? onSearchFinished : onSearchStarted) {
                if isSearching {
                    Image("cross")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .foregroundColor(.text)
                } else {
                    Image("search")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .foregroundColor(.text)
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal)
        .verticalAlignment(.top)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "Example", isSearching: false, text: .constant("")) {
            ForEach(0 ... 10, id: \.self) { int in
                Image("mojito")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        } onSearchStarted: { } onSearchFinished: { }
    }
}
