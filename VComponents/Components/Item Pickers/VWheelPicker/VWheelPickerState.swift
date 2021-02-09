//
//  VWheelPickerState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import Foundation

// MARK:- V Wheel Picker State
/// Enum that describes state, such as enabled or disabled
public enum VWheelPickerState: Int, CaseIterable {
    /// Case enabled
    case enabled
    
    /// Case disabled
    case disabled
    
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}
