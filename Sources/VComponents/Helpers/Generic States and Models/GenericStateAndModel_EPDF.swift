//
//  GenericStateAndModel_EPDF.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/10/22.
//

import SwiftUI

// MARK: - Generic State (Enabled, Pressed, Disabled, Focused)
enum GenericState_EPDF {
    // MARK: Cases
    case enabled
    case pressed
    case disabled
    case focused
    
    // MARK: Properties
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .pressed: return true
        case .disabled: return false
        case .focused: return false
        }
    }
    
    var isFocused: Bool {
        switch self {
        case .enabled: return false
        case .pressed: return false
        case .disabled: return false
        case .focused: return true
        }
    }
    
    // MARK: Initializers
    init(isEnabled: Bool, isPressed: Bool, isFocused: Bool) {
        switch (isEnabled, isPressed, isFocused) {
        case (false, _, _): self = .disabled
        case (true, false, false): self = .enabled
        case (true, true, false): self = .pressed
        case (true, _, true): self = .focused
        }
    }
}

// MARK: - Generic State Model (Enabled, Pressed, Disabled, Focused)
/// Value group containing enabled, pressed, disabled, and focused values.
public struct GenericStateModel_EPDF<Value> {
    // MARK: Properties
    /// Enabled value.
    public var enabled: Value
    
    /// Pressed value.
    public var pressed: Value
    
    /// Disabled value.
    public var disabled: Value
    
    /// Focused value.
    public var focused: Value
    
    // MARK: Initializers
    /// Initializes model with values.
    public init(
        enabled: Value,
        pressed: Value,
        disabled: Value,
        focused: Value
    ) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
        self.focused = focused
    }
    
    /// Initializes model with clear `Color` values.
    public static var clear: GenericStateModel_EPDF<Color> {
        .init(
            enabled: .clear,
            pressed: .clear,
            disabled: .clear,
            focused: .clear
        )
    }
}

// MARK: Hashable, Equatable, Comparable
extension GenericStateModel_EPDF: Hashable where Value: Hashable {}

extension GenericStateModel_EPDF: Equatable where Value: Equatable {}

extension GenericStateModel_EPDF: Comparable where Value: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs.enabled, lhs.pressed, lhs.disabled, lhs.focused) < (rhs.enabled, rhs.pressed, rhs.disabled, rhs.focused)
    }
}

// MARK: - Mapping
extension GenericStateModel_EPDF {
    func `for`(_ state: GenericState_EPDF) -> Value {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        case .focused: return focused
        }
    }
}
