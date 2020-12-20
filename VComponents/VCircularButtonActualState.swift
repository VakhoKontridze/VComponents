//
//  VCircularButtonActualState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 20.12.20.
//

import SwiftUI

// MARK:- V Rounded Button Actual State
enum VRoundedButtonActualState {
    case enabled
    case pressed
    case disabled
}

// MARK:- Mapping
extension VCircularButtonState {
    func actualState(configuration: ButtonStyleConfiguration) -> VRoundedButtonActualState {
        if configuration.isPressed && isEnabled {
            return .pressed
        } else {
            switch self {
            case .enabled: return .enabled
            case .disabled: return .disabled
            }
        }
    }
}
