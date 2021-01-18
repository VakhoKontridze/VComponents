//
//  VNavigationLinkState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/16/21.
//

import Foundation

// MARK:- V Navigation Link State
/// Enum that describes state, such as enabled or disabled
public enum VNavigationLinkState: Int, CaseIterable {
    case enabled
    case disabled
    
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}
