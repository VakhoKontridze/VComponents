//
//  VBaseButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import Foundation

// MARK:- V Base Text Field State
/// State that describes state, such as enabled or disabled
public enum VBaseButtonState: Int, CaseIterable {
    case enabled
    case disabled
    
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
    
    init(isEnabled: Bool) {
        switch isEnabled {
        case false: self = .disabled
        case true: self = .enabled
        }
    }
}
