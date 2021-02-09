//
//  VLinkState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import Foundation

// MARK:- V Link State
/// Enum that describes state, such as `enabled` or `disabled`
public enum VLinkState: Int, CaseIterable {
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
