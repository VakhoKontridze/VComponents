//
//  VBaseButtonGestureState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/12/21.
//

import Foundation

// MARK: - V Base Button Gesture State
/// Enum that describes state, such as `none`, `press`, or `click`.
@frozen public enum VBaseButtonGestureState {
    // MARK: Cases
    case none
    case press
    case click
    
    // MARK: Propertes
    /// Indicates if button is being pressed.
    public var isPressed: Bool {
        switch self {
        case .none: return false
        case .press: return true
        case .click: return false
        }
    }
    
    /// Indicates if successfull click occured.
    public var isClicked: Bool {
        switch self {
        case .none: return false
        case .press: return false
        case .click: return true
        }
    }
}
