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
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VAlertButton: VAlertButtonProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let action: (@MainActor () -> Void)?
    private let title: String
    /*private*/ let role: Role

    // MARK: Initializers
    /// Initializes `VAlertButton` with action, title, and role.
    public init(
        action: (@MainActor () -> Void)?,
        title: String,
        role: Role
    ) {
        self.action = action
        self.title = title
        self.role = role
    }

    // MARK: Role
    /// Model that describes the purpose of a button.
    public enum Role: Int, Sendable, CaseIterable {
        /// Primary.
        case primary

        /// Secondary.
        case secondary

        /// Destructive.
        case destructive

        /// Cancel.
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
