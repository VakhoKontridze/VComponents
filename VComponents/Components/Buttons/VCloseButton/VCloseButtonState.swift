//
//  VCloseButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import Foundation

// MARK:- V Close Button State
/// Enum that describes state, such as enabled or disabled
public enum VCloseButtonState: Int, CaseIterable {
    /// Enabled
    case enabled
    
    /// Disabled
    case disabled
    
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}

// MARK:- V Close Button Internal State
enum VCloseButtonInternalState {
    case enabled
    case pressed
    case disabled
    
    init(state: VCloseButtonState, isPressed: Bool) {
        switch (state, isPressed) {
        case (.enabled, false): self = .enabled
        case (.enabled, true): self = .pressed
        case (.disabled, _): self = .disabled
        }
    }
}
