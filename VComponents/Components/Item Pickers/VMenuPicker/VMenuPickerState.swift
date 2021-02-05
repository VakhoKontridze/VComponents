//
//  VMenuPickerState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import Foundation

// MARK:- V Menu Picker State
/// Enum that describes state, such as enabled or disabled
public enum VMenuPickerState: Int, CaseIterable {
    case enabled
    case disabled
    
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}
