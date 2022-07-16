//
//  VConfirmationDialogButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI

// MARK: - V Confirmation Dialog Button
/// `VConfirmationDialog` button.
public protocol VConfirmationDialogButton: VConfirmationDialogButtonConvertible {
    /// Indicates if button is enabled.
    var isEnabled: Bool { get set }
    
    /// Body type.
    typealias Body = AnyView
    
    /// Body.
    var body: Body { get }
}

extension VConfirmationDialogButton {
    public func toButtons() -> [any VConfirmationDialogButton] { [self] }
}

// MARK: - Modifiers
extension VConfirmationDialogButton {
    /// Adds a condition that controls whether users can interact with this view.
    public func disabled(_ disabled: Bool) -> Self {
        var button: Self = self
        button.isEnabled = !disabled
        return button
    }
}

// MARK: - V Confirmation Dialog Title Button
/// `VConfirmationDialog` button with title.
public struct VConfirmationDialogTitleButton: VConfirmationDialogButton {
    // MARK: Properties
    public var isEnabled: Bool = true
    private let action: () -> Void
    private let role: ButtonRole?
    private let title: String
    
    // MARK: Initializers
    /// Initializes `VConfirmationDialog` with action and title.
    public init(
        action: @escaping () -> Void,
        role: ButtonRole? = nil,
        title: String
    ) {
        self.action = action
        self.role = role
        self.title = title
    }
    
    // MARK: Row Section
    public var body: AnyView {
        .init(
            Button(
                title,
                role: role,
                action: action
            )
                .disabled(!isEnabled)
        )
    }
}
