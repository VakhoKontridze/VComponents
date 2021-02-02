//
//  VMenuRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import Foundation

// MARK:- V Menu Row
/// Enum that represens menu row, such as titled, with icons, or expandable menu
public enum VMenuRow {
    case titled(action: () -> Void, title: String)
    case titledSystemIcon(action: () -> Void, title: String, name: String)
    case titledAssetIcon(action: () -> Void, title: String, name: String, bundle: Bundle? = nil)
    case menu(title: String, rows: [VMenuRow])
}
