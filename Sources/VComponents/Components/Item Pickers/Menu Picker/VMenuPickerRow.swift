//
//  VMenuPickerRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK: - V Menu Picker Row
/// Model that represents `VMenuPicker` row, such as title, or title with various icon configurations.
public struct VMenuPickerRow {
    // MARK: Properties
    let _menuPickerRow: _VMenuPickerRow
    
    // MARK: Initializers
    private init(
        menuPickerRow: _VMenuPickerRow
    ) {
        self._menuPickerRow = menuPickerRow
    }
    
    /// Row with title.
    public static func title(
        title: String
    ) -> Self {
        .init(menuPickerRow: .title(
            title: title
        ))
    }
    
    /// Row with title and icon from assets catalog.
    public static func titleIcon(
        title: String,
        assetIcon: String,
        bundle: Bundle? = nil
    ) -> Self {
        .init(menuPickerRow: .titleAssetIcon(
            title: title,
            icon: assetIcon,
            bundle: bundle
        ))
    }
    
    /// Row with title and icon.
    public static func titleIcon(
        title: String,
        icon: Image
    ) -> Self {
        .init(menuPickerRow: .titleIcon(
            title: title,
            icon: icon
        ))
    }
    
    /// Row with title and sytem icon.
    public static func titleIcon(
        title: String,
        systemIcon: String
    ) -> Self {
        .init(menuPickerRow: .titleSystemIcon(
            title: title,
            icon: systemIcon
        ))
    }
}

// MARK: - _ V Menu Picker Row
enum _VMenuPickerRow {
    case title(title: String)
    case titleAssetIcon(title: String, icon: String, bundle: Bundle?)
    case titleIcon(title: String, icon: Image)
    case titleSystemIcon(title: String, icon: String)
}
