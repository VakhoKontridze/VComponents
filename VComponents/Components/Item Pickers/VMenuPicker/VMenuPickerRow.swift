//
//  VMenuPickerRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import Foundation

// MARK:- V Menu Picker Row
/// Enum that represens menu picker row, such as `titled`, or with icons
public enum VMenuPickerRow {
    /// Row with title
    case titled(title: String)
    
    /// Row with title and sytem icon
    case titledSystemIcon(title: String, name: String)
    
    /// Row with title and icon from assets catalog
    case titledAssetIcon(title: String, name: String, bundle: Bundle? = nil)
}
