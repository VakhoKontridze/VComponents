//
//  VTogglState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Toggle State
public enum VToggleState: Int, CaseIterable {
    case enabled
    case disabled
    
    var isDisabled: Bool {
        switch self {
        case .enabled: return false
        case .disabled: return true
        }
    }
}

// MARK:- V Toggle Internal State
enum VToggleInternalState {
    case enabled
    case pressed
    case disabled
    
    init(state: VToggleState, isPressed: Bool) {
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
