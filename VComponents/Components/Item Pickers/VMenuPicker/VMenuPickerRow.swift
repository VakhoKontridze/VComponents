//
//  VMenuPickerRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import Foundation

// MARK:- V Menu Picker Row
/// Enum that represens menu picker row, such as titled, or with icons
public enum VMenuPickerRow {
    case titled(title: String)
    case titledSystemIcon(title: String, name: String)
    case titledAssetIcon(title: String, name: String, bundle: Bundle? = nil)
}
