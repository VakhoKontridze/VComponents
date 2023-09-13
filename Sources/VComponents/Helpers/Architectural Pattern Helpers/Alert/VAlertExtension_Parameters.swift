//
//  VAlertExtension_Parameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Alert Extension (Parameters)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents `VAlert` when `VAlertParameters` is non-`nil`.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .vAlert(
    ///             id: "some_alert",
    ///             isPresented: $isPresented,
    ///             title: "Lorem Ipsum",
    ///             message: "Lorem ipsum dolor sit amet",
    ///             actions: {
    ///                 VAlertButton(role: .primary, action: { print("Confirmed") }, title: "Confirm")
    ///                 VAlertButton(role: .cancel, action: { print("Cancelled") }, title: "Cancel")
    ///             }
    ///         )
    ///     }
    ///     
    public func vAlert(
        id: String,
        uiModel: VAlertUIModel = .init(),
        parameters: Binding<VAlertParameters?>
    ) -> some View {
        self.vAlert(
            id: id,
            uiModel: uiModel,
            item: parameters,
            title: { $0.title },
            message: { $0.message },
            actions: { $0.buttons() }
        )
    }
}
