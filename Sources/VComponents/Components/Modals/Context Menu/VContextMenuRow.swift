//
//  VContextMenuRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.06.22.
//

import SwiftUI

// MARK: - V Context Menu Row
/// Model that represents context menu row, such as title, title with icons, or sub-menu.
public struct VContextMenuRow {
    // MARK: Properties
    let _contextMenuRow: _VContextMenuRow
    
    // MARK: Initializers
    private init(
        contextMenuRow: _VContextMenuRow
    ) {
        self._contextMenuRow = contextMenuRow
    }
    
    /// Row with title.
    public static func title(
        action: @escaping () -> Void,
        title: String
    ) -> Self {
        .init(contextMenuRow: .title(
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
        .init(contextMenuRow: .titleAssetIcon(
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
        .init(contextMenuRow: .titleIcon(
            action: action,
            title: title,
            icon: icon
        ))
    }
    
    /// Row with title and system icon.
    public static func titleIcon(
        action: @escaping () -> Void,
        title: String,
        systemIcon: String
    ) -> Self {
        .init(contextMenuRow: .titleSystemIcon(
            action: action,
            title: title,
            icon: systemIcon
        ))
    }
    
    /// Row that expands to sub-menu.
    public static func menu(
        title: String,
        rows: [VContextMenuRow]
    ) -> Self {
        .init(contextMenuRow: .menu(
            title: title,
            rows: rows
        ))
    }
}

// MARK: - _ V Context Menu Row
enum _VContextMenuRow {
    case title(action: () -> Void, title: String)
    case titleAssetIcon(action: () -> Void, title: String, icon: String, bundle: Bundle?)
    case titleIcon(action: () -> Void, title: String, icon: Image)
    case titleSystemIcon(action: () -> Void, title: String, icon: String)
    case menu(title: String, rows: [VContextMenuRow])
}
