//
//  VSliderState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK: - V Slider State
/// Enum that describes state, such as `enabled` or `disabled`
public enum VSliderState: Int, CaseIterable {
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
