//
//  VBaseTextFieldActions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/20/21.
//

import Foundation

// MARK:- V Base Text Field Actions
/// Enum that represents action performed when pressing return button
public enum VBaseTextFieldReturnButtonAction {
    case `return`
    case custom(_ action: () -> Void)
    case returnAndCustom(_ action: () -> Void)
    
    public static let `default`: Self = .return
}
