//
//  VAlertParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

/// Parameters for presenting a `VAlert`.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
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
        completion: (@MainActor () -> Void)?,
        attributes: [String: Any?] = [:]
    ) {
        self.init(
            title: title,
            message: message,
            actions: {
                VAlertButton(
                    action: completion,
                    title: VComponentsLocalizationManager.shared.localizationProvider.vAlertCancelButtonTitle,
                    role: .cancel
                )
            },
            attributes: attributes
        )
    }
    
    /// Initializes `VAlertParameters` with error and "ok" action.
    public init(
        error: any Error,
        completion: (@MainActor () -> Void)?,
        attributes: [String: Any?] = [:]
    ) {
        self.init(
            title: VComponentsLocalizationManager.shared.localizationProvider.vAlertErrorTitle,
            message: error.localizedDescription,
            actions: {
                VAlertButton(
                    action: completion,
                    title: VComponentsLocalizationManager.shared.localizationProvider.vAlertOKButtonTitle,
                    role: .secondary
                )
            },
            attributes: attributes
        )
    }
}
