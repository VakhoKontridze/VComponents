//
//  VSegmentedPickerState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import Foundation

// MARK: - V Segmented Picker State
/// Enum that describes state, such as `enabled` or `disabled`
public enum VSegmentedPickerState: Int, CaseIterable {
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

// MARK: - V Segmented Picker Row State
enum VSegmentedPickerRowState {
    // MARK: Cases
    case enabled
    case pressed
    case disabled
    
    // MARK: Properties
    init(isEnabled: Bool, isPressed: Bool) {
        if isPressed && isEnabled {
            self = .pressed
        } else {
            switch isEnabled {
            case true: self = .enabled
            case false: self = .disabled
            }
        }
    }
}
