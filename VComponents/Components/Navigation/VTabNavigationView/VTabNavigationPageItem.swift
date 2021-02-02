//
//  VTabNavigationPageItem.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import Foundation

// MARK:- V Tab Navigation Page Item
/// Enum that represens navigation page item, such as titled, or with icons
public enum VTabNavigationPageItem {
    case titled(title: String)
    case withSystemIcon(title: String?, name: String)
    case withAssetIcon(title: String?, name: String, bundle: Bundle? = nil)
}
