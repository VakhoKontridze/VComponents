//
//  VMenuRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import Foundation

// MARK:- V Menu Row
/// Enum that represens menu row, such as standard, with icons, or expandable menu
public enum VMenuRow {
    case standard(action: () -> Void, title: String)
    case withSystemIcon(action: () -> Void, title: String, name: String)
    case withAssetIcon(action: () -> Void, title: String, name: String, bundle: Bundle? = nil)
    case menu(title: String, rows: [VMenuRow])
}
