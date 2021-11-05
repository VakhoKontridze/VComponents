//
//  VStepperState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK: - V Stepper State
/// Enum that describes state, such as `enabled` or `disabled`.
public enum VStepperState: Int, CaseIterable {
    // MARK: Cases
    /// Case enabled.
    case enabled
    
    /// Case disabled.
    case disabled
    
    // MARK: Properties
    /// Indicates if state is enabled.
    public var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
}

// MARK: - V Stepper Button State
enum VStepperButtonState {
    // MARK: Cases
    case enabled
    case pressed
    case disabled
    
    // MARK: Initializers
    init(isEnabled: Bool, isPressed: Bool) {
        if isPressed && isEnabled {
            self = .pressed
        } else {
            switch isEnabled {
            case true: self = .enabled
            case false: self = .disabled
            }
        }
    }
}

// MARK: - Mapping
extension StateColors_ED {
    func `for`(_ state: VStepperState) -> Color {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        }
    }
}

extension StateColors_EPD {
    func `for`(_ state: VStepperButtonState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
}

extension StateColorsAndOpacities_EPD_PD {
    func `for`(_ state: VStepperButtonState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VStepperButtonState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}
