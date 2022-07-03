//
//  VDisclosureGroupState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK: - V Disclosure Group State
/// Enum that represents state, such as `collapsed` or `expanded`.
public enum VDisclosureGroupState: Int, CaseIterable {
    // MARK: Cases
    /// Case collapsed.
    case collapsed
    
    /// Case expanded.
    case expanded
    
    // MARK: Properties
    /// Indicates if state is expanded.
    public var isExpanded: Bool {
        switch self {
        case .collapsed: return false
        case .expanded: return true
        }
    }
    
    // MARK: Initializers
    /// Initializes state with `Bool`.
    public init(isExpanded: Bool) {
        switch isExpanded {
        case false: self = .collapsed
        case true: self = .expanded
        }
    }

    // MARK: Next State
    /// Goes to the next state.
    public mutating func setNextState() {
        switch self {
        case .collapsed: self = .expanded
        case .expanded: self = .collapsed
        }
    }
}

// MARK: Binding Init
extension Binding where Value == VDisclosureGroupState {
    /// Initializes state with `Bool`.
    public init(bool: Binding<Bool>) {
        self.init(
            get: { .init(isExpanded: bool.wrappedValue) },
            set: { bool.wrappedValue = $0.isExpanded }
        )
    }
}

// MARK: - V Disclosure Group Internal State
typealias VDisclosureGroupInternalState = GenericState_CED
