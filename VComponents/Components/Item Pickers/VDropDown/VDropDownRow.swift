//
//  VDropDownRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import Foundation

// MARK:- V Drop Down Row
/// Enum that represens drop down row, such as titled, or with icons
public enum VDropDownRow {
    case titled(title: String)
    case titledSystemIcon(title: String, name: String)
    case titledAssetIcon(title: String, name: String, bundle: Bundle? = nil)
}
