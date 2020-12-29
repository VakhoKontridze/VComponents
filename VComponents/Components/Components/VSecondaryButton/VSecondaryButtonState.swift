//
//  VSecondaryButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Secondary Button Type
public enum VSecondaryButtonState: Int, CaseIterable {
    case enabled
    case disabled
    
    var isDisabled: Bool {
        switch self {
        case .enabled: return false
        case .disabled: return true
        }
    }
}

// MARK:- V Secondary Button Internal State
enum VSecondaryButtonInternalState {
    case enabled
    case pressed
    case disabled
    
    init(state: VSecondaryButtonState, isPressed: Bool) {
        if isPressed && !state.isDisabled {
            self = .pressed
        } else {
            switch state {
            case .enabled: self = .enabled
            case .disabled: self = .disabled
            }
        }
    }
}
