//
//  VBaseTextFieldState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Base Text Field State
/// Enum that describes state, such as `enabled`, `focused`, or `disabled`.
public enum VBaseTextFieldState: Int, CaseIterable {
    // MARK: Cases
    /// Case enabled.
    case enabled
    
    /// Case focused.
    case focused
    
    /// Case disabled.
    case disabled
    
    // MARK: Properties
    /// Indicates if state is enabled.
    public var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .focused: return true
        case .disabled: return false
        }
    }
    
    var isFocused: Bool {
        switch self {
        case .enabled: return false
        case .focused: return true
        case .disabled: return false
        }
    }

    // MARK: Next State
    mutating func setFocus(from state: Bool) {
        switch state {
        case false: self = .enabled
        case true: self = .focused
        }
    }
}

// MARK: - Mapping
extension StateColorsAndOpacities_EP_D {
    func `for`(_ state: VBaseTextFieldState) -> Color {
        switch state {
        case .enabled: return enabled
        case .focused: return enabled
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VBaseTextFieldState) -> Double {
        switch state {
        case .enabled: return 1
        case .focused: return 1
        case .disabled: return disabledOpacity
        }
    }
}
