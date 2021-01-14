//
//  VAlertDialogType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK:- V Alert Dialog Type
public enum VAlertDialogType {
    case one(button: VAlertDialogButton)
    case two(primary: VAlertDialogButton, secondary: VAlertDialogButton)
    case multi(_ buttons: [VAlertDialogButton])
}
