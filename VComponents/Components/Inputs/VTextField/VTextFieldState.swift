//
//  VTextFieldState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import Foundation

// MARK:- V Text Field State
/// State that describes state, such as enabled, focused, or disabled
public typealias VTextFieldState = VBaseTextFieldState

// MARK:- Helpers
extension VTextFieldState {
    var clearButtonState: VCloseButtonState {
        switch self {
        case .enabled: return .enabled
        case .focused: return .enabled
        case .disabled: return .disabled
        }
    }
    
    var cancelButtonState: VPlainButtonState {
        switch self {
        case .enabled: return .enabled
        case .focused: return .enabled
        case .disabled: return .disabled
        }
    }
}
