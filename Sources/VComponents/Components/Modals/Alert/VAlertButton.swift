//
//  VAlertButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - V Alert Button
/// `VAlert` button.
public protocol VAlertButton: VAlertButtonConvertible {}

extension VAlertButton {
    public func toButtons() -> [any VAlertButton] { [self] }
}

// MARK: - V Alert Primary Button
/// Primary `VAlert` button.
public struct VAlertPrimaryButton: VAlertButton {
    // MARK: Properties
    private(set) var isEnabled: Bool = true
    let action: () -> Void
    let title: String
    
    // MARK: Initializers
    /// Initializes `VConfirmationDialog` with action and title.
    public init(
        action: @escaping () -> Void,
        title: String
    ) {
        self.action = action
        self.title = title
    }
    
    // MARK: Alert Button
    /// Adds a condition that controls whether users can interact with this view.
    public func disabled(_ disabled: Bool) -> VAlertPrimaryButton {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}

// MARK: - V Alert Secondary Button
/// Secondary `VAlert` button.
public struct VAlertSecondaryButton: VAlertButton {
    // MARK: Properties
    private(set) var isEnabled: Bool = true
    let action: () -> Void
    let title: String
    
    // MARK: Initializers
    /// Initializes `VAlertSecondaryButton` with action and title.
    public init(
        action: @escaping () -> Void,
        title: String
    ) {
        self.action = action
        self.title = title
    }
    
    // MARK: Alert Button
    /// Adds a condition that controls whether users can interact with this view.
    public func disabled(_ disabled: Bool) -> VAlertSecondaryButton {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}

// MARK: - V Alert Destructive Button
/// Destructive `VAlert` button.
public struct VAlertDestructiveButton: VAlertButton {
    // MARK: Properties
    private(set) var isEnabled: Bool = true
    let action: () -> Void
    let title: String
    
    // MARK: Initializers
    /// Initializes `VAlertDestructiveButton` with action and title.
    public init(
        action: @escaping () -> Void,
        title: String
    ) {
        self.action = action
        self.title = title
    }
    
    // MARK: Alert Button
    /// Adds a condition that controls whether users can interact with this view.
    public func disabled(_ disabled: Bool) -> VAlertDestructiveButton {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}

// MARK: - V Alert OK Button
/// "Ok" `VAlert` button.
public struct VAlertOKButton: VAlertButton {
    // MARK: Properties
    private(set) var isEnabled: Bool = true
    let action: () -> Void
    let title: String
    
    // MARK: Initializers
    /// Initializes `VAlertOKButton` with action.
    public init(
        action: @escaping () -> Void
    ) {
        self.action = action
        self.title = VComponentsLocalizationService.shared.localizationProvider.vAlertOKButtonTitle
    }
    
    // MARK: Alert Button
    /// Adds a condition that controls whether users can interact with this view.
    public func disabled(_ disabled: Bool) -> VAlertOKButton {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}

// MARK: - V Alert Cancel Button
/// Cancel `VAlert` button.
public struct VAlertCancelButton: VAlertButton {
    // MARK: Properties
    private(set) var isEnabled: Bool = true
    let action: () -> Void
    let title: String
    
    // MARK: Initializers
    /// Initializes `VAlertCancelButton` with action.
    public init(
        action: @escaping () -> Void
    ) {
        self.action = action
        self.title = VComponentsLocalizationService.shared.localizationProvider.vAlertCancelButtonTitle
    }
    
    // MARK: Alert Button
    /// Adds a condition that controls whether users can interact with this view.
    public func disabled(_ disabled: Bool) -> VAlertCancelButton {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}
