//
//  VPrimaryButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Primary Button State
public enum VPrimaryButtonState: Int, CaseIterable {
    case enabled
    case disabled
    case loading
    
    var isDisabled: Bool {
        switch self {
        case .enabled: return false
        case .disabled: return true
        case .loading: return true
        }
    }
}
