//
//  VPlainButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Plain Button State
public enum VPlainButtonState: CaseIterable {
    case enabled
    case disabled
    
    var shouldBeEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}
