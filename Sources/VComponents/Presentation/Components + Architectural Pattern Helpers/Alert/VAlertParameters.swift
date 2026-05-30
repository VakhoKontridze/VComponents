//
//  VAlertParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

public import SwiftUI
import VCore

/// Parameters for presenting a `VAlert`.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VAlertParameters: Identifiable {
    // MARK: Properties
    /// ID.
    public var id: UUID
    
    /// Appearance.
    public var appearance: VAlertAppearance
    
    /// Title.
    public var title: String
    
    /// Message.
    public var message: String?

    /// Buttons.
    public var buttons: () -> [any VAlertButtonProtocol]

    /// Attributes.
    public var attributes: [String: Any]
    
    // MARK: Parameters
    /// Initializes `VAlertParameters`.
    public init(
        id: UUID = .init(),
        appearance: VAlertAppearance = .init(),
        title: String,
        message: String?,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol],
        attributes: [String: Any] = [:]
    ) {
        self.id = id
        self.appearance = appearance
        self.title = title
        self.message = message
        self.buttons = buttons
        self.attributes = attributes
    }
    
    /// Initializes `VAlertParameters` with action.
    public init(
        id: UUID = .init(),
        appearance: VAlertAppearance = .init(),
        title: String,
        message: String?,
        completion: (() -> Void)? = nil,
        attributes: [String: Any] = [:]
    ) {
        self.init(
            id: id,
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
        id: UUID = .init(),
        appearance: VAlertAppearance = .init(),
        error: any Error,
        completion: (() -> Void)? = nil,
        attributes: [String: Any] = [:]
    ) {
        self.init(
            id: id,
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
}
