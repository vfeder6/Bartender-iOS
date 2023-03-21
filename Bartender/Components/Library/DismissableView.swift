import SwiftUI

struct DismissableView<Content: View>: View {
    @Binding var isPresented: Bool
    let content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                content()
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)
                        Button(action: { isPresented = false }, label: dismissLabel)
                            .padding(.trailing)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func dismissLabel() -> some View {
        ZStack {
            Circle()
                .foregroundColor(.white.opacity(0.7))
                .shadow(color: .black.opacity(0.5), radius: 4)
            Image("cross")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 14)
                .foregroundColor(.gray.opacity(0.7))
        }.frame(width: 28)
    }
}

extension View {
    func dismissable(isPresented: Binding<Bool>) -> some View {
        DismissableView(isPresented: isPresented) {
            self
        }
    }
}
