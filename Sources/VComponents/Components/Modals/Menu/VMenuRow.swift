//
//  VMenuRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import SwiftUI

// MARK: - V Menu Row
/// Model that represents menu row, such as title, title with icons, or sub-menu.
public struct VMenuRow {
    // MARK: Properties
    let _menuRow: _VMenuRow
    
    // MARK: Initializers
    private init(
        menuRow: _VMenuRow
    ) {
        self._menuRow = menuRow
    }
    
    /// Row with title.
    public static func title(
        action: @escaping () -> Void,
        title: String
    ) -> Self {
        .init(menuRow: .title(
            action: action,
            title: title
        ))
    }
    
    /// Row with title and icon from assets catalog.
    public static func titleIcon(
        action: @escaping () -> Void,
        title: String,
        assetIcon: String,
        bundle: Bundle? = nil
    ) -> Self {
        .init(menuRow: .titleAssetIcon(
            action: action,
            title: title,
            icon: assetIcon,
            bundle: bundle
        ))
    }
    
    /// Row with title and icon.
    public static func titleIcon(
        action: @escaping () -> Void,
        title: String,
        icon: Image
    ) -> Self {
        .init(menuRow: .titleIcon(
            action: action,
            title: title,
            icon: icon
        ))
    }
    
    /// Row with title and sytem icon.
    public static func titleIcon(
        action: @escaping () -> Void,
        title: String,
        systemIcon: String
    ) -> Self {
        .init(menuRow: .titleSystemIcon(
            action: action,
            title: title,
            icon: systemIcon
        ))
    }
    
    /// Row that expands to sub-menu.
    public static func menu(
        title: String,
        rows: [VMenuRow]
    ) -> Self {
        .init(menuRow: .menu(
            title: title,
            rows: rows
        ))
    }
}

// MARK: - _ V Menu Row
enum _VMenuRow {
    case title(action: () -> Void, title: String)
    case titleAssetIcon(action: () -> Void, title: String, icon: String, bundle: Bundle?)
    case titleIcon(action: () -> Void, title: String, icon: Image)
    case titleSystemIcon(action: () -> Void, title: String, icon: String)
    case menu(title: String, rows: [VMenuRow])
}
