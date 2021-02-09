//
//  VStepperState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import Foundation

// MARK:- V Stepper State
/// Enum that describes state, such as enabled or disabled
public enum VStepperState: Int, CaseIterable {
    /// Case enabled
    case enabled
    
    /// Case disabled
    case disabled
    
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}

// MARK:- V Stepper Button State
enum VStepperButtonState {
    case enabled
    case pressed
    case disabled
    
    init(isEnabled: Bool, isPressed: Bool) {
        if isPressed && isEnabled {
            self = .pressed
        } else {
            switch isEnabled {
            case true: self = .enabled
            case false: self = .disabled
            }
        }
    }
}
