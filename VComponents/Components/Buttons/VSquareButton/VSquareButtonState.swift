//
//  VSquareButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Square Button State
/// Enum that describes state, such as enabled or disabled
public enum VSquareButtonState: Int, CaseIterable {
    case enabled
    case disabled
    
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}

// MARK:- V Square Button Internal State
enum VSquareButtonInternalState {
    case enabled
    case pressed
    case disabled
    
    init(state: VSquareButtonState, isPressed: Bool) {
        switch (state, isPressed) {
        case (.enabled, false): self = .enabled
        case (.enabled, true): self = .pressed
        case (.disabled, _): self = .disabled
        }
    }
}
