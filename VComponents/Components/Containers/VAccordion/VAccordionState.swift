//
//  VAccordionState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import Foundation

// MARK:- V Accordion State
/// Enum that describes state, such as collapsed, expanded, or disabled
public enum VAccordionState: Int, CaseIterable {
    case collapsed
    case expanded
    case disabled
    
    public var isExpanded: Bool {
        switch self {
        case .collapsed: return false
        case .expanded: return true
        case .disabled: return false
        }
    }
    
    var chevronButtonState: VChevronButtonState {
        switch self {
        case .collapsed: return .enabled
        case .expanded: return .enabled
        case .disabled: return .disabled
        }
    }
    
    var chevronButtonDirection: VChevronButtonDirection {
        switch self {
        case .collapsed: return .down
        case .expanded: return .up
        case .disabled: return .down
        }
    }
}

// MARK:- Next State
extension VAccordionState {
    public mutating func nextState() {
        switch self {
        case .collapsed: self = .expanded
        case .expanded: self = .collapsed
        case .disabled: break
        }
    }
}
