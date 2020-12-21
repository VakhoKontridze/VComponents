//
//  VToggleActualState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import Foundation

// MARK:- V Toggle Actual State
enum VToggleActualState {
    case enabled
    case pressed
    case disabled
}

// MARK:- Mapping
extension VToggleState {
    func actualState(isPressed: Bool) -> VToggleActualState {
        if isPressed && !isDisabled {
            return .pressed
        } else {
            switch self {
            case .enabled: return .enabled
            case .disabled: return .disabled
            }
        }
    }
}
