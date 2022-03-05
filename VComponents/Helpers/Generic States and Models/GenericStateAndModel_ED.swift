//
//  GenericStateAndModel_ED.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/3/22.
//

import SwiftUI

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
    /// Initializes group with values.
    public init(
        enabled: Value,
        disabled: Value
    ) {
        self.enabled = enabled
        self.disabled = disabled
    }
}

extension GenericStateModel_ED: Equatable where Value: Equatable {}

// MARK: - Mapping
extension GenericStateModel_ED {
    func `for`(_ state: GenericState_ED) -> Value {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        }
    }
}
