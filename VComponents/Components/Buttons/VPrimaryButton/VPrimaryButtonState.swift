//
//  VPrimaryButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK: - V Primary Button State
/// Enum that describes state, such as `enabled`, `disabled`, or `loading`.
public enum VPrimaryButtonState: Int, CaseIterable {
    // MARK: Cases
    /// Enabled.
    case enabled
    
    /// Disabled.
    case disabled
    
    /// Loading.
    ///
    /// Unique state during which spinner appears.
    case loading

    // MARK: Properties
    /// Indicates if state is enabled.
    public var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        case .loading: return false
        }
    }
}

// MARK: - V Primary Button Internal State
enum VPrimaryButtonInternalState {
    // MARK: Cases
    case enabled
    case pressed
    case disabled
    case loading
    
    // MARK: Properties
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .pressed: return true
        case .disabled: return false
        case .loading: return false
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .enabled: return false
        case .pressed: return false
        case .disabled: return false
        case .loading: return true
        }
    }
    
    // MARK: Initializers
    init(state: VPrimaryButtonState, isPressed: Bool) {
        switch (state, isPressed) {
        case (.enabled, false): self = .enabled
        case (.enabled, true): self = .pressed
        case (.disabled, _): self = .disabled
        case (.loading, _): self = .loading
        }
    }
}
