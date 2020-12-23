//
//  VPlainButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Plain Button State
public enum VPlainButtonState: Int, CaseIterable {
    case enabled
    case disabled
    
    var isDisabled: Bool {
        switch self {
        case .enabled: return false
        case .disabled: return true
        }
    }
}

// MARK:- V Plain Button Internal State
enum VPlainButtonInternalState {
    case enabled
    case pressed
    case disabled
    
    init(state: VPlainButtonState, isPressed: Bool) {
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
