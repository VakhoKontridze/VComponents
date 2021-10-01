//
//  VBaseButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import Foundation

// MARK: - V Base Text Field State
/// Enum that describes state, such as `enabled` or `disabled`.
public enum VBaseButtonState: Int, CaseIterable {
    // MARK: Cases
    /// Case enabled.
    case enabled
    
    /// Case disabled.
    case disabled
    
    // MARK: Properties
    /// Indicates if state is enabled.
    public var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
    
    // MARK: Initializers
    init(isEnabled: Bool) {
        switch isEnabled {
        case false: self = .disabled
        case true: self = .enabled
        }
    }
}
