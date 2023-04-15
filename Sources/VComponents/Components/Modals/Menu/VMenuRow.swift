//
//  VMenuRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import SwiftUI

// MARK: - V Menu Row Protocol
/// `VMenu` row.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VMenuRowProtocol: VMenuRowConvertible {
    /// Body type.
    typealias Body = AnyView
    
    /// Creates a `View` that represents the body of a row.
    func makeBody() -> Body
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VMenuRowProtocol {
    public func toRows() -> [any VMenuRowProtocol] { [self] }
}

// MARK: - V Menu Title Row
/// `VMenu` row with title.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS 15.0, *)@available(tvOS, unavailable)
@available(watchOS 8.0, *)@available(watchOS, unavailable)
public struct VMenuTitleRow: VMenuRowProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let action: () -> Void
    private let role: ButtonRole?
    private let title: String
    
    // MARK: Initializers
    /// Initializes `VMenuTitleRow` with action and title.
    public init(
        action: @escaping () -> Void,
        role: ButtonRole? = nil,
        title: String
    ) {
        self.action = action
        self.role = role
        self.title = title
    }
    
    // MARK: Body
    public func makeBody() -> AnyView {
        .init(
            Button(
                title,
                role: role,
                action: action
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

// MARK: - V Menu Title Icon Row
/// `VMenu` row with title and icon.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS 15.0, *)@available(tvOS, unavailable)
@available(watchOS 8.0, *)@available(watchOS, unavailable)
public struct VMenuTitleIconRow: VMenuRowProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let action: () -> Void
    private let role: ButtonRole?
    private let title: String
    private let icon: Image
    
    // MARK: Initializers
    /// Initializes `VMenuTitleIconRow` with action, title, and icon.
    public init(
        action: @escaping () -> Void,
        role: ButtonRole? = nil,
        title: String,
        icon: Image
    ) {
        self.action = action
        self.role = role
        self.title = title
        self.icon = icon
    }
    
    /// Initializes `VMenuTitleIconRow` with action, title, and asset icon name.
    public init(
        action: @escaping () -> Void,
        role: ButtonRole? = nil,
        title: String,
        assetIcon: String,
        bundle: Bundle? = nil
    ) {
        self.action = action
        self.role = role
        self.title = title
        self.icon = Image(assetIcon, bundle: bundle)
    }
    
    /// Initializes `VMenuTitleIconRow` with action, title, and `system`icon name.
    public init(
        action: @escaping () -> Void,
        role: ButtonRole? = nil,
        title: String,
        systemIcon: String
    ) {
        self.action = action
        self.role = role
        self.title = title
        self.icon = Image(systemName: systemIcon)
    }
    
    // MARK: Body
    public func makeBody() -> AnyView {
        .init(
            Button(
                role: role,
                action: action,
                label: {
                    Text(title)
                    icon
                }
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

// MARK: - V Menu Sub Menu Row
/// `VMenu` row with submenu.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenuSubMenuRow: VMenuRowProtocol { // Cannot be disabled
    // MARK: Properties
    private let title: String
    private let primaryAction: (() -> Void)?
    private let sections: () -> [any VMenuSectionProtocol]
    
    // MARK: Initializers
    /// Initializes `VMenuPickerSection` title with sections.
    public init(
        title: String,
        primaryAction: (() -> Void)? = nil,
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol]
    ) {
        self.title = title
        self.primaryAction = primaryAction
        self.sections = sections
    }
    
    // MARK: Body
    public func makeBody() -> AnyView {
        .init(
            VMenu(
                primaryAction: primaryAction,
                title: title,
                sections: sections
            )
        )
    }
}
