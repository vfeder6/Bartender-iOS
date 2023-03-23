import SwiftUI

struct DismissableView<Content: View>: View {
    @Binding var isPresented: Bool
    let embedInNavigationStack: Bool
    let content: () -> Content

    var body: some View {
        if embedInNavigationStack {
            navigationStack
        } else {
            zStack
        }
    }

    private var navigationStack: some View {
        NavigationStack {
            content()
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        button
                    }
                }
        }
    }

    private var zStack: some View {
        ZStack {
            content()
            button
                .padding(.trailing)
                .horizontalAlignment(.trailing)
                .verticalAlignment(.top)
        }
    }

    private var button: some View {
        Button(action: { isPresented = false }, label: dismissLabel)
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
    func dismissable(isPresented: Binding<Bool>, embedInNavigationStack: Bool = false) -> some View {
        DismissableView(isPresented: isPresented, embedInNavigationStack: embedInNavigationStack) {
            self
        }
    }
}

extension View {
    func dismissableFullScreenCover<Item: Identifiable>(
        item: Binding<Item?>,
        embedInNavigationStack: Bool = false,
        onDismiss: (() -> Void)? = nil,
        content: @escaping (Item) -> some View
    ) -> some View {
        self.fullScreenCover(item: item, onDismiss: onDismiss) { identifiable in
            content(identifiable).dismissable(isPresented: .optional(item), embedInNavigationStack: embedInNavigationStack)
        }
    }
}

extension Binding where Value == Bool {
    static func optional<Item: Identifiable>(_ item: Binding<Item?>) -> Self {
        .init(get: { item.wrappedValue != nil }, set: { if !$0 { item.wrappedValue = nil } })
    }
}
