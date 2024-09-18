//
//  VAlertParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Alert Parameters
/// Parameters for presenting a `VAlert`.
///
///     @State private var parameters: VAlertParameters?
///
///     var body: some View {
///         ZStack(content: {
///             VPlainButton(
///                 action: {
///                     parameters = VAlertParameters(
///                         title: "Lorem Ipsum",
///                         message: "Lorem ipsum dolor sit amet",
///                         actions: {
///                             VAlertButton(role: .primary, action: { print("Confirmed") }, title: "Confirm")
///                             VAlertButton(role: .cancel, action: { print("Cancelled") }, title: "Cancel")
///                         }
///                     )
///                 },
///                 title: "Present"
///             )
///             .vAlert(id: "some_alert", parameters: $parameters)
///         })
///         .frame(maxWidth: .infinity, maxHeight: .infinity)
///         .presentationHostLayer() // Or declare in `App` on a `WindowScene`-level
///     }
///
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
@MainActor
public struct VAlertParameters {
    // MARK: Properties
    /// Title.
    public var title: String
    
    /// Message.
    public var message: String?

    /// Buttons.
    public var buttons: () -> [any VAlertButtonProtocol]

    /// Attributes.
    public var attributes: [String: Any?]
    
    // MARK: Parameters
    /// Initializes `VAlertParameters`.
    public init(
        title: String,
        message: String?,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol],
        attributes: [String: Any?] = [:]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
        self.attributes = attributes
    }
    
    /// Initializes `VAlertParameters` with "ok" action.
    public init(
        title: String,
        message: String?,
        completion: (() -> Void)?,
        attributes: [String: Any?] = [:]
    ) {
        self.init(
            title: title,
            message: message,
            actions: {
                VAlertButton(
                    role: .cancel,
                    action: completion,
                    title: VComponentsLocalizationManager.shared.localizationProvider.vAlertCancelButtonTitle
                )
            },
            attributes: attributes
        )
    }
    
    /// Initializes `VAlertParameters` with error and "ok" action.
    public init(
        error: any Error,
        completion: (() -> Void)?,
        attributes: [String: Any?] = [:]
    ) {
        self.init(
            title: VComponentsLocalizationManager.shared.localizationProvider.vAlertErrorTitle,
            message: error.localizedDescription,
            actions: {
                VAlertButton(
                    role: .secondary,
                    action: completion,
                    title: VComponentsLocalizationManager.shared.localizationProvider.vAlertOKButtonTitle
                )
            },
            attributes: attributes
        )
    }
}
