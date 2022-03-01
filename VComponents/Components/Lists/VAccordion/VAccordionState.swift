//
//  VAccordionState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import Foundation

// MARK: - V Accordion State
/// Enum that describes state, such as `collapsed`, `expanded`, or `disabled`.
public enum VAccordionState: Int, CaseIterable {
    // MARK: Cases
    /// Case collapsed.
    case collapsed
    
    /// Case expanded.
    case expanded
    
    /// Case disabled.
    case disabled
    
    // MARK: Properties
    /// Indicates if state is Enabled.
    public var isEnabled: Bool {
        switch self {
        case .collapsed: return true
        case .expanded: return true
        case .disabled: return false
        }
    }
    
    /// Indicates if state is expanded.
    public var isExpanded: Bool {
        switch self {
        case .collapsed: return false
        case .expanded: return true
        case .disabled: return false
        }
    }
    
    var chevronButtonIsEnabled: Bool {
        switch self {
        case .collapsed: return true
        case .expanded: return true
        case .disabled: return false
        }
    }
    
    var chevronButtonDirection: VChevronButtonDirection {
        switch self {
        case .collapsed: return .down
        case .expanded: return .up
        case .disabled: return .down
        }
    }

    // MARK: Next State
    /// Goes to the next state.
    public mutating func setNextState() {
        switch self {
        case .collapsed: self = .expanded
        case .expanded: self = .collapsed
        case .disabled: break
        }
    }
}

// MARK: - Mapping
extension StateOpacities_D {
    func `for`(_ state: VAccordionState) -> Double {
        switch state {
        case .collapsed: return 1
        case .expanded: return 1
        case .disabled: return disabledOpacity
        }
    }
}
