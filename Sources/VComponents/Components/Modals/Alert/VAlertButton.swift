//
//  VAlertButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - V Alert Button Protocol
/// `VAlert` button protocol.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VAlertButtonProtocol: VAlertButtonConvertible {
    /// Body type.
    typealias Body = AnyView
    
    /// Creates a `View` that represents the body of a button.
    func makeBody(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> Body
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VAlertButtonProtocol {
    public func toButtons() -> [any VAlertButtonProtocol] { [self] }
}

// MARK: - V Alert Primary Button
/// Primary `VAlert` button.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
    public func makeBody(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        .init(
            VStretchedButton(
                uiModel: uiModel.primaryButtonSubUIModel,
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
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
    public func makeBody(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        .init(
            VStretchedButton(
                uiModel: uiModel.secondaryButtonSubUIModel,
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
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
    public func makeBody(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        .init(
            VStretchedButton(
                uiModel: uiModel.secondaryButtonSubUIModel,
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
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
    public func makeBody(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        .init(
            VStretchedButton(
                uiModel: uiModel.destructiveButtonSubUIModel,
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
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
    public func makeBody(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        .init(
            VStretchedButton(
                uiModel: uiModel.secondaryButtonSubUIModel,
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
