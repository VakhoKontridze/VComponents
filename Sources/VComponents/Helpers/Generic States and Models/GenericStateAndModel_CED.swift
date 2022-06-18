//
//  GenericStateAndModel_CED.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/6/22.
//

import SwiftUI
import VCore

// MARK: - Generic State (Collapsed, Expanded, Disabled)
enum GenericState_CED {
    // MARK: Cases
    case collapsed
    case expanded
    case disabled
    
    // MARK: Properties
    var isEnabled: Bool {
        switch self {
        case .collapsed: return true
        case .expanded: return true
        case .disabled: return false
        }
    }
    
    var isExpanded: Bool {
        switch self {
        case .collapsed: return false
        case .expanded: return true
        case .disabled: return false
        }
    }
    
    // MARK: Initializers
    fileprivate init(isEnabled: Bool, isExpanded: Bool) {
        switch (isEnabled, isExpanded) {
        case (false, _): self = .disabled
        case (true, false): self = .collapsed
        case (true, true): self = .expanded
        }
    }
}

// MARK: Helper Inits
extension GenericState_CED {
    init(isEnabled: Bool, state: VDisclosureGroupState) {
        self.init(isEnabled: isEnabled, isExpanded: state.isExpanded)
    }
}

// MARK: - Generic State Model (Collapsed, Expanded, Disabled)
/// Value group containing collapsed, expanded, and disabled values.
public struct GenericStateModel_CED<Value> {
    // MARK: Properties
    /// Collapsed value.
    public var collapsed: Value
    
    /// Expanded value.
    public var expanded: Value
    
    /// Disabled value.
    public var disabled: Value
    
    // MARK: Initializers
    /// Initializes model with values.
    public init(
        collapsed: Value,
        expanded: Value,
        disabled: Value
    ) {
        self.collapsed = collapsed
        self.expanded = expanded
        self.disabled = disabled
    }
    
    /// Initializes model with clear `Color` values.
    public static var clear: GenericStateModel_CED<Color> {
        .init(
            collapsed: .clear,
            expanded: .clear,
            disabled: .clear
        )
    }
}

// MARK: Hashable, Equatable, Comparable
extension GenericStateModel_CED: Hashable where Value: Hashable {}

extension GenericStateModel_CED: Equatable where Value: Equatable {}

extension GenericStateModel_CED: Comparable where Value: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        isLess(lhs, than: rhs, by: \.collapsed, \.expanded, \.disabled)
    }
}

// MARK: - Mapping
extension GenericStateModel_CED {
    func `for`(_ state: GenericState_CED) -> Value {
        switch state {
        case .collapsed: return collapsed
        case .expanded: return expanded
        case .disabled: return disabled
        }
    }
}
