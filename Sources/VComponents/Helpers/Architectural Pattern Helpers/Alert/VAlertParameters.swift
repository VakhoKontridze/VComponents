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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VAlertParameters: Identifiable {
    // MARK: Properties
    /// ID.
    public let id: UUID = .init()
    
    /// Title.
    public var title: String
    
    /// Message.
    public var message: String?
    
    /// Buttons.
    public var buttons: () -> [any VAlertButtonProtocol]
    
    // MARK: Parameters
    /// Initializes `VAlertParameters`.
    public init(
        title: String,
        message: String?,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
    
    /// Initializes `VAlertParameters` with "ok" action.
    public init(
        title: String,
        message: String?,
        completion: (() -> Void)?
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
            }
        )
    }
    
    /// Initializes `VAlertParameters` with error and "ok" action.
    public init(
        error: some Error,
        completion: (() -> Void)?
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
            }
        )
    }
}
