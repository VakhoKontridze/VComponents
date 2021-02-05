//
//  VRangeSliderState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import Foundation

// MARK:- V Range Slider State
/// Enum that describes state, such as enabled or disabled
public enum VRangeSliderState: Int, CaseIterable {
    case enabled
    case disabled
    
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}
