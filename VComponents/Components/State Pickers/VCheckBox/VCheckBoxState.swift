//
//  VCheckBoxState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI



// MARK: - V Toggle State
/// Enum that describes state, such as `off`, `on`, `indeterminate`, or `disabled`.
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
    
    /// Disabled.
    case disabled
    
    // MARK: Properties
    /// Indicates if state is enabled.
    public var isEnabled: Bool {
        switch self {
        case .off: return true
        case .on: return true
        case .indeterminate: return true
        case .disabled: return false
        }
    }
    
    /// Indicates if state is on.
    public var isOn: Bool {
        switch self {
        case .off: return false
        case .on: return true
        case .indeterminate: return false
        case .disabled: return false
        }
    }

    // MARK: Next State
    /// Goes to the next state.
    public mutating func setNextState() {
        switch self {
        case .off: self = .on
        case .on: self = .off
        case .indeterminate: self = .on
        case .disabled: break
        }
    }
}

// MARK: - V Checkbox Internal State
enum VCheckBoxInternalState {
    // MARK: Cases
    case off
    case on
    case indeterminate
    case pressedOff
    case pressedOn
    case pressedIndeterminate
    case disabled
    
    // MARK: Properties
    var isEnabled: Bool {
        switch self {
        case .off: return true
        case .on: return true
        case .indeterminate: return true
        case .pressedOff: return true
        case .pressedOn: return true
        case .pressedIndeterminate: return true
        case .disabled: return false
        }
    }
    
    // MARK: Initializers
    init(state: VCheckBoxState, isPressed: Bool) {
        switch (state, isPressed) {
        case (.off, false): self = .off
        case (.off, true): self = .pressedOff
        case (.on, false): self = .on
        case (.on, true): self = .pressedOn
        case (.indeterminate, false): self = .indeterminate
        case (.indeterminate, true): self = .pressedIndeterminate
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

// MARK: - Mapping
extension StateColors_OOID {
    func `for`(_ state: VCheckBoxInternalState) -> Color {
        switch state {
        case .off: return off
        case .on: return on
        case .indeterminate: return indeterminate
        case .pressedOff: return off
        case .pressedOn: return on
        case .pressedIndeterminate: return indeterminate
        case .disabled: return disabled
        }
    }
}

extension StateOpacities_PD {
    func `for`(_ state: VCheckBoxInternalState) -> Double {
        switch state {
        case .off: return 1
        case .on: return 1
        case .indeterminate: return 1
        case .pressedOff: return pressedOpacity
        case .pressedOn: return pressedOpacity
        case .pressedIndeterminate: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}

// MARK: - Helpers
extension Binding where Value == VCheckBoxState {
    /// Initializes state with bool.
    public init(bool: Binding<Bool>) {
        self.init(
            get: { bool.wrappedValue ? .on : .off },
            set: { bool.wrappedValue = $0.isOn }
        )
    }
}
