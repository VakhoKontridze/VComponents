//
//  VSecondaryButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK: - V Secondary Button State
/// Enum that describes state, such as `enabled` or `disabled`
public enum VSecondaryButtonState: Int, CaseIterable {
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

// MARK: - V Secondary Button Internal State
enum VSecondaryButtonInternalState {
    case enabled
    case pressed
    case disabled
    
    init(state: VSecondaryButtonState, isPressed: Bool) {
        switch (state, isPressed) {
        case (.enabled, false): self = .enabled
        case (.enabled, true): self = .pressed
        case (.disabled, _): self = .disabled
        }
    }
}
