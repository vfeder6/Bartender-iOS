import SwiftUI

struct DismissableView<Content: View>: View {
    @Binding var isPresented: Bool
    let content: () -> Content

    var body: some View {
        ZStack {
            content()
            Button(action: { isPresented = false }, label: dismissLabel)
                .padding(.trailing)
                .horizontalAlignment(.trailing)
                .verticalAlignment(.top)
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

extension View {
    func dismissableFullScreenCover<T: Identifiable>(
        item: Binding<T?>,
        onDismiss: (() -> Void)? = nil,
        content: @escaping (T) -> some View
    ) -> some View {
        self.fullScreenCover(item: item, onDismiss: onDismiss) { identifiable in
            content(identifiable).dismissable(isPresented: .optional(item))
        }
    }
}

extension Binding where Value == Bool {
    static func optional<T: Identifiable>(_ item: Binding<T?>) -> Self {
        .init(get: { item.wrappedValue != nil }, set: { if !$0 { item.wrappedValue = nil } })
    }
}
