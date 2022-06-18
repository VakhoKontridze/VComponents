//
//  GenericStateAndModel_ED.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/3/22.
//

import SwiftUI
import VCore

// MARK: - Generic State (Enabled, Disabled)
enum GenericState_ED {
    // MARK: Cases
    case enabled
    case disabled
    
    // MARK: Properties
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
    
    // MARK: Initializers
    init(isEnabled: Bool) {
        switch isEnabled {
        case false: self = .disabled
        case true: self = .enabled
        }
    }
}

// MARK: - Generic State Model (Enabled, Disabled)
/// Value group containing enabled and disabled values.
public struct GenericStateModel_ED<Value> {
    // MARK: Properties
    /// Enabled value.
    public var enabled: Value
    
    /// Disabled value.
    public var disabled: Value
    
    // MARK: Initializers
    /// Initializes model with values.
    public init(
        enabled: Value,
        disabled: Value
    ) {
        self.enabled = enabled
        self.disabled = disabled
    }
    
    /// Initializes model with clear `Color` values.
    public static var clear: GenericStateModel_ED<Color> {
        .init(
            enabled: .clear,
            disabled: .clear
        )
    }
    
    init(_ model: GenericStateModel_EPD<Value>) {
        self.enabled = model.enabled
        self.disabled = model.disabled
    }
}

// MARK: Hashable, Equatable, Comparable
extension GenericStateModel_ED: Hashable where Value: Hashable {}

extension GenericStateModel_ED: Equatable where Value: Equatable {}

extension GenericStateModel_ED: Comparable where Value: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        isLess(lhs, than: rhs, by: \.enabled, \.disabled)
    }
}

// MARK: - Mapping
extension GenericStateModel_ED {
    func `for`(_ state: GenericState_ED) -> Value {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        }
    }
}
