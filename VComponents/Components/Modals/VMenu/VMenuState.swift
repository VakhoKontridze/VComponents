//
//  VMenuState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import Foundation

// MARK: - V Menu State
/// Enum that describes state, such as `enabled` or `disabled`
public enum VMenuState: Int, CaseIterable {
    /// Enabled
    case enabled
    
    /// Disabled
    case disabled
    
    /// Indicates is state is enabled
    public var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}
