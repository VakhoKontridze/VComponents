//
//  VPrimaryButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Primary Button State
public enum VPrimaryButtonState: CaseIterable {
    case enabled
    case disabled
    case loading
    
    var shouldBeEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        case .loading: return false
        }
    }
}
