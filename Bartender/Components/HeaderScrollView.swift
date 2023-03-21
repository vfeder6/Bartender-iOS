import SwiftUI

struct HeaderScrollView<Content: View>: View {
    let title: String
    var titleFont: Font = .lato(.black, 32)
    let imageReference: String
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
                    .frame(height: headerHeight(from: proxy))
                    .clipped()
                titleGradient
                Text(text)
                    .horizontalAlignment(.leading)
                    .verticalAlignment(.bottom)
                    .font(titleFont)
                    .foregroundColor(.white)
                    .padding(.bottom).padding(.leading)
            }
            .offset(x: 0, y: topBlockingScrollOffset(from: proxy))
        }
        .frame(height: height / 3)
    }

    private var titleGradient: LinearGradient {
        .init(
            colors: [.transparent, .transparent, .transparent, .transparent, .black.opacity(0.8)],
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
        HeaderScrollView(title: "Test", imageReference: "mojito") {
            Text("Ciao")
        }
    }
}
