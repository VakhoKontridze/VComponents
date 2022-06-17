//
//  VCheckBoxState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK: - V Toggle State
/// Enum that describes state, such as `off`, `on`, or `indeterminate`,
public enum VCheckBoxState: Int, CaseIterable {
    // MARK: Cases
    /// Of.
    case off
    
    /// On.
    case on
    
    /// indeterminate.
    ///
    /// Upon press, component goes to `on` state.
    case indeterminate
    
    // MARK: Properties
    /// Indicates if state is on.
    public var isOn: Bool {
        switch self {
        case .off: return false
        case .on: return true
        case .indeterminate: return false
        }
    }
    
    // MARK: Initializers
    /// Initializes state with `Bool`.
    public init(isOn: Bool) {
        switch isOn {
        case false: self = .off
        case true: self = .on
        }
    }

    // MARK: Next State
    /// Goes to the next state.
    public mutating func setNextState() {
        switch self {
        case .off: self = .on
        case .on: self = .off
        case .indeterminate: self = .on
        }
    }
}

// MARK: Binding Init
extension Binding where Value == VCheckBoxState {
    /// Initializes state with `Bool`.
    public init(bool: Binding<Bool>) {
        self.init(
            get: { .init(isOn: bool.wrappedValue) },
            set: { bool.wrappedValue = $0.isOn }
        )
    }
}

// MARK: - V Checkbox Internal State
typealias VCheckBoxInternalState = GenericState_OOIPD
