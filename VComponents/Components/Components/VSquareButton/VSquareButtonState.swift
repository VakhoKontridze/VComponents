//
//  VSquareButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation

// MARK:- V Square Button State
public enum VSquareButtonState: Int, CaseIterable {
    case enabled
    case disabled
    
    var isDisabled: Bool {
        switch self {
        case .enabled: return false
        case .disabled: return true
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
