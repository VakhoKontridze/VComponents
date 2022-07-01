//
//  VMenuRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import SwiftUI

// MARK: - V Menu Section
/// Single row in `VMenu`.
public protocol VMenuRow: VMenuRowConvertible {
    /// Row body type.
    typealias Body = AnyView
    
    /// Row body.
    var body: Body { get }
}

extension VMenuRow {
    public func toRows() -> [any VMenuRow] { [self] }
}

// MARK: - V Menu Title Row
/// SIngle row in `VMenu` with title.
public struct VMenuTitleRow: VMenuRow {
    // MARK: Properties
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
    
    // MARK: Row Section
    public var body: AnyView {
        .init(
            Button(title, role: role, action: action)
        )
    }
}

// MARK: - V Menu Title Icon Row
/// SIngle row in `VMenu` with title and icon.
public struct VMenuTitleIconRow: VMenuRow {
    // MARK: Properties
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
        self.icon = .init(assetIcon, bundle: bundle)
    }
    
    /// Initializes `VMenuTitleIconRow` with action, title, and system icon name.
    public init(
        action: @escaping () -> Void,
        role: ButtonRole? = nil,
        title: String,
        systemIcon: String
    ) {
        self.action = action
        self.role = role
        self.title = title
        self.icon = .init(systemName: systemIcon)
    }
    
    // MARK: Row Section
    public var body: AnyView {
        .init(
            Button(role: role, action: action, label: {
                Text(title)
                icon
            })
        )
    }
}

// MARK: - V Menu Sub Menu Row
/// SIngle row in `VMenu` with submenu.
public struct VMenuSubMenuRow: VMenuRow {
    // MARK: Properties
    let title: String
    let primaryAction: (() -> Void)?
    private let sections: () -> [any VMenuSection]
    
    // MARK: Initializers
    /// Initializes `VMenuPickerSection` title with sections.
    public init(
        title: String,
        primaryAction: (() -> Void)? = nil,
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSection]
    ) {
        self.title = title
        self.primaryAction = primaryAction
        self.sections = sections
    }
    
    // MARK: Row Section
    public var body: AnyView {
        .init(
            VMenu(
                primaryAction: primaryAction,
                title: title,
                sections: sections
            )
        )
    }
}
