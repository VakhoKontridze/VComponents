//
//  GenericStateAndModel_OOIPD.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/1/22.
//

import SwiftUI

// MARK: - Generic State (Off, On, Indeterminate, Pressed, Disabled)
enum GenericState_OOIPD {
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
    init(isEnabled: Bool, state: VCheckBoxState, isPressed: Bool) {
        switch (isEnabled, state, isPressed) {
        case (false, _, _): self = .disabled
        case (true, .off, false): self = .off
        case (true, .off, true): self = .pressedOff
        case (true, .on, false): self = .on
        case (true, .on, true): self = .pressedOn
        case (true, .indeterminate, false): self = .indeterminate
        case (true, .indeterminate, true): self = .pressedIndeterminate
        }
    }
    
    // MARK: Next State
    mutating func setNextState() {
        switch self {
        case .off, .pressedOff: self = .on
        case .on, .pressedOn: self = .off
        case .indeterminate, .pressedIndeterminate: self = .on
        case .disabled: break
        }
    }
}

// MARK: - Generic State Model (Off, On, Pressed, Indeterminate, Disabled)
/// Color group containing `off`, `on`, and `disabled` values.
public struct GenericStateModel_OOIPD<Value> {
    // MARK: Properties
    /// Off value.
    public var off: Value
    
    /// On value.
    public var on: Value
    
    /// Indeterminate value.
    public var indeterminate: Value
    
    /// Off pressed value.
    public var pressedOff: Value
    
    /// On pressed value.
    public var pressedOn: Value
    
    /// Indeterminate pressed value.
    public var pressedIndeterminate: Value
    
    /// Disabled value.
    public var disabled: Value
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        off: Value,
        on: Value,
        indeterminate: Value,
        pressedOff: Value,
        pressedOn: Value,
        pressedIndeterminate: Value,
        disabled: Value
    ) {
        self.off = off
        self.on = on
        self.indeterminate = indeterminate
        self.pressedOff = pressedOff
        self.pressedOn = pressedOn
        self.pressedIndeterminate = pressedIndeterminate
        self.disabled = disabled
    }
}

extension GenericStateModel_OOIPD: Equatable where Value: Equatable {}

// MARK: - Mapping
extension GenericStateModel_OOIPD {
    func `for`(_ state: GenericState_OOIPD) -> Value {
        switch state {
        case .off: return off
        case .on: return on
        case .indeterminate: return indeterminate
        case .pressedOff: return pressedOff
        case .pressedOn: return pressedOn
        case .pressedIndeterminate: return pressedIndeterminate
        case .disabled: return disabled
        }
    }
}
