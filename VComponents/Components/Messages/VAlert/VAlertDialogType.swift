//
//  VAlertDialogType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK:- V Alert Dialog Type
/// Enum that describes alert dialog, such as one button, two buttons, or many buttons
public enum VAlertDialogType {
    case one(button: VAlertDialogButton)
    case two(primary: VAlertDialogButton, secondary: VAlertDialogButton)
    case many(_ buttons: [VAlertDialogButton])
}
