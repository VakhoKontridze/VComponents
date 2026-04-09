//
//  View+VToastWithParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.08.25.
//

import SwiftUI
import VCore

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Presents `VToast` when `VToastParameters` is non-`nil`.
    ///
    ///     @State private var parameters: VToastParameters?
    ///
    ///     var body: some View {
    ///         ZStack {
    ///             VPlainButton(
    ///                 action: {
    ///                     parameters = VToastParameters(
    ///                         text: "Lorem ipsum dolor sit amet"
    ///                     )
    ///                 },
    ///                 title: "Present"
    ///             )
    ///             .vToast(link: ModalPresenterLink(linkID: "toast"), parameters: $parameters)
    ///         }
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity) // For `overlay` configuration
    ///         .modalPresenterRoot() // Or declare in `App` on a `WindowScene`-level
    ///     }
    ///
    public func vToast(
        link: ModalPresenterLink,
        parameters: Binding<VToastParameters?>
    ) -> some View {
        self
            .vToast(
                link: link,
                appearance: { $0.appearance },
                item: parameters,
                text: { $0.text }
            )
    }
}
