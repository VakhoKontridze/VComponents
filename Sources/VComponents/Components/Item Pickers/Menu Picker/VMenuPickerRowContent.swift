//
//  VMenuPickerRowContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK: - V Menu Picker Row Content
/// Model that describes `VMenuPicker` row, such as title, or title with various icon configurations.
public struct VMenuPickerRowContent {
    // MARK: Properties
    let _menuPickerRowContent: _VMenuPickerRowContent
    
    // MARK: Initializers
    private init(
        menuPickerRowContent: _VMenuPickerRowContent
    ) {
        self._menuPickerRowContent = menuPickerRowContent
    }
    
    /// Row with title.
    public static func title(
        title: String
    ) -> Self {
        .init(menuPickerRowContent: .title(
            title: title
        ))
    }
    
    /// Row with title and icon from assets catalog.
    public static func titleIcon(
        title: String,
        assetIcon: String,
        bundle: Bundle? = nil
    ) -> Self {
        .init(menuPickerRowContent: .titleAssetIcon(
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
        .init(menuPickerRowContent: .titleIcon(
            title: title,
            icon: icon
        ))
    }
    
    /// Row with title and sytem icon.
    public static func titleIcon(
        title: String,
        systemIcon: String
    ) -> Self {
        .init(menuPickerRowContent: .titleSystemIcon(
            title: title,
            icon: systemIcon
        ))
    }
}

// MARK: - _ V Menu Picker Row Content
enum _VMenuPickerRowContent {
    case title(title: String)
    case titleAssetIcon(title: String, icon: String, bundle: Bundle?)
    case titleIcon(title: String, icon: Image)
    case titleSystemIcon(title: String, icon: String)
}
