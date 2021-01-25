//
//  VDialogButtons.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK:- V Dialog Buttons
/// Enum that describes dialog buttons, such as one button, two buttons, or many buttons
public enum VDialogButtons {
    case one(button: VDialogButton)
    case two(primary: VDialogButton, secondary: VDialogButton)
    case many(_ buttons: [VDialogButton])
}
