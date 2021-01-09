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
    case off
    case on
    case pressedOff
    case pressedOn
    case disabled
    
    init(state: VToggleState, isOn: Bool, isPressed: Bool) {
        if isPressed && !state.isDisabled {
            switch isOn {
            case false: self = .pressedOff
            case true: self = .pressedOn
            }
        } else {
            switch (state, isOn) {
            case (.enabled, false): self = .off
            case (.enabled, true): self = .on
            case (.disabled, _): self = .disabled
            }
        }
    }
}
