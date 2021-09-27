//
//  VCloseButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import Foundation

// MARK: - V Close Button State
/// Enum that describes state, such as `enabled` or `disabled`
public enum VCloseButtonState: Int, CaseIterable {
    // MARK: Cases
    /// Enabled
    case enabled
    
    /// Disabled
    case disabled
    
    // MARK: Properties
    /// Indicates if state is enabled
    public var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}

// MARK: - V Close Button Internal State
enum VCloseButtonInternalState {
    // MARK: Cases
    case enabled
    case pressed
    case disabled
    
    // MARK: Initializers
    init(state: VCloseButtonState, isPressed: Bool) {
        switch (state, isPressed) {
        case (.enabled, false): self = .enabled
        case (.enabled, true): self = .pressed
        case (.disabled, _): self = .disabled
        }
    }
}
