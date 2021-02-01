//
//  VActionSheetRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI

// MARK:- V Action Sheet Row
/// Enum that represens action sheet row, such as standard, destructive, or cancel
///
/// If two cancel buttons are used, app would crash
public enum VActionSheetRow {
    case standard(action: () -> Void, title: String)
    case destructive(action: () -> Void, title: String)
    case cancel(action: (() -> Void)?, title: String)
    
    var actionSheetButton: ActionSheet.Button {
        switch self {
        case .standard(let action, let title):
            return .default(Text(title), action: action)
        
        case .destructive(let action, let title):
            return .destructive(Text(title), action: action)
        
        case .cancel(let action, let title):
            if let action = action {    // Glitches when action == nil is passed as parameter
                return .cancel(Text(title), action: action)
            } else {
                return .cancel(Text(title))
            }
        }
    }
}
