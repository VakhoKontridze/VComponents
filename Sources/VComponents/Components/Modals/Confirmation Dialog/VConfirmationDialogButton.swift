//
//  VConfirmationDialogButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI

// MARK: - V Confirmation Dialog Button Protocol
/// `VConfirmationDialog` button.
public protocol VConfirmationDialogButtonProtocol: VConfirmationDialogButtonConvertible {
    /// Body type.
    typealias Body = AnyView
    
    /// Creates a `View` that represents the body of a button.
    func makeBody() -> Body
}

extension VConfirmationDialogButtonProtocol {
    public func toButtons() -> [any VConfirmationDialogButtonProtocol] { [self] }
}

// MARK: - V Confirmation Dialog Button
/// `VConfirmationDialog` button.
public struct VConfirmationDialogButton: VConfirmationDialogButtonProtocol {
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
    public func makeBody() -> AnyView {
        .init(
            Button(
                title,
                role: nil,
                action: { action?() }
            )
                .disabled(!isEnabled)
        )
    }
    
    // MARK: Modifiers
    /// Adds a condition that controls whether users can interact with the button.
    public func disabled(_ disabled: Bool) -> Self {
        var row = self
        row.isEnabled = !disabled
        return row
    }
}

// MARK: - V Confirmation Dialog OK Button
/// "OK" `VConfirmationDialog` button.
public struct VConfirmationDialogOKButton: VConfirmationDialogButtonProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let title: String
    private let action: (() -> Void)?
    
    // MARK: Initializers
    /// Initializes `VConfirmationDialog` with action.
    ///
    /// If `title` is `nil`, value will be retrieved from `VComponentsLocalizationManager`.
    public init(
        action: (() -> Void)?,
        title: String? = nil
    ) {
        self.action = action
        self.title = title ?? VComponentsLocalizationManager.shared.localizationProvider.vConfirmationDialogOKButtonTitle
    }
    
    // MARK: Modifiers
    /// Adds a condition that controls whether users can interact with the button.
    public func disabled(_ disabled: Bool) -> Self {
        var row = self
        row.isEnabled = !disabled
        return row
    }
    
    // MARK: Body
    public func makeBody() -> AnyView {
        .init(
            Button(
                title,
                role: nil,
                action: { action?() }
            )
                .disabled(!isEnabled)
        )
    }
}

// MARK: - V Confirmation Dialog Destructive Button
/// Destructive `VConfirmationDialog` button.
public struct VConfirmationDialogDestructiveButton: VConfirmationDialogButtonProtocol {
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
    public func makeBody() -> AnyView {
        AnyView(
            Button(
                title,
                role: .destructive,
                action: { action?() }
            )
                .disabled(!isEnabled)
        )
    }
    
    // MARK: Modifiers
    /// Adds a condition that controls whether users can interact with the button.
    public func disabled(_ disabled: Bool) -> Self {
        var row = self
        row.isEnabled = !disabled
        return row
    }
}

// MARK: - V Confirmation Dialog Cancel Button
/// Cancel `VConfirmationDialog` button.
public struct VConfirmationDialogCancelButton: VConfirmationDialogButtonProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let action: (() -> Void)?
    private let title: String
    
    // MARK: Initializers
    /// Initializes `VConfirmationDialog` with action.
    ///
    /// If `title` is `nil`, value will be retrieved from `VComponentsLocalizationManager`.
    public init(
        action: (() -> Void)?,
        title: String? = nil
    ) {
        self.action = action
        self.title = title ?? VComponentsLocalizationManager.shared.localizationProvider.vConfirmationDialogCancelButtonTitle
    }
    
    // MARK: Body
    public func makeBody() -> AnyView {
        .init(
            Button(
                title,
                role: .cancel,
                action: { action?() }
            )
                .disabled(!isEnabled)
        )
    }
    
    // MARK: Modifiers
    /// Adds a condition that controls whether users can interact with the button.
    public func disabled(_ disabled: Bool) -> Self {
        var row = self
        row.isEnabled = !disabled
        return row
    }
}
