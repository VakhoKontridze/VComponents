//
//  VPlainButtonActualState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 20.12.20.
//

import SwiftUI

// MARK:- V Plain Button Actual State
enum VPlainButtonActualState {
    case enabled
    case pressed
    case disabled
}

// MARK:- Mapping
extension VPlainButtonState {
    func actualState(configuration: ButtonStyleConfiguration) -> VPlainButtonActualState {
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

