//
//  VPlainButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Plain Button State
/// Enum that describes state, such as `enabled` or `disabled`
public enum VPlainButtonState: Int, CaseIterable {
    /// Enabled
    case enabled
    
    /// Disabled
    case disabled
    
    /// Indicates if state is enabled
    public var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}

// MARK:- V Plain Button Internal State
enum VPlainButtonInternalState {
    case enabled
    case pressed
    case disabled
    
    init(state: VPlainButtonState, isPressed: Bool) {
        switch (state, isPressed) {
        case (.enabled, false): self = .enabled
        case (.enabled, true): self = .pressed
        case (.disabled, _): self = .disabled
        }
    }
}
