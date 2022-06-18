//
//  GenericStateAndModel_EDF.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/10/22.
//

import SwiftUI
import VCore

// MARK: - Generic State (Enabled, Disabled, Focused)
enum GenericState_EDF {
    // MARK: Cases
    case enabled
    case disabled
    case focused
    
    // MARK: Properties
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        case .focused: return true
        }
    }
    
    // MARK: Initializers
    init(isEnabled: Bool, isFocused: Bool) {
        switch (isEnabled, isFocused) {
        case (false, _): self = .disabled
        case (true, false): self = .enabled
        case (true, true): self = .focused
        }
    }
}

// MARK: - Generic State Model (Enabled, Disabled)
/// Value group containing enabled, disabled, and focused values.
public struct GenericStateModel_EDF<Value> {
    // MARK: Properties
    /// Enabled value.
    public var enabled: Value
    
    /// Disabled value.
    public var disabled: Value
    
    /// Focused value.
    public var focused: Value
    
    // MARK: Initializers
    /// Initializes model with values.
    public init(
        enabled: Value,
        disabled: Value,
        focused: Value
    ) {
        self.enabled = enabled
        self.disabled = disabled
        self.focused = focused
    }
    
    /// Initializes model with clear `Color` values.
    public static var clear: GenericStateModel_EDF<Color> {
        .init(
            enabled: .clear,
            disabled: .clear,
            focused: .clear
        )
    }
}

// MARK: Hashable, Equatable, Comparable
extension GenericStateModel_EDF: Hashable where Value: Hashable {}

extension GenericStateModel_EDF: Equatable where Value: Equatable {}

extension GenericStateModel_EDF: Comparable where Value: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        isLess(lhs, than: rhs, by: \.enabled, \.disabled, \.focused)
    }
}

// MARK: - Mapping
extension GenericStateModel_EDF {
    func `for`(_ state: GenericState_EDF) -> Value {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        case .focused: return focused
        }
    }
}
