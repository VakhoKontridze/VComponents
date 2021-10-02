//
//  VTextFieldState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Text Field State
/// Enum that describes state, such as `enabled`, `focused`, or `disabled`.
public enum VTextFieldState: Int, CaseIterable {
    // MARK: Cases
    /// Enabled.
    case enabled
    
    /// Focused.
    case focused
    
    /// Disabled.
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

    // MARK: Helpers
    static func baseTextFieldState(_ state: Binding<VTextFieldState>) -> Binding<VBaseTextFieldState> {
        .init(
            get: {
                switch state.wrappedValue {
                case .enabled: return .enabled
                case .focused: return .focused
                case .disabled: return .disabled
                }
            },
            set: { baseState in
                switch baseState {
                case .enabled: state.wrappedValue = .enabled
                case .focused: state.wrappedValue = .focused
                case .disabled: state.wrappedValue = .disabled
                }
            }
        )
    }
    
    var clearButtonState: VCloseButtonState {
        switch self {
        case .enabled: return .enabled
        case .focused: return .enabled
        case .disabled: return .disabled
        }
    }
    
    var visiblityButtonState: VSquareButtonState {
        switch self {
        case .enabled: return .enabled
        case .focused: return .enabled
        case .disabled: return .disabled
        }
    }
    
    var cancelButtonState: VPlainButtonState {
        switch self {
        case .enabled: return .enabled
        case .focused: return .enabled
        case .disabled: return .disabled
        }
    }
}
