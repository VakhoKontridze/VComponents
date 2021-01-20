//
//  VBaseTextFieldState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import Foundation

// MARK:- V Base Text Field State
/// State that describes state, such as enabled, focused, or disabled
public enum VBaseTextFieldState: Int, CaseIterable {
    case enabled
    case focused
    case disabled
    
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .focused: return true
        case .disabled: return false
        }
    }
    
    var isFocused: Bool {
        switch self {
        case .enabled: return false
        case .focused: return true
        case .disabled: return false
        }
    }
    
    mutating func setFocus(from state: Bool) {
        guard isFocused != state else { return }
        
        switch state {
        case false: self = .enabled
        case true: self = .focused
        }
    }
}
