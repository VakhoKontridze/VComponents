//
//  VCircularButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Circular Button State
public enum VCircularButtonState: Int, CaseIterable {
    case enabled
    case disabled
    
    var isDisabled: Bool {
        switch self {
        case .enabled: return false
        case .disabled: return true
        }
    }
}

// MARK:- V Circular Button Internal State
enum VCircularButtonInternalState {
    case enabled
    case pressed
    case disabled
    
    init(state: VCircularButtonState, isPressed: Bool) {
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
