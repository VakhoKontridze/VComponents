//
//  VMenuRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import SwiftUI

// MARK: - V Menu Row
/// `VMenu` row.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenuRow: VMenuGroupRowProtocol {
    // MARK: Properties
    private var isEnabled: Bool = true
    private let action: () -> Void
    private let role: ButtonRole?
    private let title: String
    private let icon: Image?
    
    // MARK: Initializers
    /// Initializes `VMenuRow` with action and title.
    public init(
        action: @escaping () -> Void,
        role: ButtonRole? = nil,
        title: String,
        icon: Image? = nil
    ) {
        self.action = action
        self.role = role
        self.title = title
        self.icon = icon
    }
    
    // MARK: Row Protocol
    public func makeBody() -> AnyView {
        .init(
            Button(
                role: role,
                action: action,
                label: {
                    Text(title)
                    if let icon { icon }
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

// MARK: - V Menu Expanding Row
/// `VMenu` row that expands into submenu.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenuExpandingRow: VMenuGroupRowProtocol { // TODO: Add disabling when custom component is added
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
    
    // MARK: Row Protocol
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

// MARK: - V Menu Picker Row
/// `VMenu` picker row.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenuPickerRow: VMenuPickerRowProtocol { // TODO: Add disabling when custom component is added
    // MARK: Properties
    private let title: String
    private let icon: Image?

    // MARK: Initializers
    /// Initializes `VMenuRow` with action and title.
    public init(
        title: String,
        icon: Image? = nil
    ) {
        self.title = title
        self.icon = icon
    }

    // MARK: Row Protocol
    public func makeBody() -> AnyView {
        .init(
            Button(
                action: {},
                label: {
                    Text(title)
                    if let icon { icon }
                }
            )
        )
    }
}
