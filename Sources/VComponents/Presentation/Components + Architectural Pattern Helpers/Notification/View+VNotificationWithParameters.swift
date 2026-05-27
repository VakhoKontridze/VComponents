//
//  View+VNotificationWithParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.08.25.
//

public import SwiftUI
public import VCore

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Presents `VNotification` when `VNotificationParameters` is non-`nil`.
    ///
    ///     @State private var parameters: VNotificationParameters?
    ///
    ///     var body: some View {
    ///         ZStack {
    ///             VPlainButton(
    ///                 action: {
    ///                     parameters = VNotificationParameters(
    ///                         image: Image(systemName: "swift"),
    ///                         title: "Lorem Ipsum Dolor Sit Amet",
    ///                         message: "Lorem ipsum dolor sit amet"
    ///                     )
    ///                 },
    ///                 title: "Present"
    ///             )
    ///             .vNotification(link: ModalPresenterLink(linkID: "notification"), parameters: $parameters)
    ///         }
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity) // For `overlay` configuration
    ///         .modalPresenterRoot() // Or declare in `App` on a `WindowScene`-level
    ///     }
    ///
    public func vNotification(
        link: ModalPresenterLink,
        parameters: Binding<VNotificationParameters?>
    ) -> some View {
        self
            .vNotification(
                link: link,
                appearance: { $0.appearance },
                item: parameters,
                image: { $0.image },
                title: { $0.title },
                message: { $0.message }
            )
    }
}
