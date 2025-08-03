//
//  VAlertParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI
import VCore

/// Parameters for presenting a `VAlert`.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VAlertParameters: Equatable {
    // MARK: Properties
    /// Appearance.
    public var appearance: VAlertAppearance
    
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
        appearance: VAlertAppearance = .init(),
        title: String,
        message: String?,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol],
        attributes: [String: Any?] = [:]
    ) {
        self.appearance = appearance
        self.title = title
        self.message = message
        self.buttons = buttons
        self.attributes = attributes
    }
    
    /// Initializes `VAlertParameters` with action.
    public init(
        appearance: VAlertAppearance = .init(),
        title: String,
        message: String?,
        completion: (@MainActor () -> Void)?,
        attributes: [String: Any?] = [:]
    ) {
        self.init(
            appearance: appearance,
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
    
    /// Initializes `VAlertParameters` with error and action.
    public init(
        appearance: VAlertAppearance = .init(),
        error: any Error,
        completion: (@MainActor () -> Void)?,
        attributes: [String: Any?] = [:]
    ) {
        self.init(
            appearance: appearance,
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
    
    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        isEqual(lhs, to: rhs, by: \.appearance, \.title, \.message)
    }
}
