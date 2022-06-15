//
//  GenericStateAndModel_EPD.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - Generic State (Enabled, Pressed, Disabled)
enum GenericState_EPD {
    // MARK: Cases
    case enabled
    case pressed
    case disabled
    
    // MARK: Properties
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .pressed: return true
        case .disabled: return false
        }
    }
    
    // MARK: Initializers
    init(isEnabled: Bool, isPressed: Bool) {
        switch (isEnabled, isPressed) {
        case (false, _): self = .disabled
        case (true, false): self = .enabled
        case (true, true): self = .pressed
        }
    }
}

// MARK: - Generic State Model (Enabled, Pressed, Disabled)
/// Value group containing enabled, pressed, and disabled values.
public struct GenericStateModel_EPD<Value> {
    // MARK: Properties
    /// Enabled value.
    public var enabled: Value
    
    /// Pressed value.
    public var pressed: Value
    
    /// Disabled value.
    public var disabled: Value
    
    // MARK: Initializers
    /// Initializes model with values.
    public init(
        enabled: Value,
        pressed: Value,
        disabled: Value
    ) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
    }
    
    /// Initializes model with clear `Color` values.
    public static var clear: GenericStateModel_EPD<Color> {
        .init(
            enabled: .clear,
            pressed: .clear,
            disabled: .clear
        )
    }
    
    init(_ model: GenericStateModel_EPDL<Value>) {
        self.enabled = model.enabled
        self.pressed = model.pressed
        self.disabled = model.disabled
    }
    
    init(_ model: GenericStateModel_EPDF<Value>) {
        self.enabled = model.enabled
        self.pressed = model.pressed
        self.disabled = model.disabled
    }
}

// MARK: - Hashable, Equatable, Comparable
extension GenericStateModel_EPD: Hashable where Value: Hashable {}

extension GenericStateModel_EPD: Equatable where Value: Equatable {}

extension GenericStateModel_EPD: Comparable where Value: Comparable {
    public static func < (lhs: GenericStateModel_EPD<Value>, rhs: GenericStateModel_EPD<Value>) -> Bool {
        (lhs.enabled, lhs.pressed, lhs.disabled) < (rhs.enabled, rhs.pressed, rhs.disabled)
    }
}

// MARK: - Mapping
extension GenericStateModel_EPD {
    func `for`(_ state: GenericState_EPD) -> Value {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
}
