//
//  VButtonState.swift
//  Components
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Button State
public enum VButtonState {
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
