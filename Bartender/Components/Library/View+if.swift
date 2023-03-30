import SwiftUI

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
