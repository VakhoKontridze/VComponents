//
//  VTextFieldActions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/20/21.
//

import Foundation

// MAR:- V Text Field Actins
/// Enum that describes action performed when pressing `return` button.
public typealias VTextFieldReturnButtonAction = VBaseTextFieldReturnButtonAction

/// Enum that describes action performed when pressing `clear` button.
public enum VTextFieldClearButtonAction {
    /// Clear text.
    case clear
    
    /// Custom action.
    case custom(_ action: () -> Void)
    
    /// Clear text and custom action.
    case clearAndCustom(_ action: () -> Void)
    
    /// Default value. Set to `clear`.
    public static var `default`: Self { .clear }
}

/// Enum that describes action performed when pressing `cancel` button.
public enum VTextFieldCancelButtonAction {
    /// Clear text.
    case clear
    
    /// Custom action.
    case custom(_ action: () -> Void)
    
    /// Clear text and custom action.
    case clearAndCustom(_ action: () -> Void)
    
    /// Default value. Set to `clear`.
    public static var `default`: Self { .clear }
}
