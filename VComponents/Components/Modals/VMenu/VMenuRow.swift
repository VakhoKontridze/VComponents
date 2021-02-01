//
//  VMenuRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import Foundation

// MARK:- V Menu Row
/// Enum that represens menu row, such as button, buttons with icons, or expandable menu
public enum VMenuRow {
    case button(action: () -> Void, title: String)
    case buttonSystemIcon(action: () -> Void, title: String, name: String)
    case buttonAssetIcon(action: () -> Void, title: String, name: String, bundle: Bundle? = nil)
    case menu(title: String, rows: [VMenuRow])
}
