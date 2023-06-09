import SwiftUI

struct HeaderScrollView<Content: View>: View {
    let title: String
    var titleLineLimit: Int = 2
    var titleFont: Font = .lato(.black, 28)
    let imageReference: String
    var imageBottomOpacity: Double = 1
    let content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    header(height: proxy.size.height, text: title)
                    content()
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    private func header(height: CGFloat, text: String) -> some View {
        GeometryReader { proxy in
            ZStack {
                Image(imageReference)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: headerHeight(from: proxy))
                    .clipped()
                titleGradient
                Text(text)
                    .lineLimit(2)
                    .horizontalAlignment(.leading)
                    .verticalAlignment(.bottom)
                    .font(titleFont)
                    .foregroundColor(.text)
                    .padding(.bottom, 8)
                    .padding(.horizontal)
            }
            .offset(x: 0, y: topBlockingScrollOffset(from: proxy))
        }
        .frame(height: height / 2.5)
    }

    private var titleGradient: LinearGradient {
        .init(
            stops: [
                .init(color: .clear, location: 0.7),
                .init(color: .standardBackground.opacity(imageBottomOpacity), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension HeaderScrollView {
    private func scrollOffset(from proxy: GeometryProxy) -> CGFloat {
        proxy.frame(in: .global).minY
    }

    private func topBlockingScrollOffset(from proxy: GeometryProxy) -> CGFloat {
        let offset = scrollOffset(from: proxy)
        return offset > 0 ? -offset : 0
    }

    private func headerHeight(from proxy: GeometryProxy) -> CGFloat {
        let offset = scrollOffset(from: proxy)
        return offset > 0 ? proxy.size.height + offset : proxy.size.height
    }
}

struct HeaderScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderScrollView(title: "Test with a very very long and overflowing name", imageReference: "mojito") {
            Text("Test")
        }
    }
}
