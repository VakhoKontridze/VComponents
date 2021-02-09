//
//  VTabNavigationPageItem.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import Foundation

// MARK:- V Tab Navigation Page Item
/// Enum that represens navigation page item, such as `titled`, or with icons
public enum VTabNavigationPageItem {
    /// Item with title
    case titled(title: String)
    
    /// Item with system icon
    case systemIcon(name: String)
    
    /// item with icon from asset catalog
    case assetIcon(name: String, bundle: Bundle? = nil)
    
    /// Item with titl and system icon
    case titledSystemIcon(title: String, name: String)
    
    /// item with title and icon from asset catalog
    case titledAssetIcon(title: String, name: String, bundle: Bundle? = nil)
}
