//
//  VCircularButtonActualState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 20.12.20.
//

import SwiftUI

// MARK:- V Circular Button Actual State
enum VCircularButtonActualState {
    case enabled
    case pressed
    case disabled
}

// MARK:- Mapping
extension VCircularButtonState {
    func actualState(isPressed: Bool) -> VCircularButtonActualState {
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
