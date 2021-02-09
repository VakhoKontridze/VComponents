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
    /// One button
    case one(button: VDialogButton)
    
    /// Two buttons
    ///
    /// Buttons are stacked horizontally
    case two(primary: VDialogButton, secondary: VDialogButton)
    
    /// Many buttons
    ///
    /// Buttons are stacked vertically
    case many(_ buttons: [VDialogButton])
}
