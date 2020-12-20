//
//  VPrimaryButtonActualState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 20.12.20.
//

import SwiftUI

// MARK:- V Primary Button Actual State
enum VPrimaryButtonActualState {
    case enabled
    case pressed
    case disabled
    case loading
}

// MARK:- Mapping
extension VPrimaryButtonState {
    func actualState(configuration: ButtonStyleConfiguration) -> VPrimaryButtonActualState {
        if configuration.isPressed && isEnabled {
            return .pressed
        } else {
            switch self {
            case .enabled: return .enabled
            case .disabled: return .disabled
            case .loading: return .loading
            }
        }
    }
}
