//
//  VRadioButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Radio Button State
/// Enum that represents state, such as `off` or `on`.
public enum VRadioButtonState: Int, CaseIterable {
    // MARK: Cases
    /// Off.
    case off
    
    /// On.
    case on
    
    // MARK: Properties
    /// Indicates if state is on.
    public var isOn: Bool {
        switch self {
        case .off: return false
        case .on: return true
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
        case .on: break
        }
    }
}

// MARK: Binding Init
extension Binding where Value == VRadioButtonState {
    /// Initializes state with `Bool`.
    public init(bool: Binding<Bool>) {
        self.init(
            get: { .init(isOn: bool.wrappedValue) },
            set: { bool.wrappedValue = $0.isOn }
        )
    }
}

// MARK: - V Radio Button Internal State
typealias VRadioButtonInternalState = GenericState_OOPD
