//
//  VChevronButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK: - V Chevron Button State
/// Enum that describes state, such as `enabled` or `disabled`.
public enum VChevronButtonState: Int, CaseIterable {
    // MARK: Cases
    /// Enabled.
    case enabled
    
    /// Disabled.
    case disabled
    
    // MARK: Properties
    /// Indicates if state is enabled.
    public var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .disabled: return false
        }
    }
    
    // MARK: Initializers
    init(internalState: VChevronButtonInternalState) {
        switch internalState {
        case .enabled: self = .enabled
        case .pressed: self = .enabled
        case .disabled: self = .disabled
        }
    }
}

// MARK: - V Chevron Button Internal State
enum VChevronButtonInternalState {
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
    init(state: VChevronButtonState, isPressed: Bool) {
        switch (state, isPressed) {
        case (.enabled, false): self = .enabled
        case (.enabled, true): self = .pressed
        case (.disabled, _): self = .disabled
        }
    }
    
    static func `default`(state: VChevronButtonState) -> Self {
        .init(state: state, isPressed: false)
    }
}

// MARK: - Mapping
extension StateColors_EPD {
    func `for`(_ state: VChevronButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
}

extension StateOpacities_PD {
    func `for`(_ state: VChevronButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}

extension StateColorsAndOpacities_EPD_PD {
    func `for`(_ state: VChevronButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }

    func `for`(_ state: VChevronButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}
