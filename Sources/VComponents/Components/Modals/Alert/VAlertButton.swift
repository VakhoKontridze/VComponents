//
//  VAlertButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - V Alert Button Protocol
/// `VAlert` button protocol.
public protocol VAlertButtonProtocol: VAlertButtonConvertible {
    /// Body type.
    typealias Body = AnyView
    
    /// Body.
    func body(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> Body
}

extension VAlertButtonProtocol {
    public func toButtons() -> [any VAlertButtonProtocol] { [self] }
}

// MARK: - V Alert Primary Button
/// Primary `VAlert` button.
public struct VAlertPrimaryButton: VAlertButtonProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let action: (() -> Void)?
    private let title: String
    
    // MARK: Initializers
    /// Initializes `VConfirmationDialog` with action and title.
    public init(
        action: (() -> Void)?,
        title: String
    ) {
        self.action = action
        self.title = title
    }
    
    // MARK: Body
    public func body(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        .init(
            VPrimaryButton(
                uiModel: uiModel.primaryButtonSubUIModel,
                isLoading: false,
                action: { animateOut(/*completion: */action) },
                title: title
            )
                .disabled(!isEnabled)
        )
    }
    
    // MARK: Modifiers
    /// Adds a condition that controls whether users can interact with the button.
    public func disabled(_ disabled: Bool) -> Self {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}

// MARK: - V Alert Secondary Button
/// Secondary `VAlert` button.
public struct VAlertSecondaryButton: VAlertButtonProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let action: (() -> Void)?
    private let title: String
    
    // MARK: Initializers
    /// Initializes `VAlertSecondaryButton` with action and title.
    public init(
        action: (() -> Void)?,
        title: String
    ) {
        self.action = action
        self.title = title
    }
    
    // MARK: Body
    public func body(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        .init(
            VPrimaryButton(
                uiModel: uiModel.secondaryButtonSubUIModel,
                isLoading: false,
                action: { animateOut(/*completion: */action) },
                title: title
            )
                .disabled(!isEnabled)
        )
    }
    
    // MARK: Modifiers
    /// Adds a condition that controls whether users can interact with the button.
    public func disabled(_ disabled: Bool) -> Self {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}

// MARK: - V Alert OK Button
/// "Ok" `VAlert` button.
public struct VAlertOKButton: VAlertButtonProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let action: (() -> Void)?
    private let title: String
    
    // MARK: Initializers
    /// Initializes `VAlertOKButton` with action.
    ///
    /// If `title` is `nil`, value will be retrieved from `VComponentsLocalizationManager`.
    public init(
        action: (() -> Void)?,
        title: String? = nil
    ) {
        self.action = action
        self.title = title ?? VComponentsLocalizationManager.shared.localizationProvider.vAlertOKButtonTitle
    }
    
    // MARK: Body
    public func body(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        .init(
            VPrimaryButton(
                uiModel: uiModel.secondaryButtonSubUIModel,
                isLoading: false,
                action: { animateOut(/*completion: */action) },
                title: title
            )
                .disabled(!isEnabled)
        )
    }
    
    // MARK: Modifiers
    /// Adds a condition that controls whether users can interact with the button.
    public func disabled(_ disabled: Bool) -> Self {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}

// MARK: - V Alert Destructive Button
/// Destructive `VAlert` button.
public struct VAlertDestructiveButton: VAlertButtonProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let action: (() -> Void)?
    private let title: String
    
    // MARK: Initializers
    /// Initializes `VAlertDestructiveButton` with action and title.
    public init(
        action: (() -> Void)?,
        title: String
    ) {
        self.action = action
        self.title = title
    }
    
    // MARK: Body
    public func body(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        .init(
            VPrimaryButton(
                uiModel: uiModel.destructiveButtonSubUIModel,
                isLoading: false,
                action: { animateOut(/*completion: */action) },
                title: title
            )
                .disabled(!isEnabled)
        )
    }
    
    // MARK: Modifiers
    /// Adds a condition that controls whether users can interact with the button.
    public func disabled(_ disabled: Bool) -> Self {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}

// MARK: - V Alert Cancel Button
/// Cancel `VAlert` button.
public struct VAlertCancelButton: VAlertButtonProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let action: (() -> Void)?
    private let title: String
    
    // MARK: Initializers
    /// Initializes `VAlertCancelButton` with action.
    ///
    /// If `title` is `nil`, value will be retrieved from `VComponentsLocalizationManager`.
    public init(
        action: (() -> Void)?,
        title: String? = nil
    ) {
        self.action = action
        self.title = title ?? VComponentsLocalizationManager.shared.localizationProvider.vAlertCancelButtonTitle
    }
    
    // MARK: Body
    public func body(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        .init(
            VPrimaryButton(
                uiModel: uiModel.secondaryButtonSubUIModel,
                isLoading: false,
                action: { animateOut(/*completion: */action) },
                title: title
            )
                .disabled(!isEnabled)
        )
    }
    
    // MARK: Modifiers
    /// Adds a condition that controls whether users can interact with the button.
    public func disabled(_ disabled: Bool) -> Self {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}
