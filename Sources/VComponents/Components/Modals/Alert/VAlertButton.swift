//
//  VAlertButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - V Alert Button
/// `VAlert` button.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VAlertButton: VAlertButtonProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    /*private*/ let role: Role
    private let action: (() -> Void)?
    private let title: String

    // MARK: Initializers
    /// Initializes `VAlertButton` with action and title.
    public init(
        role: Role,
        action: (() -> Void)?,
        title: String
    ) {
        self.role = role
        self.action = action
        self.title = title
    }

    // MARK: Role
    /// Model that describes the purpose of a button.
    public enum Role: Int, CaseIterable {
        /// Primary button role.
        case primary

        /// Secondary button role.
        case secondary

        /// Destructive button role.
        case destructive

        /// Cancel button role.
        case cancel
    }

    // MARK: Button Protocol
    public func makeBody(
        uiModel: VAlertUIModel,
        animateOutHandler: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> AnyView {
        VStretchedButton(
            uiModel: {
                switch role {
                case .primary: uiModel.primaryButtonSubUIModel
                case .secondary: uiModel.secondaryButtonSubUIModel
                case .destructive: uiModel.destructiveButtonSubUIModel
                case .cancel: uiModel.secondaryButtonSubUIModel
                }
            }(),
            action: { animateOutHandler(/*completion: */action) },
            title: title
        )
        .disabled(!isEnabled)
        .eraseToAnyView()
    }

    // MARK: Modifiers
    /// Adds a condition that controls whether users can interact with the button.
    public func disabled(_ disabled: Bool) -> Self {
        var button = self
        button.isEnabled = !disabled
        return button
    }
}
