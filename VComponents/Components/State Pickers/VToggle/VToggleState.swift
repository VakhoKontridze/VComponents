//
//  VTogglState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Toggle State
/// Enum that describes state, such as `off`, `on`, or `disabled`.
public enum VToggleState: Int, CaseIterable {
    // MARK: Cases
    /// Off.
    case off
    
    /// On.
    case on
    
    /// Disabled.
    case disabled
    
    // MARK: Properties
    /// Indicates if state is enabled.
    public var isEnabled: Bool {
        switch self {
        case .off: return true
        case .on: return true
        case .disabled: return false
        }
    }
    
    /// Indicates if state is on.
    public var isOn: Bool {
        switch self {
        case .off: return false
        case .on: return true
        case .disabled: return false
        }
    }

    // MARK: Next State
    /// Goes to the next state.
    public mutating func nextState() {
        switch self {
        case .off: self = .on
        case .on: self = .off
        case .disabled: break
        }
    }
}

// MARK: - V Toggle Internal State
enum VToggleInternalState {
    // MARK: Cases
    case off
    case pressedOff
    case on
    case pressedOn
    case disabled
    
    // MARK: Initializers
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

// MARK: - Helpers
extension Binding where Value == VToggleState {
    /// Initializes state with bool
    public init(bool: Binding<Bool>) {
        self.init(
            get: { bool.wrappedValue ? .on : .off },
            set: { bool.wrappedValue = $0.isOn }
        )
    }
}
