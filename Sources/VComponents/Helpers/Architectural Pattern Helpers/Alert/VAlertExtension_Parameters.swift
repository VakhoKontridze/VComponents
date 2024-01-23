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
@available(visionOS, unavailable)
extension View {
    /// Presents `VAlert` when `VAlertParameters` is non-`nil`.
    ///
    ///     @State private var parameters: VAlertParameters?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: {
    ///                 parameters = VAlertParameters(
    ///                     title: "Lorem Ipsum",
    ///                     message: "Lorem ipsum dolor sit amet",
    ///                     actions: {
    ///                         VAlertButton(role: .primary, action: { print("Confirmed") }, title: "Confirm")
    ///                         VAlertButton(role: .cancel, action: { print("Cancelled") }, title: "Cancel")
    ///                     }
    ///                 )
    ///             },
    ///             title: "Present"
    ///         )
    ///         .vAlert(id: "some_alert", parameters: $parameters)
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

    /// Presents `VAlert` when `parameters` is non-`nil`.
    ///
    ///     @State private var parameters: VAlertParameters?
    ///     @State private var inputText: String = "Lorem ipsum"
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: {
    ///                 parameters = VAlertParameters(
    ///                     title: "Lorem Ipsum",
    ///                     message: "Lorem ipsum dolor sit amet",
    ///                     actions: {
    ///                         VAlertButton(role: .primary, action: { print("Confirmed") }, title: "Confirm")
    ///                         VAlertButton(role: .cancel, action: { print("Cancelled") }, title: "Cancel")
    ///                     },
    ///                     attributes: [
    ///                         "input_text_binding": $inputText
    ///                     ]
    ///                 )
    ///             },
    ///             title: "Present"
    ///         )
    ///         .vAlert(
    ///             id: "some_alert",
    ///             parameters: $parameters,
    ///             content: { parameters in
    ///                 if let inputTextBinding = parameters.attributes["input_text_binding"] as? Binding<String> {
    ///                     TextField("", text: inputTextBinding)
    ///                         .textFieldStyle(.roundedBorder)
    ///                 }
    ///             }
    ///         )
    ///     }
    ///
    public func vAlert<Content>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        parameters: Binding<VAlertParameters?>,
        @ViewBuilder content: @escaping (VAlertParameters) -> Content
    ) -> some View
        where Content: View
    {
        self.vAlert(
            id: id,
            uiModel: uiModel,
            item: parameters,
            title: { $0.title },
            message: { $0.message },
            content: content,
            actions: { $0.buttons() }
        )
    }
}
