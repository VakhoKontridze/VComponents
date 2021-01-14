//
//  VTogglState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Toggle State
/// State that describes state, such as off, on, or disabled
public enum VToggleState: Int, CaseIterable {
    case off
    case on
    case disabled
    
    public var isOn: Bool {
        switch self {
        case .off: return false
        case .on: return true
        case .disabled: return false
        }
    }
    
    public mutating func nextState() {
        switch self {
        case .off: self = .on
        case .on: self = .off
        case .disabled: break
        }
    }
    
    var isDisabled: Bool {
        switch self {
        case .off: return false
        case .on: return false
        case .disabled: return true
        }
    }
}

// MARK:- V Toggle Internal State
enum VToggleInternalState {
    case off
    case on
    case pressedOff
    case pressedOn
    case disabled
    
    init(state: VToggleState, isPressed: Bool) {
        switch (state, isPressed) {
        case (.off, false): self = .off
        case (.off, true): self = .pressedOff
        case (.on, false): self = .on
        case (.on, true): self = .pressedOn
        case (.disabled, _): self = .disabled
        }
    }
    
    init(bool state: Bool, isPressed: Bool) {
        switch (state, isPressed) {
        case (false, false): self = .off
        case (false, true): self = .pressedOff
        case (true, false): self = .on
        case (true, true): self = .pressedOn
        }
    }
}

// MARK:- Helpers
public extension Binding where Value == VToggleState {
    init(bool: Binding<Bool>) {
        self.init(
            get: { bool.wrappedValue ? .on : .off },
            set: { bool.wrappedValue = $0.isOn }
        )
    }
}
