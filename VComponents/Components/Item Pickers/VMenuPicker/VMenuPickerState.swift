//
//  VMenuPickerState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import Foundation

// MARK: - V Menu Picker State
/// Enum that describes state, such as `enabled` or `disabled`
public enum VMenuPickerState: Int, CaseIterable {
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
