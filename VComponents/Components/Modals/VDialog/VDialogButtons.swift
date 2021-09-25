//
//  VDialogButtons.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK: - V Dialog Buttons
/// Enum that describes `VDialog` buttons, such as `one`, `two`, or `many`
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
