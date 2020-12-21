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
    
    var isLoading: Bool {
        switch self {
        case .enabled: return false
        case .pressed: return false
        case .disabled: return false
        case .loading: return true
        }
    }
}

// MARK:- Mapping
extension VPrimaryButtonState {
    func actualState(isPressed: Bool) -> VPrimaryButtonActualState {
        if isPressed && !isDisabled {
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
