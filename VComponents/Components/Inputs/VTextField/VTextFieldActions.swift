//
//  VTextFieldActions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/20/21.
//

import Foundation

// MAR:- V Text Field Actins
/// Enum that describes action performed when pressing return button
public typealias VTextFieldReturnButtonAction = VBaseTextFieldReturnButtonAction

/// Enum that describes action performed when pressing clear button
public enum VTextFieldClearButtonAction {
    case clear
    case custom(_ action: () -> Void)
    case clearAndCustom(_ action: () -> Void)
    
    public static let `default`: Self = .clear
}

/// Enum that describes action performed when pressing cancel button
public enum VTextFieldCancelButtonAction {
    case clear
    case custom(_ action: () -> Void)
    case clearAndCustom(_ action: () -> Void)
    
    public static let `default`: Self = .clear
}
