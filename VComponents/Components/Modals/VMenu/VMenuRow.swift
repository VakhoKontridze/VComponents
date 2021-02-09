//
//  VMenuRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import Foundation

// MARK:- V Menu Row
/// Enum that represens menu row, such as `titled`, with icons, or expandable `menu`
public enum VMenuRow {
    /// Row with title
    case titled(action: () -> Void, title: String)
    
    /// Row with title and system icon
    case titledSystemIcon(action: () -> Void, title: String, name: String)
    
    /// Row with title and icon from asset catalog
    case titledAssetIcon(action: () -> Void, title: String, name: String, bundle: Bundle? = nil)
    
    /// Row that expands to sub-menu
    case menu(title: String, rows: [VMenuRow])
}
