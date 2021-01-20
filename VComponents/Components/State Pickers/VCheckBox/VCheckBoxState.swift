//
//  VCheckBoxState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK:- V Toggle State
/// Enum that describes state, such as off, on, intermediate, or disabled
public enum VCheckBoxState: Int, CaseIterable {
    case off
    case on
    case intermediate
    case disabled
    
    public var isOn: Bool {
        switch self {
        case .off: return false
        case .on: return true
        case .intermediate: return false
        case .disabled: return false
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .off: return true
        case .on: return true
        case .intermediate: return true
        case .disabled: return false
        }
    }
}

// MARK:- Next State
extension VCheckBoxState {
    public mutating func nextState() {
        switch self {
        case .off: self = .on
        case .on: self = .off
        case .intermediate: self = .on
        case .disabled: break
        }
    }
}

// MARK:- V Checkbox Internal State
enum VCheckBoxInternalState {
    case off
    case pressedOff
    case on
    case pressedOn
    case intermediate
    case pressedIntermediate
    case disabled
    
    init(state: VCheckBoxState, isPressed: Bool) {
        switch (state, isPressed) {
        case (.off, false): self = .off
        case (.off, true): self = .pressedOff
        case (.on, false): self = .on
        case (.on, true): self = .pressedOn
        case (.intermediate, false): self = .intermediate
        case (.intermediate, true): self = .pressedIntermediate
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
extension Binding where Value == VCheckBoxState {
    public init(bool: Binding<Bool>) {
        self.init(
            get: { bool.wrappedValue ? .on : .off },
            set: { bool.wrappedValue = $0.isOn }
        )
    }
}
